-- 012_expenses.sql
-- Expenses table and related tables

create table public.expenses (
  id uuid primary key default gen_random_uuid(),

  user_id uuid not null
    references auth.users(id)
    on delete cascade,

  transaction_id uuid
    references public.transactions(id)
    on delete set null,

  category_id uuid
    references public.categories(id)
    on delete set null,

  amount_minor bigint not null
    check (amount_minor > 0),

  currency varchar(3) not null default 'EGP',

  expense_date timestamptz not null,

  payment_method payment_method not null,

  merchant_id uuid
    references public.merchants(id)
    on delete set null,

  notes text,

  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

alter table public.expenses enable row level security;

create policy "Users can view own expenses"
  on public.expenses for select
  using (auth.uid() = user_id);

create policy "Users can insert own expenses"
  on public.expenses for insert
  with check (auth.uid() = user_id);

create policy "Users can update own expenses"
  on public.expenses for update
  using (auth.uid() = user_id);

create policy "Users can delete own expenses"
  on public.expenses for delete
  using (auth.uid() = user_id);

-- Expense items
create table public.expense_items (
  id uuid primary key default gen_random_uuid(),

  expense_id uuid not null
    references public.expenses(id)
    on delete cascade,

  item_id uuid not null
    references public.items(id)
    on delete restrict,

  quantity integer not null
    check (quantity > 0),

  unit_price_minor bigint not null
    check (unit_price_minor >= 0),

  total_price_minor bigint not null
    check (total_price_minor >= 0),

  created_at timestamptz not null default now()
);

alter table public.expense_items enable row level security;

create policy "Users can view expense items"
  on public.expense_items for select
  using (
    expense_id in (
      select id from public.expenses where user_id = auth.uid()
    )
  );

create policy "Users can insert expense items"
  on public.expense_items for insert
  with check (
    expense_id in (
      select id from public.expenses where user_id = auth.uid()
    )
  );

-- Item usage tracking
create table public.item_usage (
  id uuid primary key default gen_random_uuid(),

  user_id uuid not null
    references auth.users(id)
    on delete cascade,

  item_id uuid not null
    references public.items(id)
    on delete restrict,

  expense_id uuid not null
    references public.expenses(id)
    on delete cascade,

  quantity integer not null
    check (quantity > 0),

  total_amount_minor bigint not null
    check (total_amount_minor >= 0),

  usage_date timestamptz not null,

  created_at timestamptz not null default now()
);

alter table public.item_usage enable row level security;

create policy "Users can view own item usage"
  on public.item_usage for select
  using (auth.uid() = user_id);

create policy "Users can insert own item usage"
  on public.item_usage for insert
  with check (auth.uid() = user_id);

-- Index for fast usage lookup
create index idx_item_usage_user_item_date
on public.item_usage(user_id, item_id, usage_date desc);

-- Index for expenses
create index idx_expenses_user_date
on public.expenses(user_id, expense_date desc);
