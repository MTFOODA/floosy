-- =============================================================================
-- SECTION 12: ENABLE RLS ON ALL USER-OWNED TABLES
-- =============================================================================

ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.merchants ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.items ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.item_price_history ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.cash_wallets ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.cash_movements ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.transactions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.sms_messages ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.expenses ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.expense_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.item_usage ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.budgets ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.budget_categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.recurring_expenses ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.recurring_expense_occurrences ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.saving_goals ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.saving_recommendations ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.alerts ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.app_notifications ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.monthly_reports ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.monthly_item_statistics ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_badges ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.ai_conversations ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.ai_messages ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.ai_actions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.sync_queue ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.audit_logs ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.bank_sms_patterns ENABLE ROW LEVEL SECURITY;

-- =============================================================================
-- SECTION 13: RLS POLICIES
-- =============================================================================

-- profiles
CREATE POLICY "Allow SELECT on profiles" ON public.profiles FOR SELECT USING (auth.uid() = id);
CREATE POLICY "Allow UPDATE on profiles" ON public.profiles FOR UPDATE USING (auth.uid() = id) WITH CHECK (auth.uid() = id);

-- categories
CREATE POLICY "SELECT categories" ON public.categories FOR SELECT USING (user_id IS NULL OR auth.uid() = user_id);
CREATE POLICY "INSERT categories" ON public.categories FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "UPDATE categories" ON public.categories FOR UPDATE USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);
CREATE POLICY "DELETE categories" ON public.categories FOR DELETE USING (auth.uid() = user_id);

-- items
CREATE POLICY "SELECT items" ON public.items FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "INSERT items" ON public.items FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "UPDATE items" ON public.items FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "DELETE items" ON public.items FOR DELETE USING (auth.uid() = user_id);

-- transactions
CREATE POLICY "SELECT transactions" ON public.transactions FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "INSERT transactions" ON public.transactions FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "UPDATE transactions" ON public.transactions FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "DELETE transactions" ON public.transactions FOR DELETE USING (auth.uid() = user_id);

-- expenses
CREATE POLICY "SELECT expenses" ON public.expenses FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "INSERT expenses" ON public.expenses FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "UPDATE expenses" ON public.expenses FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "DELETE expenses" ON public.expenses FOR DELETE USING (auth.uid() = user_id);
