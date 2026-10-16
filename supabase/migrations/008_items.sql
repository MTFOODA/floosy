-- 008_items.sql
-- Reusable quick-expense items

create table public.items (
  id uuid primary key default gen_random_uuid(),

  user_id uuid not null
    references auth.users(id)
    on delete cascade,

  name varchar(150) not null,
  name_ar varchar(150),

  description text,

  price_minor bigint not null
    check (price_minor >= 0),

  currency varchar(3) not null default 'EGP',

  category_id uuid
    references public.categories(id)
    on delete set null,

  icon varchar(100),
  image_url text,

  is_active boolean not null default true,
  is_archived boolean not null default false,

  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

alter table public.items enable row level security;

create policy "Users can view own items"
  on public.items for select
  using (auth.uid() = user_id);

create policy "Users can insert own items"
  on public.items for insert
  with check (auth.uid() = user_id);

create policy "Users can update own items"
  on public.items for update
  using (auth.uid() = user_id);

create policy "Users can delete own items"
  on public.items for delete
  using (auth.uid() = user_id);

-- Item price history
create table public.item_price_history (
  id uuid primary key default gen_random_uuid(),

  item_id uuid not null
    references public.items(id)
    on delete cascade,

  price_minor bigint not null
    check (price_minor >= 0),

  effective_from timestamptz not null default now(),
  effective_to timestamptz,

  created_at timestamptz not null default now(),

  check (
    effective_to is null
    or effective_to > effective_from
  )
);

alter table public.item_price_history enable row level security;

create policy "Users can view item price history"
  on public.item_price_history for select
  using (
    item_id in (
      select id from public.items where user_id = auth.uid()
    )
  );
