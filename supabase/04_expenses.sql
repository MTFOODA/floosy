-- =============================================================================
-- SECTION 5: EXPENSE TABLES (manual cash expenses)
-- =============================================================================

CREATE TABLE IF NOT EXISTS public.expenses (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    transaction_id uuid REFERENCES public.transactions(id),
    category_id uuid REFERENCES public.categories(id),
    amount_minor bigint NOT NULL CHECK (amount_minor >= 0),
    currency varchar(3) DEFAULT 'EGP',
    expense_date timestamptz NOT NULL DEFAULT now(),
    payment_method public.payment_method DEFAULT 'cash',
    merchant_id uuid REFERENCES public.merchants(id), notes text,
    created_at timestamptz DEFAULT now(), updated_at timestamptz DEFAULT now()
);
CREATE INDEX IF NOT EXISTS idx_expenses_user_id ON public.expenses(user_id);
CREATE INDEX IF NOT EXISTS idx_expenses_user_date ON public.expenses(user_id, expense_date DESC);

CREATE TABLE IF NOT EXISTS public.expense_items (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    expense_id uuid NOT NULL REFERENCES public.expenses(id) ON DELETE CASCADE,
    item_id uuid, item_name varchar NOT NULL,
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
    expense_id uuid REFERENCES public.expenses(id),
    quantity integer NOT NULL DEFAULT 1 CHECK (quantity > 0),
    total_amount_minor bigint NOT NULL CHECK (total_amount_minor >= 0),
    usage_date timestamptz NOT NULL DEFAULT now(), created_at timestamptz DEFAULT now()
);
CREATE INDEX IF NOT EXISTS idx_item_usage_user ON public.item_usage(user_id);
CREATE INDEX IF NOT EXISTS idx_item_usage_item ON public.item_usage(item_id);
