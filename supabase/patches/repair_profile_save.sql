-- Run once in the project's Supabase SQL Editor. Safe to run again.
-- Missing profiles are created by the signed-in app; existing data is retained.
begin;

alter table public.profiles enable row level security;
grant select, insert, update on table public.profiles to authenticated;

drop policy if exists "Users can insert their own profile" on public.profiles;
create policy "Users can insert their own profile"
  on public.profiles for insert to authenticated
  with check ((select auth.uid()) = id);

commit;

-- Confirm the ownership check was installed.
select policyname, cmd, roles, with_check
from pg_policies
where schemaname = 'public' and tablename = 'profiles'
  and policyname = 'Users can insert their own profile';
