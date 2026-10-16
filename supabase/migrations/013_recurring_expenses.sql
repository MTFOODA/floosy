-- 013_recurring_expenses.sql
-- Recurring expenses and their occurrences

create table public.recurring_expenses (
  id uuid primary key default gen_random_uuid(),

  user_id uuid not null
    references auth.users(id)
    on delete cascade,

  name varchar(150) not null,
  name_ar varchar(150),

  amount_minor bigint not null
    check (amount_minor > 0),

  currency varchar(3) not null default 'EGP',

  category_id uuid
    references public.categories(id)
    on delete set null,

  icon varchar(100),

  frequency recurring_frequency not null,

  next_due_date date not null,

  start_date date not null,

  end_date date,

  is_active boolean not null default true,

  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),

  check (
    end_date is null
    or end_date >= start_date
  )
);

alter table public.recurring_expenses enable row level security;

create policy "Users can view own recurring expenses"
  on public.recurring_expenses for select
  using (auth.uid() = user_id);

create policy "Users can insert own recurring expenses"
  on public.recurring_expenses for insert
  with check (auth.uid() = user_id);

create policy "Users can update own recurring expenses"
  on public.recurring_expenses for update
  using (auth.uid() = user_id);

create policy "Users can delete own recurring expenses"
  on public.recurring_expenses for delete
  using (auth.uid() = user_id);

-- Recurring expense occurrences
create table public.recurring_expense_occurrences (
  id uuid primary key default gen_random_uuid(),

  recurring_expense_id uuid not null
    references public.recurring_expenses(id)
    on delete cascade,

  user_id uuid not null
    references auth.users(id)
    on delete cascade,

  scheduled_date date not null,

  amount_minor bigint not null
    check (amount_minor > 0),

  status recurring_occurrence_status not null default 'pending',

  transaction_id uuid
    references public.transactions(id)
    on delete set null,

  created_at timestamptz not null default now(),

  unique (
    recurring_expense_id,
    scheduled_date
  )
);

alter table public.recurring_expense_occurrences enable row level security;

create policy "Users can view own occurrences"
  on public.recurring_expense_occurrences for select
  using (auth.uid() = user_id);

create policy "Users can insert own occurrences"
  on public.recurring_expense_occurrences for insert
  with check (auth.uid() = user_id);

create policy "Users can update own occurrences"
  on public.recurring_expense_occurrences for update
  using (auth.uid() = user_id);
