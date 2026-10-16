# Floosy Architecture Documentation

## High-Level Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    Presentation Layer                        │
│  (Screens, Widgets, UI State with Riverpod Providers)       │
└────────────────────┬────────────────────────────────────────┘
                     │
┌────────────────────▼────────────────────────────────────────┐
│               State Management Layer                         │
│  (Riverpod Providers, Notifiers, State Listeners)           │
└────────────────────┬────────────────────────────────────────┘
                     │
┌────────────────────▼────────────────────────────────────────┐
│                 Repository Layer                             │
│  (Abstract data access, Business logic coordination)        │
└────────────────────┬────────────────────────────────────────┘
                     │
        ┌────────────┴────────────┐
        │                         │
┌───────▼──────────┐    ┌────────▼──────────┐
│  Remote Layer    │    │   Local Layer     │
│  (Supabase API)  │    │  (Drift/SQLite)   │
└──────────────────┘    └───────────────────┘
```

## Detailed Layer Descriptions

### 1. Presentation Layer

Located in: `lib/features/*/presentation/`

Responsibilities:
- Display UI to users
- Collect user input
- Show loading, error, empty states
- Respond to user interactions

Example:
```dart
// screens/dashboard_screen.dart
class DashboardScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionRepository = ref.watch(transactionRepositoryProvider);
    // Use repository through Riverpod
  }
}
```

### 2. State Management Layer

Located in: `lib/core/providers.dart` and feature-specific providers

Responsibilities:
- Manage application state
- Expose data to UI
- Handle side effects
- Provide dependency injection

Provider Types:
```dart
// Simple values
final currentUserProvider = Provider<User?>(...)

// Async operations
final transactionsProvider = FutureProvider<List<Transaction>>(...)

// Observable streams
final authStateProvider = StreamProvider<AuthState>(...)

// Mutable state
final selectedCategoryProvider = StateProvider<String?>(...)

// Complex logic
final transactionRepositoryProvider = Provider<TransactionRepository>(...)
```

### 3. Repository Layer

Located in: `lib/data/repositories/`

Responsibilities:
- Abstract data source details
- Coordinate between local and remote
- Implement business logic
- Handle caching strategies

Example:
```dart
class TransactionRepository {
  Future<List<Transaction>> getTransactions({
    required String userId,
    bool syncWithRemote = true,
  }) async {
    // Try local first
    var transactions = await localDataSource.get(userId);
    
    // Sync with remote if requested
    if (syncWithRemote) {
      try {
        final remote = await remoteDataSource.get(userId);
        // Merge and update local
      }
    }
    
    return transactions;
  }
}
```

### 4. Data Source Layer

#### Remote Data Source (Supabase)
Located in: `lib/data/remote/datasources/`

```dart
class TransactionRemoteDataSource {
  Future<Transaction> createTransaction(Transaction t) async {
    return _supabaseClient
        .from('transactions')
        .insert(t.toJson())
        .select()
        .single();
  }
}
```

#### Local Data Source (Drift/SQLite)
Located in: `lib/data/local/datasources/`

```dart
class TransactionLocalDataSource {
  Future<void> insertTransaction(Transaction t) async {
    await database.into(database.transactions).insert(...);
  }
}
```

## Data Flow Patterns

### Create Transaction Flow

```
User Taps "Add Expense"
    ↓
UI calls repository.createTransaction()
    ↓
Repository saves to Local Database (Drift)
    ↓
Repository attempts Remote Sync (Supabase)
    ├─ Success: Update local with remote ID
    └─ Failure: Add to sync queue for later
    ↓
UI updates with new transaction
```

### SMS Transaction Flow

```
SMS Received (Android)
    ↓
SMSParser.parseTransaction()
    ├─ Extract amount
    ├─ Detect merchant
    ├─ Classify type (purchase/ATM/etc)
    └─ Generate fingerprint
    ↓
Check duplicate via fingerprint
    ├─ Duplicate: Skip
    └─ New: Continue
    ↓
Create Transaction
    ↓
Save locally → Sync remotely
```

## Model Generation with Freezed

All data models use Freezed for immutability and JSON serialization:

```dart
@freezed
class Transaction with _$Transaction {
  const factory Transaction({
    required String id,
    required int amountMinor,
    DateTime? createdAt,
  }) = _Transaction;

  factory Transaction.fromJson(Map<String, dynamic> json) =>
      _$TransactionFromJson(json);
}
```

Commands to regenerate:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

## Offline-First Sync Architecture

### Sync Queue

When offline:
1. User creates transaction
2. Saved locally to Drift
3. Added to sync_queue table with status='pending'
4. UI shows transaction immediately

When online:
1. Sync engine reads sync_queue
2. Attempts Supabase operations
3. Updates sync_queue status
4. Removes completed items

```dart
class SyncEngine {
  Future<void> syncPendingOperations() async {
    final pending = await database.getPendingSyncItems();
    
    for (final item in pending) {
      try {
        final result = await remote.executeOperation(
          item.operation,
          item.payload,
        );
        await database.markSyncComplete(item.id);
      } catch (e) {
        await database.updateSyncError(item.id, e.toString());
      }
    }
  }
}
```

## Row-Level Security (RLS) in Supabase

All tables have policies enforcing user isolation:

```sql
-- Example: Users can only see their own transactions
create policy "Users can view own transactions"
  on public.transactions for select
  using (auth.uid() = user_id);
```

This means:
- Supabase automatically filters by logged-in user
- No service role key needed in Flutter app
- Data is inherently isolated

## Error Handling Strategy

```
Try Remote Operation
    ├─ Success: Return result
    ├─ Network Error:
    │   └─ Check local cache
    │   └─ Queue for retry
    └─ Auth Error:
        └─ Redirect to login
```

Example:
```dart
Future<List<Transaction>> getTransactions(String userId) async {
  try {
    return await remoteDataSource.getTransactions(userId);
  } on SocketException catch (e) {
    // Network error - return local cache
    return await localDataSource.getTransactions(userId);
  } on AuthException catch (e) {
    // Auth error - trigger re-login
    rethrow;
  } catch (e) {
    // Unknown error
    print('Error: $e');
    return [];
  }
}
```

## Dependency Injection

All dependencies injected through Riverpod:

```dart
// Define datasources
final supabaseClientProvider = Provider((ref) => Supabase.instance.client);

final transactionRemoteDataSourceProvider = Provider((ref) {
  final client = ref.watch(supabaseClientProvider);
  return TransactionRemoteDataSource(client);
});

// Define repositories
final transactionRepositoryProvider = Provider((ref) {
  final remote = ref.watch(transactionRemoteDataSourceProvider);
  final local = ref.watch(transactionLocalDataSourceProvider);
  return TransactionRepository(remote, local);
});

// Use in UI
final transactionsProvider = FutureProvider((ref) {
  final repo = ref.watch(transactionRepositoryProvider);
  return repo.getTransactions(userId);
});
```

## State Management Best Practices

### ✅ DO

```dart
// Use providers for dependencies
final repositoryProvider = Provider((ref) => SomeRepository());

// Use FutureProvider for async data
final dataProvider = FutureProvider((ref) => repo.getData());

// Use StateNotifier for complex state
final counterProvider = StateNotifierProvider(
  (ref) => CounterNotifier()
);

// Watch dependencies
final myData = ref.watch(dataProvider);
```

### ❌ DON'T

```dart
// Don't use global singletons
final repo = SomeRepository();  // BAD

// Don't mix UI and business logic
class MyScreen extends StatelessWidget {
  void onClick() {
    Supabase.instance.client.from('table').insert(...);  // BAD
  }
}

// Don't store Supabase client directly in widget
late final SupabaseClient client;  // BAD
```

## Authentication Flow with Riverpod

```dart
// Monitor auth state
final authStateProvider = StreamProvider((ref) {
  return ref.watch(authRemoteDataSourceProvider)
      .getAuthStateChanges();
});

// Redirect based on auth state
GoRouter createRouter() {
  return GoRouter(
    redirect: (context, state) {
      final authState = ref.watch(authStateProvider);
      
      return authState.when(
        loading: () => '/splash',
        data: (session) =>
          session == null ? '/login' : null,
        error: (err, stack) => '/login',
      );
    },
  );
}
```

## Testing Structure

```
test/
├── unit/
│   ├── models/
│   ├── services/
│   └── repositories/
├── widget/
│   ├── screens/
│   └── widgets/
└── integration/
    └── sync_flow_test.dart
```

Example Unit Test:
```dart
test('TransactionRepository creates transaction', () async {
  final mock = MockTransactionRemoteDataSource();
  final repo = TransactionRepository(mock, mockLocal);
  
  final result = await repo.createTransaction(...);
  
  expect(result.id, isNotEmpty);
  verify(mock.createTransaction(...)).called(1);
});
```

## Performance Considerations

1. **Pagination** - Load transactions in batches
2. **Caching** - Keep frequently used data in local DB
3. **Lazy Loading** - Load item details only when needed
4. **Debouncing** - Debounce search/filter operations
5. **Image Optimization** - Resize images before upload

## Security Considerations

1. **RLS Policies** - Always enable on production
2. **No Privileged Secrets in the App** - Use only a client-safe publishable key
3. **Input Validation** - Validate all user inputs
4. **HTTPS Only** - Supabase enforces TLS
5. **Token Management** - Supabase handles automatically

## Monitoring & Logging

```dart
// Configure logging
final logger = Logger();

// Log important operations
logger.i('User login: $userId');
logger.e('Sync failed', error: e, stackTrace: st);

// Monitor errors
Sentry.captureException(e, stackTrace: st);
```

This architecture ensures:
- ✅ Scalability
- ✅ Testability  
- ✅ Maintainability
- ✅ Offline capability
- ✅ Security
