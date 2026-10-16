-- 017_notifications.sql
-- Notifications table

create table public.notifications (
  id uuid primary key default gen_random_uuid(),

  user_id uuid not null
    references auth.users(id)
    on delete cascade,

  type varchar(50) not null,

  title varchar(200) not null,
  message text not null,

  data jsonb not null default '{}'::jsonb,

  is_read boolean not null default false,

  scheduled_for timestamptz,
  sent_at timestamptz,

  created_at timestamptz not null default now()
);

alter table public.notifications enable row level security;

create policy "Users can view own notifications"
  on public.notifications for select
  using (auth.uid() = user_id);

create policy "Users can insert own notifications"
  on public.notifications for insert
  with check (auth.uid() = user_id);

create policy "Users can update own notifications"
  on public.notifications for update
  using (auth.uid() = user_id);

-- Index for notifications
create index idx_notifications_user_read
on public.notifications(user_id, is_read);
