import AppIntents
import Flutter
import Foundation

// This is an app-local App Intent, not a message-filter extension. Shortcuts
// supplies the input with the user's permission; no SMS database is queried.
private struct BankMessageRecord: Codable, Sendable {
  let id: String
  let owner: String
  let sender: String
  let body: String
  let receivedAt: Double
  var needsReview: Bool = false

  var platformValue: [String: Any] {
    ["id": id, "sender": sender, "body": body,
     "receivedAt": receivedAt, "needsReview": needsReview]
  }
}

private struct BankMessageState: Codable {
  var owner: String?
  var enabledOwners: Set<String> = []
  var messages: [BankMessageRecord] = []
}

private enum BankMessageError: LocalizedError {
  case signIn, disabled, invalidInput, full
  var errorDescription: String? {
    switch self {
    case .signIn: return "Open Floosy and sign in before importing bank messages."
    case .disabled: return "Enable bank message import in Floosy Settings first."
    case .invalidInput: return "Provide the bank sender, message text and a valid received date."
    case .full: return "Floosy's message queue is full. Open Floosy to process or review pending messages."
    }
  }
}

// All access is serialized in the Runner app process. Atomic replacement keeps
// a killed/failed write from corrupting the previous queue. There is no App
// Group or entitlement dependency, including for personal sideloaded builds.
private actor BankMessageQueue {
  static let shared = BankMessageQueue()

  private func fileURL() throws -> URL {
    let manager = FileManager.default
    let base = try manager.url(for: .applicationSupportDirectory,
                               in: .userDomainMask, appropriateFor: nil, create: true)
    var directory = base.appendingPathComponent("BankMessageImports", isDirectory: true)
    try manager.createDirectory(at: directory, withIntermediateDirectories: true,
      attributes: [.protectionKey: FileProtectionType.completeUntilFirstUserAuthentication])
    var resources = URLResourceValues()
    resources.isExcludedFromBackup = true
    try directory.setResourceValues(resources)
    return directory.appendingPathComponent("queue.json")
  }

  private func load() throws -> BankMessageState {
    let url = try fileURL()
    guard FileManager.default.fileExists(atPath: url.path) else { return BankMessageState() }
    // Decode failures are errors, never a reason to overwrite a saved queue.
    return try JSONDecoder().decode(BankMessageState.self, from: Data(contentsOf: url))
  }

  private func save(_ state: BankMessageState) throws {
    try JSONEncoder().encode(state).write(to: fileURL(),
      options: [.atomic, .completeFileProtectionUntilFirstUserAuthentication])
  }

  private func requireOwner(_ owner: String, state: BankMessageState) throws {
    guard !owner.isEmpty, state.owner == owner else { throw BankMessageError.signIn }
  }

  func bind(_ owner: String?) throws {
    var state = try load()
    guard state.owner != owner else { return }
    state.owner = owner
    try save(state)
  }

  func inbox(_ owner: String) throws -> (Bool, [BankMessageRecord]) {
    let state = try load()
    try requireOwner(owner, state: state)
    return (state.enabledOwners.contains(owner), state.messages.filter { $0.owner == owner })
  }

  func setEnabled(_ enabled: Bool, owner: String) throws {
    var state = try load()
    try requireOwner(owner, state: state)
    if enabled { state.enabledOwners.insert(owner) } else { state.enabledOwners.remove(owner) }
    try save(state)
  }

  func add(sender: String, body: String, receivedAt: Date, owner: String? = nil) throws {
    var state = try load()
    guard let currentOwner = state.owner else { throw BankMessageError.signIn }
    if let owner = owner { try requireOwner(owner, state: state) }
    guard state.enabledOwners.contains(currentOwner) else { throw BankMessageError.disabled }
    let sender = sender.trimmingCharacters(in: .whitespacesAndNewlines)
    let body = body.trimmingCharacters(in: .whitespacesAndNewlines)
    guard !sender.isEmpty, sender.count <= 128, !body.isEmpty, body.count <= 16000,
          receivedAt.timeIntervalSince1970.isFinite, receivedAt.timeIntervalSince1970 > 0,
          receivedAt <= Date().addingTimeInterval(86400) else { throw BankMessageError.invalidInput }
    if state.messages.contains(where: {
      $0.owner == currentOwner && $0.sender == sender && $0.body == body
    }) { return }
    guard state.messages.count < 1000 else { throw BankMessageError.full }
    state.messages.append(BankMessageRecord(id: UUID().uuidString, owner: currentOwner,
      sender: sender, body: body, receivedAt: receivedAt.timeIntervalSince1970 * 1000))
    try save(state)
  }

  func update(_ id: String, owner: String, action: String) throws {
    var state = try load()
    try requireOwner(owner, state: state)
    guard let index = state.messages.firstIndex(where: { $0.id == id && $0.owner == owner }) else { return }
    switch action {
    case "remove": state.messages.remove(at: index)
    case "review": state.messages[index].needsReview = true
    case "retry": state.messages[index].needsReview = false
    default: throw BankMessageError.invalidInput
    }
    try save(state)
  }
}

