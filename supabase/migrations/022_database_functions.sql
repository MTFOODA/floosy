-- 022_database_functions.sql
-- PostgreSQL functions for critical operations

-- Function to update the updated_at timestamp
create or replace function public.set_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

-- Function to get cash balance for a user
create or replace function public.get_cash_balance(user_id_param uuid)
returns bigint
language sql
security definer
set search_path = public
as $$
  select coalesce(sum(amount_minor), 0)
  from public.cash_movements
  where user_id = user_id_param;
$$;

-- Function to get monthly spending by category
create or replace function public.get_monthly_spending(
  user_id_param uuid,
  year_param smallint,
  month_param smallint
)
returns table (
  category_id uuid,
  category_name varchar,
  total_amount_minor bigint
)
language sql
security definer
set search_path = public
as $$
  select 
    c.id,
    c.name,
    coalesce(sum(e.amount_minor), 0) as total_amount_minor
  from public.categories c
  left join public.expenses e on c.id = e.category_id
    and e.user_id = user_id_param
    and extract(year from e.expense_date) = year_param
    and extract(month from e.expense_date) = month_param
  where c.user_id = user_id_param or c.is_system = true
  group by c.id, c.name
  order by total_amount_minor desc;
$$;

-- Function to get item usage statistics for a month
create or replace function public.get_item_usage_stats(
  user_id_param uuid,
  year_param smallint,
  month_param smallint
)
returns table (
  item_id uuid,
  item_name varchar,
  quantity bigint,
  total_spending_minor bigint,
  average_price_minor bigint
)
language sql
security definer
set search_path = public
as $$
  select 
    i.id,
    i.name,
    coalesce(sum(iu.quantity), 0) as quantity,
    coalesce(sum(iu.total_amount_minor), 0) as total_spending_minor,
    case when coalesce(sum(iu.quantity), 0) > 0
      then coalesce(sum(iu.total_amount_minor), 0) / coalesce(sum(iu.quantity), 1)
      else 0
    end as average_price_minor
  from public.items i
  left join public.item_usage iu on i.id = iu.item_id
    and iu.user_id = user_id_param
    and extract(year from iu.usage_date) = year_param
    and extract(month from iu.usage_date) = month_param
  where i.user_id = user_id_param and i.is_active = true
  group by i.id, i.name
  having coalesce(sum(iu.quantity), 0) > 0
  order by quantity desc;
$$;

-- Function to automatically create profile and cash wallet for new users
create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into public.profiles (id, email)
  values (new.id, new.email)
  on conflict do nothing;
  
  insert into public.cash_wallets (user_id)
  values (new.id)
  on conflict do nothing;
  
  return new;
end;
$$;

-- Trigger to create profile and wallet after signup
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();

-- Function to calculate potential savings
create or replace function public.calculate_savings_opportunity(
  user_id_param uuid,
  item_id_param uuid,
  reduction_percentage_param numeric
)
returns bigint
language sql
security definer
set search_path = public
as $$
  select case 
    when coalesce(sum(iu.total_amount_minor), 0) > 0
      then (coalesce(sum(iu.total_amount_minor), 0) * reduction_percentage_param / 100)::bigint
    else 0
  end
  from public.item_usage iu
  where iu.user_id = user_id_param
    and iu.item_id = item_id_param
    and extract(year from iu.usage_date) = extract(year from now())
    and extract(month from iu.usage_date) = extract(month from now());
$$;
