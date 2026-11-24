# Floosy encrypted local financial storage

Historical release 1.0.0+6 report. The owner subsequently confirmed that all
financial history was test data and authorized a clean start. The current
behavior is in [the clean-start report](local-first-migration.md).

Updated 21 November 2026. The native app uses the device database for financial
reads and writes. Supabase remains responsible for authentication, profiles,
avatars and public reference data. Historical cloud records are retained.

The implementation is in the working tree. Both production SQL changes below
were applied with explicit user approval and verified on 21 November 2026.
Their versions are also recorded and verified in production migration history.
There is no completed migration of a real customer's device in this session.

## Six stages

| Stage | Implementation and verification |
| --- | --- |
| 1. Inventory | Read-only audit of 35 public tables, 68 foreign keys, two views, 11 functions, 28 triggers and 128 policies. The manifest selects 31 financial tables for import. |
| 2. Encrypted storage | Drift schema 6 with SQLite3MultipleCiphers, a random 256-bit device secret in secure storage, runtime cipher checks, verified conversion of the old database and no plaintext fallback. Tests cover close/reopen, wrong/missing keys, WAL commits and failed migration preservation. |
| 3. Transactions | Reads, inserts, updates and deletes use the encrypted ledger. SMS fingerprint checks and ledger effects commit atomically. Remote mirror hooks are inactive. Balance rules still use integer minor units and the existing card calculator. |
| 4. Related data | Cards, Items, wallets, movements, income, expenses, usage, budgets, recurring expenses, goals, alerts, AI records and historical analytics are imported or stored locally. Item and receipt objects are downloaded into encrypted BLOBs. Current analytics derive from the local ledger. |
| 5. Financial network boundary | Normal app traffic denies financial tables, RPCs, functions and financial storage paths. The initial importer has a separate read-only path. Financial log payloads and automatic FX requests are disabled. Automatic cloud-wallet creation and public financial RPC access have been retired on production. |
| 6. Verification | Flutter tests exercise encryption, resumable imports, changed snapshots, rollback, deduplication, account changes, images, compression, balances, settings and Arabic layout. PostgreSQL tests validate the proposed trigger and grants with synthetic data. Native-device validation limits are below. |

Schema-only snapshots are in [the inventory](local-first-inventory.json) and
[the dependency audit](local-first-dependencies.json). They contain no customer
messages or financial rows. The security review is recorded in
[the advisor snapshot](local-first-security-review.json).

The read-only background inventory found no deployed Edge Functions and no
`pg_cron` or `pgmq` extension in this project. The app has no active Realtime
subscriptions or financial sync worker. Old sync-queue records are retained
encrypted and are not executed.

## Import and preservation

`AppRuntime` stops SMS imports and hides financial screens until preparation
succeeds. Failure offers retry and sign-out without resetting the database.
Account changes clear visible state; a previous account's late completion
cannot enable imports for the next account.

Preparation migrates existing device records and card preferences first, so
current local edits take priority over older cloud values. The legacy reader
uses the signed-in user's bearer token, explicit owner filters and existing RLS.
Child rows are checked against their staged parents. It does not use an admin
key, upload financial records, invoke financial RPCs or delete cloud objects.

Cloud rows are downloaded in pages of 200 into encrypted staging. Each page has
a persisted cursor, count and content digest. Every staged row is read back and
compared. The source tables are read again and their complete counts and
canonical content digests must match before projection.

Projection is one local transaction. Failure rolls back the ledger and keeps
the staged source for retry. Completion records per-table verification evidence.
Staging payloads are removed only after successful projection. `VACUUM` then
reclaims free pages; insufficient free space leaves a compaction retry flag and
does not invalidate an already verified import. Temporary extra disk space is
needed while preserving the original database and staged import.

Fingerprints, wallet identities, card bank/last-four identities and referenced
movements prevent proven duplicates. Aliases preserve child relationships when
local and cloud IDs differ. Local edits win; conflicting server values remain
compressed and encrypted under `legacy_conflicts:*`. Fields not represented by
the existing typed ledger remain in `legacy_extras:*`. Source
timestamps with fractional seconds also retain their exact value there,
because the old typed ledger stores dates in whole seconds. Conflicting movement
amounts follow the retained local transaction instead of restoring stale cloud
balance effects. Ambiguous or unknown schema is rejected rather than silently
discarded. Do not delete server records based only on a download count.

The cloud source is not a transactionally locked database snapshot. The second
read detects changes encountered during verification; it cannot prevent another
old client from writing after verification. Existing old app versions must be
retired as part of rollout. This version never resumes financial synchronization
after its verified import marker is present.

## Encryption and space

The database is in application support under `FloosyVault/floosy-vault-v1.db`.
The legacy documents-directory `floosy.db` is copied, encrypted, reopened,
integrity-checked and compared across all tables before its verified plaintext
source and sidecars are removed. An interrupted or failed verification does not
discard the only source. An inaccessible key never causes an empty replacement
database or key reset. Password changes do not replace the device key.

