# Floosy — Supabase Database Setup

## Prerequisites

1. A [Supabase](https://supabase.com) project with **Authentication** enabled.
2. Supabase **service_role** access (via SQL Editor — no special role needed).

## How to Run the Schema

### Option A — Supabase Dashboard (Recommended)

1. Open your Supabase project dashboard.
2. Navigate to **SQL Editor**.
3. Click **New Query**.
4. Copy and paste the contents of `floosy_complete_schema.sql`.
5. Click **Run**.

The script is **idempotent** — every `CREATE TABLE` uses `IF NOT EXISTS`, every
enum uses `EXCEPTION WHEN duplicate_object`, and every policy/trigger uses
`CREATE OR REPLACE` / `DROP ... IF EXISTS`. You can re-run the script safely.

### Option B — Individual Migrations

Run the numbered files in order (each is also idempotent):

```
001_extensions.sql → 002_enums.sql → 003_profiles.sql → 004_banks.sql
→ 005_bank_sms_patterns.sql → 006_categories.sql → 007_merchants.sql
→ 008_items.sql → 009_transactions.sql → 010_sms_messages.sql
→ 011_cash_wallets.sql → 012_expenses.sql → 013_recurring_expenses.sql
→ 014_budgets.sql → 015_savings.sql → 016_alerts_badges.sql
→ 017_notifications.sql → 018_ai.sql → 019_reports.sql → 020_audit_sync.sql
→ 021_storage_policies.sql → 022_database_functions.sql → 023_triggers.sql
→ 024_seed_data.sql → 025_money_tables.sql
```

## Storage Buckets

Before using item images, create the following storage buckets via the Supabase
Dashboard (Storage → New Bucket):

| Bucket | Public | Notes |
|--------|--------|-------|
| `item-images` | Yes | User-isolated item photos (`{userId}/{itemId}.{ext}`) |
| `avatars` | Yes | User avatars (`{userId}/avatar.{ext}`) |
| `receipt-images` | Yes | Receipt photos |

The RLS policies in `021_storage_policies.sql` restrict each user to their own
folder.

## After Running the Schema

1. **Authentication → Users**: Create or verify your test user.
   - Do NOT create test users via SQL — use the Supabase Auth UI.
2. **Authentication → Settings → URLs**:
   - Set `http://localhost:3000` (for web dev) and your app's redirect URL.
   - Disable email confirmation for development if needed.

## Row-Level Security

Every user-owned table has RLS enabled with `auth.uid() = user_id` policies.
The `bank_sms_patterns` table is system-wide (read-only for all).

## Automatic Profile/Wallet Creation

The `handle_new_user()` trigger fires on `auth.users` INSERT (new signups) and
automatically creates a `profiles` row and a `cash_wallets` row (currency: EGP).
