-- =============================================================================
-- Floosy Complete Database Schema (Fixed & Production-Ready)
-- =============================================================================

-- SECTION 1: ENUMS
DO $$ BEGIN
  CREATE TYPE public.transaction_type AS ENUM ('purchase','atm_withdrawal','cash_expense','income','adjustment','refund','reversal','transfer_in','transfer_out');
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

DO $$ BEGIN
  CREATE TYPE public.transaction_source AS ENUM ('sms','manual','receipt','system','ai_assisted');
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

DO $$ BEGIN
  CREATE TYPE public.transaction_status AS ENUM ('pending','confirmed','cancelled','reversed');
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

DO $$ BEGIN
  CREATE TYPE public.payment_method AS ENUM ('card','cash','bank_transfer','other');
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

DO $$ BEGIN
  CREATE TYPE public.movement_type AS ENUM ('in','out','adjustment');
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

DO $$ BEGIN
  CREATE TYPE public.budget_period AS ENUM ('weekly','monthly','yearly','custom');
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

DO $$ BEGIN
  CREATE TYPE public.recurring_frequency AS ENUM ('daily','weekly','monthly','yearly','custom');
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

DO $$ BEGIN
  CREATE TYPE public.recurring_occurrence_status AS ENUM ('pending','paid','skipped','cancelled');
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

DO $$ BEGIN
  CREATE TYPE public.category_type AS ENUM ('expense','income','both');
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

DO $$ BEGIN
  CREATE TYPE public.alert_type AS ENUM ('high_item_usage','budget_warning','high_spending','subscription_detected','cash_difference','saving_opportunity');
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

DO $$ BEGIN
  CREATE TYPE public.alert_severity AS ENUM ('info','warning','critical');
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

DO $$ BEGIN
  CREATE TYPE public.ai_message_role AS ENUM ('user','assistant','tool','system');
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

DO $$ BEGIN
  CREATE TYPE public.ai_action_status AS ENUM ('pending_confirmation','confirmed','rejected','executed','failed');
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

DO $$ BEGIN
  CREATE TYPE public.recommendation_status AS ENUM ('active','applied','dismissed','expired');
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

DO $$ BEGIN
  CREATE TYPE public.sync_operation AS ENUM ('insert','update','delete');
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

DO $$ BEGIN
  CREATE TYPE public.sync_status AS ENUM ('pending','synced','failed');
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

-- SECTION 2: BASE / REFERENCE TABLES

CREATE TABLE IF NOT EXISTS public.banks (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    name varchar NOT NULL, 
    name_ar varchar, 
    code varchar, 
    logo_url text,
    country varchar(2) DEFAULT 'EG', 
    currency varchar(3) DEFAULT 'EGP',
    is_active boolean DEFAULT true,
    created_at timestamptz DEFAULT now(), 
    updated_at timestamptz DEFAULT now()
);

CREATE TABLE IF NOT EXISTS public.profiles (
    id uuid PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    full_name varchar, 
    email varchar, 
    phone varchar, 
    avatar_url text,
    language varchar(5) DEFAULT 'ar', 
    currency varchar(3) DEFAULT 'EGP',
    default_bank_id uuid REFERENCES public.banks(id),
    sms_tracking_enabled boolean DEFAULT false,
    notifications_enabled boolean DEFAULT true,
    biometric_lock_enabled boolean DEFAULT false,
    hide_balances boolean DEFAULT false,
    created_at timestamptz DEFAULT now(), 
    updated_at timestamptz DEFAULT now()
);
CREATE UNIQUE INDEX IF NOT EXISTS idx_profiles_email ON public.profiles(email) WHERE email IS NOT NULL;

CREATE TABLE IF NOT EXISTS public.bank_sms_patterns (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    bank_id uuid NOT NULL REFERENCES public.banks(id) ON DELETE CASCADE,
    sender_pattern varchar NOT NULL,
    purchase_patterns jsonb DEFAULT '[]'::jsonb, 
    atm_patterns jsonb DEFAULT '[]'::jsonb,
    refund_patterns jsonb DEFAULT '[]'::jsonb, 
    income_patterns jsonb DEFAULT '[]'::jsonb,
    reversal_patterns jsonb DEFAULT '[]'::jsonb,
    amount_pattern varchar, 
    merchant_pattern varchar, 
    card_pattern varchar, 
    date_pattern varchar,
    is_active boolean DEFAULT true, 
    version integer DEFAULT 1,
    created_at timestamptz DEFAULT now(), 
    updated_at timestamptz DEFAULT now()
);
CREATE UNIQUE INDEX IF NOT EXISTS idx_bank_sms_patterns_bank ON public.bank_sms_patterns(bank_id);

CREATE TABLE IF NOT EXISTS public.categories (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id uuid REFERENCES auth.users(id) ON DELETE CASCADE,
    name varchar NOT NULL, 
    name_ar varchar, 
    icon varchar,
    parent_id uuid REFERENCES public.categories(id) ON DELETE CASCADE,
    type public.category_type DEFAULT 'expense',
    is_system boolean DEFAULT false, 
    is_active boolean DEFAULT true,
    created_at timestamptz DEFAULT now(), 
    updated_at timestamptz DEFAULT now()
);
CREATE INDEX IF NOT EXISTS idx_categories_user ON public.categories(user_id);

CREATE TABLE IF NOT EXISTS public.merchants (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    name varchar NOT NULL, 
    normalized_name varchar NOT NULL,
    category_id uuid REFERENCES public.categories(id), 
    logo_url text,
    created_at timestamptz DEFAULT now(), 
    updated_at timestamptz DEFAULT now()
);

