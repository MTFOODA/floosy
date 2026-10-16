-- 016_alerts_badges.sql
-- Alerts, badges, and user badges

create table public.alerts (
  id uuid primary key default gen_random_uuid(),

  user_id uuid not null
    references auth.users(id)
    on delete cascade,

  type alert_type not null,

  severity alert_severity not null default 'info',

  item_id uuid
    references public.items(id)
    on delete set null,

  category_id uuid
    references public.categories(id)
    on delete set null,

  title varchar(200) not null,
  message text not null,

  data jsonb not null default '{}'::jsonb,

  is_read boolean not null default false,

  created_at timestamptz not null default now()
);

alter table public.alerts enable row level security;

create policy "Users can view own alerts"
  on public.alerts for select
  using (auth.uid() = user_id);

create policy "Users can insert own alerts"
  on public.alerts for insert
  with check (auth.uid() = user_id);

create policy "Users can update own alerts"
  on public.alerts for update
  using (auth.uid() = user_id);

-- Index for alerts
create index idx_alerts_user_read
on public.alerts(user_id, is_read);

-- Badges (global definitions)
create table public.badges (
  id uuid primary key default gen_random_uuid(),

  code varchar(100) not null unique,

  name varchar(150) not null,
  name_ar varchar(150),

  description text,
  description_ar text,

  icon varchar(100),

  criteria jsonb not null default '{}'::jsonb,

  created_at timestamptz not null default now()
);

-- User badges (earned)
create table public.user_badges (
  id uuid primary key default gen_random_uuid(),

  user_id uuid not null
    references auth.users(id)
    on delete cascade,

  badge_id uuid not null
    references public.badges(id)
    on delete cascade,

  earned_at timestamptz not null default now(),

  metadata jsonb not null default '{}'::jsonb,

  unique (
    user_id,
    badge_id
  )
);

alter table public.user_badges enable row level security;

create policy "Users can view own badges"
  on public.user_badges for select
  using (auth.uid() = user_id);

create policy "Users can insert own badges"
  on public.user_badges for insert
  with check (auth.uid() = user_id);
