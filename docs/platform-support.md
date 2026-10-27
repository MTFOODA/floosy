# Floosy Platform Support Matrix

| Feature | Android | iOS | Web | Windows | macOS | Linux |
|---|---|---|---|---|---|---|
| Authentication | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| Supabase | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| Transactions | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| Pocket Cash | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| Quick Items | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| Budgets | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| Recurring Expenses | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| Analytics | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| Reports | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| Alerts & Badges | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| AI Chat | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| Direct SMS Inbox Tracking | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ |
| Manual Transactions | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| Offline Local DB | ✅ | ✅ | ✅¹ | ✅ | ✅ | ✅ |
| Notifications | ✅ | ✅ | Limited² | Appropriate | Appropriate | Appropriate |
| Biometric Lock | ✅ | ✅ | ❌ | ❌ | ✅³ | ❌ |
| RTL / Arabic | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |

**Notes:**
¹ Web uses IndexedDB via Drift web adapter — works in modern browsers.
² Web notifications depend on browser Push API support and user permission.
³ macOS supports Touch ID / Face ID via `local_auth`.

## Platform-Specific Implementation

### Android
- Real SMS reading via platform abstraction (`SmsParserService`)
- Runtime permissions for SMS, contacts, notifications
- Material 3 design, supports phone/tablet/desktop (Chromebook)

### iOS
- No direct access to the SMS inbox or historical SMS
- iOS 16+ App Intent for user-configured Shortcuts bank message import; queued messages are processed while Floosy is open
- Manual transaction entry and copied-message import
- See [iPhone bank message setup and validation limits](ios-bank-messages.md)
- `local_auth` for biometric lock (Face ID / Touch ID)

### Web
- No SMS access
- Supabase auth with redirect flow
- Drift web adapter (IndexedDB)
- Responsive layout with navigation rail on wide screens

### Windows / macOS / Linux
- Desktop window management
- No SMS access
- Manual transaction entry
- Keyboard shortcuts and accessibility

## Build Status (Verified in Current Environment)

| Platform | Build Command | Status |
|---|---|---|
| Android | `flutter build apk --debug` | ✅ PASS |
| Web | `flutter build web` | ✅ PASS |
| Windows | `flutter build windows` | ✅ PASS |
| Linux | `flutter build linux` | ✅ PASS |
| iOS | `flutter build ios --no-codesign` | ⚠️ NOT TESTABLE (requires macOS/Xcode) |
| macOS | `flutter build macos` | ⚠️ NOT TESTABLE (requires macOS/Xcode) |

## Minimum SDK Versions

| Platform | Minimum | Target |
|---|---|---|
| Android | API 21 (Android 5.0) | API 36 (Android 16) |
| iOS | 13.0 (bank message App Intent: 16.0+) | Latest |
| Web | Modern browsers (ES2017+) | — |
| Windows | Windows 10 (1809+) | Windows 11 |
| macOS | 10.15 (Catalina) | Latest |
| Linux | Ubuntu 20.04+ / equivalent | — |