CREATE TABLE IF NOT EXISTS public.items (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    name varchar NOT NULL, 
    name_ar varchar, 
    description text,
    price_minor bigint NOT NULL CHECK (price_minor >= 0),
    currency varchar(3) DEFAULT 'EGP', 
    category_id uuid REFERENCES public.categories(id),
    icon varchar, 
    image_url text,
    is_active boolean DEFAULT true, 
    is_archived boolean DEFAULT false,
    created_at timestamptz DEFAULT now(), 
    updated_at timestamptz DEFAULT now()
);
CREATE INDEX IF NOT EXISTS idx_items_user ON public.items(user_id);

CREATE TABLE IF NOT EXISTS public.item_price_history (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    item_id uuid NOT NULL REFERENCES public.items(id) ON DELETE CASCADE,
    price_minor bigint NOT NULL CHECK (price_minor >= 0),
    currency varchar(3) DEFAULT 'EGP',
    recorded_at timestamptz DEFAULT now(),
    created_at timestamptz DEFAULT now(),
    updated_at timestamptz DEFAULT now()
);
CREATE INDEX IF NOT EXISTS idx_item_price_history_item ON public.item_price_history(item_id);

-- SECTION 3: WALLET / CASH TABLES

CREATE TABLE IF NOT EXISTS public.cash_wallets (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    currency varchar(3) DEFAULT 'EGP',
    created_at timestamptz DEFAULT now(), 
    updated_at timestamptz DEFAULT now()
);
CREATE UNIQUE INDEX IF NOT EXISTS idx_cash_wallets_user ON public.cash_wallets(user_id);

CREATE TABLE IF NOT EXISTS public.cash_movements (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    wallet_id uuid NOT NULL REFERENCES public.cash_wallets(id) ON DELETE CASCADE,
    type public.movement_type NOT NULL,
    amount_minor bigint NOT NULL CHECK (amount_minor >= 0),
    reference_type varchar, 
    reference_id uuid, 
    description text,
    movement_date timestamptz DEFAULT now(), 
    created_at timestamptz DEFAULT now(),
    updated_at timestamptz DEFAULT now()
);
CREATE INDEX IF NOT EXISTS idx_cash_movements_user ON public.cash_movements(user_id);
CREATE INDEX IF NOT EXISTS idx_cash_movements_wallet ON public.cash_movements(wallet_id);

-- SECTION 4: DETECTED CARDS, TRANSACTIONS & SMS MESSAGES

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
CREATE UNIQUE INDEX IF NOT EXISTS detected_cards_user_last4_bank_unique
  ON public.detected_cards(user_id, last4, coalesce(bank_name, ''));
CREATE INDEX IF NOT EXISTS detected_cards_user_idx ON public.detected_cards(user_id);

CREATE TABLE IF NOT EXISTS public.transactions (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    bank_id uuid REFERENCES public.banks(id),
    category_id uuid REFERENCES public.categories(id),
    merchant_id uuid REFERENCES public.merchants(id),
    type public.transaction_type NOT NULL,
    source public.transaction_source NOT NULL DEFAULT 'manual',
    amount_minor bigint NOT NULL CHECK (amount_minor >= 0),
    currency varchar(3) DEFAULT 'EGP',
    transaction_date timestamptz NOT NULL DEFAULT now(),
    merchant_name varchar, 
    card_last4 varchar(4),
    card_id uuid REFERENCES public.detected_cards(id),
    raw_reference varchar, 
    external_reference varchar,
    fingerprint varchar,
    status public.transaction_status DEFAULT 'confirmed',
    notes text,
    created_at timestamptz DEFAULT now(), 
    updated_at timestamptz DEFAULT now()
);
CREATE INDEX IF NOT EXISTS idx_transactions_user_id ON public.transactions(user_id);
CREATE INDEX IF NOT EXISTS idx_transactions_user_date ON public.transactions(user_id, transaction_date DESC);
CREATE UNIQUE INDEX IF NOT EXISTS idx_transactions_fingerprint_unique ON public.transactions(fingerprint) WHERE fingerprint IS NOT NULL;

CREATE TABLE IF NOT EXISTS public.sms_messages (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    sender varchar, 
    message_hash varchar NOT NULL,
    message_body text,
    received_at timestamptz NOT NULL DEFAULT now(),
    bank_identified boolean NOT NULL DEFAULT false,
    type_identified boolean NOT NULL DEFAULT false,
    amount_identified boolean NOT NULL DEFAULT false,
    currency_identified boolean NOT NULL DEFAULT false,
    card_last4_identified boolean NOT NULL DEFAULT false,
    detected_bank_id uuid REFERENCES public.banks(id),
    detected_bank_name varchar,
    detected_type varchar,
    detected_amount_minor bigint,
    detected_currency varchar(3),
    detected_card_last4 varchar(4),
    processed_at timestamptz,
    processing_status varchar DEFAULT 'pending',
    transaction_id uuid REFERENCES public.transactions(id),
    parser_version varchar,
    confidence double precision,
    created_at timestamptz DEFAULT now()
);
CREATE INDEX IF NOT EXISTS idx_sms_messages_user ON public.sms_messages(user_id);
CREATE INDEX IF NOT EXISTS idx_sms_messages_hash ON public.sms_messages(user_id, message_hash);
CREATE UNIQUE INDEX IF NOT EXISTS sms_messages_user_hash_unique ON public.sms_messages(user_id, message_hash);

-- SECTION 5: EXPENSE TABLES

