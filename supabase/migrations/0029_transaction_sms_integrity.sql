-- 0029_transaction_sms_integrity.sql
-- Aligns the remote transaction/SMS/card contract with the running app.
-- All additions are nullable/backward-compatible with existing rows.

begin;

-- The Flutter application already writes card_id; create the missing table
-- before the foreign key can be used on a fresh database.
create table if not exists public.detected_cards (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  last4 varchar(4) not null,
  bank_name varchar,
  transaction_count integer not null default 0,
  appearance jsonb not null default '{}'::jsonb,
  is_credit_card boolean not null default false,
  credit_limit_minor bigint not null default 0,
  current_balance_minor bigint not null default 0,
  cash_withdrawal_enabled boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
create unique index if not exists detected_cards_user_last4_bank_unique
  on public.detected_cards(user_id, last4, coalesce(bank_name, ''));
create index if not exists detected_cards_user_idx
  on public.detected_cards(user_id);

alter table public.detected_cards enable row level security;
drop policy if exists "Detected cards: SELECT" on public.detected_cards;
create policy "Detected cards: SELECT" on public.detected_cards
  for select using (auth.uid() = user_id);
drop policy if exists "Detected cards: INSERT" on public.detected_cards;
create policy "Detected cards: INSERT" on public.detected_cards
  for insert with check (auth.uid() = user_id);
drop policy if exists "Detected cards: UPDATE" on public.detected_cards;
create policy "Detected cards: UPDATE" on public.detected_cards
  for update using (auth.uid() = user_id)
  with check (auth.uid() = user_id);
drop policy if exists "Detected cards: DELETE" on public.detected_cards;
create policy "Detected cards: DELETE" on public.detected_cards
  for delete using (auth.uid() = user_id);

alter table public.transactions
  add column if not exists card_id uuid references public.detected_cards(id) on delete set null;

alter table public.sms_messages
  add column if not exists message_body text,
  add column if not exists bank_identified boolean not null default false,
  add column if not exists type_identified boolean not null default false,
  add column if not exists amount_identified boolean not null default false,
  add column if not exists currency_identified boolean not null default false,
  add column if not exists card_last4_identified boolean not null default false,
  add column if not exists detected_bank_id uuid references public.banks(id) on delete set null,
  add column if not exists detected_bank_name varchar,
  add column if not exists detected_type varchar,
  add column if not exists detected_amount_minor bigint,
  add column if not exists detected_currency varchar(3),
  add column if not exists detected_card_last4 varchar(4);

-- A unique user-scoped hash is the required upsert/dedupe identity.
create unique index if not exists sms_messages_user_hash_unique
  on public.sms_messages(user_id, message_hash);

drop policy if exists "Users can update own SMS messages" on public.sms_messages;
create policy "Users can update own SMS messages"
  on public.sms_messages for update
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

commit;
