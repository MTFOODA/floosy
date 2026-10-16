-- 009_transactions.sql
-- Central transactions table for all financial movements

create table public.transactions (
  id uuid primary key default gen_random_uuid(),

  user_id uuid not null
    references auth.users(id)
    on delete cascade,

  bank_id uuid
    references public.banks(id)
    on delete set null,

  category_id uuid
    references public.categories(id)
    on delete set null,

  merchant_id uuid
    references public.merchants(id)
    on delete set null,

  type transaction_type not null,

  source transaction_source not null,

  amount_minor bigint not null
    check (amount_minor > 0),

  currency varchar(3) not null default 'EGP',

  transaction_date timestamptz not null,

  merchant_name varchar(200),

  card_last4 varchar(4),

  raw_reference text,
  external_reference text,

  fingerprint varchar(128),

  status transaction_status not null default 'confirmed',

  notes text,

  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

alter table public.transactions enable row level security;

create policy "Users can view own transactions"
  on public.transactions for select
  using (auth.uid() = user_id);

create policy "Users can insert own transactions"
  on public.transactions for insert
  with check (auth.uid() = user_id);

create policy "Users can update own transactions"
  on public.transactions for update
  using (auth.uid() = user_id);

create policy "Users can delete own transactions"
  on public.transactions for delete
  using (auth.uid() = user_id);

-- Unique index for SMS duplicate protection
create unique index transactions_user_fingerprint_unique
on public.transactions(user_id, fingerprint)
where fingerprint is not null;

-- Required indexes
create index idx_transactions_user_date
on public.transactions(user_id, transaction_date desc);

create index idx_transactions_user_type
on public.transactions(user_id, type);

create index idx_transactions_user_bank
on public.transactions(user_id, bank_id);

create index idx_transactions_user_category
on public.transactions(user_id, category_id);

create index idx_transactions_user_merchant
on public.transactions(user_id, merchant_id);

create index idx_transactions_fingerprint
on public.transactions(user_id, fingerprint);
