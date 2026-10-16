-- =============================================================================
-- SECTION 2: BASE / REFERENCE TABLES
-- =============================================================================

-- 2.1 Banks (system reference data)
CREATE TABLE IF NOT EXISTS public.banks (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    name varchar NOT NULL, name_ar varchar, code varchar, logo_url text,
    country varchar(2) DEFAULT 'EG', currency varchar(3) DEFAULT 'EGP',
    is_active boolean DEFAULT true,
    created_at timestamptz DEFAULT now(), updated_at timestamptz DEFAULT now()
);

-- 2.2 Profiles (1:1 with auth.users)
CREATE TABLE IF NOT EXISTS public.profiles (
    id uuid PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    full_name varchar, email varchar, phone varchar, avatar_url text,
    language varchar(5) DEFAULT 'ar', currency varchar(3) DEFAULT 'EGP',
    default_bank_id uuid REFERENCES public.banks(id),
    sms_tracking_enabled boolean DEFAULT false,
    notifications_enabled boolean DEFAULT true,
    biometric_lock_enabled boolean DEFAULT false, hide_balances boolean DEFAULT false,
    created_at timestamptz DEFAULT now(), updated_at timestamptz DEFAULT now()
);
CREATE UNIQUE INDEX IF NOT EXISTS idx_profiles_email ON public.profiles(email) WHERE email IS NOT NULL;

-- 2.3 Bank SMS Patterns
CREATE TABLE IF NOT EXISTS public.bank_sms_patterns (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    bank_id uuid NOT NULL REFERENCES public.banks(id) ON DELETE CASCADE,
    sender_pattern varchar NOT NULL,
    purchase_patterns jsonb DEFAULT '[]'::jsonb, atm_patterns jsonb DEFAULT '[]'::jsonb,
    refund_patterns jsonb DEFAULT '[]'::jsonb, income_patterns jsonb DEFAULT '[]'::jsonb,
    reversal_patterns jsonb DEFAULT '[]'::jsonb,
    amount_pattern varchar, merchant_pattern varchar, card_pattern varchar, date_pattern varchar,
    is_active boolean DEFAULT true, version integer DEFAULT 1,
    created_at timestamptz DEFAULT now(), updated_at timestamptz DEFAULT now()
);

-- 2.4 Categories (system + user)
CREATE TABLE IF NOT EXISTS public.categories (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id uuid REFERENCES auth.users(id) ON DELETE CASCADE,
    name varchar NOT NULL, name_ar varchar, icon varchar,
    parent_id uuid REFERENCES public.categories(id) ON DELETE CASCADE,
    type public.category_type DEFAULT 'expense',
    is_system boolean DEFAULT false, is_active boolean DEFAULT true,
    created_at timestamptz DEFAULT now(), updated_at timestamptz DEFAULT now()
);
CREATE INDEX IF NOT EXISTS idx_categories_user ON public.categories(user_id);
CREATE INDEX IF NOT EXISTS idx_categories_parent ON public.categories(parent_id);

-- 2.5 Merchants
CREATE TABLE IF NOT EXISTS public.merchants (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    name varchar NOT NULL, normalized_name varchar NOT NULL,
    category_id uuid REFERENCES public.categories(id), logo_url text,
    created_at timestamptz DEFAULT now(), updated_at timestamptz DEFAULT now()
);

-- 2.6 Items (reusable user-defined products)
CREATE TABLE IF NOT EXISTS public.items (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    name varchar NOT NULL, name_ar varchar, description text,
    price_minor bigint NOT NULL CHECK (price_minor >= 0),
    currency varchar(3) DEFAULT 'EGP', category_id uuid REFERENCES public.categories(id),
    icon varchar, image_url text,
    is_active boolean DEFAULT true, is_archived boolean DEFAULT false,
    created_at timestamptz DEFAULT now(), updated_at timestamptz DEFAULT now()
);

-- 2.7 Item price history
CREATE TABLE IF NOT EXISTS public.item_price_history (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    item_id uuid NOT NULL REFERENCES public.items(id) ON DELETE CASCADE,
    price_minor bigint NOT NULL CHECK (price_minor >= 0),
    effective_from timestamptz NOT NULL DEFAULT now(), effective_to timestamptz,
    created_at timestamptz DEFAULT now()
);