@available(iOS 16.0, *)
struct ImportBankMessageIntent: AppIntent {
  static var title: LocalizedStringResource = "Import Bank SMS"
  static var description = IntentDescription(
    "Save a bank message on this iPhone. Floosy processes it when you next open the app.")
  // Default execution is in the background. This action only queues input;
  // it never displays balances or changes the financial ledger while locked.
  static var authenticationPolicy: IntentAuthenticationPolicy { .alwaysAllowed }

  @Parameter(title: "Bank sender") var sender: String
  @Parameter(title: "Message text") var message: String
  @Parameter(title: "Received at") var receivedAt: Date?

  static var parameterSummary: some ParameterSummary {
    Summary("Import \(\.$message) from \(\.$sender)") {
      \.$receivedAt
    }
  }

  func perform() async throws -> some IntentResult & ProvidesDialog {
    try await BankMessageQueue.shared.add(sender: sender, body: message,
      receivedAt: receivedAt ?? Date())
    return .result(dialog: "Saved on this iPhone. Open Floosy to process the message.")
  }
}

@available(iOS 16.0, *)
struct FloosyBankMessageShortcuts: AppShortcutsProvider {
  static var appShortcuts: [AppShortcut] {
    AppShortcut(intent: ImportBankMessageIntent(),
      phrases: ["Import a bank message in \(.applicationName)"],
      shortTitle: "Import Bank SMS", systemImageName: "message")
  }
}

enum BankMessageImportBridge {
  static func register(messenger: FlutterBinaryMessenger) {
    let channel = FlutterMethodChannel(name: "floosy/bank_message_import", binaryMessenger: messenger)
    channel.setMethodCallHandler { call, result in
      Task { @MainActor in
        do {
          let args = call.arguments as? [String: Any] ?? [:]
          let queue = BankMessageQueue.shared
          if call.method == "bindUser" {
            try await queue.bind(args["userId"] as? String)
            result(nil)
            return
          }
          guard let owner = args["userId"] as? String else { throw BankMessageError.signIn }
          switch call.method {
          case "inbox":
            let (enabled, messages) = try await queue.inbox(owner)
            result(["enabled": enabled, "messages": messages.map { $0.platformValue }])
          case "setEnabled":
            guard let enabled = args["enabled"] as? Bool else { throw BankMessageError.invalidInput }
            try await queue.setEnabled(enabled, owner: owner)
            result(nil)
          case "addMessage":
            guard let sender = args["sender"] as? String, let body = args["body"] as? String,
                  let timestamp = args["receivedAt"] as? NSNumber else { throw BankMessageError.invalidInput }
            try await queue.add(sender: sender, body: body,
              receivedAt: Date(timeIntervalSince1970: timestamp.doubleValue / 1000), owner: owner)
            result(nil)
          case "updateMessage":
            guard let id = args["id"] as? String, let action = args["action"] as? String else {
              throw BankMessageError.invalidInput
            }
            try await queue.update(id, owner: owner, action: action)
            result(nil)
          default: result(FlutterMethodNotImplemented)
          }
        } catch {
          // Errors contain setup instructions only, never message contents.
          let description = (error as? BankMessageError)?.errorDescription
            ?? "Bank message import is temporarily unavailable. Open Floosy and try again."
          result(FlutterError(code: "BANK_MESSAGE_IMPORT", message: description, details: nil))
        }
      }
    }
  }
}
