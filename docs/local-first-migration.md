# Floosy clean start and encrypted local storage

Current release **1.0.4+10**, 23 November 2026, adds completion-only transaction
editing, Arabic UI coverage, clearer merchant/type presentation and a smaller
Android launcher mark. The previous **1.0.3+9** release imports bank/wallet SMS from the
first day of the current month, then follows new arrivals. It rejects promotional
discounts, repairs earlier promotional imports, and adds encrypted backup/restore.
The original navy holder now contains realistic landscape cards. Native launch
artwork and all generated launcher icons use the same symbol.
The previous release fixed the stalled “Preparing your data on this device”
screen after the owner authorized clearing old financial test data.

## Current startup

Opening the app no longer imports or verifies 31 cloud financial tables and
their images before displaying the dashboard. That old flow required at least
62 sequential table requests, had no overall preparation deadline and could
take a long time even with a small test dataset on a slow connection.

The app now opens `FloosyVault/floosy-vault-v2.db` with the existing device secret
and initializes a clean encrypted ledger locally. It never copies the old test
database into this generation. Obsolete v1 database files and sidecars are
retired only after the new encrypted file opens. Auth session preferences,
secure-storage keys and account profiles are preserved.

`FreshStartService` clears legacy financial preferences once, retains a device
reset marker, and seeds 15 bundled public categories. Each user receives an
independent SMS cursor. The one-time `sms-current-month-history-v1` upgrade
replaces the previous new-messages-only cutoff with midnight on day one of the
device's current month (1 November for this release's date). It preserves all
new transactions, cards, balances and processed-message ledgers. The boundary
is saved per account; reopening in another month retains any unfinished gap.
History uses 200-message pages; incremental scans use 50-message pages and a
deduplicated two-minute overlap, clamped to the saved month boundary. The native
query and Dart processing both enforce these bounds. Permission denial/read
failure keeps the page pending; a successful empty inbox completes history.
Granting permission, returning to the app, or refreshing Transactions can
resume a bounded history page. Future app launches or another account signing
in do not delete newly created records. The iOS import
queue has a corresponding one-time test reset; its native device validation
still requires macOS/Xcode.

Preparation, selection loading and import-user binding have an overall
**20-second deadline**. A stalled operation shows retry/sign-out instead of an
infinite spinner. Retries join an existing preparation operation, and a late
completion or previous account cannot unlock the UI after failure/account change.

## Authorized cloud cleanup

The explicit one-off script is
[`tool/sql/reset_test_financial_data.sql`](../tool/sql/reset_test_financial_data.sql).
It is deliberately not a replayed schema migration. It uses an explicit table
list without `CASCADE`, bounded lock/statement timeouts and one transaction.

Production verification confirmed:

- All **248** old financial test rows, including audit history, were removed.
- All **five login accounts** and **five profiles** remain.
- Two test item images were removed through the Storage API.
- The CLI also removed the item-images bucket; it was immediately recreated
  empty and private. The final bucket state was checked. Avatars were untouched.
- Banks, SMS patterns, badges and global categories were retained.

The previously approved profile trigger/RPC hardening remains applied and
recorded in migration history. There are no deployed Edge Functions or cron/
queue extensions in this project. Normal app traffic still denies financial
tables, RPCs, functions and financial image uploads.

## Validation and limits

All **65 Flutter tests pass**, and analysis reports **no issues**. Exact results
are recorded in the linked machine-readable report. Regression
coverage includes offline production preparation with zero HTTP requests,
preserved Auth, one-time reset, retained new data, SMS overlap cutoffs, timeout,
late completion, account switching and a real background-isolate encrypted
database opening without reading a deliberately invalid retired test file.
Month-import coverage exercises the real parser, encrypted-local adapters,
card creation and transaction ledger, including the exact midnight boundary,
older-month exclusion, OTP rejection, restart deduplication, full-page
pagination, permission/read recovery and lifecycle restart behavior.

