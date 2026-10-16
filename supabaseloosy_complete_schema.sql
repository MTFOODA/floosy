-- =============================================================================
-- Floosy - Canonical Supabase Schema
-- Self-contained, one-shot, fresh-install, production ready
-- =============================================================================
-- HOW TO USE
--   1. Create a brand-new Supabase project.
--   2. Open the SQL Editor.
--   3. Paste this ENTIRE file.
--   4. Run it ONCE, top to bottom. It must complete with no SQL error.
--
-- This file is the FINAL desired database state. It is written to be safely
-- re-runnable (CREATE ... IF NOT EXISTS / CREATE OR REPLACE / DROP ... IF
-- EXISTS / guarded enum creation), so it may also be applied to a database
-- that already contains part of this schema.
--
-- It deliberately contains NO destructive reset logic. The global data wipe in
-- migration 0026_reset_transaction_data.sql is intentionally NOT represented
-- here: this file only ever CREATES or REPLACES schema objects and never
-- DELETEs rows from a user table.
--
-- MONEY CONVENTION
--   * Every amount is stored in MINOR units (piastres for EGP) in a bigint.
--   * Direction is NEVER encoded in the sign of the amount. It is encoded in a
--     dedicated direction column:
--       - public.cash_movements.type        (movement_type: in|out|adjustment)
--       - public.user_bank_movements.type  (varchar CHECK IN (in,out))
--     A balance is therefore always
--         SUM(CASE WHEN type = 'in' THEN amount_minor ELSE -amount_minor END)
--     This single rule is applied identically by get_cash_balance(), by
--     v_user_balances and by the Flutter client, so the three can never
--     disagree. The app writes an adjustment as a directional in/out row with
--     reference_type = 'adjustment', exactly as Flutter adjustBalance() does.
--
-- STATEMENT ORDER (strict dependency order - do not reorder)
--    1. Extensions      2. Enums             3. Tables (topological)
--    4. Constraints    5. Functions          6. Views
--    7. Triggers       8. RLS enablement     9. RLS policies
--   10. Storage       11. Seed data         12. Grants
-- =============================================================================

CREATE EXTENSION IF NOT EXISTS pgcrypto;
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- =============================================================================
-- SECTION 1: ENUMS
-- =============================================================================
-- Each enum is created inside a DO block that swallows duplicate_object, so
-- this file stays re-runnable.

DO $$ BEGIN
  CREATE TYPE public.transaction_type AS ENUM (
    'purchase','atm_withdrawal','cash_expense','income','adjustment',
    'refund','reversal','transfer_in','transfer_out');
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

DO $$ BEGIN
  CREATE TYPE public.transaction_source AS ENUM (
    'sms','manual','receipt','system','ai_assisted');
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

DO $$ BEGIN
  CREATE TYPE public.transaction_status AS ENUM (
    'pending','confirmed','cancelled','reversed');
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

-- Superset of the Dart PaymentMethod { cash, card }: extra values are inert.
DO $$ BEGIN
  CREATE TYPE public.payment_method AS ENUM (
    'card','cash','bank_transfer','other');
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

-- Canonical movement direction for the pocket-cash ledger.
-- ONLY 'in', 'out' and 'adjustment' exist here. Values such as
-- 'atm_withdrawal', 'income', 'manual_in' or 'adjustment_in' belong to
-- transaction_type (or do not exist at all) and MUST NEVER be compared against
-- or inserted into a movement_type column.
DO $$ BEGIN
  CREATE TYPE public.movement_type AS ENUM ('in','out','adjustment');
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

DO $$ BEGIN
  CREATE TYPE public.budget_period AS ENUM (
    'weekly','monthly','yearly','custom');
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

DO $$ BEGIN
  CREATE TYPE public.recurring_frequency AS ENUM (
    'daily','weekly','monthly','yearly','custom');
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

DO $$ BEGIN
  CREATE TYPE public.recurring_occurrence_status AS ENUM (
    'pending','paid','skipped','cancelled');
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

DO $$ BEGIN
  CREATE TYPE public.category_type AS ENUM (
    'expense','income','both','transfer');
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

DO $$ BEGIN
  CREATE TYPE public.alert_type AS ENUM (
    'high_item_usage','budget_warning','high_spending',
    'subscription_detected','cash_difference','saving_opportunity');
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

DO $$ BEGIN
  CREATE TYPE public.alert_severity AS ENUM ('info','warning','critical');
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

DO $$ BEGIN
  CREATE TYPE public.ai_message_role AS ENUM ('user','assistant','tool','system');
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

DO $$ BEGIN
  CREATE TYPE public.ai_action_status AS ENUM (
    'pending_confirmation','confirmed','rejected','executed','completed','failed');
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

-- Superset of the Dart RecommendationStatus { active, completed, dismissed }.
-- 'completed' MUST be present: the app writes it.
DO $$ BEGIN
  CREATE TYPE public.recommendation_status AS ENUM (
    'active','applied','completed','dismissed','expired');
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

DO $$ BEGIN
  CREATE TYPE public.sync_operation AS ENUM ('insert','update','delete');
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

DO $$ BEGIN
  CREATE TYPE public.sync_status AS ENUM (
    'pending','processing','synced','completed','failed');
EXCEPTION WHEN duplicate_object THEN NULL; END $$;
-- =============================================================================
-- SECTION 2: BASE / REFERENCE TABLES
-- =============================================================================