Apple keychain accessibility is device-only after first unlock. Android secure
storage has automatic reset on error disabled. Android cloud backup and device
transfer are excluded. iOS excludes the vault directory from backup and uses
file protection; its imported-message queue uses authenticated AES-GCM with a
separate device-only keychain secret, including verified migration of old JSON.

SMS text is kept once per owner and hash in `sms_payloads`, compressed when this
saves space. The metadata table retains relationships and parsed fields without
another body copy. Extension records and images also use compressed BLOBs when
smaller. Derived balances are calculated with the existing ledger rules.

SQLite statement logging and Supabase debug logging are disabled. Application
logging emits fixed severity markers in debug and is silent in release. It does
not print caller messages, SDK errors or stacks. Financial item images resolve
from local bytes, and the image widget has no network fallback. FX conversion
uses an existing cached rate or leaves the foreign transaction pending review;
it does not send a transaction date/currency to a rate provider automatically.

## Applied production changes

These changes were tested against synthetic PostgreSQL fixtures, applied
together in one transaction after explicit user approval, then checked through
read-only production metadata queries:

1. [Stop automatic cloud wallets](../supabase/migrations/20261120202017_stop_automatic_cloud_wallet_creation.sql)
   keeps profile creation and removes only the automatic empty-wallet insertion.
2. [Retire financial RPC access](../supabase/migrations/20261121005825_retire_financial_rpc_access.sql)
   revokes PUBLIC, anon and authenticated execution of seven legacy financial
   RPCs and three trigger functions. Existing trigger bindings and all stored
   financial rows remain. The native importer reads tables, not these RPCs.

The original advisor reported seven financial `SECURITY DEFINER` RPCs executable
without sign-in and by authenticated callers. Verification now confirms that
neither API role can execute any of the ten retired functions, profile creation
is retained and the Auth trigger remains bound. The financial function warnings
are gone. The remaining advisor warning is disabled leaked-password protection;
changing that Auth setting is outside these SQL migrations.

Versions `20261120202017` and `20261121005825` are recorded as applied in
production migration history after explicit approval for that metadata action.
The recorded versions were checked through a read-only query. Both SQL files
are idempotent.

There are no financial DELETE/TRUNCATE statements in either migration. No
historical cloud financial rows or storage objects were removed. Their eventual
deletion requires device migration verification, reconciliation and separate
explicit user approval.

## Validation and platform limits

Run the Flutter checks from the project root:

```sh
flutter analyze --no-pub
flutter test --no-pub
flutter build apk --debug --no-pub --target-platform android-arm64
```

The SQL regression uses PostgreSQL in memory, never the production project:

```sh
npm install --prefix .diag/sql-check @electric-sql/pglite@0.5.17
node tool/check_local_first_sql.mjs .diag/sql-check/node_modules/@electric-sql/pglite/dist/index.js
```

The corresponding local PostgreSQL test is
[`supabase/tests/local_first_profile_and_rpc.sql`](../supabase/tests/local_first_profile_and_rpc.sql).
It checks profile creation, unchanged wallets and API-role grants with synthetic
fixtures, then rolls the fixtures back. Do not run it on production.

Flutter analysis reports no issues and all 37 Flutter tests pass. Android arm64
debug and optimized release compilation passed. The release APK is about 27 MB;
inspection confirmed `libsqlite3mc.so` with cipher support. It uses the project's
existing debug signing configuration and is for device review, not store upload.
See [the machine-readable validation report](local-first-validation.json).
The current Windows build is blocked by
the machine's disabled symbolic-link support; no Windows settings were changed.
The source changes and native SQLite encryption tests can still be checked here.

Flutter encryption tests run against the actual cipher-enabled native SQLite
library on Windows. Flutter widget tests include narrow Arabic screens and
large text. No Android phone or emulator was attached during this session.
iOS keychain, App Intent, backup exclusion and native AES-GCM changes still need
an Xcode build and locked/unlocked real-device tests on macOS. Desktop and mobile
build outcomes must be taken from this release's validation report, not older
documentation. These checks do not replace an independent security audit.

Web financial storage fails closed instead of writing plaintext IndexedDB. The
web gate explains that a native app is currently required. Authentication can
still use the web redirect flow.

## New phones and backups

Signing into the same Google account does not transfer records created in a
different device's local vault. Historical cloud records may still be available
to the one-time importer, but they do not include new local-only activity.
Losing the phone, uninstalling or losing its key can lose access to the vault.
The Settings privacy dialog explains this.

Password-encrypted backup and restore is a future feature, not an implemented
backup guarantee. Its future design must keep the decryption secret off the
server, authenticate the archive, preserve IDs and relationships, verify
balances before activation and test recovery independently. The proposed
“Your Money. Your Data. Your Control.” identity must be accompanied by a clear
privacy policy and the actual rollout status above.

Implementation references: [Drift encryption](https://drift.simonbinder.eu/platforms/encryption/),
[Apple device-only keychain](https://developer.apple.com/documentation/security/ksecattraccessibleafterfirstunlockthisdeviceonly),
[Apple AES-GCM](https://developer.apple.com/documentation/cryptokit/aes/gcm),
[Supabase profile triggers](https://supabase.com/docs/guides/auth/managing-user-data).
