-- 0028_add_transfer_enums.sql
-- =============================================================================
-- FIX: the `transaction_type` Postgres enum was missing the values the Dart
-- model and the SMS parser produce for bank/wallet money movements:
-- `transfer_in` (استقبال تحويل / InstaPay / wallet received) and
-- `transfer_out` (تحويل من حسابكم / sent transfers).
--
-- Every SMS-classified transfer transaction failed to insert with
-- "invalid input value for enum transaction_type", which (together with the
-- remote-overwrites-local read path) left the Transactions page empty.
--
-- Idempotent: each value is added only when it does not exist yet.
-- Note: ALTER TYPE ... ADD VALUE runs fine on Supabase (PostgreSQL 13+)
-- because the new value is never used within the same transaction.
-- =============================================================================

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1
    FROM pg_enum e
    JOIN pg_type t ON t.oid = e.enumtypid
    WHERE t.typname = 'transaction_type' AND e.enumlabel = 'transfer_in'
  ) THEN
    ALTER TYPE public.transaction_type ADD VALUE 'transfer_in';
  END IF;

  IF NOT EXISTS (
    SELECT 1
    FROM pg_enum e
    JOIN pg_type t ON t.oid = e.enumtypid
    WHERE t.typname = 'transaction_type' AND e.enumlabel = 'transfer_out'
  ) THEN
    ALTER TYPE public.transaction_type ADD VALUE 'transfer_out';
  END IF;
END $$;
