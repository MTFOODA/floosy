-- Financial reads now use the device vault. Initial legacy import reads
-- owner-scoped tables under RLS and never invokes these retired RPCs.
-- Keep functions and historical data; remove API-role execution only.
revoke execute on function public.calculate_savings_opportunity(uuid, uuid, numeric) from public, anon, authenticated;
revoke execute on function public.get_bank_accounts_with_balance(uuid) from public, anon, authenticated;
revoke execute on function public.get_cash_balance(uuid) from public, anon, authenticated;
revoke execute on function public.get_deducted_money(uuid, smallint, smallint) from public, anon, authenticated;
revoke execute on function public.get_item_usage_stats(uuid, smallint, smallint) from public, anon, authenticated;
revoke execute on function public.get_monthly_spending(uuid, smallint, smallint) from public, anon, authenticated;
revoke execute on function public.get_total_bank_balance(uuid) from public, anon, authenticated;

-- Trigger functions retain their existing trigger bindings. They are not RPCs.
revoke execute on function public.handle_new_user() from public, anon, authenticated;
revoke execute on function public.log_audit_event() from public, anon, authenticated;
revoke execute on function public.rls_auto_enable() from public, anon, authenticated;
