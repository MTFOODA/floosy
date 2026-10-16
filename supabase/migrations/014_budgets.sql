-- 014_budgets.sql
-- Budgets and budget categories

create table public.budgets (
  id uuid primary key default gen_random_uuid(),

  user_id uuid not null
    references auth.users(id)
    on delete cascade,

  name varchar(150) not null,

  amount_minor bigint not null
    check (amount_minor >= 0),

  currency varchar(3) not null default 'EGP',

  period varchar(30) not null default 'monthly',

  start_date date not null,
  end_date date not null,

  is_active boolean not null default true,

  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),

  check (end_date >= start_date)
);

alter table public.budgets enable row level security;

create policy "Users can view own budgets"
  on public.budgets for select
  using (auth.uid() = user_id);

create policy "Users can insert own budgets"
  on public.budgets for insert
  with check (auth.uid() = user_id);

create policy "Users can update own budgets"
  on public.budgets for update
  using (auth.uid() = user_id);

create policy "Users can delete own budgets"
  on public.budgets for delete
  using (auth.uid() = user_id);

-- Budget categories
create table public.budget_categories (
  id uuid primary key default gen_random_uuid(),

  budget_id uuid not null
    references public.budgets(id)
    on delete cascade,

  category_id uuid not null
    references public.categories(id)
    on delete cascade,

  limit_minor bigint not null
    check (limit_minor >= 0),

  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),

  unique (
    budget_id,
    category_id
  )
);

alter table public.budget_categories enable row level security;

create policy "Users can view budget categories"
  on public.budget_categories for select
  using (
    budget_id in (
      select id from public.budgets where user_id = auth.uid()
    )
  );

create policy "Users can insert budget categories"
  on public.budget_categories for insert
  with check (
    budget_id in (
      select id from public.budgets where user_id = auth.uid()
    )
  );

create policy "Users can update budget categories"
  on public.budget_categories for update
  using (
    budget_id in (
      select id from public.budgets where user_id = auth.uid()
    )
  );

create policy "Users can delete budget categories"
  on public.budget_categories for delete
  using (
    budget_id in (
      select id from public.budgets where user_id = auth.uid()
    )
  );