CREATE TABLE IF NOT EXISTS public.expenses (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    transaction_id uuid REFERENCES public.transactions(id),
    category_id uuid REFERENCES public.categories(id),
    amount_minor bigint NOT NULL CHECK (amount_minor >= 0),
    currency varchar(3) DEFAULT 'EGP',
    expense_date timestamptz NOT NULL DEFAULT now(),
    payment_method public.payment_method DEFAULT 'cash',
    merchant_id uuid REFERENCES public.merchants(id), 
    notes text,
    created_at timestamptz DEFAULT now(), 
    updated_at timestamptz DEFAULT now()
);
CREATE INDEX IF NOT EXISTS idx_expenses_user_id ON public.expenses(user_id);
CREATE INDEX IF NOT EXISTS idx_expenses_user_date ON public.expenses(user_id, expense_date DESC);

CREATE TABLE IF NOT EXISTS public.expense_items (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    expense_id uuid NOT NULL REFERENCES public.expenses(id) ON DELETE CASCADE,
    item_id uuid REFERENCES public.items(id) ON DELETE SET NULL, 
    item_name varchar NOT NULL,
    quantity integer NOT NULL DEFAULT 1 CHECK (quantity > 0),
    unit_price_minor bigint NOT NULL CHECK (unit_price_minor >= 0),
    total_price_minor bigint NOT NULL CHECK (total_price_minor >= 0),
    created_at timestamptz DEFAULT now()
);
CREATE INDEX IF NOT EXISTS idx_expense_items_expense ON public.expense_items(expense_id);

CREATE TABLE IF NOT EXISTS public.item_usage (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    item_id uuid NOT NULL REFERENCES public.items(id) ON DELETE CASCADE,
    expense_id uuid REFERENCES public.expenses(id) ON DELETE CASCADE,
    quantity integer NOT NULL DEFAULT 1 CHECK (quantity > 0),
    total_amount_minor bigint NOT NULL CHECK (total_amount_minor >= 0),
    usage_date timestamptz NOT NULL DEFAULT now(), 
    created_at timestamptz DEFAULT now()
);
CREATE INDEX IF NOT EXISTS idx_item_usage_user ON public.item_usage(user_id);
CREATE INDEX IF NOT EXISTS idx_item_usage_item ON public.item_usage(item_id);

-- SECTION 6: BUDGET & RECURRING EXPENSE TABLES

CREATE TABLE IF NOT EXISTS public.budgets (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    name varchar NOT NULL, 
    amount_minor bigint NOT NULL CHECK (amount_minor >= 0),
    currency varchar(3) DEFAULT 'EGP', 
    period public.budget_period DEFAULT 'monthly',
    start_date timestamptz NOT NULL, 
    end_date timestamptz NOT NULL,
    is_active boolean DEFAULT true, 
    created_at timestamptz DEFAULT now(), 
    updated_at timestamptz DEFAULT now()
);

CREATE TABLE IF NOT EXISTS public.budget_categories (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    budget_id uuid NOT NULL REFERENCES public.budgets(id) ON DELETE CASCADE,
    category_id uuid NOT NULL REFERENCES public.categories(id) ON DELETE CASCADE,
    limit_minor bigint NOT NULL CHECK (limit_minor >= 0),
    created_at timestamptz DEFAULT now(), 
    updated_at timestamptz DEFAULT now(),
    UNIQUE(budget_id, category_id)
);

CREATE TABLE IF NOT EXISTS public.recurring_expenses (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    name varchar NOT NULL, 
    name_ar varchar,
    amount_minor bigint NOT NULL CHECK (amount_minor >= 0), 
    currency varchar(3) DEFAULT 'EGP',
    category_id uuid REFERENCES public.categories(id), 
    icon varchar,
    frequency public.recurring_frequency DEFAULT 'monthly',
    next_due_date timestamptz NOT NULL, 
    start_date timestamptz NOT NULL, 
    end_date timestamptz,
    is_active boolean DEFAULT true, 
    created_at timestamptz DEFAULT now(), 
    updated_at timestamptz DEFAULT now()
);
CREATE INDEX IF NOT EXISTS idx_recurring_expenses_user ON public.recurring_expenses(user_id);

CREATE TABLE IF NOT EXISTS public.recurring_expense_occurrences (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    recurring_expense_id uuid NOT NULL REFERENCES public.recurring_expenses(id) ON DELETE CASCADE,
    scheduled_date timestamptz NOT NULL, 
    amount_minor bigint NOT NULL CHECK (amount_minor >= 0),
    status public.recurring_occurrence_status DEFAULT 'pending',
    transaction_id uuid REFERENCES public.transactions(id) ON DELETE SET NULL, 
    created_at timestamptz DEFAULT now()
);

CREATE TABLE IF NOT EXISTS public.saving_goals (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    name varchar NOT NULL, 
    target_amount_minor bigint NOT NULL CHECK (target_amount_minor >= 0),
    current_amount_minor bigint NOT NULL DEFAULT 0 CHECK (current_amount_minor >= 0),
    currency varchar(3) DEFAULT 'EGP', 
    target_date timestamptz, 
    status varchar DEFAULT 'active',
    created_at timestamptz DEFAULT now(), 
    updated_at timestamptz DEFAULT now()
);
CREATE INDEX IF NOT EXISTS idx_saving_goals_user ON public.saving_goals(user_id);

