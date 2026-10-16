-- 007_merchants.sql
-- Merchants for transactions

create table public.merchants (
  id uuid primary key default gen_random_uuid(),

  user_id uuid not null
    references auth.users(id)
    on delete cascade,

  name varchar(200) not null,
  normalized_name varchar(200) not null,

  category_id uuid
    references public.categories(id)
    on delete set null,

  logo_url text,

  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

alter table public.merchants enable row level security;

create policy "Users can view own merchants"
  on public.merchants for select
  using (auth.uid() = user_id);

create policy "Users can insert own merchants"
  on public.merchants for insert
  with check (auth.uid() = user_id);

create policy "Users can update own merchants"
  on public.merchants for update
  using (auth.uid() = user_id);

create policy "Users can delete own merchants"
  on public.merchants for delete
  using (auth.uid() = user_id);

-- Index for fast merchant lookup
create index idx_merchants_user_normalized
on public.merchants(user_id, normalized_name);
