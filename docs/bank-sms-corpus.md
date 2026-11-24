# Egyptian bank identities and SMS reference data

The offline directory is `lib/domain/entities/bank_directory.dart`: 38 bank
identities and five wallet/transfer providers. It is a supported identity list,
not a claim that every institution offers every SMS service. Old brand aliases
resolve to one identity; no database UUIDs are invented for offline banks.

## Logos and card appearance

`assets/banks/` contains 43 bundled PNG logos. `sources.json` records the website,
actual downloaded image URL, and publisher/app link where an official App Store
icon was needed. MIDBANK's image comes from the attributed LogoDaliL directory.
`tool/fetch_bank_logos.py` restores missing assets using those recorded sources;
the app does not contact these services to display a logo. Unknown custom banks
use a neutral bank icon. Bank names and logos appear on dashboard cards,
detected cards, transaction rows, and the mapping bank picker. Transaction
branding follows bank ID or the linked/unambiguous card, not arbitrary merchant
text. There are 24 gradient presets and 48 selectable colors.

## SMS samples: provenance matters

`assets/data/bank_sms_corpus.json` contains **645 synthetic, labelled regression
samples**, 15 for each supported institution. Run
`python tool/generate_bank_sms_corpus.py` to regenerate them. They cover Arabic
and English purchases, cash withdrawal, deposit, salary, incoming/outgoing
transfer, refund/reversal, OTP, declined payments, marketing, balance-only
notifications, and transfers with uncertain direction. Each sample records
its nature, expected transaction type/direction, amount, currency, last four
digits and whether it should create a transaction. A reversal notification
currently maps to the existing refund behavior.

**These are not actual SMS templates obtained from the banks.** A corpus covering
every bank's actual wording was not publicly available. The same generic
templates are exercised across identities to guard detection against regressions;
Arabic fixtures do not imply that a bank actually sends Arabic alerts. Sender
names in fixtures are synthetic identifiers unless separately verified below.
No customer inbox or private financial data is included.

Public evidence reviewed on 20 November 2026:

- [HSBC Egypt SMS alerts](https://www.hsbc.com.eg/ways-to-bank/mobile/text-alerts/)
  documents the `HSBC` sender, English alerts and supported account/card events.
  It does not publish all exact message templates.
- [CBE Instant Payment Network](https://www.cbe.org.eg/en/payment-systems-and-services/instant-payment-network)
  documents the service and participating banks, not their SMS wording.
- [KFH Egypt rebranding FAQ](https://www.eg.kfh.com/faqs/)
  supports the Ahli United Bank alias.
- [Bank NXT about page](https://nxtwin.banknxteg.com/pages/about)
  supports the aiBANK alias.

To add real samples later, redact names, phone/account numbers, card digits,
references and precise personal timestamps. Record the source, consent,
capture date, sender, language, nature and expected fields. Keep captured
messages separate from synthetic fixtures; never label generated text as
verified bank evidence. Sender matching is an import heuristic, not proof that
a message or a transaction is authentic.

## Mapping rejection and passwords

The red X rejects a normalized sender for the current user. Rejection wins over
automatic recognition and saved mappings in Android ingestion and the shared
processor (also used by iOS imports). Rejected senders stay out of suggestions
after another scan/restart. Existing ledger entries are retained. The rejected
senders section lets the user restore a sender before assigning it again.
This preference is stored locally per user; it is not synchronized across devices.

Changing a password verifies the old password through an isolated HTTP auth
request before updating the existing session. This avoids SDK `signedIn`
broadcasts replacing the session or resetting navigation on web. The temporary
verification session is revoked with local scope. New password confirmation,
same-password rejection, validation, busy state and localized errors are included.
Verification uses the existing publishable key, never an admin/service-role key.

## Database rollout and validation

`supabase/migrations/20261120115435_expand_egypt_bank_directory.sql` adds reference
rows and logo URLs. It preserves existing UUIDs, English names, activity state,
and the historical ALEX2 row/foreign keys; no financial rows are deleted.

The reference-data SQL was executed on Floosy project `nyynpeancrulycunizzs`
on 20 November 2026 through the locally authenticated Supabase CLI. There are
39 rows: 38 supported banks plus the preserved historical ALEX2 row. All rows
have logo URLs. A read using the application's public API key confirmed all
39 active rows are accessible. Existing CIB UUID/name were verified unchanged.
The SQL is idempotent and can safely be replayed by the normal migration process;
the direct data update did not add a migration-history entry.

Validation completed:

- 15 automated tests passed, including every one of the 645 synthetic samples.
- Tests cover offline/remote detection, uncertain direction, sender precedence,
  rejected sender persistence/account isolation/processor exclusion, mapping
  restore/save, incorrect old passwords, isolated password verification,
  password form validation, color persistence without money operations, and
  branding layouts at 320 pixels in Arabic.
- `flutter analyze lib test --no-pub`: no issues.
- `flutter build apk --debug --no-pub`: successful.
- The SQL ran twice against isolated PostgreSQL (PGlite), verifying UUID/name
  preservation, retained activation state and no duplicate rows.
- Hosted bank counts and public API access were verified after the update;
  Supabase security advisors reported no errors at the error level.

Live account password changes and physical-device SMS delivery still require
an authenticated device test. Offline detection and bundled branding work
independently of a network connection. Other settings/features outside this
bank/card/import/password flow were not subjected to an exhaustive device audit.
