-- =============================================================================
-- SECTION 3: WALLET / CASH TABLES
-- =============================================================================

CREATE TABLE IF NOT EXISTS public.cash_wallets (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    currency varchar(3) DEFAULT 'EGP',
    created_at timestamptz DEFAULT now(), updated_at timestamptz DEFAULT now()
);
CREATE UNIQUE INDEX IF NOT EXISTS idx_cash_wallets_user ON public.cash_wallets(user_id);

CREATE TABLE IF NOT EXISTS public.cash_movements (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    wallet_id uuid NOT NULL REFERENCES public.cash_wallets(id) ON DELETE CASCADE,
    type public.movement_type NOT NULL,
    amount_minor bigint NOT NULL CHECK (amount_minor >= 0),
    reference_type varchar, reference_id uuid, description text,
    movement_date timestamptz DEFAULT now(), created_at timestamptz DEFAULT now()
);
CREATE INDEX IF NOT EXISTS idx_cash_movements_user ON public.cash_movements(user_id);
CREATE INDEX IF NOT EXISTS idx_cash_movements_wallet ON public.cash_movements(wallet_id);

-- =============================================================================
-- SECTION 4: DETECTED CARDS, TRANSACTIONS & SMS MESSAGES
-- =============================================================================

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
    merchant_name varchar, card_last4 varchar(4),
    card_id uuid REFERENCES public.detected_cards(id) ON DELETE SET NULL,
    raw_reference varchar, external_reference varchar,
    fingerprint varchar,
    status public.transaction_status DEFAULT 'confirmed',
    notes text,
    created_at timestamptz DEFAULT now(), updated_at timestamptz DEFAULT now()
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
    parser_version varchar, confidence double precision,
    created_at timestamptz DEFAULT now()
);
CREATE INDEX IF NOT EXISTS idx_sms_messages_user ON public.sms_messages(user_id);
CREATE INDEX IF NOT EXISTS idx_sms_messages_hash ON public.sms_messages(user_id, message_hash);
CREATE UNIQUE INDEX IF NOT EXISTS sms_messages_user_hash_unique ON public.sms_messages(user_id, message_hash);
