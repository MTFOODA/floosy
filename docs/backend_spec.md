# Supabase Backend Specification

## Database Schema Overview

### Authentication
- Users managed by Supabase Auth
- Email/password authentication
- Session tokens automatic
- OAuth ready for future

### Core Data Models

#### Users & Profiles
```
profiles
├── id (UUID, FK to auth.users)
├── email
├── full_name
├── avatar_url
├── language (ar/en)
├── currency (EGP/USD/EUR/etc)
├── sms_tracking_enabled
├── created_at
└── updated_at
```

#### Banks & SMS Patterns
```
banks
├── id (UUID)
├── name & name_ar
├── code (CIB, NBE, QNB, etc)
├── country
├── currency
└── is_active

bank_sms_patterns
├── id (UUID)
├── bank_id (FK)
├── sender_pattern (regex)
├── purchase_patterns
├── atm_patterns
├── refund_patterns
├── amount_pattern
└── merchant_pattern
```

### Transactions

#### Main Transaction Table
```
transactions
├── id (UUID, Primary Key)
├── user_id (FK to auth.users)
├── bank_id (FK)
├── category_id (FK)
├── merchant_id (FK)
├── type (enum: purchase, atm_withdrawal, cash_expense, income, adjustment, refund, reversal)
├── source (enum: sms, manual, receipt, system, ai_assisted)
├── amount_minor (BIGINT - in smallest currency unit)
├── currency (varchar 3: EGP, USD, etc)
├── transaction_date (timestamp)
├── merchant_name
├── card_last4
├── fingerprint (SHA-256 hash for duplicate detection)
├── status (enum: pending, confirmed, cancelled, reversed)
├── notes
├── created_at
└── updated_at

Indexes:
├── (user_id, transaction_date DESC) - For listing
├── (user_id, type) - For filtering by type
├── (user_id, fingerprint) - For duplicate detection
└── (user_id, category_id) - For category analysis
```

#### SMS Message Tracking
```
sms_messages
├── id (UUID)
├── user_id (FK)
├── sender
├── message_hash (SHA-256 for security)
├── received_at
├── processed_at
├── transaction_id (FK to transactions)
├── confidence (0.0-1.0)
└── created_at
```

### Expenses & Items

#### Expense System
```
expenses
├── id (UUID)
├── user_id (FK)
├── transaction_id (FK, nullable)
├── category_id (FK)
├── amount_minor
├── expense_date
├── payment_method (cash/card)
└── notes

expense_items
├── id (UUID)
├── expense_id (FK)
├── item_id (FK)
├── quantity
├── unit_price_minor
└── total_price_minor
```

#### Quick Items
```
items
├── id (UUID)
├── user_id (FK)
├── name & name_ar
├── price_minor
├── category_id (FK)
├── image_url
├── is_active
└── is_archived

item_price_history
├── id (UUID)
├── item_id (FK)
├── price_minor
├── effective_from
├── effective_to
```

#### Item Usage Analytics
```
item_usage
├── id (UUID)
├── user_id (FK)
├── item_id (FK)
├── expense_id (FK)
├── quantity
├── total_amount_minor
├── usage_date

Index: (user_id, item_id, usage_date DESC)
```

### Financial Management

#### Cash Wallet
```
cash_wallets
├── id (UUID)
├── user_id (UUID, UNIQUE)
└── currency

cash_movements
├── id (UUID)
├── user_id (FK)
├── wallet_id (FK)
├── type (string: in, out, adjustment)
├── amount_minor (can be negative for out)
├── description
└── movement_date
```

#### Budgets
```
budgets
├── id (UUID)
├── user_id (FK)
├── name
├── amount_minor
├── period (monthly, yearly)
├── start_date
├── end_date
└── is_active

budget_categories
├── budget_id (FK)
├── category_id (FK)
├── limit_minor
└── Unique constraint: (budget_id, category_id)
```

#### Recurring Expenses
```
recurring_expenses
├── id (UUID)
├── user_id (FK)
├── name & name_ar
├── amount_minor
├── frequency (daily, weekly, monthly, yearly)
├── next_due_date
├── start_date
├── end_date
└── is_active

recurring_expense_occurrences
├── recurring_expense_id (FK)
├── scheduled_date
├── amount_minor
├── status (pending, paid, skipped, cancelled)
└── transaction_id (FK, nullable)
```

### Analytics & Reports

#### Monthly Summaries
```
monthly_reports
├── user_id (FK)
├── year & month
├── total_income_minor
├── total_expenses_minor
├── card_expenses_minor
├── cash_expenses_minor
├── atm_withdrawals_minor
├── top_category_id
├── top_item_id
├── top_merchant_id
├── potential_savings_minor
├── actual_savings_minor
└── Unique: (user_id, year, month)
```

#### Item Statistics
```
monthly_item_statistics
├── user_id (FK)
├── item_id (FK)
├── year & month
├── quantity
├── purchase_events
├── total_spending_minor
├── average_price_minor
├── previous_quantity
├── usage_change_percentage
├── spending_change_percentage
└── Unique: (user_id, item_id, year, month)
```

### Gamification & Notifications

#### Alerts System
```
alerts
├── id (UUID)
├── user_id (FK)
├── type (enum: high_item_usage, budget_warning, high_spending, etc)
├── severity (info, warning, critical)
├── title
├── message
├── data (JSONB for flexible metadata)
├── is_read
└── created_at

Index: (user_id, is_read)
```

