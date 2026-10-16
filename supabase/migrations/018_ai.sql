-- 018_ai.sql
-- AI conversations, messages, and actions

create table public.ai_conversations (
  id uuid primary key default gen_random_uuid(),

  user_id uuid not null
    references auth.users(id)
    on delete cascade,

  title varchar(200),

  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

alter table public.ai_conversations enable row level security;

create policy "Users can view own conversations"
  on public.ai_conversations for select
  using (auth.uid() = user_id);

create policy "Users can insert own conversations"
  on public.ai_conversations for insert
  with check (auth.uid() = user_id);

create policy "Users can update own conversations"
  on public.ai_conversations for update
  using (auth.uid() = user_id);

create policy "Users can delete own conversations"
  on public.ai_conversations for delete
  using (auth.uid() = user_id);

-- AI messages
create table public.ai_messages (
  id uuid primary key default gen_random_uuid(),

  conversation_id uuid not null
    references public.ai_conversations(id)
    on delete cascade,

  user_id uuid not null
    references auth.users(id)
    on delete cascade,

  role ai_message_role not null,

  content text,

  tool_name varchar(100),

  tool_arguments jsonb,

  tool_result jsonb,

  created_at timestamptz not null default now()
);

alter table public.ai_messages enable row level security;

create policy "Users can view own messages"
  on public.ai_messages for select
  using (auth.uid() = user_id);

create policy "Users can insert own messages"
  on public.ai_messages for insert
  with check (auth.uid() = user_id);

-- Index for messages
create index idx_ai_messages_conversation
on public.ai_messages(conversation_id, created_at);

create index idx_ai_conversations_user
on public.ai_conversations(user_id);

-- AI actions requiring confirmation
create table public.ai_actions (
  id uuid primary key default gen_random_uuid(),

  user_id uuid not null
    references auth.users(id)
    on delete cascade,

  conversation_id uuid
    references public.ai_conversations(id)
    on delete cascade,

  tool_name varchar(100) not null,

  arguments jsonb not null default '{}'::jsonb,

  status ai_action_status not null default 'pending_confirmation',

  result jsonb,

  created_at timestamptz not null default now(),
  confirmed_at timestamptz,
  completed_at timestamptz
);

alter table public.ai_actions enable row level security;

create policy "Users can view own actions"
  on public.ai_actions for select
  using (auth.uid() = user_id);

create policy "Users can insert own actions"
  on public.ai_actions for insert
  with check (auth.uid() = user_id);

create policy "Users can update own actions"
  on public.ai_actions for update
  using (auth.uid() = user_id);
