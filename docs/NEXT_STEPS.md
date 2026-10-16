# Floosy - Next Steps Implementation Guide

## Current State (Session Checkpoint)

✅ **Completed:**
- Full Supabase database schema (24 migrations)
- 7 Freezed data models
- All 10 repositories (Auth, Transaction, Item, Expense, Category, CashWallet, Budget, RecurringExpense, Analytics, AI)
- SMS parser service
- Complete Riverpod dependency injection
- 7 UI screens (Splash, Auth flow, Onboarding, Dashboard, Settings)
- Comprehensive documentation
- Environment configuration (.env support)

⏳ **In Progress:**
- Remote data sources need implementation
- Local data sources (partially done - only Transaction)

## Phase 2: Critical Path Items

### 1. Implement Remote Data Sources (8-10 files)

**Priority Order:**
```
1. item_remote_datasource.dart     (5-10 queries)
2. expense_remote_datasource.dart  (5-8 queries)
3. category_remote_datasource.dart (4-6 queries)
4. cash_wallet_remote_datasource.dart (4-5 queries)
5. budget_remote_datasource.dart   (6-8 queries)
6. recurring_expense_remote_datasource.dart (6-8 queries)
7. analytics_remote_datasource.dart (8-10 queries)
8. ai_remote_datasource.dart       (6-8 queries)
```

**Template for Each:**
```dart
class ItemRemoteDataSource {
  final SupabaseClient client;
  
  ItemRemoteDataSource(this.client);

  Future<List<Item>> getActiveItems(String userId) async {
    final response = await client
        .from('items')
        .select()
        .eq('user_id', userId)
        .eq('is_active', true)
        .order('name');
    
    return List<Item>.from(
      response.map((item) => Item.fromJson(item))
    );
  }

  // ... more methods
}
```

**Where to Create:**
- `lib/data/remote/datasources/item_remote_datasource.dart`
- `lib/data/remote/datasources/expense_remote_datasource.dart`
- etc.

### 2. Implement Sync Engine

**File:** `lib/data/services/sync_engine.dart`

```dart
class SyncEngine {
  final SupabaseClient supabaseClient;
  final AppDatabase localDatabase;

  Future<void> syncPendingOperations() async {
    final pending = await localDatabase.getSyncQueue()
        .where((item) => item.status == 'pending')
        .get();

    for (final item in pending) {
      try {
        final result = await _executeOperation(item);
        await _markSyncComplete(item.id);
      } catch (e) {
        await _markSyncFailed(item.id, e.toString());
      }
    }
  }

  Future<void> _executeOperation(SyncQueueItem item) async {
    // Execute based on operation type (insert/update/delete)
    // Use repositories to perform operations
  }
}
```

### 3. Wire Auth Flow to Repository

**File:** `lib/features/auth/presentation/providers/auth_providers.dart`

```dart
final authRepositoryProvider = Provider((ref) {
  final remoteDataSource = ref.watch(authRemoteDataSourceProvider);
  return AuthRepository(remoteDataSource);
});

final currentUserProvider = FutureProvider((ref) async {
  final repo = ref.watch(authRepositoryProvider);
  return repo.getCurrentUser();
});

// Use in screens: ref.watch(currentUserProvider)
```

### 4. Create Feature Providers

For each feature, create provider files:

**Example:** `lib/features/transactions/presentation/providers/transaction_providers.dart`

```dart
final transactionsProvider = FutureProvider<List<Transaction>>((ref) async {
  final repo = ref.watch(transactionRepositoryProvider);
  final user = ref.watch(currentUserProvider).value;
  if (user == null) return [];
  return repo.getTransactions(user.id);
});

final selectedTransactionProvider = StateProvider<Transaction?>((ref) => null);

final transactionFilterProvider = StateProvider<String?>((ref) => null);
```

### 5. Build Feature Screens (Priority Order)

**1. Transactions Screen**
- List view with filtering
- Add transaction modal
- SMS parser integration
- Edit/delete transaction

**2. Pocket Cash Screen**
- Current balance display
- Add/withdraw cash modal
- Movement history

**3. Items Screen**
- Grid/list view of items
- Create item modal
- Edit/delete item
- Price tracking

**4. Dashboard Enhancements**
- Wire to actual repositories
- Real-time balance updates
- Quick action buttons

**5. Budgets Screen**
- Create/edit budgets
- Category limits
- Progress tracking

**6. Analytics Screen**
- Monthly reports
- Spending charts
- Item statistics

**7. AI Chat Screen**
- Chat UI with flutter_chat_ui
- Tool calling integration
- Action confirmations

### 6. Implement Core Features

#### SMS to Transaction Flow

```dart
// In transaction_screen.dart
final smsTransactionProvider = FutureProvider((ref) async {
  // 1. Get SMS list (requires permission)
  // 2. Parse with SMSParser
  // 3. Check for duplicates
  // 4. Create transaction in repository
  // 5. Update UI
});
```

#### Sync Engine Integration

```dart
// In main.dart or app startup
Future<void> initializeSyncEngine() async {
  final syncEngine = SyncEngine(supabase, database);
  
  // Run on app start
  await syncEngine.syncPendingOperations();
  
  // Listen for connectivity changes
  connectivity.onConnectivityChanged.listen((_) async {
    await syncEngine.syncPendingOperations();
  });
}
```

## File Structure Checklist

