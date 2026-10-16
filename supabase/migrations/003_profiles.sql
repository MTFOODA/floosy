-- 003_profiles.sql
-- User profiles table

create table public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,

  full_name text,
  email text,
  phone text,
  avatar_url text,

  language varchar(10) not null default 'ar',
  currency varchar(3) not null default 'EGP',

  default_bank_id uuid,

  sms_tracking_enabled boolean not null default false,
  notifications_enabled boolean not null default true,
  biometric_lock_enabled boolean not null default false,
  hide_balances boolean not null default false,

  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

alter table public.profiles enable row level security;

create policy "Users can view own profile"
  on public.profiles for select
  using (auth.uid() = id);

create policy "Users can update own profile"
  on public.profiles for update
  using (auth.uid() = id);
