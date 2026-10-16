-- 0027_seed_faisal_bank.sql
-- =============================================================================
-- Idempotent seed: Faisal Bank in the remote `banks` table.
-- =============================================================================
-- The recovery audit found Faisal Bank only in the static offline
-- BankCatalog and missing from the remote `banks` table, so SMS from
-- FAISAL BANK resolved to `bank_id = ''` and could never be linked to a
-- user's Faisal bank account.
--
-- Safe to run against an already-seeded database: the row is inserted
-- only when no bank with the FAISAL code (or the Faisal Bank name)
-- exists yet — no duplicates are created on re-run.
-- =============================================================================

insert into public.banks (name, name_ar, code, country, currency, is_active)
select 'Faisal Bank', 'بنك فيصل', 'FAISAL', 'EG', 'EGP', true
where not exists (
  select 1
  from public.banks
  where lower(code) = 'faisal'
     or lower(name) = 'faisal bank'
     or lower(name_ar) = 'بنك فيصل'
);