-- =============================================================================
-- SECTION 7: ANALYTICS / NOTIFICATION / AUDIT TABLES
-- =============================================================================

CREATE TABLE IF NOT EXISTS public.alerts (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    type public.alert_type NOT NULL,
    severity public.alert_severity DEFAULT 'info',
    item_id uuid REFERENCES public.items(id),
    category_id uuid REFERENCES public.categories(id),
    title varchar NOT NULL, message text NOT NULL,
    data jsonb DEFAULT '{}'::jsonb, is_read boolean DEFAULT false,
    created_at timestamptz DEFAULT now(), UNIQUE(id)
);
CREATE INDEX IF NOT EXISTS idx_alerts_user ON public.alerts(user_id, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_alerts_unread ON public.alerts(user_id, is_read) WHERE is_read = false;

CREATE TABLE IF NOT EXISTS public.app_notifications (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    type varchar NOT NULL, title varchar NOT NULL, message text NOT NULL,
    data jsonb DEFAULT '{}'::jsonb, is_read boolean DEFAULT false,
    scheduled_for timestamptz, sent_at timestamptz,
    created_at timestamptz DEFAULT now()
);
CREATE INDEX IF NOT EXISTS idx_app_notifications_user ON public.app_notifications(user_id, created_at DESC);

CREATE TABLE IF NOT EXISTS public.monthly_reports (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    year smallint NOT NULL, month smallint NOT NULL,
    total_income_minor bigint DEFAULT 0, total_expenses_minor bigint DEFAULT 0,
    card_expenses_minor bigint DEFAULT 0, cash_expenses_minor bigint DEFAULT 0,
    atm_withdrawals_minor bigint DEFAULT 0,
    top_category_id uuid REFERENCES public.categories(id),
    top_item_id uuid REFERENCES public.items(id),
    top_merchant_id uuid REFERENCES public.merchants(id),
    potential_savings_minor bigint DEFAULT 0, actual_savings_minor bigint DEFAULT 0,
    generated_at timestamptz,
    created_at timestamptz DEFAULT now(), updated_at timestamptz DEFAULT now(),
    UNIQUE(user_id, year, month)
);
CREATE INDEX IF NOT EXISTS idx_monthly_reports_user ON public.monthly_reports(user_id, year DESC, month DESC);

CREATE TABLE IF NOT EXISTS public.monthly_item_statistics (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    item_id uuid NOT NULL REFERENCES public.items(id) ON DELETE CASCADE,
    year smallint NOT NULL, month smallint NOT NULL,
    quantity integer DEFAULT 0, purchase_events integer DEFAULT 0,
    total_spending_minor bigint DEFAULT 0, average_price_minor bigint DEFAULT 0,
    previous_quantity integer DEFAULT 0, previous_spending_minor bigint DEFAULT 0,
    usage_change_percentage numeric(6,2) DEFAULT 0,
    spending_change_percentage numeric(6,2) DEFAULT 0,
    created_at timestamptz DEFAULT now(), updated_at timestamptz DEFAULT now(),
    UNIQUE(user_id, item_id, year, month)
);
CREATE INDEX IF NOT EXISTS idx_monthly_item_stats_user ON public.monthly_item_statistics(user_id, year DESC, month DESC);

CREATE TABLE IF NOT EXISTS public.badges (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(), code varchar UNIQUE NOT NULL,
    name varchar NOT NULL, name_ar varchar, description text, description_ar text,
    icon varchar, criteria jsonb DEFAULT '{}'::jsonb, created_at timestamptz DEFAULT now()
);
CREATE TABLE IF NOT EXISTS public.user_badges (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    badge_id uuid NOT NULL REFERENCES public.badges(id) ON DELETE CASCADE,
    earned_at timestamptz DEFAULT now(), metadata jsonb DEFAULT '{}'::jsonb,
    UNIQUE(user_id, badge_id)
);
CREATE INDEX IF NOT EXISTS idx_user_badges_user ON public.user_badges(user_id);

CREATE TABLE IF NOT EXISTS public.audit_logs (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id uuid REFERENCES auth.users(id) ON DELETE CASCADE,
    action varchar NOT NULL, entity_type varchar NOT NULL, entity_id uuid,
    old_data jsonb, new_data jsonb, created_at timestamptz DEFAULT now()
);