CREATE TABLE IF NOT EXISTS public.saving_recommendations (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    item_id uuid REFERENCES public.items(id) ON DELETE CASCADE, 
    category_id uuid REFERENCES public.categories(id) ON DELETE CASCADE,
    baseline_amount_minor bigint DEFAULT 0, 
    current_amount_minor bigint DEFAULT 0,
    reduction_percentage numeric(5,2) NOT NULL, 
    estimated_saving_minor bigint DEFAULT 0,
    month smallint NOT NULL, 
    year smallint NOT NULL,
    status public.recommendation_status DEFAULT 'active',
    created_at timestamptz DEFAULT now(), 
    updated_at timestamptz DEFAULT now()
);
CREATE INDEX IF NOT EXISTS idx_saving_recommendations_user ON public.saving_recommendations(user_id);

-- SECTION 7: ANALYTICS / NOTIFICATION / AUDIT TABLES

CREATE TABLE IF NOT EXISTS public.alerts (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    type public.alert_type NOT NULL, 
    severity public.alert_severity DEFAULT 'info',
    item_id uuid REFERENCES public.items(id) ON DELETE CASCADE, 
    category_id uuid REFERENCES public.categories(id) ON DELETE CASCADE,
    title varchar NOT NULL, 
    message text NOT NULL,
    data jsonb DEFAULT '{}'::jsonb, 
    is_read boolean DEFAULT false,
    created_at timestamptz DEFAULT now()
);
CREATE INDEX IF NOT EXISTS idx_alerts_user ON public.alerts(user_id, created_at DESC);

CREATE TABLE IF NOT EXISTS public.app_notifications (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    title varchar NOT NULL,
    body text NOT NULL,
    data jsonb DEFAULT '{}'::jsonb,
    is_read boolean DEFAULT false,
    created_at timestamptz DEFAULT now(),
    updated_at timestamptz DEFAULT now()
);
CREATE INDEX IF NOT EXISTS idx_app_notifications_user ON public.app_notifications(user_id, created_at DESC);

CREATE TABLE IF NOT EXISTS public.monthly_reports (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    year smallint NOT NULL,
    month smallint NOT NULL,
    total_income_minor bigint DEFAULT 0,
    total_expense_minor bigint DEFAULT 0,
    net_savings_minor bigint DEFAULT 0,
    report_data jsonb DEFAULT '{}'::jsonb,
    created_at timestamptz DEFAULT now(),
    updated_at timestamptz DEFAULT now(),
    UNIQUE(user_id, year, month)
);

CREATE TABLE IF NOT EXISTS public.monthly_item_statistics (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    item_id uuid NOT NULL REFERENCES public.items(id) ON DELETE CASCADE,
    year smallint NOT NULL, 
    month smallint NOT NULL,
    quantity integer DEFAULT 0, 
    purchase_events integer DEFAULT 0,
    total_spending_minor bigint DEFAULT 0, 
    average_price_minor bigint DEFAULT 0,
    previous_quantity integer DEFAULT 0, 
    previous_spending_minor bigint DEFAULT 0,
    usage_change_percentage numeric(6,2) DEFAULT 0,
    spending_change_percentage numeric(6,2) DEFAULT 0,
    created_at timestamptz DEFAULT now(), 
    updated_at timestamptz DEFAULT now(),
    UNIQUE(user_id, item_id, year, month)
);
CREATE INDEX IF NOT EXISTS idx_monthly_item_stats_user ON public.monthly_item_statistics(user_id, year DESC, month DESC);

CREATE TABLE IF NOT EXISTS public.badges (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(), 
    code varchar UNIQUE NOT NULL,
    name varchar NOT NULL, 
    name_ar varchar, 
    description text, 
    description_ar text,
    icon varchar, 
    criteria jsonb DEFAULT '{}'::jsonb, 
    created_at timestamptz DEFAULT now()
);

CREATE TABLE IF NOT EXISTS public.user_badges (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    badge_id uuid NOT NULL REFERENCES public.badges(id) ON DELETE CASCADE,
    earned_at timestamptz DEFAULT now(), 
    metadata jsonb DEFAULT '{}'::jsonb,
    UNIQUE(user_id, badge_id)
);

CREATE TABLE IF NOT EXISTS public.audit_logs (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id uuid REFERENCES auth.users(id) ON DELETE CASCADE,
    action varchar NOT NULL, 
    entity_type varchar NOT NULL, 
    entity_id uuid,
    old_data jsonb, 
    new_data jsonb, 
    created_at timestamptz DEFAULT now()
);

-- SECTION 8: AI TABLES

CREATE TABLE IF NOT EXISTS public.ai_conversations (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    title varchar,
    created_at timestamptz DEFAULT now(), 
    updated_at timestamptz DEFAULT now()
);

CREATE TABLE IF NOT EXISTS public.ai_messages (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    conversation_id uuid NOT NULL REFERENCES public.ai_conversations(id) ON DELETE CASCADE,
    user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    role public.ai_message_role NOT NULL,
    content text NOT NULL,
    metadata jsonb DEFAULT '{}'::jsonb,
    created_at timestamptz DEFAULT now()
);
CREATE INDEX IF NOT EXISTS idx_ai_messages_conversation ON public.ai_messages(conversation_id);

CREATE TABLE IF NOT EXISTS public.ai_actions (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    conversation_id uuid REFERENCES public.ai_conversations(id) ON DELETE SET NULL,
    tool_name varchar NOT NULL, 
    arguments jsonb DEFAULT '{}'::jsonb,
    status public.ai_action_status DEFAULT 'pending_confirmation',
    result jsonb, 
    created_at timestamptz DEFAULT now(),
    confirmed_at timestamptz, 
    completed_at timestamptz
);
CREATE INDEX IF NOT EXISTS idx_ai_actions_user ON public.ai_actions(user_id, status);

