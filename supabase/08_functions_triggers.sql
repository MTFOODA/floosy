-- =============================================================================
-- SECTION 10: FUNCTIONS
-- =============================================================================

CREATE OR REPLACE FUNCTION public.set_updated_at()
RETURNS TRIGGER LANGUAGE plpgsql AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$;

CREATE OR REPLACE FUNCTION public.get_cash_balance(user_id_param uuid)
RETURNS bigint LANGUAGE sql SECURITY DEFINER
SET search_path = public AS $$
  SELECT COALESCE(SUM(CASE WHEN type = 'in' THEN amount_minor ELSE -amount_minor END), 0)
  FROM public.cash_movements WHERE user_id = user_id_param;
$$;

CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER LANGUAGE plpgsql SECURITY DEFINER
SET search_path = public AS $$
BEGIN
  INSERT INTO public.profiles (id, email, full_name)
  VALUES (NEW.id, NEW.email, NEW.raw_user_meta_data->>'full_name');
  INSERT INTO public.cash_wallets (user_id, currency)
  VALUES (NEW.id, 'EGP') ON CONFLICT (user_id) DO NOTHING;
  RETURN NEW;
END;
$$;

-- =============================================================================
-- SECTION 11: TRIGGERS
-- =============================================================================

CREATE TRIGGER profiles_updated_at BEFORE UPDATE ON public.profiles
  FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();
CREATE TRIGGER banks_updated_at BEFORE UPDATE ON public.banks
  FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();
CREATE TRIGGER bank_sms_patterns_updated_at BEFORE UPDATE ON public.bank_sms_patterns
  FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();
CREATE TRIGGER categories_updated_at BEFORE UPDATE ON public.categories
  FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();
CREATE TRIGGER merchants_updated_at BEFORE UPDATE ON public.merchants
  FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();
CREATE TRIGGER items_updated_at BEFORE UPDATE ON public.items
  FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();
CREATE TRIGGER item_price_history_updated_at BEFORE UPDATE ON public.item_price_history
  FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();
CREATE TRIGGER transactions_updated_at BEFORE UPDATE ON public.transactions
  FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();
CREATE TRIGGER cash_wallets_updated_at BEFORE UPDATE ON public.cash_wallets
  FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();
CREATE TRIGGER cash_movements_updated_at BEFORE UPDATE ON public.cash_movements
  FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();
CREATE TRIGGER expenses_updated_at BEFORE UPDATE ON public.expenses
  FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();
CREATE TRIGGER recurring_expenses_updated_at BEFORE UPDATE ON public.recurring_expenses
  FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();
CREATE TRIGGER budgets_updated_at BEFORE UPDATE ON public.budgets
  FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();
CREATE TRIGGER budget_categories_updated_at BEFORE UPDATE ON public.budget_categories
  FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();
CREATE TRIGGER saving_goals_updated_at BEFORE UPDATE ON public.saving_goals
  FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();
CREATE TRIGGER saving_recommendations_updated_at BEFORE UPDATE ON public.saving_recommendations
  FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();
CREATE TRIGGER monthly_reports_updated_at BEFORE UPDATE ON public.monthly_reports
  FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();
CREATE TRIGGER monthly_item_statistics_updated_at BEFORE UPDATE ON public.monthly_item_statistics
  FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();
CREATE TRIGGER ai_conversations_updated_at BEFORE UPDATE ON public.ai_conversations
  FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();
CREATE TRIGGER sync_queue_updated_at BEFORE UPDATE ON public.sync_queue
  FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();
CREATE TRIGGER handle_new_user_trigger AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();
