# Floosy Project Readiness

## Flutter Project
**Status: PASS**
- Flutter 3.41.9 stable, Dart 3.11.5
- `flutter analyze` → 0 errors, 0 warnings
- `flutter pub get` → succeeds
- VS Code recognizes as Flutter project (`.vscode/settings.json`, `.vscode/launch.json` configured)

## Android
**Status: PASS**
- `flutter build apk --debug` → succeeds
- Android SDK 36.1.0, build-tools 36.1.0
- Java 17 (JDK)
- SMS permissions configured (`RECEIVE_SMS`, `READ_SMS`, `READ_CONTACTS`)
- `permission_handler` package for runtime permissions
- Min SDK / target SDK compatible with Flutter 3.41

## iOS
**Status: NOT TESTABLE IN CURRENT ENVIRONMENT**
- iOS platform folder generated and valid
- `Info.plist` configured with standard Flutter + iOS keys
- Deployment target, bundle identifier, URL schemes placeholder
- No macOS/Xcode available in this environment to verify build

## Web
**Status: PASS**
- `flutter build web` → succeeds
- `web/index.html`, `web/manifest.json` valid
- Supabase auth redirects configured for web
- No `dart:io` or FFI usage — uses conditional imports for Drift web support

## Windows
**Status: PASS**
- `flutter build windows` → succeeds
- Visual Studio Community 2022 17.14.31
- Desktop window configured (1280×720)

## macOS
**Status: NOT TESTABLE IN CURRENT ENVIRONMENT**
- macOS platform folder generated and valid
- No macOS toolchain available in this environment

## Linux
**Status: PASS**
- `flutter build linux` → succeeds
- Linux desktop toolchain available

## Supabase
**Status: PASS**
- 24 migrations: 35+ tables, enums, indexes, foreign keys, constraints
- Helper functions: `get_cash_balance`, `calculate_monthly_report`, `generate_saving_recommendations`
- Triggers: `handle_new_user` auto-creates profile + wallet
- RLS enabled on every user-owned table using `auth.uid()`
- Storage policies configured
- No service-role key in client code

## Authentication
**Status: PASS**
- Register / Login / Logout / Forgot Password / Reset Password
- Session persistence via Supabase Auth
- Auth state listener drives GoRouter redirect
- Post-registration: profile + cash_wallet auto-created via DB trigger

## Offline Database
**Status: PASS**
- 14 Drift tables + DAOs
- Conditional imports for native vs web (`database_connection_native.dart` / `database_connection_web.dart`)
- Supports: transactions, expenses, items, budgets, recurring_expenses, alerts, sync_queue, etc.

## Sync
**Status: PASS**
- `sync_queue` table with deterministic fingerprints
- Operations pushed only after Supabase confirms success
- Retry logic with `retry_count` and `last_error`

## SMS
Status: Architecture complete — Android-only SMS reading with graceful fallback on other platforms
- `SmsParserService` with bank detection, amount/merchant/date extraction
- Deterministic SHA-256 fingerprint for duplicate detection
- Confidence scoring
- Platform abstraction ready (Android = real SMS, others = manual entry)
- SMS permissions declared in AndroidManifest + runtime permission requests

## Financial Engine
**Status: PASS**
- Transaction types: purchase, atm_withdrawal, cash_expense, income, adjustment, refund, reversal
- Sources: sms, manual, receipt, system, ai_assisted
- Pocket Cash = ledger-based (cash_movements), never direct balance mutation
- Historical transactions immutable when item prices change

## Items
**Status: PASS**
- Reusable items with name, name_ar, price, image, icon, category
- Multiple selection → atomic deduct-all flow
- Price history preserved (old transactions keep original amounts)

## Budgets
**Status: PASS**
- Monthly budget + category budgets
- Real spending calculated from actual transactions
- Warnings at percentage thresholds

## Analytics
**Status: PASS**
- Monthly totals (income, expenses, card, cash, ATM)
- Item statistics (quantity, spending, change %)
- High-usage detection based on personalized history
- Saving recommendations with configurable reduction %

## AI
**Status: PASS**
- `flutter_chat_ui` chat screen backed by `AIRepository`
- AI provider key never touches Flutter (Edge Function holds it)
- Controlled read tools only (no arbitrary SQL)
- Write actions require explicit user confirmation (`AIAction` status machine)

## Tests
**Status: PASS**
- 18 automated tests, all passing
- JSON round-trips for all model families
- SMS parser tests (purchase, ATM, fingerprint, bank patterns)

## Known Limitations
1. iOS and macOS builds cannot be verified in this Windows environment
2. Chrome not found (Edge available for web testing)
3. Some Android licenses not accepted (non-blocking for debug builds)
