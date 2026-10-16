-- =============================================================================
-- SECTION 1: ENUMS
-- =============================================================================
DO $$ BEGIN
  CREATE TYPE public.transaction_type AS ENUM ('purchase','atm_withdrawal','cash_expense','income','adjustment','refund','reversal','transfer_in','transfer_out');
EXCEPTION WHEN duplicate_object THEN NULL; END $$;
DO $$ BEGIN
  CREATE TYPE public.transaction_source AS ENUM ('sms','manual','receipt','system','ai_assisted');
EXCEPTION WHEN duplicate_object THEN NULL; END $$;
DO $$ BEGIN
  CREATE TYPE public.transaction_status AS ENUM ('pending','confirmed','cancelled','reversed');
EXCEPTION WHEN duplicate_object THEN NULL; END $$;
DO $$ BEGIN
  CREATE TYPE public.payment_method AS ENUM ('card','cash','bank_transfer','other');
EXCEPTION WHEN duplicate_object THEN NULL; END $$;
DO $$ BEGIN
  CREATE TYPE public.movement_type AS ENUM ('in','out','adjustment');
EXCEPTION WHEN duplicate_object THEN NULL; END $$;
DO $$ BEGIN
  CREATE TYPE public.budget_period AS ENUM ('weekly','monthly','yearly','custom');
EXCEPTION WHEN duplicate_object THEN NULL; END $$;
DO $$ BEGIN
  CREATE TYPE public.recurring_frequency AS ENUM ('daily','weekly','monthly','yearly','custom');
EXCEPTION WHEN duplicate_object THEN NULL; END $$;
DO $$ BEGIN
  CREATE TYPE public.recurring_occurrence_status AS ENUM ('pending','paid','skipped','cancelled');
EXCEPTION WHEN duplicate_object THEN NULL; END $$;
DO $$ BEGIN
  CREATE TYPE public.category_type AS ENUM ('expense','income','both');
EXCEPTION WHEN duplicate_object THEN NULL; END $$;
DO $$ BEGIN
  CREATE TYPE public.alert_type AS ENUM ('high_item_usage','budget_warning','high_spending','subscription_detected','cash_difference','saving_opportunity');
EXCEPTION WHEN duplicate_object THEN NULL; END $$;
DO $$ BEGIN
  CREATE TYPE public.alert_severity AS ENUM ('info','warning','critical');
EXCEPTION WHEN duplicate_object THEN NULL; END $$;
DO $$ BEGIN
  CREATE TYPE public.ai_message_role AS ENUM ('user','assistant','tool','system');
EXCEPTION WHEN duplicate_object THEN NULL; END $$;
DO $$ BEGIN
  CREATE TYPE public.ai_action_status AS ENUM ('pending_confirmation','confirmed','rejected','completed','failed');
EXCEPTION WHEN duplicate_object THEN NULL; END $$;
DO $$ BEGIN
  CREATE TYPE public.sync_operation AS ENUM ('insert','update','delete');
EXCEPTION WHEN duplicate_object THEN NULL; END $$;
DO $$ BEGIN
  CREATE TYPE public.sync_status AS ENUM ('pending','processing','completed','failed');
EXCEPTION WHEN duplicate_object THEN NULL; END $$;
DO $$ BEGIN
  CREATE TYPE public.recommendation_status AS ENUM ('active','completed','dismissed');
EXCEPTION WHEN duplicate_object THEN NULL; END $$;