#### Badges
```
badges
├── code (unique)
├── name & name_ar
├── description
├── icon
└── criteria (JSONB)

user_badges
├── user_id (FK)
├── badge_id (FK)
├── earned_at
└── Unique: (user_id, badge_id)
```

#### Notifications
```
notifications
├── id (UUID)
├── user_id (FK)
├── type
├── title & message
├── data (JSONB)
├── is_read
├── scheduled_for
├── sent_at
```

### AI & Advanced Features

#### Conversations
```
ai_conversations
├── id (UUID)
├── user_id (FK)
├── title
├── created_at
└── updated_at

ai_messages
├── id (UUID)
├── conversation_id (FK)
├── user_id (FK)
├── role (enum: user, assistant, tool, system)
├── content
├── tool_name
├── tool_arguments (JSONB)
├── tool_result (JSONB)
└── created_at

Index: (conversation_id, created_at)
```

#### Saving Recommendations
```
saving_recommendations
├── user_id (FK)
├── item_id (FK, nullable)
├── category_id (FK, nullable)
├── baseline_amount_minor
├── current_amount_minor
├── reduction_percentage
├── estimated_saving_minor
├── month & year
├── status
```

### System Tables

#### Sync Queue
```
sync_queue
├── id (UUID)
├── user_id (FK)
├── entity_type
├── entity_id (UUID)
├── operation (insert, update, delete)
├── payload (JSONB)
├── status (pending, processing, completed, failed)
├── retry_count
├── last_error
└── Indexes: (user_id, status)
```

#### Audit Logs
```
audit_logs
├── id (UUID)
├── user_id (FK, nullable)
├── action
├── entity_type
├── entity_id
├── old_data (JSONB)
├── new_data (JSONB)
└── created_at
```

## API Operations

### Authentication
```
POST /auth/v1/signup
  {email, password}
  
POST /auth/v1/token?grant_type=password
  {email, password}
  
POST /auth/v1/logout
  Authorization: Bearer token
  
POST /auth/v1/user/attributes
  Authorization: Bearer token
  {password}
```

### Transaction Operations
```
GET /rest/v1/transactions?user_id=eq.{userId}&order=transaction_date.desc.range(0,49)
POST /rest/v1/transactions
  {type, source, amount_minor, transaction_date, ...}
  
PATCH /rest/v1/transactions?id=eq.{id}
  {status, category_id, ...}
  
DELETE /rest/v1/transactions?id=eq.{id}

RPC: get_monthly_transactions({user_id, year, month})
RPC: get_cash_balance({user_id})
```

### Item Operations
```
GET /rest/v1/items?user_id=eq.{userId}&is_active=eq.true
POST /rest/v1/items
  {name, price_minor, category_id, ...}

GET /rest/v1/item_price_history?item_id=eq.{itemId}
POST /rest/v1/item_price_history
  {item_id, price_minor, effective_from}
```

### Analytics
```
RPC: get_monthly_spending({user_id, year, month})
RPC: get_item_usage_stats({user_id, year, month})

GET /rest/v1/monthly_reports?user_id=eq.{userId}&year=eq.{year}&month=eq.{month}
```

## Security & RLS Policies

Every table has RLS enabled with policies:

```sql
-- Standard user isolation policy
create policy "User isolation"
  on table_name for all
  using (auth.uid() = user_id);

-- System data visibility
create policy "Public system data"
  on table_name for select
  using (is_system = true);

-- Child table access
create policy "Child access"
  on child_table for all
  using (
    parent_id in (
      select id from parent_table 
      where user_id = auth.uid()
    )
  );
```

## Enums (PostgreSQL Types)

```
transaction_type: purchase, atm_withdrawal, cash_expense, income, adjustment, refund, reversal
transaction_source: sms, manual, receipt, system, ai_assisted
transaction_status: pending, confirmed, cancelled, reversed
payment_method: cash, card
category_type: expense, income, transfer
recurring_frequency: daily, weekly, monthly, yearly, custom
alert_type: high_item_usage, budget_warning, high_spending, subscription_detected, cash_difference, saving_opportunity
alert_severity: info, warning, critical
ai_message_role: user, assistant, tool, system
ai_action_status: pending_confirmation, confirmed, rejected, completed, failed
sync_operation: insert, update, delete
sync_status: pending, processing, completed, failed
```

## Database Functions

### get_cash_balance(user_id_param UUID)
Returns total pocket cash balance

### get_monthly_spending(user_id_param, year, month)
Returns spending by category for the month

### get_item_usage_stats(user_id_param, year, month)
Returns usage statistics for all items in the month

### calculate_savings_opportunity(user_id, item_id, reduction_percentage)
Calculates potential savings from spending reduction

### handle_new_user()
Trigger function that creates profile and cash wallet

## Triggers

- `updated_at` triggers on all mutable tables
- `audit_logs` triggers on critical operations
- `profiles`, `transactions`, `expenses`, etc.

## Scalability Considerations

1. **Partitioning**: `transactions` and `sms_messages` by user_id
2. **Indexes**: All FK relationships and frequently queried fields
3. **Materialized Views**: For complex monthly aggregations
4. **Cache**: Monthly reports computed once/month
5. **Archival**: Old transactions marked as archived

## Compliance & Privacy

- ✅ GDPR compliant (user data deletion)
- ✅ No SMS content storage (only hash)
- ✅ Financial data encryption in transit (TLS)
- ✅ User-specific data isolation (RLS)
- ✅ Audit logging for compliance

## Backup & Recovery

Supabase handles:
- Automatic daily backups
- Point-in-time recovery
- Replication across regions
- Disaster recovery procedures

Configuration in Supabase Dashboard → Database → Backups
