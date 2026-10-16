-- Recurring expenses, saving goals, alerts, app_notifications
CREATE POLICY "SELECT recurring_expenses" ON public.recurring_expenses FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "INSERT recurring_expenses" ON public.recurring_expenses FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "UPDATE recurring_expenses" ON public.recurring_expenses FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "DELETE recurring_expenses" ON public.recurring_expenses FOR DELETE USING (auth.uid() = user_id);

CREATE POLICY "SELECT recurring_occurrences" ON public.recurring_expense_occurrences FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "UPDATE recurring_occurrences" ON public.recurring_expense_occurrences FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "SELECT saving_goals" ON public.saving_goals FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "INSERT saving_goals" ON public.saving_goals FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "UPDATE saving_goals" ON public.saving_goals FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "DELETE saving_goals" ON public.saving_goals FOR DELETE USING (auth.uid() = user_id);

CREATE POLICY "SELECT alerts" ON public.alerts FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "INSERT alerts" ON public.alerts FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "UPDATE alerts" ON public.alerts FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "SELECT app_notifications" ON public.app_notifications FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "INSERT app_notifications" ON public.app_notifications FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "UPDATE app_notifications" ON public.app_notifications FOR UPDATE USING (auth.uid() = user_id);
