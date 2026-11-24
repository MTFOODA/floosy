-- ONE-OFF operation authorized by the project owner on 21 November 2026.
-- All historical financial records were confirmed to be test data.
-- Preserve auth.users, profiles, avatars, bank catalog, patterns, badges and
-- global categories. Do not put this operation into replayed schema migrations.
begin;
set local lock_timeout = '5s';
set local statement_timeout = '30s';
truncate table public."merchants", public."items", public."item_price_history", public."cash_wallets", public."detected_cards", public."user_bank_accounts", public."transactions", public."monthly_incomes", public."user_bank_movements", public."cash_movements", public."expenses", public."expense_items", public."item_usage", public."budgets", public."budget_categories", public."recurring_expenses", public."recurring_expense_occurrences", public."saving_goals", public."saving_recommendations", public."alerts", public."notifications", public."monthly_reports", public."monthly_item_statistics", public."user_badges", public."audit_logs", public."ai_conversations", public."ai_messages", public."ai_actions", public."sync_queue", public."sms_messages";
delete from public.categories where user_id is not null;
-- Category deletion can create audit events; those are test history too.
delete from public.audit_logs;
commit;
