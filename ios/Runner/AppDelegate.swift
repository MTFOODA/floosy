import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
    BankMessageImportBridge.register(
      messenger: engineBridge.applicationRegistrar.messenger()
    )
    let vault = FlutterMethodChannel(name: "floosy/private_vault",
      binaryMessenger: engineBridge.applicationRegistrar.messenger())
    vault.setMethodCallHandler { call, result in
      guard call.method == "prepareVault" else { result(FlutterMethodNotImplemented); return }
      do {
        let manager = FileManager.default
        let support = try manager.url(for: .applicationSupportDirectory,
          in: .userDomainMask, appropriateFor: nil, create: true)
        var directory = support.appendingPathComponent("FloosyVault", isDirectory: true)
        try manager.createDirectory(at: directory, withIntermediateDirectories: true,
          attributes: [.protectionKey: FileProtectionType.completeUntilFirstUserAuthentication])
        try manager.setAttributes([.protectionKey: FileProtectionType.completeUntilFirstUserAuthentication],
          ofItemAtPath: directory.path)
        var resources = URLResourceValues()
        resources.isExcludedFromBackup = true
        try directory.setResourceValues(resources)
        result(nil)
      } catch {
        result(FlutterError(code: "VAULT_UNAVAILABLE", message: "Local storage is unavailable.", details: nil))
      }
    }
  }
}
