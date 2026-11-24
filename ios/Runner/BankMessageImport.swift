import AppIntents
import Flutter
import Foundation
import CryptoKit
import Security

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
  var resetEpoch: String?
}

private enum BankMessageError: LocalizedError {
  case signIn, disabled, invalidInput, full, storage
  var errorDescription: String? {
    switch self {
    case .storage: return "Secure message storage is unavailable. Open Floosy and try again."
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

  private func encryptedURL() throws -> URL {
    try fileURL().deletingLastPathComponent().appendingPathComponent("queue.encrypted")
  }

  private func key() throws -> SymmetricKey {
    let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
      kSecAttrService as String: "floosy.bank-import.v1", kSecAttrAccount as String: "device-key",
      kSecAttrSynchronizable as String: false]
    var lookup = query
    lookup[kSecReturnData as String] = true
    lookup[kSecMatchLimit as String] = kSecMatchLimitOne
    var result: CFTypeRef?
    let status = SecItemCopyMatching(lookup as CFDictionary, &result)
    if status == errSecSuccess, let bytes = result as? Data, bytes.count == 32 {
      return SymmetricKey(data: bytes)
    }
    // Never replace a missing/inaccessible key when encrypted data exists.
    guard status == errSecItemNotFound,
      !FileManager.default.fileExists(atPath: try encryptedURL().path) else { throw BankMessageError.storage }
    let generated = SymmetricKey(size: .bits256)
    let data = generated.withUnsafeBytes { Data($0) }
    var item = query
    item[kSecValueData as String] = data
    item[kSecAttrAccessible as String] = kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly
    guard SecItemAdd(item as CFDictionary, nil) == errSecSuccess else { throw BankMessageError.storage }
    return generated
  }

  private func load() throws -> BankMessageState {
    let encrypted = try encryptedURL()
    let legacy = try fileURL()
    if FileManager.default.fileExists(atPath: encrypted.path) {
      let bytes = try AES.GCM.open(AES.GCM.SealedBox(combined: Data(contentsOf: encrypted)), using: key())
      let state = try JSONDecoder().decode(BankMessageState.self, from: bytes)
      if FileManager.default.fileExists(atPath: legacy.path) {
        let old = try JSONDecoder().decode(BankMessageState.self, from: Data(contentsOf: legacy))
        // Resume cleanup after a crash only when every original record survived.
        guard old.messages.allSatisfy({ record in state.messages.contains(where: {
          $0.id == record.id && $0.owner == record.owner && $0.sender == record.sender &&
          $0.body == record.body && $0.receivedAt == record.receivedAt
        }) }) else { throw BankMessageError.storage }
        try FileManager.default.removeItem(at: legacy)
      }
      return state
    }
    guard FileManager.default.fileExists(atPath: legacy.path) else { return BankMessageState() }
    let state = try JSONDecoder().decode(BankMessageState.self, from: Data(contentsOf: legacy))
    try save(state)
    // Read/decrypt verification inside save precedes removal of the old source.
    try FileManager.default.removeItem(at: legacy)
    return state
  }

  private func save(_ state: BankMessageState) throws {
    let plaintext = try JSONEncoder().encode(state)
    let secret = try key()
    guard let encrypted = try AES.GCM.seal(plaintext, using: secret).combined else { throw BankMessageError.storage }
    let destination = try encryptedURL()
    try encrypted.write(to: destination, options: [.atomic, .completeFileProtectionUntilFirstUserAuthentication])
    let verified = try AES.GCM.open(AES.GCM.SealedBox(combined: Data(contentsOf: destination)), using: secret)
    guard verified == plaintext else { throw BankMessageError.storage }
  }

  func resetTestData(_ epoch: String) throws {
    guard epoch == "test-reset-2026-11-21" else { throw BankMessageError.invalidInput }
    var state = try load()
    guard state.resetEpoch != epoch else { return }
    state.messages = []
    state.resetEpoch = epoch
    try save(state)
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
          if call.method == "resetTestData" {
            guard let epoch = args["epoch"] as? String else { throw BankMessageError.invalidInput }
            try await queue.resetTestData(epoch)
            result(nil)
            return
          }
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