-- SECTION 9: SYNC QUEUE

CREATE TABLE IF NOT EXISTS public.sync_queue (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    entity_type varchar NOT NULL, 
    entity_id uuid NOT NULL,
    operation public.sync_operation NOT NULL, 
    payload jsonb DEFAULT '{}'::jsonb,
    status public.sync_status DEFAULT 'pending', 
    retry_count integer DEFAULT 0,
    last_error text, 
    created_at timestamptz DEFAULT now(), 
    updated_at timestamptz DEFAULT now()
);
CREATE INDEX IF NOT EXISTS idx_sync_queue_user ON public.sync_queue(user_id, status);

-- SECTION 10: FUNCTIONS

CREATE OR REPLACE FUNCTION public.set_updated_at() 
RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$;

CREATE OR REPLACE FUNCTION public.get_cash_balance(user_id_param uuid)
RETURNS bigint LANGUAGE sql SECURITY DEFINER SET search_path = public AS $$
  SELECT COALESCE(SUM(CASE WHEN type = 'in' THEN amount_minor ELSE -amount_minor END), 0)
  FROM public.cash_movements WHERE user_id = user_id_param;
$$;

CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER LANGUAGE plpgsql SECURITY DEFINER SET search_path = public AS $$
BEGIN
  INSERT INTO public.profiles (id, email, full_name)
  VALUES (NEW.id, NEW.email, NEW.raw_user_meta_data->>'full_name');
  RETURN NEW;
END;
$$;

-- SECTION 11: TRIGGERS

CREATE OR REPLACE TRIGGER profiles_updated_at BEFORE UPDATE ON public.profiles FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();
CREATE OR REPLACE TRIGGER banks_updated_at BEFORE UPDATE ON public.banks FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();
CREATE OR REPLACE TRIGGER bank_sms_patterns_updated_at BEFORE UPDATE ON public.bank_sms_patterns FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();
CREATE OR REPLACE TRIGGER categories_updated_at BEFORE UPDATE ON public.categories FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();
CREATE OR REPLACE TRIGGER merchants_updated_at BEFORE UPDATE ON public.merchants FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();
CREATE OR REPLACE TRIGGER items_updated_at BEFORE UPDATE ON public.items FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();
CREATE OR REPLACE TRIGGER item_price_history_updated_at BEFORE UPDATE ON public.item_price_history FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();
CREATE OR REPLACE TRIGGER transactions_updated_at BEFORE UPDATE ON public.transactions FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();
CREATE OR REPLACE TRIGGER cash_wallets_updated_at BEFORE UPDATE ON public.cash_wallets FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();
CREATE OR REPLACE TRIGGER cash_movements_updated_at BEFORE UPDATE ON public.cash_movements FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();
CREATE OR REPLACE TRIGGER expenses_updated_at BEFORE UPDATE ON public.expenses FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();
CREATE OR REPLACE TRIGGER recurring_expenses_updated_at BEFORE UPDATE ON public.recurring_expenses FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();
CREATE OR REPLACE TRIGGER budgets_updated_at BEFORE UPDATE ON public.budgets FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();
CREATE OR REPLACE TRIGGER budget_categories_updated_at BEFORE UPDATE ON public.budget_categories FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();
CREATE OR REPLACE TRIGGER saving_goals_updated_at BEFORE UPDATE ON public.saving_goals FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();
CREATE OR REPLACE TRIGGER saving_recommendations_updated_at BEFORE UPDATE ON public.saving_recommendations FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();
CREATE OR REPLACE TRIGGER app_notifications_updated_at BEFORE UPDATE ON public.app_notifications FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();
CREATE OR REPLACE TRIGGER monthly_reports_updated_at BEFORE UPDATE ON public.monthly_reports FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();
CREATE OR REPLACE TRIGGER monthly_item_statistics_updated_at BEFORE UPDATE ON public.monthly_item_statistics FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();
CREATE OR REPLACE TRIGGER ai_conversations_updated_at BEFORE UPDATE ON public.ai_conversations FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();
CREATE OR REPLACE TRIGGER sync_queue_updated_at BEFORE UPDATE ON public.sync_queue FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

DROP TRIGGER IF EXISTS handle_new_user_trigger ON auth.users;
CREATE TRIGGER handle_new_user_trigger AFTER INSERT ON auth.users FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- SECTION 12: ROW LEVEL SECURITY (RLS) ENABLEMENT

ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.bank_sms_patterns ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.merchants ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.items ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.item_price_history ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.cash_wallets ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.cash_movements ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.transactions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.sms_messages ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.expenses ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.expense_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.item_usage ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.budgets ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.budget_categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.recurring_expenses ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.recurring_expense_occurrences ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.saving_goals ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.saving_recommendations ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.alerts ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.app_notifications ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.monthly_reports ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.monthly_item_statistics ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_badges ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.audit_logs ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.ai_conversations ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.ai_messages ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.ai_actions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.sync_queue ENABLE ROW LEVEL SECURITY;

-- SECTION 13: RLS POLICIES

-- Profiles
DROP POLICY IF EXISTS "Users can view their own profile" ON public.profiles;
CREATE POLICY "Users can view their own profile" ON public.profiles FOR SELECT USING (auth.uid() = id);

DROP POLICY IF EXISTS "Users can insert their own profile" ON public.profiles;
CREATE POLICY "Users can insert their own profile" ON public.profiles FOR INSERT TO authenticated WITH CHECK ((SELECT auth.uid()) = id);

