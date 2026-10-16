-- monthly_reports, item stats, badges, audit, AI tables
CREATE POLICY "SELECT monthly_reports" ON public.monthly_reports FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "INSERT monthly_reports" ON public.monthly_reports FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "UPDATE monthly_reports" ON public.monthly_reports FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "SELECT monthly_item_stats" ON public.monthly_item_statistics FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "INSERT monthly_item_stats" ON public.monthly_item_statistics FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "UPDATE monthly_item_stats" ON public.monthly_item_statistics FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "SELECT user_badges" ON public.user_badges FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "INSERT user_badges" ON public.user_badges FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "SELECT audit_logs" ON public.audit_logs FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "SELECT ai_conversations" ON public.ai_conversations FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "INSERT ai_conversations" ON public.ai_conversations FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "DELETE ai_conversations" ON public.ai_conversations FOR DELETE USING (auth.uid() = user_id);

CREATE POLICY "SELECT ai_messages" ON public.ai_messages FOR SELECT
  USING (EXISTS (SELECT 1 FROM public.ai_conversations ac WHERE ac.id = ai_messages.conversation_id AND ac.user_id = auth.uid()));
CREATE POLICY "INSERT ai_messages" ON public.ai_messages FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "SELECT ai_actions" ON public.ai_actions FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "INSERT ai_actions" ON public.ai_actions FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "UPDATE ai_actions" ON public.ai_actions FOR UPDATE USING (auth.uid() = user_id);