CREATE TABLE IF NOT EXISTS public.banks (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    name varchar(150) NOT NULL,
    name_ar varchar(150),
    code varchar(50) UNIQUE,
    logo_url text,
    country varchar(2) NOT NULL DEFAULT 'EG',
    currency varchar(3) NOT NULL DEFAULT 'EGP',
    is_active boolean NOT NULL DEFAULT true,
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS public.profiles (
    id uuid PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    full_name varchar,
    email varchar,
    phone varchar,
    avatar_url text,
    language varchar(10) NOT NULL DEFAULT 'ar',
    currency varchar(3) NOT NULL DEFAULT 'EGP',
    default_bank_id uuid,
    sms_tracking_enabled boolean NOT NULL DEFAULT false,
    notifications_enabled boolean NOT NULL DEFAULT true,
    biometric_lock_enabled boolean NOT NULL DEFAULT false,
    hide_balances boolean NOT NULL DEFAULT false,
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now()
);
CREATE UNIQUE INDEX IF NOT EXISTS idx_profiles_email
  ON public.profiles(email) WHERE email IS NOT NULL;

-- Added by migration 004 once both tables exist.
DO $$ BEGIN
  ALTER TABLE public.profiles
    ADD CONSTRAINT profiles_default_bank_fk
    FOREIGN KEY (default_bank_id) REFERENCES public.banks(id) ON DELETE SET NULL;
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

CREATE TABLE IF NOT EXISTS public.bank_sms_patterns (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    bank_id uuid NOT NULL REFERENCES public.banks(id) ON DELETE CASCADE,
    sender_pattern text NOT NULL,
    purchase_patterns jsonb NOT NULL DEFAULT '[]'::jsonb,
    atm_patterns jsonb NOT NULL DEFAULT '[]'::jsonb,
    refund_patterns jsonb NOT NULL DEFAULT '[]'::jsonb,
    income_patterns jsonb NOT NULL DEFAULT '[]'::jsonb,
    reversal_patterns jsonb NOT NULL DEFAULT '[]'::jsonb,
    amount_pattern text,
    merchant_pattern text,
    card_pattern text,
    date_pattern text,
    is_active boolean NOT NULL DEFAULT true,
    version integer NOT NULL DEFAULT 1,
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX IF NOT EXISTS idx_bank_sms_patterns_bank
  ON public.bank_sms_patterns(bank_id);

CREATE TABLE IF NOT EXISTS public.categories (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id uuid REFERENCES auth.users(id) ON DELETE CASCADE,
    name varchar(100) NOT NULL,
    name_ar varchar(100),
    icon varchar(100),
    parent_id uuid REFERENCES public.categories(id) ON DELETE SET NULL,
    type public.category_type NOT NULL DEFAULT 'expense',
    is_system boolean NOT NULL DEFAULT false,
    is_active boolean NOT NULL DEFAULT true,
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX IF NOT EXISTS idx_categories_user ON public.categories(user_id);
CREATE INDEX IF NOT EXISTS idx_categories_parent ON public.categories(parent_id);

CREATE TABLE IF NOT EXISTS public.merchants (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    name varchar NOT NULL,
    normalized_name varchar NOT NULL,
    category_id uuid REFERENCES public.categories(id) ON DELETE SET NULL,
    logo_url text,
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX IF NOT EXISTS idx_merchants_user_normalized
  ON public.merchants(user_id, normalized_name);

CREATE TABLE IF NOT EXISTS public.items (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    name varchar NOT NULL,
    name_ar varchar,
    description text,
    price_minor bigint NOT NULL CHECK (price_minor >= 0),
    currency varchar(3) NOT NULL DEFAULT 'EGP',
    category_id uuid REFERENCES public.categories(id) ON DELETE SET NULL,
    icon varchar,
    image_url text,
    is_active boolean NOT NULL DEFAULT true,
    is_archived boolean NOT NULL DEFAULT false,
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX IF NOT EXISTS idx_items_user ON public.items(user_id);

-- Flutter writes effective_from / effective_to here: it closes the open row with
-- effective_to and then inserts the next one. The Dart ItemPriceHistory model
-- is the contract, so recorded_at from the original migration is not used.
CREATE TABLE IF NOT EXISTS public.item_price_history (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    item_id uuid NOT NULL REFERENCES public.items(id) ON DELETE CASCADE,
    price_minor bigint NOT NULL CHECK (price_minor >= 0),
    currency varchar(3) NOT NULL DEFAULT 'EGP',
    effective_from timestamptz NOT NULL DEFAULT now(),
    effective_to timestamptz,
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX IF NOT EXISTS idx_item_price_history_item
  ON public.item_price_history(item_id, effective_from DESC);
-- At most one open (effective_to IS NULL) price row per item.
CREATE UNIQUE INDEX IF NOT EXISTS item_price_history_one_open_row
  ON public.item_price_history(item_id) WHERE effective_to IS NULL;
-- =============================================================================
-- SECTION 3: POCKET-CASH (WALLET) TABLES
-- =============================================================================
-- One wallet per user. cash_wallets.user_id is UNIQUE, which is what lets
-- handle_new_user() use ON CONFLICT (user_id) DO NOTHING.

CREATE TABLE IF NOT EXISTS public.cash_wallets (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id uuid NOT NULL UNIQUE REFERENCES auth.users(id) ON DELETE CASCADE,
    currency varchar(3) NOT NULL DEFAULT 'EGP',
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now()
);

-- The pocket-cash ledger. `type` is movement_type and `amount_minor` is always
-- a POSITIVE magnitude; the sign of the balance comes from `type`. The balance
-- is SUM(CASE WHEN type = 'in' THEN amount_minor ELSE -amount_minor END).
CREATE TABLE IF NOT EXISTS public.cash_movements (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    wallet_id uuid NOT NULL REFERENCES public.cash_wallets(id) ON DELETE CASCADE,
    type public.movement_type NOT NULL,
    amount_minor bigint NOT NULL CHECK (amount_minor > 0),
    reference_type varchar,
    reference_id uuid,
    description text,
    movement_date timestamptz NOT NULL DEFAULT now(),
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX IF NOT EXISTS idx_cash_movements_user
  ON public.cash_movements(user_id);
CREATE INDEX IF NOT EXISTS idx_cash_movements_wallet
  ON public.cash_movements(wallet_id);
CREATE INDEX IF NOT EXISTS idx_cash_movements_user_date
  ON public.cash_movements(user_id, movement_date DESC);

-- =============================================================================
-- SECTION 4: DETECTED CARDS, TRANSACTIONS & SMS MESSAGES
-- =============================================================================
-- Card identity is (user_id, last4, bank_name). last4 is deliberately NOT
-- globally unique: two users, or two banks, may hold cards that share the
-- same last four digits.

CREATE TABLE IF NOT EXISTS public.detected_cards (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    last4 varchar(4) NOT NULL,
    bank_name varchar,
    transaction_count integer NOT NULL DEFAULT 0,
    appearance jsonb NOT NULL DEFAULT '{}'::jsonb,
    is_credit_card boolean NOT NULL DEFAULT false,
    credit_limit_minor bigint NOT NULL DEFAULT 0,
    current_balance_minor bigint NOT NULL DEFAULT 0,
    cash_withdrawal_enabled boolean NOT NULL DEFAULT false,
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now()
);
-- coalesce() keeps the index usable when bank_name is NULL, because two NULLs
-- never compare equal.
CREATE UNIQUE INDEX IF NOT EXISTS detected_cards_user_last4_bank_unique
  ON public.detected_cards(user_id, last4, coalesce(bank_name, ''));
CREATE INDEX IF NOT EXISTS detected_cards_user_idx
  ON public.detected_cards(user_id);
CREATE INDEX IF NOT EXISTS detected_cards_user_bank_last4_idx
  ON public.detected_cards(user_id, bank_name, last4);

CREATE TABLE IF NOT EXISTS public.transactions (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    bank_id uuid REFERENCES public.banks(id) ON DELETE SET NULL,
    category_id uuid REFERENCES public.categories(id) ON DELETE SET NULL,
    merchant_id uuid REFERENCES public.merchants(id) ON DELETE SET NULL,
    type public.transaction_type NOT NULL,
    source public.transaction_source NOT NULL DEFAULT 'manual',
    amount_minor bigint NOT NULL CHECK (amount_minor >= 0),
    currency varchar(3) NOT NULL DEFAULT 'EGP',
    transaction_date timestamptz NOT NULL DEFAULT now(),
    merchant_name varchar(200),
    card_last4 varchar(4),
    card_id uuid REFERENCES public.detected_cards(id) ON DELETE SET NULL,
    raw_reference text,
    external_reference text,
    fingerprint varchar(128),
    status public.transaction_status NOT NULL DEFAULT 'confirmed',
    notes text,
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX IF NOT EXISTS idx_transactions_user_id
  ON public.transactions(user_id);
CREATE INDEX IF NOT EXISTS idx_transactions_user_date
  ON public.transactions(user_id, transaction_date DESC);
CREATE INDEX IF NOT EXISTS idx_transactions_user_type
  ON public.transactions(user_id, type);
CREATE INDEX IF NOT EXISTS idx_transactions_user_bank
  ON public.transactions(user_id, bank_id);
CREATE INDEX IF NOT EXISTS idx_transactions_user_category
  ON public.transactions(user_id, category_id);
CREATE INDEX IF NOT EXISTS idx_transactions_user_merchant
  ON public.transactions(user_id, merchant_id);
CREATE INDEX IF NOT EXISTS idx_transactions_user_card
  ON public.transactions(user_id, card_id);
-- Dedupe identity for SMS-derived transactions. USER-SCOPED by design, and the
-- partial predicate leaves manually entered rows (fingerprint IS NULL) free.
CREATE UNIQUE INDEX IF NOT EXISTS transactions_user_fingerprint_unique
  ON public.transactions(user_id, fingerprint) WHERE fingerprint IS NOT NULL;
-- SMS ingestion metadata. transaction_id is ON DELETE SET NULL so deleting a
-- transaction never destroys the record of the message that produced it; the
-- Flutter client relies on this in deleteTransactionReferences().
CREATE TABLE IF NOT EXISTS public.sms_messages (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    sender varchar(200),
    message_hash varchar(128) NOT NULL,
    message_body text,
    received_at timestamptz NOT NULL DEFAULT now(),
    bank_identified boolean NOT NULL DEFAULT false,
    type_identified boolean NOT NULL DEFAULT false,
    amount_identified boolean NOT NULL DEFAULT false,
    currency_identified boolean NOT NULL DEFAULT false,
    card_last4_identified boolean NOT NULL DEFAULT false,
    detected_bank_id uuid REFERENCES public.banks(id) ON DELETE SET NULL,
    detected_bank_name varchar,
    detected_type varchar,
    detected_amount_minor bigint,
    detected_currency varchar(3),
    detected_card_last4 varchar(4),
    processed_at timestamptz,
    processing_status varchar(30) NOT NULL DEFAULT 'pending',
    transaction_id uuid REFERENCES public.transactions(id) ON DELETE SET NULL,
    parser_version varchar(50),
    confidence double precision
      CHECK (confidence IS NULL OR (confidence >= 0 AND confidence <= 1)),
    created_at timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX IF NOT EXISTS idx_sms_messages_user
  ON public.sms_messages(user_id);
CREATE INDEX IF NOT EXISTS idx_sms_messages_status
  ON public.sms_messages(user_id, processing_status);
CREATE INDEX IF NOT EXISTS idx_sms_messages_received
  ON public.sms_messages(user_id, received_at DESC);
-- Dedupe identity. USER-SCOPED by design: two users may legitimately receive
-- byte-identical SMS text. Flutter upserts with onConflict user_id,message_hash,
-- so this exact unique index is what makes that upsert work.
CREATE UNIQUE INDEX IF NOT EXISTS sms_messages_user_hash_unique
  ON public.sms_messages(user_id, message_hash);

-- =============================================================================
-- SECTION 5: BANK MONEY TABLES
-- =============================================================================
-- "My Balance" is the user's bank money: opening balance plus ledger movements
-- across every account. Balances are always DERIVED, never stored.

CREATE TABLE IF NOT EXISTS public.monthly_incomes (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    year smallint NOT NULL CHECK (year >= 2000),
    month smallint NOT NULL CHECK (month BETWEEN 1 AND 12),
    label varchar(200),
    amount_minor bigint NOT NULL CHECK (amount_minor >= 0),
    currency varchar(3) NOT NULL DEFAULT 'EGP',
    bank_account_id uuid,
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX IF NOT EXISTS idx_monthly_incomes_user_period
  ON public.monthly_incomes(user_id, year, month);

CREATE TABLE IF NOT EXISTS public.user_bank_accounts (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    name varchar(150) NOT NULL,
    bank_id uuid REFERENCES public.banks(id) ON DELETE SET NULL,
    account_last4 varchar(4),
    opening_balance_minor bigint NOT NULL DEFAULT 0 CHECK (opening_balance_minor >= 0),
    currency varchar(3) NOT NULL DEFAULT 'EGP',
    is_active boolean NOT NULL DEFAULT true,
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX IF NOT EXISTS idx_user_bank_accounts_user
  ON public.user_bank_accounts(user_id);

-- Bank ledger. `type` is a plain varchar constrained to in/out (the Dart
-- BankAccountMovement.type field is a String) and amount_minor is a positive
-- magnitude. Direction lives in `type`, exactly as for cash_movements.
CREATE TABLE IF NOT EXISTS public.user_bank_movements (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    account_id uuid NOT NULL REFERENCES public.user_bank_accounts(id) ON DELETE CASCADE,
    user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    type varchar(10) NOT NULL CHECK (type IN ('in', 'out')),
    amount_minor bigint NOT NULL CHECK (amount_minor > 0),
    description text,
    reference_type varchar(50),
    reference_id uuid,
    movement_date timestamptz NOT NULL DEFAULT now(),
    created_at timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX IF NOT EXISTS idx_user_bank_movements_user_date
  ON public.user_bank_movements(user_id, movement_date DESC);
CREATE INDEX IF NOT EXISTS idx_user_bank_movements_account
  ON public.user_bank_movements(account_id);
CREATE INDEX IF NOT EXISTS idx_user_bank_movements_reference
  ON public.user_bank_movements(user_id, reference_type, reference_id);

-- Deferred FK: monthly_incomes -> user_bank_accounts (both now exist).
DO $$ BEGIN
  ALTER TABLE public.monthly_incomes
    ADD CONSTRAINT monthly_incomes_bank_account_fk
    FOREIGN KEY (bank_account_id)
    REFERENCES public.user_bank_accounts(id) ON DELETE SET NULL;
EXCEPTION WHEN duplicate_object THEN NULL; END $$;
-- =============================================================================
-- SECTION 6: EXPENSE TABLES
-- =============================================================================

CREATE TABLE IF NOT EXISTS public.expenses (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    transaction_id uuid REFERENCES public.transactions(id) ON DELETE SET NULL,
    category_id uuid REFERENCES public.categories(id) ON DELETE SET NULL,
    amount_minor bigint NOT NULL CHECK (amount_minor >= 0),
    currency varchar(3) NOT NULL DEFAULT 'EGP',
    expense_date timestamptz NOT NULL DEFAULT now(),
    payment_method public.payment_method NOT NULL DEFAULT 'cash',
    merchant_id uuid REFERENCES public.merchants(id) ON DELETE SET NULL,
    notes text,
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX IF NOT EXISTS idx_expenses_user_id
  ON public.expenses(user_id);
CREATE INDEX IF NOT EXISTS idx_expenses_user_date
  ON public.expenses(user_id, expense_date DESC);
CREATE INDEX IF NOT EXISTS idx_expenses_user_category
  ON public.expenses(user_id, category_id);

-- The Dart ExpenseItem requires item_id and never sends item_name, so item_id
-- is NOT NULL and no additional NOT NULL column is introduced here.
CREATE TABLE IF NOT EXISTS public.expense_items (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    expense_id uuid NOT NULL REFERENCES public.expenses(id) ON DELETE CASCADE,
    item_id uuid NOT NULL REFERENCES public.items(id) ON DELETE CASCADE,
    quantity integer NOT NULL DEFAULT 1 CHECK (quantity > 0),
    unit_price_minor bigint NOT NULL CHECK (unit_price_minor >= 0),
    total_price_minor bigint NOT NULL CHECK (total_price_minor >= 0),
    created_at timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX IF NOT EXISTS idx_expense_items_expense
  ON public.expense_items(expense_id);
CREATE INDEX IF NOT EXISTS idx_expense_items_item
  ON public.expense_items(item_id);

CREATE TABLE IF NOT EXISTS public.item_usage (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    item_id uuid NOT NULL REFERENCES public.items(id) ON DELETE CASCADE,
    expense_id uuid NOT NULL REFERENCES public.expenses(id) ON DELETE CASCADE,
    quantity integer NOT NULL DEFAULT 1 CHECK (quantity > 0),
    total_amount_minor bigint NOT NULL CHECK (total_amount_minor >= 0),
    usage_date timestamptz NOT NULL DEFAULT now(),
    created_at timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX IF NOT EXISTS idx_item_usage_user ON public.item_usage(user_id);
CREATE INDEX IF NOT EXISTS idx_item_usage_item ON public.item_usage(item_id);
CREATE INDEX IF NOT EXISTS idx_item_usage_user_item_date
  ON public.item_usage(user_id, item_id, usage_date DESC);

-- =============================================================================
-- SECTION 7: BUDGET & RECURRING EXPENSE TABLES
-- =============================================================================

CREATE TABLE IF NOT EXISTS public.budgets (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    name varchar(150) NOT NULL,
    amount_minor bigint NOT NULL CHECK (amount_minor >= 0),
    currency varchar(3) NOT NULL DEFAULT 'EGP',
    period public.budget_period NOT NULL DEFAULT 'monthly',
    start_date timestamptz NOT NULL,
    end_date timestamptz NOT NULL,
    is_active boolean NOT NULL DEFAULT true,
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now(),
    CHECK (end_date >= start_date)
);
-- NOT unique: a user owns many budgets (Flutter getBudgets returns a list and
-- createBudget inserts a new row each time).
CREATE INDEX IF NOT EXISTS idx_budgets_user_period
  ON public.budgets(user_id, start_date DESC);

CREATE TABLE IF NOT EXISTS public.budget_categories (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    budget_id uuid NOT NULL REFERENCES public.budgets(id) ON DELETE CASCADE,
    category_id uuid NOT NULL REFERENCES public.categories(id) ON DELETE CASCADE,
    limit_minor bigint NOT NULL CHECK (limit_minor >= 0),
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now(),
    UNIQUE (budget_id, category_id)
);

CREATE TABLE IF NOT EXISTS public.recurring_expenses (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    name varchar NOT NULL,
    name_ar varchar,
    amount_minor bigint NOT NULL CHECK (amount_minor >= 0),
    currency varchar(3) NOT NULL DEFAULT 'EGP',
    category_id uuid REFERENCES public.categories(id) ON DELETE SET NULL,
    icon varchar,
    frequency public.recurring_frequency NOT NULL DEFAULT 'monthly',
    next_due_date timestamptz NOT NULL,
    start_date timestamptz NOT NULL,
    end_date timestamptz,
    is_active boolean NOT NULL DEFAULT true,
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX IF NOT EXISTS idx_recurring_expenses_user
  ON public.recurring_expenses(user_id);
CREATE INDEX IF NOT EXISTS idx_recurring_expenses_due
  ON public.recurring_expenses(user_id, is_active, next_due_date);

CREATE TABLE IF NOT EXISTS public.recurring_expense_occurrences (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    recurring_expense_id uuid NOT NULL REFERENCES public.recurring_expenses(id) ON DELETE CASCADE,
    scheduled_date timestamptz NOT NULL,
    amount_minor bigint NOT NULL CHECK (amount_minor > 0),
    status public.recurring_occurrence_status NOT NULL DEFAULT 'pending',
    transaction_id uuid REFERENCES public.transactions(id) ON DELETE SET NULL,
    created_at timestamptz NOT NULL DEFAULT now(),
    UNIQUE (recurring_expense_id, scheduled_date)
);
CREATE INDEX IF NOT EXISTS idx_recurring_occurrences_user_date
  ON public.recurring_expense_occurrences(user_id, scheduled_date DESC);
-- =============================================================================
-- SECTION 8: SAVINGS, ANALYTICS, NOTIFICATION & AUDIT TABLES
-- =============================================================================

CREATE TABLE IF NOT EXISTS public.saving_goals (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    name varchar(150) NOT NULL,
    target_amount_minor bigint NOT NULL CHECK (target_amount_minor > 0),
    current_amount_minor bigint NOT NULL DEFAULT 0 CHECK (current_amount_minor >= 0),
    currency varchar(3) NOT NULL DEFAULT 'EGP',
    target_date timestamptz,
    status varchar(30) NOT NULL DEFAULT 'active',
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX IF NOT EXISTS idx_saving_goals_user ON public.saving_goals(user_id);

CREATE TABLE IF NOT EXISTS public.saving_recommendations (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    item_id uuid REFERENCES public.items(id) ON DELETE CASCADE,
    category_id uuid REFERENCES public.categories(id) ON DELETE CASCADE,
    baseline_amount_minor bigint NOT NULL DEFAULT 0 CHECK (baseline_amount_minor >= 0),
    current_amount_minor bigint NOT NULL DEFAULT 0 CHECK (current_amount_minor >= 0),
    reduction_percentage numeric(5,2) NOT NULL
      CHECK (reduction_percentage >= 0 AND reduction_percentage <= 100),
    estimated_saving_minor bigint NOT NULL DEFAULT 0 CHECK (estimated_saving_minor >= 0),
    month smallint NOT NULL CHECK (month BETWEEN 1 AND 12),
    year smallint NOT NULL CHECK (year >= 2000),
    status public.recommendation_status NOT NULL DEFAULT 'active',
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX IF NOT EXISTS idx_saving_recommendations_user
  ON public.saving_recommendations(user_id);

CREATE TABLE IF NOT EXISTS public.alerts (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    type public.alert_type NOT NULL,
    severity public.alert_severity NOT NULL DEFAULT 'info',
    item_id uuid REFERENCES public.items(id) ON DELETE SET NULL,
    category_id uuid REFERENCES public.categories(id) ON DELETE SET NULL,
    title varchar(200) NOT NULL,
    message text NOT NULL,
    data jsonb NOT NULL DEFAULT '{}'::jsonb,
    is_read boolean NOT NULL DEFAULT false,
    created_at timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX IF NOT EXISTS idx_alerts_user
  ON public.alerts(user_id, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_alerts_user_read
  ON public.alerts(user_id, is_read);

-- The Dart class is named AppNotification, but the TABLE is `notifications`
-- (migration 017). There is no app_notifications table anywhere in this file.
CREATE TABLE IF NOT EXISTS public.notifications (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    type varchar(50) NOT NULL,
    title varchar(200) NOT NULL,
    message text NOT NULL,
    data jsonb NOT NULL DEFAULT '{}'::jsonb,
    is_read boolean NOT NULL DEFAULT false,
    scheduled_for timestamptz,
    sent_at timestamptz,
    created_at timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX IF NOT EXISTS idx_notifications_user_read
  ON public.notifications(user_id, is_read);
CREATE INDEX IF NOT EXISTS idx_notifications_user_created
  ON public.notifications(user_id, created_at DESC);

-- Column set matches migration 019 and the Dart MonthlyReport model exactly.
CREATE TABLE IF NOT EXISTS public.monthly_reports (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    year smallint NOT NULL CHECK (year >= 2000),
    month smallint NOT NULL CHECK (month BETWEEN 1 AND 12),
    total_income_minor bigint NOT NULL DEFAULT 0 CHECK (total_income_minor >= 0),
    total_expenses_minor bigint NOT NULL DEFAULT 0 CHECK (total_expenses_minor >= 0),
    card_expenses_minor bigint NOT NULL DEFAULT 0 CHECK (card_expenses_minor >= 0),
    cash_expenses_minor bigint NOT NULL DEFAULT 0 CHECK (cash_expenses_minor >= 0),
    atm_withdrawals_minor bigint NOT NULL DEFAULT 0 CHECK (atm_withdrawals_minor >= 0),
    top_category_id uuid REFERENCES public.categories(id) ON DELETE SET NULL,
    top_item_id uuid REFERENCES public.items(id) ON DELETE SET NULL,
    top_merchant_id uuid REFERENCES public.merchants(id) ON DELETE SET NULL,
    potential_savings_minor bigint NOT NULL DEFAULT 0 CHECK (potential_savings_minor >= 0),
    actual_savings_minor bigint NOT NULL DEFAULT 0 CHECK (actual_savings_minor >= 0),
    report_data jsonb NOT NULL DEFAULT '{}'::jsonb,
    generated_at timestamptz,
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now(),
    UNIQUE (user_id, year, month)
);
CREATE INDEX IF NOT EXISTS idx_monthly_reports_user_period
  ON public.monthly_reports(user_id, year, month);

CREATE TABLE IF NOT EXISTS public.monthly_item_statistics (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    item_id uuid NOT NULL REFERENCES public.items(id) ON DELETE CASCADE,
    year smallint NOT NULL CHECK (year >= 2000),
    month smallint NOT NULL CHECK (month BETWEEN 1 AND 12),
    quantity bigint NOT NULL DEFAULT 0 CHECK (quantity >= 0),
    purchase_events bigint NOT NULL DEFAULT 0 CHECK (purchase_events >= 0),
    total_spending_minor bigint NOT NULL DEFAULT 0 CHECK (total_spending_minor >= 0),
    average_price_minor bigint NOT NULL DEFAULT 0 CHECK (average_price_minor >= 0),
    previous_quantity bigint NOT NULL DEFAULT 0 CHECK (previous_quantity >= 0),
    previous_spending_minor bigint NOT NULL DEFAULT 0 CHECK (previous_spending_minor >= 0),
    usage_change_percentage numeric(8,2) NOT NULL DEFAULT 0,
    spending_change_percentage numeric(8,2) NOT NULL DEFAULT 0,
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now(),
    UNIQUE (user_id, item_id, year, month)
);
CREATE INDEX IF NOT EXISTS idx_monthly_item_stats_user_period
  ON public.monthly_item_statistics(user_id, year, month);

CREATE TABLE IF NOT EXISTS public.badges (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    code varchar(100) NOT NULL UNIQUE,
    name varchar(150) NOT NULL,
    name_ar varchar(150),
    description text,
    description_ar text,
    icon varchar(100),
    criteria jsonb NOT NULL DEFAULT '{}'::jsonb,
    created_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS public.user_badges (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    badge_id uuid NOT NULL REFERENCES public.badges(id) ON DELETE CASCADE,
    earned_at timestamptz NOT NULL DEFAULT now(),
    metadata jsonb NOT NULL DEFAULT '{}'::jsonb,
    UNIQUE (user_id, badge_id)
);

-- user_id is nullable and ON DELETE SET NULL (migration 020) so that audit
-- rows outlive the account they describe.
CREATE TABLE IF NOT EXISTS public.audit_logs (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id uuid REFERENCES auth.users(id) ON DELETE SET NULL,
    action varchar(100) NOT NULL,
    entity_type varchar(100) NOT NULL,
    entity_id uuid,
    old_data jsonb,
    new_data jsonb,
    created_at timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX IF NOT EXISTS idx_audit_logs_user_created
  ON public.audit_logs(user_id, created_at DESC);
-- =============================================================================
-- SECTION 9: AI TABLES
-- =============================================================================
-- ai_messages keeps the tool_* columns from migration 018 because the Dart
-- AIMessage model serialises tool_name, tool_arguments and tool_result, and
-- `content` is nullable there (a tool-call message has no natural-language
-- content yet).

CREATE TABLE IF NOT EXISTS public.ai_conversations (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    title varchar(200),
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX IF NOT EXISTS idx_ai_conversations_user
  ON public.ai_conversations(user_id, created_at DESC);

CREATE TABLE IF NOT EXISTS public.ai_messages (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    conversation_id uuid NOT NULL REFERENCES public.ai_conversations(id) ON DELETE CASCADE,
    user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    role public.ai_message_role NOT NULL,
    content text,
    tool_name varchar(100),
    tool_arguments jsonb,
    tool_result jsonb,
    metadata jsonb NOT NULL DEFAULT '{}'::jsonb,
    created_at timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX IF NOT EXISTS idx_ai_messages_conversation
  ON public.ai_messages(conversation_id, created_at);
CREATE INDEX IF NOT EXISTS idx_ai_messages_user
  ON public.ai_messages(user_id);

CREATE TABLE IF NOT EXISTS public.ai_actions (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    conversation_id uuid REFERENCES public.ai_conversations(id) ON DELETE CASCADE,
    tool_name varchar(100) NOT NULL,
    arguments jsonb NOT NULL DEFAULT '{}'::jsonb,
    status public.ai_action_status NOT NULL DEFAULT 'pending_confirmation',
    result jsonb,
    created_at timestamptz NOT NULL DEFAULT now(),
    confirmed_at timestamptz,
    completed_at timestamptz
);
CREATE INDEX IF NOT EXISTS idx_ai_actions_user ON public.ai_actions(user_id, status);
CREATE INDEX IF NOT EXISTS idx_ai_actions_pending
  ON public.ai_actions(user_id, created_at DESC) WHERE status = 'pending_confirmation';

-- =============================================================================
-- SECTION 10: SYNC QUEUE
-- =============================================================================

CREATE TABLE IF NOT EXISTS public.sync_queue (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    entity_type varchar(100) NOT NULL,
    entity_id uuid NOT NULL,
    operation public.sync_operation NOT NULL,
    payload jsonb NOT NULL DEFAULT '{}'::jsonb,
    status public.sync_status NOT NULL DEFAULT 'pending',
    retry_count integer NOT NULL DEFAULT 0 CHECK (retry_count >= 0),
    last_error text,
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX IF NOT EXISTS idx_sync_queue_user_status
  ON public.sync_queue(user_id, status);
CREATE INDEX IF NOT EXISTS idx_sync_queue_pending
  ON public.sync_queue(status, created_at) WHERE status IN ('pending', 'processing');
-- =============================================================================
-- SECTION 11: FUNCTIONS
-- =============================================================================
-- Every function below is SECURITY DEFINER with an explicit search_path, and
-- is created only after all of its tables, columns and enums exist.

CREATE OR REPLACE FUNCTION public.set_updated_at()
RETURNS trigger
LANGUAGE plpgsql
SET search_path = public
AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$;

-- POCKET-CASH BALANCE
-- cash_movements.type is movement_type, whose only values are
-- 'in', 'out' and 'adjustment'. The balance is therefore
--     SUM(CASE WHEN type = 'in' THEN amount_minor ELSE -amount_minor END)
-- and nothing else. Values such as 'atm_withdrawal', 'income', 'manual_in' or
-- 'adjustment_in' are NOT valid movement_type literals and must never appear
-- here: comparing them would raise
--   ERROR: invalid input value for enum movement_type
-- This is the exact same expression used by v_user_balances and by the Flutter
-- client, so the three implementations cannot drift apart.
CREATE OR REPLACE FUNCTION public.get_cash_balance(user_id_param uuid)
RETURNS bigint
LANGUAGE sql
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT COALESCE(SUM(
    CASE WHEN cm.type = 'in' THEN cm.amount_minor ELSE -cm.amount_minor END
  ), 0)
  FROM public.cash_movements cm
  WHERE cm.user_id = user_id_param;
$$;

CREATE OR REPLACE FUNCTION public.get_monthly_spending(
  user_id_param uuid, year_param smallint, month_param smallint)
RETURNS TABLE (category_id uuid, category_name varchar, total_amount_minor bigint)
LANGUAGE sql
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT c.id, c.name, COALESCE(SUM(e.amount_minor), 0)::bigint AS total_amount_minor
  FROM public.categories c
  LEFT JOIN public.expenses e
    ON c.id = e.category_id
   AND e.user_id = user_id_param
   AND extract(year FROM e.expense_date) = year_param
   AND extract(month FROM e.expense_date) = month_param
  WHERE c.user_id = user_id_param OR c.is_system = true
  GROUP BY c.id, c.name
  ORDER BY total_amount_minor DESC;
$$;

CREATE OR REPLACE FUNCTION public.get_item_usage_stats(
  user_id_param uuid, year_param smallint, month_param smallint)
RETURNS TABLE (
  item_id uuid, item_name varchar, quantity bigint,
  total_spending_minor bigint, average_price_minor bigint)
LANGUAGE sql
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT i.id, i.name,
    COALESCE(SUM(iu.quantity), 0)::bigint AS quantity,
    COALESCE(SUM(iu.total_amount_minor), 0)::bigint AS total_spending_minor,
    CASE
      WHEN COALESCE(SUM(iu.quantity), 0) > 0
        THEN (COALESCE(SUM(iu.total_amount_minor), 0)
              / COALESCE(SUM(iu.quantity), 1))::bigint
      ELSE 0
    END AS average_price_minor
  FROM public.items i
  LEFT JOIN public.item_usage iu
    ON i.id = iu.item_id
   AND iu.user_id = user_id_param
   AND extract(year FROM iu.usage_date) = year_param
   AND extract(month FROM iu.usage_date) = month_param
  WHERE i.user_id = user_id_param AND i.is_active = true
  GROUP BY i.id, i.name
  ORDER BY quantity DESC;
$$;

CREATE OR REPLACE FUNCTION public.calculate_savings_opportunity(
  user_id_param uuid, item_id_param uuid, reduction_percentage_param numeric)
RETURNS bigint
LANGUAGE sql
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT CASE
    WHEN COALESCE(SUM(iu.total_amount_minor), 0) > 0
      THEN (COALESCE(SUM(iu.total_amount_minor), 0)
            * reduction_percentage_param / 100)::bigint
    ELSE 0
  END
  FROM public.item_usage iu
  WHERE iu.user_id = user_id_param AND iu.item_id = item_id_param
    AND extract(year FROM iu.usage_date) = extract(year FROM now())
    AND extract(month FROM iu.usage_date) = extract(month FROM now());
$$;
-- Generic audit trigger helper.
--   * TG_ARGV[0] supplies the `action` label supplied at trigger creation.
--   * TG_TABLE_NAME supplies `entity_type`.
--   * entity_id is taken from the row `id`, which every audited table has.
--   * OLD is only referenced for UPDATE/DELETE and NEW only for INSERT/UPDATE,
--     because referencing the wrong one raises
--     "record \"old\" is not assigned yet" in PL/pgSQL.
-- The column list below matches public.audit_logs exactly.
CREATE OR REPLACE FUNCTION public.log_audit_event()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_old jsonb;
  v_new jsonb;
BEGIN
  IF TG_OP = 'DELETE' OR TG_OP = 'UPDATE' THEN
    v_old := to_jsonb(OLD);
  END IF;
  IF TG_OP = 'INSERT' OR TG_OP = 'UPDATE' THEN
    v_new := to_jsonb(NEW);
  END IF;

  INSERT INTO public.audit_logs
    (user_id, action, entity_type, entity_id, old_data, new_data)
  VALUES
    (auth.uid(),
     COALESCE(TG_ARGV[0], TG_OP),
     TG_TABLE_NAME,
     CASE WHEN TG_OP = 'DELETE' THEN (v_old ->> 'id')::uuid
          ELSE (v_new ->> 'id')::uuid END,
     v_old,
     v_new);

  IF TG_OP = 'DELETE' THEN
    RETURN OLD;
  END IF;
  RETURN NEW;
END;
$$;

-- Creates the profile and the pocket-cash wallet for every new auth user.
-- cash_wallets.user_id is UNIQUE, so ON CONFLICT (user_id) is valid.
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  INSERT INTO public.profiles (id, email, full_name)
  VALUES (NEW.id, NEW.email, NEW.raw_user_meta_data ->> 'full_name')
  ON CONFLICT (id) DO NOTHING;

  INSERT INTO public.cash_wallets (user_id)
  VALUES (NEW.id)
  ON CONFLICT (user_id) DO NOTHING;

  RETURN NEW;
END;
$$;

-- All bank accounts of a user with their DERIVED balance
-- (opening balance + in - out).
CREATE OR REPLACE FUNCTION public.get_bank_accounts_with_balance(user_id_param uuid)
RETURNS TABLE (
  id uuid, name varchar, bank_id uuid, currency varchar,
  opening_balance_minor bigint, balance_minor bigint, is_active boolean)
LANGUAGE sql
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT a.id, a.name, a.bank_id, a.currency, a.opening_balance_minor,
    a.opening_balance_minor
      + COALESCE((SELECT SUM(m.amount_minor)
                   FROM public.user_bank_movements m
                  WHERE m.account_id = a.id AND m.type = 'in'), 0)
      - COALESCE((SELECT SUM(m.amount_minor)
                   FROM public.user_bank_movements m
                  WHERE m.account_id = a.id AND m.type = 'out'), 0)
      AS balance_minor,
    a.is_active
  FROM public.user_bank_accounts a
  WHERE a.user_id = user_id_param
  ORDER BY a.created_at;
$$;

-- Total bank money across all ACTIVE accounts of a user.
CREATE OR REPLACE FUNCTION public.get_total_bank_balance(user_id_param uuid)
RETURNS bigint
LANGUAGE sql
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT COALESCE(SUM(b.balance), 0) FROM (
    SELECT a.opening_balance_minor
      + COALESCE((SELECT SUM(m.amount_minor)
                   FROM public.user_bank_movements m
                  WHERE m.account_id = a.id AND m.type = 'in'), 0)
      - COALESCE((SELECT SUM(m.amount_minor)
                   FROM public.user_bank_movements m
                  WHERE m.account_id = a.id AND m.type = 'out'), 0) AS balance
    FROM public.user_bank_accounts a
    WHERE a.user_id = user_id_param AND a.is_active = true
  ) b;
$$;

-- Deducted money = purchases + cash expenses + transfers sent.
-- These are all valid transaction_type literals.
CREATE OR REPLACE FUNCTION public.get_deducted_money(
  user_id_param uuid, year_param smallint, month_param smallint)
RETURNS bigint
LANGUAGE sql
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT COALESCE(SUM(t.amount_minor), 0)::bigint
  FROM public.transactions t
  WHERE t.user_id = user_id_param
    AND t.status = 'confirmed'
    AND t.type IN ('purchase', 'cash_expense', 'transfer_out')
    AND extract(year FROM t.transaction_date) = year_param
    AND extract(month FROM t.transaction_date) = month_param;
$$;
-- =============================================================================
-- SECTION 12: VIEWS
-- =============================================================================
-- Both views are declared WITH (security_invoker = true). Without it a view
-- runs with the privileges of its owner and BYPASSES the RLS policies of the
-- tables underneath it, which would let any authenticated user read every
-- other user's balances. security_invoker makes the caller's own RLS apply.

CREATE OR REPLACE VIEW public.v_user_balances
  WITH (security_invoker = true)
AS
  SELECT
    cm.user_id,
    COALESCE(SUM(
      CASE WHEN cm.type = 'in' THEN cm.amount_minor ELSE -cm.amount_minor END
    ), 0) AS cash_balance_minor
  FROM public.cash_movements cm
  GROUP BY cm.user_id;
COMMENT ON VIEW public.v_user_balances IS
  'Per-user pocket-cash balance. Uses the identical sign rule as '
  'get_cash_balance(): in = +amount_minor, everything else = -amount_minor.';

CREATE OR REPLACE VIEW public.v_monthly_item_summary
  WITH (security_invoker = true)
AS
  SELECT
    mis.user_id,
    mis.item_id,
    i.name AS item_name,
    mis.year,
    mis.month,
    mis.quantity,
    mis.total_spending_minor,
    mis.usage_change_percentage
  FROM public.monthly_item_statistics mis
  LEFT JOIN public.items i ON i.id = mis.item_id;

-- =============================================================================
-- SECTION 13: TRIGGERS
-- =============================================================================
-- updated_at maintenance. Every listed table really has an updated_at column.
DO $$
DECLARE
  t text;
BEGIN
  FOREACH t IN ARRAY ARRAY[
    'banks','profiles','bank_sms_patterns','categories','merchants','items',
    'item_price_history','cash_wallets','cash_movements','detected_cards',
    'transactions','expenses','recurring_expenses','budgets','budget_categories',
    'saving_goals','saving_recommendations','monthly_reports',
    'monthly_item_statistics','ai_conversations','sync_queue',
    'monthly_incomes','user_bank_accounts'
  ] LOOP
    EXECUTE format('DROP TRIGGER IF EXISTS %I ON public.%I', t || '_updated_at', t);
    EXECUTE format(
      'CREATE TRIGGER %I BEFORE UPDATE ON public.%I
         FOR EACH ROW EXECUTE FUNCTION public.set_updated_at()',
      t || '_updated_at', t);
  END LOOP;
END $$;

-- Audit trail for the financially significant tables.
-- The action label is passed as TG_ARGV[0] and read by log_audit_event().
DO $$
DECLARE
  t text;
  a text;
BEGIN
  FOREACH t IN ARRAY ARRAY['transactions','expenses','cash_movements','budgets']
  LOOP
    a := t || '_modified';
    EXECUTE format('DROP TRIGGER IF EXISTS %I ON public.%I', 'audit_' || t, t);
    EXECUTE format(
      'CREATE TRIGGER %I AFTER INSERT OR UPDATE OR DELETE ON public.%I
         FOR EACH ROW EXECUTE FUNCTION public.log_audit_event(%L)',
      'audit_' || t, t, a);
  END LOOP;
END $$;

-- New auth users get a profile and a pocket-cash wallet.
-- auth.users is owned by Supabase, so the trigger is dropped first to keep the
-- statement idempotent.
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();
-- =============================================================================
-- SECTION 14: ROW LEVEL SECURITY ENABLEMENT
-- =============================================================================
-- RLS is enabled on every application table. Reference/catalog tables get
-- public-read policies below; every user-owned table gets strict
-- auth.uid() = user_id isolation.

DO $$
DECLARE
  t text;
BEGIN
  FOREACH t IN ARRAY ARRAY[
    'banks','bank_sms_patterns','badges',
    'profiles','categories','merchants','items','item_price_history',
    'cash_wallets','cash_movements','detected_cards','transactions','sms_messages',
    'monthly_incomes','user_bank_accounts','user_bank_movements',
    'expenses','expense_items','item_usage',
    'budgets','budget_categories','recurring_expenses','recurring_expense_occurrences',
    'saving_goals','saving_recommendations','alerts','notifications',
    'monthly_reports','monthly_item_statistics','user_badges','audit_logs',
    'ai_conversations','ai_messages','ai_actions','sync_queue'
  ] LOOP
    EXECUTE format('ALTER TABLE public.%I ENABLE ROW LEVEL SECURITY', t);
  END LOOP;
END $$;

-- =============================================================================
-- SECTION 15: RLS POLICIES
-- =============================================================================
-- Naming convention: "<table>: <ACTION>". Every policy is dropped before it is
-- created, so re-running the file cannot produce a duplicate-policy error.

-- -----------------------------------------------------------------------------
-- 15.1 REFERENCE CATALOGS (read-only for every authenticated user)
-- -----------------------------------------------------------------------------
DROP POLICY IF EXISTS "Anyone can view active banks" ON public.banks;
CREATE POLICY "Anyone can view active banks"
  ON public.banks FOR SELECT USING (is_active = true);

DROP POLICY IF EXISTS "Anyone can view active patterns" ON public.bank_sms_patterns;
CREATE POLICY "Anyone can view active patterns"
  ON public.bank_sms_patterns FOR SELECT USING (is_active = true);

DROP POLICY IF EXISTS "Badges: SELECT" ON public.badges;
CREATE POLICY "Badges: SELECT"
  ON public.badges FOR SELECT USING (true);

-- -----------------------------------------------------------------------------
-- 15.2 USER-OWNED TABLES: full CRUD scoped to auth.uid() = user_id
-- -----------------------------------------------------------------------------
DO $$
DECLARE
  t text;
BEGIN
  FOREACH t IN ARRAY ARRAY[
    'cash_wallets','cash_movements','detected_cards','transactions','sms_messages',
    'monthly_incomes','user_bank_accounts','user_bank_movements',
    'expenses','item_usage','budgets','recurring_expenses',
    'recurring_expense_occurrences','saving_goals','saving_recommendations',
    'alerts','notifications','monthly_reports','monthly_item_statistics',
    'user_badges','ai_conversations','ai_actions','sync_queue','merchants'
  ] LOOP
    EXECUTE format('DROP POLICY IF EXISTS %I ON public.%I', t || ': SELECT', t);
    EXECUTE format('DROP POLICY IF EXISTS %I ON public.%I', t || ': INSERT', t);
    EXECUTE format('DROP POLICY IF EXISTS %I ON public.%I', t || ': UPDATE', t);
    EXECUTE format('DROP POLICY IF EXISTS %I ON public.%I', t || ': DELETE', t);

    EXECUTE format(
      'CREATE POLICY %I ON public.%I FOR SELECT USING (auth.uid() = user_id)',
      t || ': SELECT', t);
    EXECUTE format(
      'CREATE POLICY %I ON public.%I FOR INSERT WITH CHECK (auth.uid() = user_id)',
      t || ': INSERT', t);
    EXECUTE format(
      'CREATE POLICY %I ON public.%I FOR UPDATE
         USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id)',
      t || ': UPDATE', t);
    EXECUTE format(
      'CREATE POLICY %I ON public.%I FOR DELETE USING (auth.uid() = user_id)',
      t || ': DELETE', t);
  END LOOP;
END $$;
-- -----------------------------------------------------------------------------
-- 15.3 PROFILES - the owner key is `id`, not `user_id`
-- -----------------------------------------------------------------------------
DROP POLICY IF EXISTS "Users can view their own profile" ON public.profiles;
CREATE POLICY "Users can view their own profile"
  ON public.profiles FOR SELECT USING (auth.uid() = id);

DROP POLICY IF EXISTS "Users can insert their own profile" ON public.profiles;
CREATE POLICY "Users can insert their own profile"
  ON public.profiles FOR INSERT WITH CHECK (auth.uid() = id);

DROP POLICY IF EXISTS "Users can update their own profile" ON public.profiles;
CREATE POLICY "Users can update their own profile"
  ON public.profiles FOR UPDATE
  USING (auth.uid() = id) WITH CHECK (auth.uid() = id);

DROP POLICY IF EXISTS "Users can delete their own profile" ON public.profiles;
CREATE POLICY "Users can delete their own profile"
  ON public.profiles FOR DELETE USING (auth.uid() = id);

-- -----------------------------------------------------------------------------
-- 15.4 CATEGORIES - system rows (user_id IS NULL) are readable by everyone,
--      user rows only by their owner. Only an owner may write a user row.
-- -----------------------------------------------------------------------------
DROP POLICY IF EXISTS "View system + own categories" ON public.categories;
CREATE POLICY "View system + own categories"
  ON public.categories FOR SELECT
  USING (user_id IS NULL OR auth.uid() = user_id);

DROP POLICY IF EXISTS "Insert own categories" ON public.categories;
CREATE POLICY "Insert own categories"
  ON public.categories FOR INSERT WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "Update own categories" ON public.categories;
CREATE POLICY "Update own categories"
  ON public.categories FOR UPDATE
  USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "Delete own categories" ON public.categories;
CREATE POLICY "Delete own categories"
  ON public.categories FOR DELETE USING (auth.uid() = user_id);

-- -----------------------------------------------------------------------------
-- 15.5 ITEMS - direct owner scope
-- -----------------------------------------------------------------------------
DROP POLICY IF EXISTS "Items: SELECT" ON public.items;
CREATE POLICY "Items: SELECT" ON public.items FOR SELECT USING (auth.uid() = user_id);
DROP POLICY IF EXISTS "Items: INSERT" ON public.items;
CREATE POLICY "Items: INSERT" ON public.items FOR INSERT WITH CHECK (auth.uid() = user_id);
DROP POLICY IF EXISTS "Items: UPDATE" ON public.items;
CREATE POLICY "Items: UPDATE" ON public.items FOR UPDATE USING (auth.uid() = user_id);
DROP POLICY IF EXISTS "Items: DELETE" ON public.items;
CREATE POLICY "Items: DELETE" ON public.items FOR DELETE USING (auth.uid() = user_id);

-- -----------------------------------------------------------------------------
-- 15.6 AUDIT LOGS - readable by their owner. Rows are written by the
--      SECURITY DEFINER log_audit_event() trigger, which bypasses RLS, so no
--      INSERT policy is required (and none is granted to clients).
-- -----------------------------------------------------------------------------
DROP POLICY IF EXISTS "Audit logs: SELECT" ON public.audit_logs;
CREATE POLICY "Audit logs: SELECT"
  ON public.audit_logs FOR SELECT USING (auth.uid() = user_id);

-- -----------------------------------------------------------------------------
-- 15.7 CHILD TABLES - scoped through their parent row
-- -----------------------------------------------------------------------------
DROP POLICY IF EXISTS "Item price history: SELECT" ON public.item_price_history;
CREATE POLICY "Item price history: SELECT"
  ON public.item_price_history FOR SELECT
  USING (EXISTS (SELECT 1 FROM public.items i
                  WHERE i.id = item_price_history.item_id
                    AND i.user_id = auth.uid()));

DROP POLICY IF EXISTS "Item price history: INSERT" ON public.item_price_history;
CREATE POLICY "Item price history: INSERT"
  ON public.item_price_history FOR INSERT
  WITH CHECK (EXISTS (SELECT 1 FROM public.items i
                       WHERE i.id = item_price_history.item_id
                         AND i.user_id = auth.uid()));

DROP POLICY IF EXISTS "Item price history: UPDATE" ON public.item_price_history;
CREATE POLICY "Item price history: UPDATE"
  ON public.item_price_history FOR UPDATE
  USING (EXISTS (SELECT 1 FROM public.items i
                  WHERE i.id = item_price_history.item_id
                    AND i.user_id = auth.uid()));

DROP POLICY IF EXISTS "Item price history: DELETE" ON public.item_price_history;
CREATE POLICY "Item price history: DELETE"
  ON public.item_price_history FOR DELETE
  USING (EXISTS (SELECT 1 FROM public.items i
                  WHERE i.id = item_price_history.item_id
                    AND i.user_id = auth.uid()));

DROP POLICY IF EXISTS "Expense items: SELECT" ON public.expense_items;
CREATE POLICY "Expense items: SELECT"
  ON public.expense_items FOR SELECT
  USING (EXISTS (SELECT 1 FROM public.expenses e
                  WHERE e.id = expense_items.expense_id
                    AND e.user_id = auth.uid()));

DROP POLICY IF EXISTS "Expense items: INSERT" ON public.expense_items;
CREATE POLICY "Expense items: INSERT"
  ON public.expense_items FOR INSERT
  WITH CHECK (EXISTS (SELECT 1 FROM public.expenses e
                       WHERE e.id = expense_items.expense_id
                         AND e.user_id = auth.uid()));

DROP POLICY IF EXISTS "Expense items: UPDATE" ON public.expense_items;
CREATE POLICY "Expense items: UPDATE"
  ON public.expense_items FOR UPDATE
  USING (EXISTS (SELECT 1 FROM public.expenses e
                  WHERE e.id = expense_items.expense_id
                    AND e.user_id = auth.uid()));

DROP POLICY IF EXISTS "Expense items: DELETE" ON public.expense_items;
CREATE POLICY "Expense items: DELETE"
  ON public.expense_items FOR DELETE
  USING (EXISTS (SELECT 1 FROM public.expenses e
                  WHERE e.id = expense_items.expense_id
                    AND e.user_id = auth.uid()));
DROP POLICY IF EXISTS "Budget categories: SELECT" ON public.budget_categories;
CREATE POLICY "Budget categories: SELECT"
  ON public.budget_categories FOR SELECT
  USING (EXISTS (SELECT 1 FROM public.budgets b
                  WHERE b.id = budget_categories.budget_id
                    AND b.user_id = auth.uid()));

DROP POLICY IF EXISTS "Budget categories: INSERT" ON public.budget_categories;
CREATE POLICY "Budget categories: INSERT"
  ON public.budget_categories FOR INSERT
  WITH CHECK (EXISTS (SELECT 1 FROM public.budgets b
                       WHERE b.id = budget_categories.budget_id
                         AND b.user_id = auth.uid()));

DROP POLICY IF EXISTS "Budget categories: UPDATE" ON public.budget_categories;
CREATE POLICY "Budget categories: UPDATE"
  ON public.budget_categories FOR UPDATE
  USING (EXISTS (SELECT 1 FROM public.budgets b
                  WHERE b.id = budget_categories.budget_id
                    AND b.user_id = auth.uid()));

DROP POLICY IF EXISTS "Budget categories: DELETE" ON public.budget_categories;
CREATE POLICY "Budget categories: DELETE"
  ON public.budget_categories FOR DELETE
  USING (EXISTS (SELECT 1 FROM public.budgets b
                  WHERE b.id = budget_categories.budget_id
                    AND b.user_id = auth.uid()));

-- AI messages inherit their conversation's ownership for reads/writes, and also
-- carry their own user_id which must match the caller on insert.
DROP POLICY IF EXISTS "AI messages: SELECT" ON public.ai_messages;
CREATE POLICY "AI messages: SELECT"
  ON public.ai_messages FOR SELECT
  USING (EXISTS (SELECT 1 FROM public.ai_conversations c
                  WHERE c.id = ai_messages.conversation_id
                    AND c.user_id = auth.uid()));

DROP POLICY IF EXISTS "AI messages: INSERT" ON public.ai_messages;
CREATE POLICY "AI messages: INSERT"
  ON public.ai_messages FOR INSERT
  WITH CHECK (auth.uid() = user_id
              AND EXISTS (SELECT 1 FROM public.ai_conversations c
                           WHERE c.id = ai_messages.conversation_id
                             AND c.user_id = auth.uid()));

DROP POLICY IF EXISTS "AI messages: UPDATE" ON public.ai_messages;
CREATE POLICY "AI messages: UPDATE"
  ON public.ai_messages FOR UPDATE
  USING (EXISTS (SELECT 1 FROM public.ai_conversations c
                  WHERE c.id = ai_messages.conversation_id
                    AND c.user_id = auth.uid()));

DROP POLICY IF EXISTS "AI messages: DELETE" ON public.ai_messages;
CREATE POLICY "AI messages: DELETE"
  ON public.ai_messages FOR DELETE
  USING (EXISTS (SELECT 1 FROM public.ai_conversations c
                  WHERE c.id = ai_messages.conversation_id
                    AND c.user_id = auth.uid()));

-- =============================================================================
-- SECTION 16: STORAGE
-- =============================================================================
-- All three buckets are PRIVATE (public = false). The Flutter client reads
-- item images through createSignedUrl(), which only works against a private
-- bucket, and every storage policy below is folder-scoped to auth.uid().
-- A public bucket would make the per-folder SELECT policies meaningless and
-- would expose every user's images to unauthenticated requests.

INSERT INTO storage.buckets (id, name, public)
VALUES ('avatars', 'avatars', false),
       ('item-images', 'item-images', false),
       ('receipt-images', 'receipt-images', false)
ON CONFLICT (id) DO UPDATE SET public = EXCLUDED.public;

-- Object paths are "{userId}/{file}", so storage.foldername(name)[1] is the
-- owning user id.
DO $$
DECLARE
  b text;
  act text;
  cmd text;
BEGIN
  FOREACH b IN ARRAY ARRAY['avatars','item-images','receipt-images'] LOOP
    FOREACH act IN ARRAY ARRAY['SELECT','INSERT','UPDATE','DELETE'] LOOP
      cmd := b || ': ' || act;
      EXECUTE format('DROP POLICY IF EXISTS %I ON storage.objects', cmd);
      IF act = 'SELECT' THEN
        EXECUTE format(
          'CREATE POLICY %I ON storage.objects FOR SELECT
             USING (bucket_id = %L AND (storage.foldername(name))[1] = auth.uid()::text)',
          cmd, b);
      ELSIF act = 'INSERT' THEN
        EXECUTE format(
          'CREATE POLICY %I ON storage.objects FOR INSERT
             WITH CHECK (bucket_id = %L AND (storage.foldername(name))[1] = auth.uid()::text)',
          cmd, b);
      ELSIF act = 'UPDATE' THEN
        EXECUTE format(
          'CREATE POLICY %I ON storage.objects FOR UPDATE
             USING (bucket_id = %L AND (storage.foldername(name))[1] = auth.uid()::text)
             WITH CHECK (bucket_id = %L AND (storage.foldername(name))[1] = auth.uid()::text)',
          cmd, b, b);
      ELSE
        EXECUTE format(
          'CREATE POLICY %I ON storage.objects FOR DELETE
             USING (bucket_id = %L AND (storage.foldername(name))[1] = auth.uid()::text)',
          cmd, b);
      END IF;
    END LOOP;
  END LOOP;
END $$;
-- =============================================================================
-- SECTION 17: SEED / REFERENCE DATA
-- =============================================================================
-- Every seed statement is guarded by a NOT EXISTS predicate, so it inserts
-- nothing on a database that is already seeded and can never raise a unique
-- violation. Running the whole file twice is therefore safe.

-- Egyptian banks. Faisal Bank is included: migration 0027 added it because the
-- offline BankCatalog and the remote banks table had drifted apart.
INSERT INTO public.banks (name, name_ar, code, country, currency, is_active)
SELECT v.name, v.name_ar, v.code, 'EG', 'EGP', true
FROM (VALUES
  ('Commercial International Bank (CIB)', 'البنك التجاري الدولي', 'CIB'),
  ('National Bank of Egypt',             'البنك الأهلي المصري',  'NBE'),
  ('Banque Misr',                        'بنك مصر',            'MISR'),
  ('QNB Egypt',                          'بنك قطر الوطني مصر', 'QNB'),
  ('AlexBank',                           'بنك الإسكندرية',     'ALEX'),
  ('HSBC Egypt',                         'بنك HSBC مصر',       'HSBC'),
  ('Abu Dhabi Islamic Bank',             'مصرف أبوظبي الإسلامي', 'ADIB'),
  ('Emirates NBD',                       'بنك الإمارات دبي الوطني', 'ENBD'),
  ('FAB Egypt',                          'البنك الأول بأبو ظبي', 'FAB'),
  ('Bank of Alexandria',                 'بنك الإسكندرية',     'ALEX2'),
  ('Faisal Bank',                        'بنك فيصل',          'FAISAL')
) AS v(name, name_ar, code)
WHERE NOT EXISTS (
  SELECT 1 FROM public.banks b
  WHERE lower(b.code) = lower(v.code) OR lower(b.name) = lower(v.name)
);

-- System categories. `type` values are all valid category_type literals.
INSERT INTO public.categories (user_id, name, name_ar, type, is_system, is_active)
SELECT NULL, v.name, v.name_ar, v.type::public.category_type, true, true
FROM (VALUES
  ('Food & Dining',  'الطعام والمطاعم', 'expense'),
  ('Transportation', 'المواصلات',       'expense'),
  ('Groceries',      'البقالة',         'expense'),
  ('Shopping',       'التسوق',          'expense'),
  ('Entertainment',  'الترفيه',         'expense'),
  ('Utilities',      'الفواتير',        'expense'),
  ('Healthcare',     'الصحة',           'expense'),
  ('Education',      'التعليم',         'expense'),
  ('Subscriptions',  'الاشتراكات',     'expense'),
  ('Other',          'أخرى',            'expense'),
  ('Salary',         'الراتب',          'income'),
  ('Freelance',      'عمل حر',          'income'),
  ('Investment',     'استثمار',         'income'),
  ('Other Income',   'دخل آخر',         'income'),
  ('Transfer',       'تحويل',           'transfer')
) AS v(name, name_ar, type)
WHERE NOT EXISTS (
  SELECT 1 FROM public.categories c
  WHERE c.user_id IS NULL AND c.is_system = true AND c.name = v.name
);

-- Badge catalogue. The VALUES list is fully closed BEFORE the WHERE clause:
-- an earlier revision of this file had a section header spliced into the middle
-- of this statement, which broke it.
INSERT INTO public.badges (code, name, name_ar, description, description_ar, criteria)
SELECT v.code, v.name, v.name_ar, v.description, v.description_ar, v.criteria::jsonb
FROM (VALUES
  ('first_expense',       'First Step',          'الخطوة الأولى',   'Record your first expense',            'سجل أول مصروف لك',            '{"type":"first_transaction"}'),
  ('spending_master',     'Spending Master',     'سيد الإنفاق',    'Track 100 transactions',               'تابع 100 معاملة',             '{"type":"transaction_count","count":100}'),
  ('budget_champion',     'Budget Champion',     'بطل الميزانية',   'Stay within budget for 3 months',     'ابق ضمن الميزانية لمدة 3 أشهر','{"type":"consecutive_months","count":3}'),
  ('saving_star',         'Saving Star',         'نجم المدخرات',   'Save 10% of income',                  'وفر 10% من الدخل',            '{"type":"savings_percentage","percentage":10}'),
  ('reduction_expert',    'Reduction Expert',    'خبير التخفيض',   'Reduce spending by 20%',              'خفض الإنفاق بنسبة 20%',       '{"type":"spending_reduction","percentage":20}'),
  ('consistent_tracker',  'Consistent Tracker',  'المتابع المنتظم','Log transactions for 30 days',        'سجل المعاملات لمدة 30 يوم',   '{"type":"consecutive_days","count":30}'),
  ('category_expert',     'Category Expert',     'خبير الفئات',    'Use all expense categories',          'استخدم جميع فئات المصروفات',  '{"type":"use_all_categories"}'),
  ('pocket_pro',          'Pocket Pro',          'خبير النقد',      'Manage Pocket Cash for 60 days',      'ادار النقد لمدة 60 يوم',      '{"type":"pocket_cash_days","count":60}')
) AS v(code, name, name_ar, description, description_ar, criteria)
WHERE NOT EXISTS (
  SELECT 1 FROM public.badges b WHERE b.code = v.code
);
-- =============================================================================
-- SECTION 18: GRANTS
-- =============================================================================
-- Supabase's PostgREST layer connects as `authenticated` (or `anon`).
-- Every function below is SECURITY DEFINER, so it must be executable by those
-- roles, otherwise the Flutter .rpc() calls fail with
-- "permission denied for function".

GRANT EXECUTE ON FUNCTION public.get_cash_balance(uuid)                  TO authenticated, anon;
GRANT EXECUTE ON FUNCTION public.get_monthly_spending(uuid, smallint, smallint) TO authenticated, anon;
GRANT EXECUTE ON FUNCTION public.get_item_usage_stats(uuid, smallint, smallint)  TO authenticated, anon;
GRANT EXECUTE ON FUNCTION public.calculate_savings_opportunity(uuid, uuid, numeric) TO authenticated, anon;
GRANT EXECUTE ON FUNCTION public.get_deducted_money(uuid, smallint, smallint) TO authenticated, anon;
GRANT EXECUTE ON FUNCTION public.get_bank_accounts_with_balance(uuid)     TO authenticated, anon;
GRANT EXECUTE ON FUNCTION public.get_total_bank_balance(uuid)             TO authenticated, anon;
GRANT EXECUTE ON FUNCTION public.set_updated_at()                         TO authenticated, anon, service_role;
GRANT EXECUTE ON FUNCTION public.log_audit_event()                       TO service_role;
GRANT EXECUTE ON FUNCTION public.handle_new_user()                        TO service_role;

-- The reporting views are readable by the API roles; their RLS behaviour comes
-- from security_invoker = true plus the policies on the underlying tables.
GRANT SELECT ON public.v_user_balances         TO authenticated, anon;
GRANT SELECT ON public.v_monthly_item_summary  TO authenticated, anon;

-- =============================================================================
-- END OF SCHEMA
-- =============================================================================