DROP POLICY IF EXISTS "Users can update their own profile" ON public.profiles;
CREATE POLICY "Users can update their own profile" ON public.profiles FOR UPDATE USING (auth.uid() = id) WITH CHECK (auth.uid() = id);

-- Categories
DROP POLICY IF EXISTS "View system + own categories" ON public.categories;
CREATE POLICY "View system + own categories" ON public.categories FOR SELECT USING (user_id IS NULL OR auth.uid() = user_id);

DROP POLICY IF EXISTS "Insert own categories" ON public.categories;
CREATE POLICY "Insert own categories" ON public.categories FOR INSERT WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "Update own categories" ON public.categories;
CREATE POLICY "Update own categories" ON public.categories FOR UPDATE USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "Delete own categories" ON public.categories;
CREATE POLICY "Delete own categories" ON public.categories FOR DELETE USING (auth.uid() = user_id);

-- Items
DROP POLICY IF EXISTS "Items: SELECT" ON public.items;
CREATE POLICY "Items: SELECT" ON public.items FOR SELECT USING (auth.uid() = user_id);

DROP POLICY IF EXISTS "Items: INSERT" ON public.items;
CREATE POLICY "Items: INSERT" ON public.items FOR INSERT WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "Items: UPDATE" ON public.items;
CREATE POLICY "Items: UPDATE" ON public.items FOR UPDATE USING (auth.uid() = user_id);

DROP POLICY IF EXISTS "Items: DELETE" ON public.items;
CREATE POLICY "Items: DELETE" ON public.items FOR DELETE USING (auth.uid() = user_id);

-- Item price history
DROP POLICY IF EXISTS "Item price history: SELECT" ON public.item_price_history;
CREATE POLICY "Item price history: SELECT" ON public.item_price_history FOR SELECT USING (EXISTS (SELECT 1 FROM public.items i WHERE i.id = item_price_history.item_id AND i.user_id = auth.uid()));

DROP POLICY IF EXISTS "Item price history: INSERT" ON public.item_price_history;
CREATE POLICY "Item price history: INSERT" ON public.item_price_history FOR INSERT WITH CHECK (EXISTS (SELECT 1 FROM public.items i WHERE i.id = item_price_history.item_id AND i.user_id = auth.uid()));

-- Cash wallets
DROP POLICY IF EXISTS "Cash wallets: SELECT" ON public.cash_wallets;
CREATE POLICY "Cash wallets: SELECT" ON public.cash_wallets FOR SELECT USING (auth.uid() = user_id);

DROP POLICY IF EXISTS "Cash wallets: INSERT" ON public.cash_wallets;
CREATE POLICY "Cash wallets: INSERT" ON public.cash_wallets FOR INSERT WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "Cash wallets: UPDATE" ON public.cash_wallets;
CREATE POLICY "Cash wallets: UPDATE" ON public.cash_wallets FOR UPDATE USING (auth.uid() = user_id);

-- Cash movements
DROP POLICY IF EXISTS "Cash movements: SELECT" ON public.cash_movements;
CREATE POLICY "Cash movements: SELECT" ON public.cash_movements FOR SELECT USING (auth.uid() = user_id);

DROP POLICY IF EXISTS "Cash movements: INSERT" ON public.cash_movements;
CREATE POLICY "Cash movements: INSERT" ON public.cash_movements FOR INSERT WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "Cash movements: UPDATE" ON public.cash_movements;
CREATE POLICY "Cash movements: UPDATE" ON public.cash_movements FOR UPDATE USING (auth.uid() = user_id);

-- Transactions
DROP POLICY IF EXISTS "Transactions: SELECT" ON public.transactions;
CREATE POLICY "Transactions: SELECT" ON public.transactions FOR SELECT USING (auth.uid() = user_id);

DROP POLICY IF EXISTS "Transactions: INSERT" ON public.transactions;
CREATE POLICY "Transactions: INSERT" ON public.transactions FOR INSERT WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "Transactions: UPDATE" ON public.transactions;
CREATE POLICY "Transactions: UPDATE" ON public.transactions FOR UPDATE USING (auth.uid() = user_id);

DROP POLICY IF EXISTS "Transactions: DELETE" ON public.transactions;
CREATE POLICY "Transactions: DELETE" ON public.transactions FOR DELETE USING (auth.uid() = user_id);

-- Detected cards
DROP POLICY IF EXISTS "Detected cards: SELECT" ON public.detected_cards;
CREATE POLICY "Detected cards: SELECT" ON public.detected_cards FOR SELECT USING (auth.uid() = user_id);
DROP POLICY IF EXISTS "Detected cards: INSERT" ON public.detected_cards;
CREATE POLICY "Detected cards: INSERT" ON public.detected_cards FOR INSERT WITH CHECK (auth.uid() = user_id);
DROP POLICY IF EXISTS "Detected cards: UPDATE" ON public.detected_cards;
CREATE POLICY "Detected cards: UPDATE" ON public.detected_cards FOR UPDATE USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);
DROP POLICY IF EXISTS "Detected cards: DELETE" ON public.detected_cards;
CREATE POLICY "Detected cards: DELETE" ON public.detected_cards FOR DELETE USING (auth.uid() = user_id);

-- SMS messages
DROP POLICY IF EXISTS "SMS messages: SELECT" ON public.sms_messages;
CREATE POLICY "SMS messages: SELECT" ON public.sms_messages FOR SELECT USING (auth.uid() = user_id);

