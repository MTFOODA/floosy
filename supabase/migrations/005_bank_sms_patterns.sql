-- 005_bank_sms_patterns.sql
-- Bank SMS patterns for transaction parsing

create table public.bank_sms_patterns (
  id uuid primary key default gen_random_uuid(),

  bank_id uuid not null
    references public.banks(id)
    on delete cascade,

  sender_pattern text not null,

  purchase_patterns jsonb not null default '[]'::jsonb,
  atm_patterns jsonb not null default '[]'::jsonb,
  refund_patterns jsonb not null default '[]'::jsonb,
  income_patterns jsonb not null default '[]'::jsonb,
  reversal_patterns jsonb not null default '[]'::jsonb,

  amount_pattern text,
  merchant_pattern text,
  card_pattern text,
  date_pattern text,

  is_active boolean not null default true,
  version integer not null default 1,

  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

alter table public.bank_sms_patterns enable row level security;

create policy "Anyone can view active patterns"
  on public.bank_sms_patterns for select
  using (is_active = true);
