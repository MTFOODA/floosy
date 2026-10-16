-- 004_banks.sql
-- Banks table for storing bank information

create table public.banks (
  id uuid primary key default gen_random_uuid(),

  name varchar(150) not null,
  name_ar varchar(150),

  code varchar(50) unique,
  logo_url text,

  country varchar(2) not null default 'EG',
  currency varchar(3) not null default 'EGP',

  is_active boolean not null default true,

  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

alter table public.banks enable row level security;

create policy "Anyone can view active banks"
  on public.banks for select
  using (is_active = true);

-- Add foreign key to profiles after both tables exist
alter table public.profiles
add constraint profiles_default_bank_fk
foreign key (default_bank_id)
references public.banks(id)
on delete set null;