```
lib/
├── data/
│   ├── remote/datasources/
│   │   ├── ✅ auth_remote_datasource.dart
│   │   ├── ✅ transaction_remote_datasource.dart
│   │   ├── ⏳ item_remote_datasource.dart
│   │   ├── ⏳ expense_remote_datasource.dart
│   │   ├── ⏳ category_remote_datasource.dart
│   │   ├── ⏳ cash_wallet_remote_datasource.dart
│   │   ├── ⏳ budget_remote_datasource.dart
│   │   ├── ⏳ recurring_expense_remote_datasource.dart
│   │   ├── ⏳ analytics_remote_datasource.dart
│   │   └── ⏳ ai_remote_datasource.dart
│   ├── local/datasources/
│   │   └── ✅ transaction_local_datasource.dart
│   ├── repositories/
│   │   ├── ✅ auth_repository.dart
│   │   ├── ✅ transaction_repository.dart
│   │   ├── ✅ item_repository.dart
│   │   ├── ✅ expense_repository.dart
│   │   ├── ✅ category_repository.dart
│   │   ├── ✅ cash_wallet_repository.dart
│   │   ├── ✅ budget_repository.dart
│   │   ├── ✅ recurring_expense_repository.dart
│   │   ├── ✅ analytics_repository.dart
│   │   └── ✅ ai_repository.dart
│   └── services/
│       ├── ✅ sms_parser_service.dart
│       └── ⏳ sync_engine.dart
└── features/
    ├── transactions/
    │   └── presentation/
    │       └── ⏳ providers/
    │           └── transaction_providers.dart
    ├── pocket_cash/
    │   └── ⏳ presentation/
    └── items/
        └── ⏳ presentation/

```

## Testing Strategy

### Unit Tests
```dart
test/repositories/
├── transaction_repository_test.dart
├── item_repository_test.dart
└── ... (one per repository)
```

### Widget Tests
```dart
test/features/
├── transactions/screens/
│   └── transaction_list_screen_test.dart
├── pocket_cash/screens/
└── ...
```

### Integration Tests
```dart
test/integration/
├── sync_flow_test.dart
├── offline_first_test.dart
└── sms_parsing_test.dart
```

## Code Generation

After creating new data sources, run:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

This regenerates:
- Freezed models
- Drift database code
- JSON serialization

## Performance Tips

1. **Pagination:** Load transactions in batches (50-100)
   ```dart
   const int pageSize = 50;
   List<Transaction> getPage(int page) =>
       transactions.skip(page * pageSize).take(pageSize).toList();
   ```

2. **Caching:** Use Provider.select() to avoid rebuilds
   ```dart
   final userName = ref.watch(userProvider.select((u) => u?.name));
   ```

3. **Lazy Loading:** Load data only when needed
   ```dart
   final expensesProvider = FutureProvider.autoDispose((ref) async {
     return ref.watch(expenseRepositoryProvider).getExpenses(userId);
   });
   ```

4. **Debouncing:** Debounce search/filter operations
   ```dart
   final searchProvider = StateProvider<String>((ref) => '');
   // Apply debounce in provider that uses it
   ```

## Common Patterns

### Handling Offline State
```dart
final hasInternetProvider = StreamProvider((ref) {
  return ConnectivityPlus().onConnectivityChanged.map((result) =>
      result.contains(ConnectivityResult.none) ? false : true);
});

// Use in widgets:
final hasInternet = ref.watch(hasInternetProvider);
```

### Loading States
```dart
final dataProvider = FutureProvider((ref) async {
  return ref.watch(repositoryProvider).getData();
});

// In widget:
dataProvider.when(
  loading: () => LoadingWidget(),
  error: (err, st) => ErrorWidget(error: err),
  data: (data) => DataWidget(data: data),
)
```

### Form Validation
```dart
final formProvider = StateProvider<FormState>((ref) => FormState());

// Update form
ref.read(formProvider.notifier).state = 
  state.copyWith(name: newValue);
```

## Debugging

### Enable Supabase Logging
```dart
// In main.dart
await Supabase.initialize(
  url: url,
  anonKey: key,
  debug: true, // Enable logs
);
```

### Inspect Local Database
```bash
# Copy database file for inspection
adb pull /data/data/com.floosy/databases/app.db
# Open with SQLite browser
```

### Riverpod DevTools
```dart
import 'package:riverpod_observer/riverpod_observer.dart';

// In main.dart
ProviderScope(
  observers: [RiverpodObserver()],
  child: MyApp(),
)
```

## Deployment Checklist

- [ ] All tests passing
- [ ] Code coverage >80%
- [ ] No debug logs in production
- [ ] Environment variables configured
- [ ] Supabase RLS enabled
- [ ] Error reporting configured (Sentry)
- [ ] Performance optimized
- [ ] Documentation complete
- [ ] App version bumped
- [ ] Changelog updated

## Emergency Recovery

If stuck:

1. **Clear cache:**
   ```bash
   flutter clean
   flutter pub get
   flutter pub run build_runner clean
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

2. **Reset Supabase (dev only):**
   - Delete and recreate project
   - Re-run migrations

3. **Check logs:**
   - logcat for Android errors
   - Xcode console for iOS errors
   - Supabase dashboard for API errors

## Resources

- **Floosy Documentation:** `README.md`, `docs/`
- **Architecture:** `docs/architecture.md`
- **Backend Spec:** `docs/backend_spec.md`
- **Development Guide:** `docs/development-guide.md`
- **Flutter Docs:** https://flutter.dev
- **Riverpod Docs:** https://riverpod.dev
- **Supabase Docs:** https://supabase.com/docs

## Contact & Support

For questions or issues:
1. Check existing documentation first
2. Search GitHub issues
3. Check Supabase logs
4. Run in debug mode with logging enabled
5. Review code comments for implementation details
