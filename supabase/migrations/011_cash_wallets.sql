-- 011_cash_wallets.sql
-- Pocket Cash wallet for each user

create table public.cash_wallets (
  id uuid primary key default gen_random_uuid(),

  user_id uuid not null unique
    references auth.users(id)
    on delete cascade,

  currency varchar(3) not null default 'EGP',

  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

alter table public.cash_wallets enable row level security;

create policy "Users can view own wallet"
  on public.cash_wallets for select
  using (auth.uid() = user_id);

-- Cash movements ledger
create table public.cash_movements (
  id uuid primary key default gen_random_uuid(),

  user_id uuid not null
    references auth.users(id)
    on delete cascade,

  wallet_id uuid not null
    references public.cash_wallets(id)
    on delete cascade,

  type varchar(40) not null,

  amount_minor bigint not null
    check (amount_minor <> 0),

  reference_type varchar(50),
  reference_id uuid,

  description text,

  movement_date timestamptz not null default now(),

  created_at timestamptz not null default now()
);

alter table public.cash_movements enable row level security;

create policy "Users can view own movements"
  on public.cash_movements for select
  using (auth.uid() = user_id);

create policy "Users can insert own movements"
  on public.cash_movements for insert
  with check (auth.uid() = user_id);

-- Index for fast balance calculation
create index idx_cash_movements_user_date
on public.cash_movements(user_id, movement_date desc);
