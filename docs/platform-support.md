# Floosy platform support

The encrypted local-first update replaces the previous plaintext financial
cache. Implementation support and successful native-device validation are
different: see [the rollout and test limits](local-first-migration.md).

| Capability | Android | iOS | Windows | macOS and Linux | Web |
| --- | --- | --- | --- | --- | --- |
| Auth and profile | Implemented | Implemented | Implemented | Implemented | Implemented |
| Encrypted financial vault | Implemented | Implemented, device tests pending | Implemented | Native adapters, build tests pending | Disabled; native app required |
| Local transactions, cards, Items and analytics | Implemented | Implemented | Implemented | Native adapters | Disabled |
| Direct SMS inbox scan | Implemented; permission required | Unavailable | Unavailable | Unavailable | Unavailable |
| Bank message import | Inbox scan | Shortcuts App Intent on iOS 16+, copied messages | Manual entry | Manual entry | Unavailable |
| Password-encrypted backup and restore | Future | Future | Future | Future | Unavailable |

The web financial gate fails closed and explains that the native app is
required. It no longer writes financial data to plaintext IndexedDB. Logging
into a native app does not transfer another device's local-only history.

Native builds use cipher-enabled SQLite assets and secure platform key storage.
Android disables automatic cloud backup and device transfer. iOS has device-only
keychain keys, a protected vault directory excluded from backup and an encrypted
App Intent queue. These iOS changes need an Xcode build and real locked/unlocked
iPhone validation; Windows cannot provide that validation.

For this update, use the commands and actual outcomes in
[the local-first migration report](local-first-migration.md). Older documentation
claiming successful Web or Linux builds does not verify this version. There was
no attached Android phone or emulator during development of this update.

See [iPhone message setup](ios-bank-messages.md) for platform restrictions.
