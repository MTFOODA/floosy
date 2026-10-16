-- cash_wallets, cash_movements, merchants, budgets policies
CREATE POLICY "SELECT cash_wallets" ON public.cash_wallets FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "INSERT cash_wallets" ON public.cash_wallets FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "UPDATE cash_wallets" ON public.cash_wallets FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "SELECT cash_movements" ON public.cash_movements FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "INSERT cash_movements" ON public.cash_movements FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "SELECT merchants" ON public.merchants FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "INSERT merchants" ON public.merchants FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "UPDATE merchants" ON public.merchants FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "SELECT budgets" ON public.budgets FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "INSERT budgets" ON public.budgets FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "UPDATE budgets" ON public.budgets FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "DELETE budgets" ON public.budgets FOR DELETE USING (auth.uid() = user_id);

CREATE POLICY "SELECT budget_categories" ON public.budget_categories FOR SELECT
  USING (EXISTS (SELECT 1 FROM public.budgets b WHERE b.id = budget_categories.budget_id AND b.user_id = auth.uid()));
CREATE POLICY "INSERT budget_categories" ON public.budget_categories FOR INSERT
  WITH CHECK (EXISTS (SELECT 1 FROM public.budgets b WHERE b.id = budget_categories.budget_id AND b.user_id = auth.uid()));
