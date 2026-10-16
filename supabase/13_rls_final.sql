-- sync_queue policies + views + END
CREATE POLICY "SELECT sync_queue" ON public.sync_queue FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "INSERT sync_queue" ON public.sync_queue FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "UPDATE sync_queue" ON public.sync_queue FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "DELETE sync_queue" ON public.sync_queue FOR DELETE USING (auth.uid() = user_id);

-- bank_sms_patterns (system reference — visible to all authenticated users)
CREATE POLICY "SELECT bank_sms_patterns" ON public.bank_sms_patterns FOR SELECT USING (true);

-- remaining policies
CREATE POLICY "SELECT item_price_history" ON public.item_price_history FOR SELECT
  USING (EXISTS (SELECT 1 FROM public.items i WHERE i.id = item_price_history.item_id AND i.user_id = auth.uid()));
CREATE POLICY "INSERT item_price_history" ON public.item_price_history FOR INSERT
  WITH CHECK (EXISTS (SELECT 1 FROM public.items i WHERE i.id = item_price_history.item_id AND i.user_id = auth.uid()));
CREATE POLICY "SELECT sms_messages" ON public.sms_messages FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "INSERT sms_messages" ON public.sms_messages FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "SELECT expense_items" ON public.expense_items FOR SELECT
  USING (EXISTS (SELECT 1 FROM public.expenses e WHERE e.id = expense_items.expense_id AND e.user_id = auth.uid()));
CREATE POLICY "INSERT expense_items" ON public.expense_items FOR INSERT
  WITH CHECK (EXISTS (SELECT 1 FROM public.expenses e WHERE e.id = expense_items.expense_id AND e.user_id = auth.uid()));

-- =============================================================================
-- SECTION 14: VIEWS
-- =============================================================================

CREATE OR REPLACE VIEW public.v_user_balances AS
SELECT user_id,
    COALESCE(SUM(CASE WHEN type = 'in' THEN amount_minor ELSE -amount_minor END), 0) AS cash_balance_minor
FROM public.cash_movements GROUP BY user_id;

CREATE OR REPLACE VIEW public.v_monthly_item_summary AS
SELECT mis.user_id, mis.item_id, i.name AS item_name, mis.year, mis.month,
    mis.quantity, mis.total_spending_minor, mis.usage_change_percentage
FROM public.monthly_item_statistics mis
LEFT JOIN public.items i ON i.id = mis.item_id;

-- =============================================================================
-- END OF SCHEMA
-- =============================================================================
