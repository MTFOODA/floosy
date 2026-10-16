-- 023_triggers.sql
-- Triggers for automatic timestamp updates and business logic

-- Apply updated_at trigger to all tables that have it
create trigger profiles_updated_at before update on public.profiles
  for each row execute function public.set_updated_at();

create trigger banks_updated_at before update on public.banks
  for each row execute function public.set_updated_at();

create trigger bank_sms_patterns_updated_at before update on public.bank_sms_patterns
  for each row execute function public.set_updated_at();

create trigger categories_updated_at before update on public.categories
  for each row execute function public.set_updated_at();

create trigger merchants_updated_at before update on public.merchants
  for each row execute function public.set_updated_at();

create trigger items_updated_at before update on public.items
  for each row execute function public.set_updated_at();

create trigger transactions_updated_at before update on public.transactions
  for each row execute function public.set_updated_at();

create trigger cash_wallets_updated_at before update on public.cash_wallets
  for each row execute function public.set_updated_at();

create trigger expenses_updated_at before update on public.expenses
  for each row execute function public.set_updated_at();

create trigger recurring_expenses_updated_at before update on public.recurring_expenses
  for each row execute function public.set_updated_at();

create trigger budgets_updated_at before update on public.budgets
  for each row execute function public.set_updated_at();

create trigger budget_categories_updated_at before update on public.budget_categories
  for each row execute function public.set_updated_at();

create trigger saving_goals_updated_at before update on public.saving_goals
  for each row execute function public.set_updated_at();

create trigger saving_recommendations_updated_at before update on public.saving_recommendations
  for each row execute function public.set_updated_at();

create trigger monthly_reports_updated_at before update on public.monthly_reports
  for each row execute function public.set_updated_at();

create trigger monthly_item_statistics_updated_at before update on public.monthly_item_statistics
  for each row execute function public.set_updated_at();

create trigger ai_conversations_updated_at before update on public.ai_conversations
  for each row execute function public.set_updated_at();

create trigger sync_queue_updated_at before update on public.sync_queue
  for each row execute function public.set_updated_at();

-- Trigger to log important audit events
create or replace function public.log_audit_event()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into public.audit_logs (
    user_id,
    action,
    entity_type,
    entity_id,
    old_data,
    new_data
  ) values (
    auth.uid(),
    tg_argv[0]::text,
    tg_table_name,
    case when tg_op = 'DELETE' then old.id else new.id end,
    case when tg_op = 'DELETE' or tg_op = 'UPDATE' then row_to_json(old) else null end,
    case when tg_op = 'INSERT' or tg_op = 'UPDATE' then row_to_json(new) else null end
  );
  return case when tg_op = 'DELETE' then old else new end;
end;
$$;

-- Apply audit triggers to critical tables
create trigger audit_transactions
  after insert or update or delete on public.transactions
  for each row execute function public.log_audit_event('transaction_modified');

create trigger audit_expenses
  after insert or update or delete on public.expenses
  for each row execute function public.log_audit_event('expense_modified');

create trigger audit_cash_movements
  after insert or update or delete on public.cash_movements
  for each row execute function public.log_audit_event('cash_movement_modified');

create trigger audit_budgets
  after insert or update or delete on public.budgets
  for each row execute function public.log_audit_event('budget_modified');
