-- Run against a local test database after the two local-first migrations.
-- Synthetic fixtures are rolled back; do not run this test on production.
begin;
do $$
declare
  fixture_id uuid := '00000000-0000-0000-0000-000000000090';
  wallets_before bigint;
  signature text;
begin
  if exists(select 1 from auth.users where id=fixture_id) then
    raise exception 'Synthetic fixture ID is already in use';
  end if;
  select count(*) into wallets_before from public.cash_wallets;
  insert into auth.users(id,email,raw_user_meta_data)
  values(fixture_id,'floosy-synthetic@example.invalid','{"full_name":"Synthetic User"}'::jsonb);
  if not exists(select 1 from public.profiles where id=fixture_id and full_name='Synthetic User') then
    raise exception 'Sign-up no longer creates a profile';
  end if;
  if (select count(*) from public.cash_wallets) <> wallets_before then
    raise exception 'Sign-up changed financial wallets';
  end if;
  foreach signature in array array[
    'public.calculate_savings_opportunity(uuid,uuid,numeric)',
    'public.get_bank_accounts_with_balance(uuid)',
    'public.get_cash_balance(uuid)',
    'public.get_deducted_money(uuid,smallint,smallint)',
    'public.get_item_usage_stats(uuid,smallint,smallint)',
    'public.get_monthly_spending(uuid,smallint,smallint)',
    'public.get_total_bank_balance(uuid)',
    'public.handle_new_user()', 'public.log_audit_event()', 'public.rls_auto_enable()'
  ] loop
    if has_function_privilege('anon',signature,'execute')
      or has_function_privilege('authenticated',signature,'execute') then
      raise exception 'A retired function is still executable by API roles';
    end if;
  end loop;
end;
$$;
rollback;
