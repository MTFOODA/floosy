-- =============================================================================
-- SECTION 6: BUDGET & RECURRING EXPENSE TABLES
-- =============================================================================

CREATE TABLE IF NOT EXISTS public.budgets (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    name varchar NOT NULL,
    amount_minor bigint NOT NULL CHECK (amount_minor >= 0),
    currency varchar(3) DEFAULT 'EGP',
    period public.budget_period DEFAULT 'monthly',
    start_date timestamptz NOT NULL, end_date timestamptz NOT NULL,
    is_active boolean DEFAULT true,
    created_at timestamptz DEFAULT now(), updated_at timestamptz DEFAULT now()
);
CREATE INDEX IF NOT EXISTS idx_budgets_user ON public.budgets(user_id);

CREATE TABLE IF NOT EXISTS public.budget_categories (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    budget_id uuid NOT NULL REFERENCES public.budgets(id) ON DELETE CASCADE,
    category_id uuid NOT NULL REFERENCES public.categories(id),
    limit_minor bigint NOT NULL CHECK (limit_minor >= 0),
    created_at timestamptz DEFAULT now(), updated_at timestamptz DEFAULT now(),
    UNIQUE(budget_id, category_id)
);

CREATE TABLE IF NOT EXISTS public.recurring_expenses (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    name varchar NOT NULL, name_ar varchar,
    amount_minor bigint NOT NULL CHECK (amount_minor >= 0),
    currency varchar(3) DEFAULT 'EGP',
    category_id uuid REFERENCES public.categories(id), icon varchar,
    frequency public.recurring_frequency DEFAULT 'monthly',
    next_due_date timestamptz NOT NULL,
    start_date timestamptz NOT NULL, end_date timestamptz,
    is_active boolean DEFAULT true,
    created_at timestamptz DEFAULT now(), updated_at timestamptz DEFAULT now()
);
CREATE INDEX IF NOT EXISTS idx_recurring_expenses_user ON public.recurring_expenses(user_id);
CREATE INDEX IF NOT EXISTS idx_recurring_expenses_due ON public.recurring_expenses(user_id, next_due_date);

CREATE TABLE IF NOT EXISTS public.recurring_expense_occurrences (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    recurring_expense_id uuid NOT NULL REFERENCES public.recurring_expenses(id) ON DELETE CASCADE,
    scheduled_date timestamptz NOT NULL,
    amount_minor bigint NOT NULL CHECK (amount_minor >= 0),
    status public.recurring_occurrence_status DEFAULT 'pending',
    transaction_id uuid REFERENCES public.transactions(id),
    created_at timestamptz DEFAULT now()
);
CREATE INDEX IF NOT EXISTS idx_recurring_occurrences_expense ON public.recurring_expense_occurrences(recurring_expense_id);
CREATE INDEX IF NOT EXISTS idx_recurring_occurrences_user ON public.recurring_expense_occurrences(user_id, scheduled_date);

CREATE TABLE IF NOT EXISTS public.saving_goals (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    name varchar NOT NULL,
    target_amount_minor bigint NOT NULL CHECK (target_amount_minor >= 0),
    current_amount_minor bigint NOT NULL DEFAULT 0 CHECK (current_amount_minor >= 0),
    currency varchar(3) DEFAULT 'EGP',
    target_date timestamptz, status varchar DEFAULT 'active',
    created_at timestamptz DEFAULT now(), updated_at timestamptz DEFAULT now()
);
CREATE INDEX IF NOT EXISTS idx_saving_goals_user ON public.saving_goals(user_id);

CREATE TABLE IF NOT EXISTS public.saving_recommendations (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    item_id uuid REFERENCES public.items(id),
    category_id uuid REFERENCES public.categories(id),
    baseline_amount_minor bigint DEFAULT 0,
    current_amount_minor bigint DEFAULT 0,
    reduction_percentage numeric(5,2) NOT NULL,
    estimated_saving_minor bigint DEFAULT 0,
    month smallint NOT NULL, year smallint NOT NULL,
    status public.recommendation_status DEFAULT 'active',
    created_at timestamptz DEFAULT now(), updated_at timestamptz DEFAULT now()
);
CREATE INDEX IF NOT EXISTS idx_saving_recommendations_user ON public.saving_recommendations(user_id);
