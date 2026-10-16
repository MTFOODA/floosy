-- 025_money_tables.sql
-- Monthly income/salary per user per month.
-- My Balance is the user's bank money: opening + movements across accounts.
-- User bank accounts give each bank identity (multi-bank support).

create table public.monthly_incomes (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null
    references auth.users(id)
    on delete cascade,
  year smallint not null check (year >= 2000),
  month smallint not null check (month between 1 and 12),
  label varchar(200),
  amount_minor bigint not null check (amount_minor >= 0),
  currency varchar(3) not null default 'EGP',
  bank_account_id uuid,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

alter table public.monthly_incomes enable row level security;

create policy "Users can view own monthly incomes"
  on public.monthly_incomes for select
  using (auth.uid() = user_id);

create policy "Users can insert own monthly incomes"
  on public.monthly_incomes for insert
  with check (auth.uid() = user_id);

create policy "Users can update own monthly incomes"
  on public.monthly_incomes for update
  using (auth.uid() = user_id);

create policy "Users can delete own monthly incomes"
  on public.monthly_incomes for delete
  using (auth.uid() = user_id);

create index idx_monthly_incomes_user_period
on public.monthly_incomes(user_id, year, month);

-- User-owned bank accounts (multi-bank support).
create table public.user_bank_accounts (
  id uuid primary key default gen_random_uuid(),

  user_id uuid not null
    references auth.users(id)
    on delete cascade,

  name varchar(150) not null,
  bank_id uuid references public.banks(id) on delete set null,
  account_last4 varchar(4),
  opening_balance_minor bigint not null default 0 check (opening_balance_minor >= 0),
  currency varchar(3) not null default 'EGP',
  is_active boolean not null default true,

  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

alter table public.user_bank_accounts enable row level security;

create policy "Users can view own bank accounts"
  on public.user_bank_accounts for select
  using (auth.uid() = user_id);

create policy "Users can insert own bank accounts"
  on public.user_bank_accounts for insert
  with check (auth.uid() = user_id);

create policy "Users can update own bank accounts"
  on public.user_bank_accounts for update
  using (auth.uid() = user_id);

create policy "Users can delete own bank accounts"
  on public.user_bank_accounts for delete
  using (auth.uid() = user_id);

create index idx_user_bank_accounts_user
on public.user_bank_accounts(user_id);

-- Ledger entries per bank account. Balance is derived from the ledger,
-- never stored as a mutable field.
create table public.user_bank_movements (
  id uuid primary key default gen_random_uuid(),

  account_id uuid not null
    references public.user_bank_accounts(id)
    on delete cascade,

  user_id uuid not null
    references auth.users(id)
    on delete cascade,

  type varchar(10) not null check (type in ('in', 'out')),
  amount_minor bigint not null check (amount_minor > 0),
  description text,
  reference_type varchar(50),
  reference_id uuid,
  movement_date timestamptz not null default now(),
  created_at timestamptz not null default now()
);

alter table public.user_bank_movements enable row level security;

create policy "Users can view own bank movements"
  on public.user_bank_movements for select
  using (auth.uid() = user_id);

create policy "Users can insert own bank movements"
  on public.user_bank_movements for insert
  with check (auth.uid() = user_id);

create index idx_user_bank_movements_user_date
on public.user_bank_movements(user_id, movement_date desc);

create index idx_user_bank_movements_account
on public.user_bank_movements(account_id);

-- Return all active accounts with their current balance
-- (opening balance + in - out).
create or replace function public.get_bank_accounts_with_balance(user_id_param uuid)
returns table (
  id uuid,
  name varchar,
  bank_id uuid,
  currency varchar,
  opening_balance_minor bigint,
  balance_minor bigint,
  is_active boolean
)
language sql
security definer
set search_path = public
as $$
  select
    a.id,
    a.name,
    a.bank_id,
    a.currency,
    a.opening_balance_minor,
    a.opening_balance_minor
      + coalesce((select sum(m.amount_minor) from public.user_bank_movements m
                  where m.account_id = a.id and m.type = 'in'), 0)
      - coalesce((select sum(m.amount_minor) from public.user_bank_movements m
                  where m.account_id = a.id and m.type = 'out'), 0) as balance_minor,
    a.is_active
  from public.user_bank_accounts a
  where a.user_id = user_id_param
  order by a.created_at;
$$;

-- Total bank balance across all active accounts for a user.
create or replace function public.get_total_bank_balance(user_id_param uuid)
returns bigint
language sql
security definer
set search_path = public
as $$
  select coalesce(sum(balance), 0) from (
    select
      a.opening_balance_minor
        + coalesce((select sum(m.amount_minor) from public.user_bank_movements m
                    where m.account_id = a.id and m.type = 'in'), 0)
        - coalesce((select sum(m.amount_minor) from public.user_bank_movements m
                    where m.account_id = a.id and m.type = 'out'), 0) as balance
    from public.user_bank_accounts a
    where a.user_id = user_id_param and a.is_active = true
  ) balances;
$$;

-- Deducted money = purchases + cash expenses + transfers sent.
create or replace function public.get_deducted_money(
  user_id_param uuid,
  year_param smallint,
  month_param smallint
)
returns bigint
language sql
security definer
set search_path = public
as $$
  select coalesce(sum(amount_minor), 0)
  from public.transactions
  where user_id = user_id_param
    and status = 'confirmed'
    and type in ('purchase', 'cash_expense', 'transfer_out')
    and extract(year from transaction_date) = year_param
    and extract(month from transaction_date) = month_param;
$$;

-- Apply updated_at trigger.
create trigger monthly_incomes_updated_at before update on public.monthly_incomes
  for each row execute function public.set_updated_at();

create trigger user_bank_accounts_updated_at before update on public.user_bank_accounts
  for each row execute function public.set_updated_at();

-- ─────────────────────────────────────────────────────────────────────────────
-- FIX: get_cash_balance previously summed ALL movements, which made cash
-- outflows INCREASE the balance. The ledger stores amount_minor as a positive
-- number with a direction in `type`, so balance must be direction-aware.
-- ─────────────────────────────────────────────────────────────────────────────
create or replace function public.get_cash_balance(user_id_param uuid)
returns bigint
language sql
security definer
set search_path = public
as $$
  select coalesce(sum(
    case
      when type in ('atm_withdrawal', 'income', 'in', 'manual_in', 'adjustment_in')
        then amount_minor
      else -amount_minor
    end), 0)
  from public.cash_movements
  where user_id = user_id_param;
$$;