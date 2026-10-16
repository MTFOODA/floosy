-- 015_savings.sql
-- Saving goals and recommendations

create table public.saving_goals (
  id uuid primary key default gen_random_uuid(),

  user_id uuid not null
    references auth.users(id)
    on delete cascade,

  name varchar(150) not null,

  target_amount_minor bigint not null
    check (target_amount_minor > 0),

  current_amount_minor bigint not null default 0
    check (current_amount_minor >= 0),

  currency varchar(3) not null default 'EGP',

  target_date date,

  status varchar(30) not null default 'active',

  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

alter table public.saving_goals enable row level security;

create policy "Users can view own goals"
  on public.saving_goals for select
  using (auth.uid() = user_id);

create policy "Users can insert own goals"
  on public.saving_goals for insert
  with check (auth.uid() = user_id);

create policy "Users can update own goals"
  on public.saving_goals for update
  using (auth.uid() = user_id);

create policy "Users can delete own goals"
  on public.saving_goals for delete
  using (auth.uid() = user_id);

-- Saving recommendations
create table public.saving_recommendations (
  id uuid primary key default gen_random_uuid(),

  user_id uuid not null
    references auth.users(id)
    on delete cascade,

  item_id uuid
    references public.items(id)
    on delete set null,

  category_id uuid
    references public.categories(id)
    on delete set null,

  baseline_amount_minor bigint not null
    check (baseline_amount_minor >= 0),

  current_amount_minor bigint not null
    check (current_amount_minor >= 0),

  reduction_percentage numeric(5,2) not null
    check (
      reduction_percentage >= 0
      and reduction_percentage <= 100
    ),

  estimated_saving_minor bigint not null
    check (estimated_saving_minor >= 0),

  month smallint not null
    check (month between 1 and 12),

  year smallint not null
    check (year >= 2000),

  status recommendation_status not null default 'active',

  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

alter table public.saving_recommendations enable row level security;

create policy "Users can view own recommendations"
  on public.saving_recommendations for select
  using (auth.uid() = user_id);

create policy "Users can insert own recommendations"
  on public.saving_recommendations for insert
  with check (auth.uid() = user_id);

create policy "Users can update own recommendations"
  on public.saving_recommendations for update
  using (auth.uid() = user_id);
