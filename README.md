# Floosy - Personal Finance Assistant

A comprehensive Flutter financial management application for tracking expenses, managing budgets, and achieving financial goals with AI-powered insights.

## Overview

Floosy is a modern, Arabic-first financial management application built with Flutter and Supabase. It helps users track all their financial transactions (bank purchases, ATM withdrawals, cash expenses), manage budgets, set savings goals, and get intelligent recommendations to reduce spending.

## Key Features

### Core Features
- **Transaction Tracking**: Automatically capture bank transactions via SMS
- **Pocket Cash Management**: Track physical cash with real-time balance updates
- **Smart Item Management**: Create reusable quick-expense items with price tracking
- **Budget System**: Set monthly budgets with category-level tracking
- **Recurring Expenses**: Manage fixed recurring costs (rent, subscriptions, utilities)
- **Analytics & Reports**: Comprehensive monthly analysis with item-level statistics
- **Alerts & Badges**: Get notified of unusual spending and earn achievement badges
- **AI Assistant**: Chat with an AI agent for financial insights and recommendations

### Advanced Features
- **Local-First Architecture**: Works offline with automatic sync when online
- **SMS Transaction Parsing**: Automatically detect and parse bank SMS messages
- **Duplicate Prevention**: Fingerprint-based system prevents duplicate transactions
- **Saving Opportunities**: AI-powered recommendations for spending reduction
- **Month Comparison**: Track spending patterns across months
- **Multi-Language Support**: Full Arabic and English support with RTL layout

## Technology Stack

### Frontend
- **Flutter 3.13+** - UI Framework
- **Dart** - Programming Language
- **Riverpod 2.4+** - State Management
- **GoRouter** - Navigation
- **Freezed** - Model Generation
- **Drift/SQLite** - Local Database
- **Flutter Chat UI** - AI Chat Interface

### Backend
- **Supabase** - Backend-as-a-Service
- **PostgreSQL** - Primary Database
- **Row Level Security (RLS)** - Data Isolation
- **Edge Functions** - Serverless Backend
- **Storage** - File Management

### Architecture
```
Presentation Layer (Screens, Widgets)
    ↓
State Management (Riverpod Providers)
    ↓
Repository Pattern (Data abstraction)
    ↓
Data Layer
├── Remote (Supabase API)
├── Local (Drift/SQLite)
└── Services (SMS Parser, Sync Engine)
```

## Project Structure

```
lib/
├── main.dart                 # Entry point
├── config/                   # Configuration files
├── routing/                  # GoRouter setup
├── theme/                    # UI Theme
├── core/                     # Core utilities and providers
│   └── providers.dart        # Riverpod providers
│
├── features/                 # Feature modules
│   ├── auth/                # Authentication
│   ├── onboarding/          # Onboarding flow
│   ├── dashboard/           # Dashboard
│   ├── transactions/        # Transactions
│   ├── pocket_cash/         # Cash management
│   ├── items/               # Quick items
│   ├── budgets/             # Budgets
│   ├── recurring_expenses/  # Recurring expenses
│   ├── analytics/           # Analytics
│   ├── ai/                  # AI agent
│   ├── alerts/              # Alerts & notifications
│   ├── badges/              # Achievement badges
│   └── settings/            # Settings
│
└── data/                     # Data layer
    ├── models/               # Freezed data models
    ├── local/                # Local database
    │   ├── database/         # Drift schema
    │   └── datasources/      # Local data sources
    ├── remote/               # Remote data sources
    │   └── datasources/      # Supabase integration
    ├── repositories/         # Repository implementations
    └── services/             # Business logic services
        └── sms_parser_service.dart
```

## Setup Instructions

### 1. Prerequisites
- Flutter 3.13.0 or higher
- Dart 3.1.0 or higher
- Android SDK 21+ (for Android development)
- Supabase account and project

### 2. Clone and Setup

```bash
# Clone repository
git clone https://github.com/MTFOODA/floosy.git
cd floosy

# Get dependencies
flutter pub get

# Build runner for code generation
flutter pub run build_runner build --delete-conflicting-outputs
```

### 3. Environment Configuration

Configure the Supabase project URL and publishable key in
`lib/config/supabase_config.dart`. Use only client-safe publishable (anon) keys;
never put service-role keys or other privileged credentials in the app. Local
`.env` files are ignored and are not bundled into the application.

### 4. Database Setup

Apply migrations to your Supabase PostgreSQL database:

```bash
# Using Supabase CLI
supabase db reset

# Or manually run migrations in order:
# supabase/migrations/001_extensions.sql
# supabase/migrations/002_enums.sql
# ... (all numbered migrations in order)
```

### 5. Android Configuration

Update `android/app/build.gradle`:

```gradle
minSdkVersion 21
targetSdkVersion 34
```

Add to `AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.READ_SMS" />
<uses-permission android:name="android.permission.RECEIVE_SMS" />
<uses-permission android:name="android.permission.POST_NOTIFICATIONS" />
</manifest>
```

### 6. Run Application

```bash
# Debug mode
flutter run

# Release mode
flutter run --release

# Specific device
flutter run -d <device-id>
```

## Database Schema

### Core Tables
- `profiles` - User profiles
- `banks` - Bank definitions
- `bank_sms_patterns` - SMS parsing patterns
- `categories` - Expense categories
- `merchants` - Merchant tracking
- `items` - Reusable expense items

