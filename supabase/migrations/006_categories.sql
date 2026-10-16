-- 006_categories.sql
-- Categories for transactions and expenses

create table public.categories (
  id uuid primary key default gen_random_uuid(),

  user_id uuid references auth.users(id) on delete cascade,

  name varchar(100) not null,
  name_ar varchar(100),

  icon varchar(100),

  parent_id uuid references public.categories(id) on delete set null,

  type category_type not null default 'expense',

  is_system boolean not null default false,
  is_active boolean not null default true,

  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

alter table public.categories enable row level security;

create policy "Users can view own and system categories"
  on public.categories for select
  using (auth.uid() = user_id or is_system = true);

create policy "Users can insert own categories"
  on public.categories for insert
  with check (auth.uid() = user_id and is_system = false);

create policy "Users can update own categories"
  on public.categories for update
  using (auth.uid() = user_id);

create policy "Users can delete own categories"
  on public.categories for delete
  using (auth.uid() = user_id);
