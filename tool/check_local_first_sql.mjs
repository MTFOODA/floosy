// Usage: node tool/check_local_first_sql.mjs <path-to-pglite/dist/index.js>
// Runs synthetic PostgreSQL fixtures in memory; never connects to Supabase.
import {readFileSync} from 'node:fs';
import {resolve} from 'node:path';
import {pathToFileURL, fileURLToPath} from 'node:url';
import assert from 'node:assert/strict';
const {PGlite}=process.argv[2]
  ? await import(pathToFileURL(resolve(process.argv[2])).href)
  : await import('@electric-sql/pglite');
const root=fileURLToPath(new URL('../',import.meta.url));
const read=(path)=>readFileSync(resolve(root,path),'utf8');
const database=new PGlite();
try {
  await database.exec(`create schema auth; create role anon; create role authenticated;
    create table auth.users(id uuid primary key,email text,raw_user_meta_data jsonb);
    create table public.profiles(id uuid primary key,email text,full_name text);
    create table public.cash_wallets(id uuid primary key,user_id uuid);
    insert into public.cash_wallets values('00000000-0000-0000-0000-000000000001','00000000-0000-0000-0000-000000000002');`);
  // Stub audited signatures; tests here concern grants and trigger behavior.
  const inventory=JSON.parse(read('docs/local-first-dependencies.json'));
  for(const fn of inventory.functions){
    if(fn.name==='handle_new_user'||fn.name==='set_updated_at')continue;
    const signature=fn.definition.match(/FUNCTION public\.([^\n]+)\n/)[1];
    const returnType=fn.name==='rls_auto_enable'?'event_trigger':fn.name==='log_audit_event'?'trigger':'bigint';
    const body=returnType==='bigint'?'return 0;':returnType==='trigger'?'return new;':'null;';
    await database.exec(`create function public.${signature} returns ${returnType} language plpgsql security definer as $$ begin ${body} end; $$;`);
  }
  const profile=read('supabase/migrations/20261120202017_stop_automatic_cloud_wallet_creation.sql');
  const rpc=read('supabase/migrations/20261121005825_retire_financial_rpc_access.sql');
  await database.exec(profile);
  await database.exec(`create trigger on_auth_user_created after insert on auth.users for each row execute function public.handle_new_user();`);
  await database.exec(rpc);
  await database.exec(read('supabase/tests/local_first_profile_and_rpc.sql'));
  // Replaying both migrations is safe and does not touch existing money.
  await database.exec(profile);await database.exec(rpc);
  assert.equal((await database.query('select count(*)::int as n from public.cash_wallets')).rows[0].n,1);
  assert.equal((await database.query('select count(*)::int as n from public.profiles')).rows[0].n,0);
  console.log('PASS: profile creation, preserved wallets, retired API grants, rollback and idempotency.');
} finally {await database.close();}
