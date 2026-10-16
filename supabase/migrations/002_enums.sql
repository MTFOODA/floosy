-- 002_enums.sql
-- Create PostgreSQL enum types for data integrity

create type transaction_type as enum (
  'purchase',
  'atm_withdrawal',
  'cash_expense',
  'income',
  'adjustment',
  'refund',
  'reversal'
);

create type transaction_source as enum (
  'sms',
  'manual',
  'receipt',
  'system',
  'ai_assisted'
);

create type transaction_status as enum (
  'pending',
  'confirmed',
  'cancelled',
  'reversed'
);

create type payment_method as enum (
  'cash',
  'card'
);

create type category_type as enum (
  'expense',
  'income',
  'transfer'
);

create type recurring_frequency as enum (
  'daily',
  'weekly',
  'monthly',
  'yearly',
  'custom'
);

create type alert_type as enum (
  'high_item_usage',
  'budget_warning',
  'high_spending',
  'subscription_detected',
  'cash_difference',
  'saving_opportunity'
);

create type alert_severity as enum (
  'info',
  'warning',
  'critical'
);

create type recommendation_status as enum (
  'active',
  'completed',
  'dismissed'
);

create type recurring_occurrence_status as enum (
  'pending',
  'paid',
  'skipped',
  'cancelled'
);

create type sync_operation as enum (
  'insert',
  'update',
  'delete'
);

create type sync_status as enum (
  'pending',
  'processing',
  'completed',
  'failed'
);

create type ai_message_role as enum (
  'user',
  'assistant',
  'tool',
  'system'
);

create type ai_action_status as enum (
  'pending_confirmation',
  'confirmed',
  'rejected',
  'completed',
  'failed'
);