### Transaction Tables
- `transactions` - All financial transactions
- `sms_messages` - SMS transaction metadata
- `expenses` - Detailed expenses
- `expense_items` - Items within expenses
- `item_usage` - Item usage tracking

### Financial Management
- `cash_wallets` - Pocket cash wallets
- `cash_movements` - Cash ledger movements
- `budgets` - Monthly budgets
- `budget_categories` - Category budgets
- `recurring_expenses` - Recurring expense definitions
- `recurring_expense_occurrences` - Occurrences of recurring expenses

### Analytics & Reports
- `monthly_reports` - Monthly summaries
- `monthly_item_statistics` - Item-level statistics
- `saving_goals` - Financial goals
- `saving_recommendations` - Saving opportunities

### Notifications & Gamification
- `alerts` - User alerts
- `badges` - Badge definitions
- `user_badges` - Earned badges
- `notifications` - Push notifications

### AI & Sync
- `ai_conversations` - Chat conversations
- `ai_messages` - Chat messages
- `ai_actions` - Confirmable AI actions
- `sync_queue` - Offline-first sync queue
- `audit_logs` - Activity audit trail

## SMS Transaction Parsing

The SMS parser automatically detects and classifies bank transactions:

### Supported Transaction Types
- **Purchase** - Card transactions at merchants
- **ATM Withdrawal** - Cash withdrawals from ATMs
- **Cash Expense** - Manual cash tracking
- **Income** - Money received/transfers in
- **Refund** - Transaction refunds
- **Reversal** - Reversed transactions

### Duplicate Prevention
Uses SHA-256 fingerprinting on normalized SMS content to prevent duplicate processing.

## Authentication Flow

1. **Sign Up** → Profile auto-creation
2. **Onboarding** → Currency, Bank, Permissions
3. **SMS Access** → Read bank transaction SMS
4. **Dashboard** → Full app access

Session persistence via Supabase Auth.

## Offline-First Architecture

### Local Storage
- Drift/SQLite for local transaction cache
- Automatic sync queue for pending operations

### Sync Strategy
```
User Action (create transaction)
    ↓
Save to Local (Drift)
    ↓
Add to Sync Queue
    ↓
Attempt Remote Sync
    ↓
Update sync_queue status
```

## State Management with Riverpod

### Provider Structure
```dart
// Data providers
final supabaseClientProvider        // Supabase instance
final appDatabaseProvider           // Local database
final authRemoteDataSourceProvider  // Auth API calls

// Repository providers
final authRepositoryProvider        // Auth business logic
final transactionRepositoryProvider // Transaction logic

// State providers
final authStateProvider      // Auth state stream
final currentUserProvider    // Current user
```

## AI Agent Integration

The AI assistant (`flutter_chat_ui`) with secure backend tools:

### Available Tools
- `get_cash_balance` - Current pocket cash
- `get_monthly_summary` - Month spending overview
- `get_item_statistics` - Item usage stats
- `get_top_items` - Top spending items
- `get_top_categories` - Top spending categories
- `compare_months` - Month-to-month comparison
- `calculate_saving` - Saving opportunity calculations

### Confirmable Actions
Actions like "delete item" require explicit user confirmation.

## Testing

### Run Tests
```bash
flutter test
```

### Test Coverage
- Authentication (login, signup, reset password)
- Transaction parsing (SMS, duplicates)
- Pocket cash (balance, movements)
- Items (CRUD, usage tracking)
- Budgets (limits, warnings)
- Analytics (calculations, comparisons)

## Localization

The app supports:
- **Arabic (ar)** - Default, RTL layout
- **English (en)** - LTR layout

Add translations to `assets/translations/`:
```
assets/
└── translations/
    ├── ar.json
    └── en.json
```

## Security Best Practices

1. **RLS Enabled** - All tables have row-level security
2. **User Isolation** - Users only see their own data
3. **No Service Role Key** - Flutter app uses anon key only
4. **Input Validation** - All user input validated
5. **Fingerprinting** - Duplicate detection via hashing
6. **Secure Storage** - Sensitive data in Flutter Secure Storage

## Troubleshooting

### SMS Permission Issues
- Check Android manifest permissions
- Request runtime permissions before reading SMS
- Test on physical device (emulator limitations)

### Supabase Connection
- Verify `.env` credentials
- Check Supabase project is active
- Ensure network connectivity

### Database Migrations
- Run migrations in correct order
- Check Supabase database logs
- Verify RLS policies are enabled

## Future Enhancements

- [ ] Receipt OCR scanning
- [ ] Bill payment reminders
- [ ] Investment tracking
- [ ] Expense categorization AI
- [ ] Multi-currency support
- [ ] Dark mode refinements
- [ ] Web dashboard
- [ ] Family/Shared budgets
- [ ] Bank API integration (direct)
- [ ] ML-based spending predictions

## Contributing

1. Create feature branch: `git checkout -b feature/feature-name`
2. Commit changes: `git commit -am 'Add feature'`
3. Push to branch: `git push origin feature/feature-name`
4. Submit pull request

## License

Proprietary - All rights reserved

## Support

For issues and questions, contact support@floosy.app

## Development Roadmap

### Phase 1 (Current)
- Core authentication
- Transaction tracking
- SMS parsing
- Pocket cash management
- Basic analytics

### Phase 2
- Item management
- Budget system
- Recurring expenses
- Alerts system

### Phase 3
- AI agent
- Advanced analytics
- Badge system
- Monthly reports

### Phase 4
- Testing suite
- Performance optimization
- Web version
- API documentation
