-- 020_audit_sync.sql
-- Audit logs and sync queue

create table public.audit_logs (
  id uuid primary key default gen_random_uuid(),

  user_id uuid
    references auth.users(id)
    on delete set null,

  action varchar(100) not null,

  entity_type varchar(100) not null,

  entity_id uuid,

  old_data jsonb,

  new_data jsonb,

  created_at timestamptz not null default now()
);

alter table public.audit_logs enable row level security;

create policy "Users can view own audit logs"
  on public.audit_logs for select
  using (auth.uid() = user_id);

-- Sync queue for offline-first synchronization
create table public.sync_queue (
  id uuid primary key default gen_random_uuid(),

  user_id uuid not null
    references auth.users(id)
    on delete cascade,

  entity_type varchar(100) not null,

  entity_id uuid not null,

  operation sync_operation not null,

  payload jsonb not null default '{}'::jsonb,

  status sync_status not null default 'pending',

  retry_count integer not null default 0
    check (retry_count >= 0),

  last_error text,

  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

alter table public.sync_queue enable row level security;

create policy "Users can view own sync queue"
  on public.sync_queue for select
  using (auth.uid() = user_id);

create policy "Users can insert own sync queue"
  on public.sync_queue for insert
  with check (auth.uid() = user_id);

create policy "Users can update own sync queue"
  on public.sync_queue for update
  using (auth.uid() = user_id);

-- Index for sync queue
create index idx_sync_queue_user_status
on public.sync_queue(user_id, status);