The old logo persisted in both Android `drawable/floosy_logo.png` variants,
separately from the Flutter/launcher artwork. Both are replaced; explicit day
and night Android 12 launch themes use a padded icon that fits the system mask.
iOS LaunchImage and generated platform launcher icons use the same new source.
Artwork and the exact built-in image-generation prompt are archived under
`output/branding-2026-11-21/`. Android splash dimensions follow the
[official platform guide](https://developer.android.com/develop/ui/views/launch/splash-screen#dimensions).

The Android arm64 review APK uses the project's existing signing key so it can
be installed over the previous build. Build hashes and exact verification
results are in [the validation report](local-first-validation.json).
The previous 1.0.3 signed APK was installed as an update on the connected Android API 37
phone. Package version 1.0.3/code 9 was verified and a cold activity launch
completed successfully (857 ms reported by Android). After the owner signed
in, both backup actions were visible in Settings. The login screen uses the
original navy holder with realistic cards, and native launch artwork was checked
inside the compiled APK. The phone blocks injected input events, so clicking
through the OS file picker and saving/restoring a real account backup require
manual device validation. The complete backup core, account isolation,
maintenance suspension and password-dialog behavior passed automated tests.
No production finance reset was run for this release. The phone's screenshot evidence stays in ignored local
diagnostics because it contains personal financial information.
Windows build needs OS symlink support; iOS needs Xcode and actual device
testing. For 1.0.4, no authorized Android device was connected during verification;
installing the new APK and checking the launcher on the phone remain device checks.
Web financial storage remains disabled instead of plaintext.

New financial data stays encrypted locally. Google sign-in alone does not
transfer local records to another phone. The encrypted backup file can transfer
the signed-in account's financial database after signing into the same account.
These tests do not replace an independent security audit.

## Transaction completion and Arabic UI (1.0.4)

The transaction row labels the merchant explicitly for purchases and overlays a
small movement icon on the bank logo. Rows within a day have a 12 logical-pixel
gap; date groups have a 20-pixel gap. The completion form has 16-pixel vertical
gaps, padded input boxes, shaded disabled fields and lock icons. Category
selection uses localized names instead of exposing database UUIDs. Amount and
last-four-digit inputs accept Arabic digits; amounts convert directly to integer
minor units.

`TransactionEditPolicy` and the actual `SaveTransactionEdit` path enforce the
same rule: recorded amount, currency, type, date, issuing bank, last four digits,
merchant and category cannot be replaced. Missing fields can be supplied once;
new notes append to existing notes. Zero-amount authorizations with positive
detection evidence stay locked. The current database row is re-read to reject
stale forms. Row changes, completion evidence and card-identity learning run in
one local transaction. Completed card assignments and balances remain unchanged
when adding optional data. Completing information never changes a pending FX
transaction's original amount/currency or silently confirms it.

Interface labels, hints, action sheets, auth error fallbacks, onboarding,
currency names, local assistant responses, transaction counts and cash movement
labels follow the chosen language. Arabic and English have matching keys and
placeholders; an automated check rejects English labels in Arabic translation
values. Original message bodies, merchant names, email addresses and user input
are preserved as data rather than machine-translated.

The Android adaptive-icon inset increases from 8% to 18%, reducing the symbol's
linear size inside the same launcher tile by about 24%. The approved source
artwork and native splash image stay unchanged. This is launcher configuration,
so no additional image-generation pass is required.

Coverage includes direct locked-field save attempts, completing missing values
once, optional information preserving card balances, stale edits, zero holds,
Arabic digit input, language switching, and narrow-screen layout with 1.4× text
scaling. Encrypted backup/restore and SMS tests remain in the complete suite.

## Promotional messages and transaction presentation

The old generic classifier treated Arabic `خصم` as a debit even when the SMS
advertised a percentage discount, maximum promotional saving, or coupon.
`isPromotional` now runs before transaction/card creation and recognizes these
offers and telecom-unit gifts. Completed purchase/debit/credit notifications
with an offer footer remain financial transactions. Synthetic corpus coverage
and anonymized regressions exercise the distinction.

At preparation, `sms-promotion-repair-v1` removes only SMS-origin transactions
whose linked source proves promotional. The normal deletion path reverses bank
and cash movements and derived expenses atomically. Original compressed messages
and processed hashes remain, while stale transaction links and card counters
are corrected. Manual records and legitimate transactions remain. No cloud reset
or additional clearing of valid local data is involved.

The reported Vodafone entries were issuing-bank card-purchase notifications with
Vodafone as merchant, so they remain valid purchases. The bank is now the primary
title, its large logo stays on the right, movement type appears below its name,
and merchant text is separate. Identity is read from local SMS metadata even
offline. The daily net header and duplicated currency labels are removed.
Arabic uses the bundled Arabic bank name; English canonicalizes historical
aliases, including `Bank of Alexandria` to `ALEXBANK`. Source text is preserved.
The names were checked against [ALEXBANK](https://www.alexbank.com/) and
[Faisal Islamic Bank of Egypt](https://www.faisalbank.com.eg/ar/).

## Encrypted backup and restore

Settings has Create backup and Restore backup actions in Arabic and English.
The user chooses a password of at least ten characters and a destination using
the OS document picker. Export captures one consistent account-scoped snapshot
of all 17 typed tables, private financial/configuration records, compressed SMS
payloads and private image bytes. It excludes Auth sessions, passwords,
biometric secrets, device encryption keys, other accounts and device reset
journals. Pending iOS messages still waiting in the native import queue are
outside the database snapshot.

The snapshot is compressed, then encrypted in a worker isolate using
AES-256-GCM with a random 16-byte salt, 12-byte nonce and 16-byte tag. PBKDF2
HMAC-SHA256 uses 600,000 iterations. The fixed `FLOOSYB1` version header is
authenticated. Neither the backup password nor its derived key is stored or
sent to a server. Encryption uses the
[cryptography package](https://pub.dev/packages/cryptography).

Restore authenticates the entire file and checks account ownership and exact
schema/columns before changing any row. The user sees the backup date and
transaction count and confirms replacing this account's current financial data.
SMS polling stops and all current scan writes settle before import. Import and
read-back verification of every row and binary payload occur in one database
transaction, followed by the current promotional-message repair. Any failure
rolls everything back. Other accounts and Auth remain intact. Repeating a restore
replaces the same account snapshot rather than duplicating its transactions.
Afterwards the in-memory SMS cursor is cleared and polling/UI reload resume.

Only ciphertext is passed to the OS picker; decrypted temporary files are never
written. File size is bounded to 64 MiB, with a bounded 128 MiB decompression
limit. Wrong-password, tampering, portable restore, integer balances, item/cash
links, binary payloads, replay and rollback are covered by tests. Password loss
cannot be recovered by Google sign-in or by the server.

The former preserving-import design and audit snapshots remain available in
[the historical v1 report](local-first-migration-v1.md). Its importer is retained
for regression/reference work but is no longer wired into production startup.
