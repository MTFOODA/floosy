-- 019_reports.sql
-- Monthly reports and statistics

create table public.monthly_reports (
  id uuid primary key default gen_random_uuid(),

  user_id uuid not null
    references auth.users(id)
    on delete cascade,

  year smallint not null
    check (year >= 2000),

  month smallint not null
    check (month between 1 and 12),

  total_income_minor bigint not null default 0
    check (total_income_minor >= 0),

  total_expenses_minor bigint not null default 0
    check (total_expenses_minor >= 0),

  card_expenses_minor bigint not null default 0
    check (card_expenses_minor >= 0),

  cash_expenses_minor bigint not null default 0
    check (cash_expenses_minor >= 0),

  atm_withdrawals_minor bigint not null default 0
    check (atm_withdrawals_minor >= 0),

  top_category_id uuid
    references public.categories(id)
    on delete set null,

  top_item_id uuid
    references public.items(id)
    on delete set null,

  top_merchant_id uuid
    references public.merchants(id)
    on delete set null,

  potential_savings_minor bigint not null default 0
    check (potential_savings_minor >= 0),

  actual_savings_minor bigint not null default 0
    check (actual_savings_minor >= 0),

  generated_at timestamptz,

  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),

  unique (
    user_id,
    year,
    month
  )
);

alter table public.monthly_reports enable row level security;

create policy "Users can view own reports"
  on public.monthly_reports for select
  using (auth.uid() = user_id);

-- Index for reports
create index idx_monthly_reports_user_period
on public.monthly_reports(user_id, year, month);

-- Monthly item statistics
create table public.monthly_item_statistics (
  id uuid primary key default gen_random_uuid(),

  user_id uuid not null
    references auth.users(id)
    on delete cascade,

  item_id uuid not null
    references public.items(id)
    on delete restrict,

  year smallint not null
    check (year >= 2000),

  month smallint not null
    check (month between 1 and 12),

  quantity bigint not null default 0
    check (quantity >= 0),

  purchase_events bigint not null default 0
    check (purchase_events >= 0),

  total_spending_minor bigint not null default 0
    check (total_spending_minor >= 0),

  average_price_minor bigint not null default 0
    check (average_price_minor >= 0),

  previous_quantity bigint not null default 0
    check (previous_quantity >= 0),

  previous_spending_minor bigint not null default 0
    check (previous_spending_minor >= 0),

  usage_change_percentage numeric(8,2) not null default 0,

  spending_change_percentage numeric(8,2) not null default 0,

  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),

  unique (
    user_id,
    item_id,
    year,
    month
  )
);

alter table public.monthly_item_statistics enable row level security;

create policy "Users can view own statistics"
  on public.monthly_item_statistics for select
  using (auth.uid() = user_id);

-- Index for statistics
create index idx_monthly_item_stats_user_period
on public.monthly_item_statistics(user_id, year, month);
