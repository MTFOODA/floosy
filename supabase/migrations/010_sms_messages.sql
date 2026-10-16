-- 010_sms_messages.sql
-- SMS transaction tracking (store only metadata, not raw content)

create table public.sms_messages (
  id uuid primary key default gen_random_uuid(),

  user_id uuid not null
    references auth.users(id)
    on delete cascade,

  sender varchar(200),

  message_hash varchar(128) not null,

  received_at timestamptz not null,

  processed_at timestamptz,

  processing_status varchar(30) not null default 'pending',

  transaction_id uuid
    references public.transactions(id)
    on delete set null,

  parser_version varchar(50),

  confidence numeric(5,4)
    check (
      confidence is null
      or (confidence >= 0 and confidence <= 1)
    ),

  created_at timestamptz not null default now()
);

alter table public.sms_messages enable row level security;

create policy "Users can view own SMS messages"
  on public.sms_messages for select
  using (auth.uid() = user_id);

create policy "Users can insert own SMS messages"
  on public.sms_messages for insert
  with check (auth.uid() = user_id);

drop policy if exists "Users can update own SMS messages" on public.sms_messages;
create policy "Users can update own SMS messages"
  on public.sms_messages for update
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

-- Unique index for SMS duplicate protection
create unique index sms_messages_user_hash_unique
on public.sms_messages(user_id, message_hash);
