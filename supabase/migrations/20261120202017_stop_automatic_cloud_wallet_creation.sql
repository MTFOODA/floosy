-- Local-first release: Auth creates only the non-financial profile.
-- Historical financial rows, storage objects, and migration read access remain.
create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
  insert into public.profiles (id, email, full_name)
  values (new.id, new.email, new.raw_user_meta_data ->> 'full_name')
  on conflict (id) do nothing;
  return new;
end;
$$;

-- This function is an Auth trigger, never a public RPC endpoint.
revoke all on function public.handle_new_user() from public, anon, authenticated;