DROP POLICY IF EXISTS "SMS messages: INSERT" ON public.sms_messages;
CREATE POLICY "SMS messages: INSERT" ON public.sms_messages FOR INSERT WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "SMS messages: UPDATE" ON public.sms_messages;
CREATE POLICY "SMS messages: UPDATE" ON public.sms_messages FOR UPDATE USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

-- Expenses
DROP POLICY IF EXISTS "Expenses: SELECT" ON public.expenses;
CREATE POLICY "Expenses: SELECT" ON public.expenses FOR SELECT USING (auth.uid() = user_id);

DROP POLICY IF EXISTS "Expenses: INSERT" ON public.expenses;
CREATE POLICY "Expenses: INSERT" ON public.expenses FOR INSERT WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "Expenses: UPDATE" ON public.expenses;
CREATE POLICY "Expenses: UPDATE" ON public.expenses FOR UPDATE USING (auth.uid() = user_id);

DROP POLICY IF EXISTS "Expenses: DELETE" ON public.expenses;
CREATE POLICY "Expenses: DELETE" ON public.expenses FOR DELETE USING (auth.uid() = user_id);

-- Expense items
DROP POLICY IF EXISTS "Expense items: SELECT" ON public.expense_items;
CREATE POLICY "Expense items: SELECT" ON public.expense_items FOR SELECT USING (EXISTS (SELECT 1 FROM public.expenses e WHERE e.id = expense_items.expense_id AND e.user_id = auth.uid()));

DROP POLICY IF EXISTS "Expense items: INSERT" ON public.expense_items;
CREATE POLICY "Expense items: INSERT" ON public.expense_items FOR INSERT WITH CHECK (EXISTS (SELECT 1 FROM public.expenses e WHERE e.id = expense_items.expense_id AND e.user_id = auth.uid()));

-- Item usage
DROP POLICY IF EXISTS "Item usage: SELECT" ON public.item_usage;
CREATE POLICY "Item usage: SELECT" ON public.item_usage FOR SELECT USING (auth.uid() = user_id);

DROP POLICY IF EXISTS "Item usage: INSERT" ON public.item_usage;
CREATE POLICY "Item usage: INSERT" ON public.item_usage FOR INSERT WITH CHECK (auth.uid() = user_id);

-- Merchants
DROP POLICY IF EXISTS "Merchants: SELECT" ON public.merchants;
CREATE POLICY "Merchants: SELECT" ON public.merchants FOR SELECT USING (auth.uid() = user_id);

DROP POLICY IF EXISTS "Merchants: INSERT" ON public.merchants;
CREATE POLICY "Merchants: INSERT" ON public.merchants FOR INSERT WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "Merchants: UPDATE" ON public.merchants;
CREATE POLICY "Merchants: UPDATE" ON public.merchants FOR UPDATE USING (auth.uid() = user_id);

-- Budgets
DROP POLICY IF EXISTS "Budgets: SELECT" ON public.budgets;
CREATE POLICY "Budgets: SELECT" ON public.budgets FOR SELECT USING (auth.uid() = user_id);

-- Saving goals
DROP POLICY IF EXISTS "Saving goals: SELECT" ON public.saving_goals;
CREATE POLICY "Saving goals: SELECT" ON public.saving_goals FOR SELECT USING (auth.uid() = user_id);

DROP POLICY IF EXISTS "Saving goals: INSERT" ON public.saving_goals;
CREATE POLICY "Saving goals: INSERT" ON public.saving_goals FOR INSERT WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "Saving goals: UPDATE" ON public.saving_goals;
CREATE POLICY "Saving goals: UPDATE" ON public.saving_goals FOR UPDATE USING (auth.uid() = user_id);

DROP POLICY IF EXISTS "Saving goals: DELETE" ON public.saving_goals;
CREATE POLICY "Saving goals: DELETE" ON public.saving_goals FOR DELETE USING (auth.uid() = user_id);

-- Saving recommendations
DROP POLICY IF EXISTS "Saving recommendations: SELECT" ON public.saving_recommendations;
CREATE POLICY "Saving recommendations: SELECT" ON public.saving_recommendations FOR SELECT USING (auth.uid() = user_id);

DROP POLICY IF EXISTS "Saving recommendations: INSERT" ON public.saving_recommendations;
CREATE POLICY "Saving recommendations: INSERT" ON public.saving_recommendations FOR INSERT WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "Saving recommendations: UPDATE" ON public.saving_recommendations;
CREATE POLICY "Saving recommendations: UPDATE" ON public.saving_recommendations FOR UPDATE USING (auth.uid() = user_id);

-- Alerts
DROP POLICY IF EXISTS "Alerts: SELECT" ON public.alerts;
CREATE POLICY "Alerts: SELECT" ON public.alerts FOR SELECT USING (auth.uid() = user_id);

DROP POLICY IF EXISTS "Alerts: INSERT" ON public.alerts;
CREATE POLICY "Alerts: INSERT" ON public.alerts FOR INSERT WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "Alerts: UPDATE" ON public.alerts;
CREATE POLICY "Alerts: UPDATE" ON public.alerts FOR UPDATE USING (auth.uid() = user_id);

-- App notifications
DROP POLICY IF EXISTS "App notifications: SELECT" ON public.app_notifications;
CREATE POLICY "App notifications: SELECT" ON public.app_notifications FOR SELECT USING (auth.uid() = user_id);

DROP POLICY IF EXISTS "App notifications: INSERT" ON public.app_notifications;
CREATE POLICY "App notifications: INSERT" ON public.app_notifications FOR INSERT WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "App notifications: UPDATE" ON public.app_notifications;
CREATE POLICY "App notifications: UPDATE" ON public.app_notifications FOR UPDATE USING (auth.uid() = user_id);

