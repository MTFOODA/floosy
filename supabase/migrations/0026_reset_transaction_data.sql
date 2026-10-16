-- 0026_reset_transaction_data.sql
-- =============================================================================
-- INTENTIONAL ONE-TIME DATA RESET — TRANSACTION / SMS SUBSYSTEM
-- =============================================================================
-- Resets ALL currently generated transaction-related data so the app starts
-- fresh and only processes bank/wallet SMS from September 1, 2026 onward.
--
-- SCOPE (cleared):
--   * sms_messages
--   * transactions
--   * expenses / expense_items / item_usage
--   * user_bank_movements / user_bank_accounts
--   * cash_movements / cash_wallets
--   * monthly_incomes
--
-- PRESERVED (NOT touched):
--   * auth.users (authentication accounts)
--   * profiles (user profile, settings, default bank, preferences)
--   * banks / categories / merchants (static lookup catalogs)
--   * budgets / recurring_expenses / savings / alerts / notifications
--   * ai / reports / sync queue
--   * items (user-managed reusable items are preserved; only usage history
--     and purchase/expense records above are cleared)
--
-- NOTE: This is a DESTRUCTIVE, GLOBAL reset. Run it once in the Supabase SQL
-- editor (or via supabase db reset) only when you intend to wipe the current
-- test/generated data. Because row-level security is enabled, execute it with
-- a privileged role (postgres / service_role) so it can clear every row.
-- =============================================================================

begin;

-- 1. SMS metadata (source of duplicate detection).
delete from public.sms_messages;

-- 2. Expense-derived records (children first).
delete from public.item_usage;
delete from public.expense_items;
delete from public.expenses;

-- 3. Bank ledger (multi-bank accounts + movements).
delete from public.user_bank_movements;
delete from public.user_bank_accounts;

-- 4. Pocket Cash ledger.
delete from public.cash_movements;
delete from public.cash_wallets;

-- 5. Monthly income / salary entries.
delete from public.monthly_incomes;

-- 6. Transactions last (SMS records reference it with on-delete-set-null,
--    so this order keeps foreign keys consistent).
delete from public.transactions;

commit;