-- Monthly reports
DROP POLICY IF EXISTS "Monthly reports: SELECT" ON public.monthly_reports;
CREATE POLICY "Monthly reports: SELECT" ON public.monthly_reports FOR SELECT USING (auth.uid() = user_id);

DROP POLICY IF EXISTS "Monthly reports: INSERT" ON public.monthly_reports;
CREATE POLICY "Monthly reports: INSERT" ON public.monthly_reports FOR INSERT WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "Monthly reports: UPDATE" ON public.monthly_reports;
CREATE POLICY "Monthly reports: UPDATE" ON public.monthly_reports FOR UPDATE USING (auth.uid() = user_id);

-- Monthly item stats
DROP POLICY IF EXISTS "Monthly item stats: SELECT" ON public.monthly_item_statistics;
CREATE POLICY "Monthly item stats: SELECT" ON public.monthly_item_statistics FOR SELECT USING (auth.uid() = user_id);

DROP POLICY IF EXISTS "Monthly item stats: INSERT" ON public.monthly_item_statistics;
CREATE POLICY "Monthly item stats: INSERT" ON public.monthly_item_statistics FOR INSERT WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "Monthly item stats: UPDATE" ON public.monthly_item_statistics;
CREATE POLICY "Monthly item stats: UPDATE" ON public.monthly_item_statistics FOR UPDATE USING (auth.uid() = user_id);

-- User badges
DROP POLICY IF EXISTS "User badges: SELECT" ON public.user_badges;
CREATE POLICY "User badges: SELECT" ON public.user_badges FOR SELECT USING (auth.uid() = user_id);

DROP POLICY IF EXISTS "User badges: INSERT" ON public.user_badges;
CREATE POLICY "User badges: INSERT" ON public.user_badges FOR INSERT WITH CHECK (auth.uid() = user_id);

-- Audit logs
DROP POLICY IF EXISTS "Audit logs: SELECT" ON public.audit_logs;
CREATE POLICY "Audit logs: SELECT" ON public.audit_logs FOR SELECT USING (auth.uid() = user_id);

-- AI conversations
DROP POLICY IF EXISTS "AI conversations: SELECT" ON public.ai_conversations;
CREATE POLICY "AI conversations: SELECT" ON public.ai_conversations FOR SELECT USING (auth.uid() = user_id);

DROP POLICY IF EXISTS "AI conversations: INSERT" ON public.ai_conversations;
CREATE POLICY "AI conversations: INSERT" ON public.ai_conversations FOR INSERT WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "AI conversations: DELETE" ON public.ai_conversations;
CREATE POLICY "AI conversations: DELETE" ON public.ai_conversations FOR DELETE USING (auth.uid() = user_id);

-- AI messages
DROP POLICY IF EXISTS "AI messages: SELECT" ON public.ai_messages;
CREATE POLICY "AI messages: SELECT" ON public.ai_messages FOR SELECT USING (EXISTS (SELECT 1 FROM public.ai_conversations ac WHERE ac.id = ai_messages.conversation_id AND ac.user_id = auth.uid()));

DROP POLICY IF EXISTS "AI messages: INSERT" ON public.ai_messages;
CREATE POLICY "AI messages: INSERT" ON public.ai_messages FOR INSERT WITH CHECK (auth.uid() = user_id);

-- AI actions
DROP POLICY IF EXISTS "AI actions: SELECT" ON public.ai_actions;
CREATE POLICY "AI actions: SELECT" ON public.ai_actions FOR SELECT USING (auth.uid() = user_id);

DROP POLICY IF EXISTS "AI actions: INSERT" ON public.ai_actions;
CREATE POLICY "AI actions: INSERT" ON public.ai_actions FOR INSERT WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "AI actions: UPDATE" ON public.ai_actions;
CREATE POLICY "AI actions: UPDATE" ON public.ai_actions FOR UPDATE USING (auth.uid() = user_id);

-- Sync queue
DROP POLICY IF EXISTS "Sync queue: SELECT" ON public.sync_queue;
CREATE POLICY "Sync queue: SELECT" ON public.sync_queue FOR SELECT USING (auth.uid() = user_id);

DROP POLICY IF EXISTS "Sync queue: INSERT" ON public.sync_queue;
CREATE POLICY "Sync queue: INSERT" ON public.sync_queue FOR INSERT WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "Sync queue: UPDATE" ON public.sync_queue;
CREATE POLICY "Sync queue: UPDATE" ON public.sync_queue FOR UPDATE USING (auth.uid() = user_id);

DROP POLICY IF EXISTS "Sync queue: DELETE" ON public.sync_queue;
CREATE POLICY "Sync queue: DELETE" ON public.sync_queue FOR DELETE USING (auth.uid() = user_id);

-- Bank SMS patterns (public read)
DROP POLICY IF EXISTS "Bank SMS patterns: SELECT" ON public.bank_sms_patterns;
CREATE POLICY "Bank SMS patterns: SELECT" ON public.bank_sms_patterns FOR SELECT USING (true);

-- SECTION 14: VIEWS

CREATE OR REPLACE VIEW public.v_user_balances AS
SELECT
    user_id,
    COALESCE(SUM(CASE WHEN type = 'in' THEN amount_minor ELSE -amount_minor END), 0) AS cash_balance_minor
FROM public.cash_movements
GROUP BY user_id;

CREATE OR REPLACE VIEW public.v_monthly_item_summary AS
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
-- END OF SCHEMA
-- =============================================================================
