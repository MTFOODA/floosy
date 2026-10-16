# Floosy Development Guide

## Getting Started with Development

### Prerequisites
- Flutter SDK 3.13+
- Dart 3.1+
- Android Studio / Xcode
- Supabase account
- VS Code or Android Studio

### Development Setup

```bash
# 1. Clone and setup
git clone https://github.com/MTFOODA/floosy.git
cd floosy
flutter pub get

# 2. Generate code
flutter pub run build_runner build --delete-conflicting-outputs

# 3. Configure Supabase in lib/config/supabase_config.dart
# Use only a client-safe publishable (anon) key.

# 4. Run app
flutter run
```

## Code Generation

Several packages require code generation:

```bash
# Generate all
flutter pub run build_runner build --delete-conflicting-outputs

# Watch for changes during development
flutter pub run build_runner watch

# Clean before rebuilding (if issues)
flutter pub run build_runner clean
flutter pub run build_runner build --delete-conflicting-outputs
```

**Packages needing generation:**
- `freezed` - Data models
- `json_serializable` - JSON serialization
- `drift` - Database queries
- `riverpod_generator` - Providers (if used)

## Project Structure by Feature

Each feature follows this structure:

```
feature_name/
├── data/
│   ├── datasources/
│   │   ├── remote_datasource.dart
│   │   └── local_datasource.dart
│   ├── models/
│   │   └── model.dart
│   └── repositories/
│       └── repository.dart
├── domain/
│   └── (optional - for additional business logic)
└── presentation/
    ├── screens/
    │   └── screen.dart
    ├── widgets/
    │   ├── custom_widget.dart
    │   └── builders/
    ├── providers/
    │   └── feature_providers.dart
    └── state/
        └── (if using StateNotifier)
```

### Feature Example: Transactions

```
features/transactions/
├── data/
│   ├── datasources/
│   │   ├── transaction_remote_datasource.dart
│   │   └── transaction_local_datasource.dart
│   ├── models/
│   │   └── transaction_model.dart
│   └── repositories/
│       └── transaction_repository.dart
└── presentation/
    ├── screens/
    │   ├── transactions_list_screen.dart
    │   ├── transaction_detail_screen.dart
    │   └── add_transaction_screen.dart
    ├── widgets/
    │   ├── transaction_card.dart
    │   ├── transaction_filter.dart
    │   └── builders/transaction_list_builder.dart
    └── providers/
        └── transaction_providers.dart
```

## Implementing a New Feature

### Step 1: Define the Model (Data Layer)

```dart
// lib/features/my_feature/data/models/my_model.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'my_model.freezed.dart';
part 'my_model.g.dart';

@freezed
class MyModel with _$MyModel {
  const factory MyModel({
    required String id,
    required String userId,
    required String name,
    DateTime? createdAt,
  }) = _MyModel;

  factory MyModel.fromJson(Map<String, dynamic> json) =>
      _$MyModelFromJson(json);
}
```

### Step 2: Create Data Sources

```dart
// lib/features/my_feature/data/datasources/my_remote_datasource.dart
class MyRemoteDataSource {
  final SupabaseClient client;
  
  MyRemoteDataSource(this.client);

  Future<MyModel> create(MyModel model) async {
    final response = await client
        .from('my_table')
        .insert(model.toJson())
        .select()
        .single();
    
    return MyModel.fromJson(response);
  }

  Future<List<MyModel>> getAll(String userId) async {
    final response = await client
        .from('my_table')
        .select()
        .eq('user_id', userId);
    
    return List<MyModel>.from(
      response.map((item) => MyModel.fromJson(item))
    );
  }
}
```

### Step 3: Create Repository

```dart
// lib/features/my_feature/data/repositories/my_repository.dart
class MyRepository {
  final MyRemoteDataSource remoteDataSource;
  final MyLocalDataSource localDataSource;

  MyRepository({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  Future<MyModel> create(MyModel model) async {
    try {
      // Save locally first (offline-first)
      await localDataSource.create(model);
      
      // Try to sync remotely
      final remote = await remoteDataSource.create(model);
      
      // Update local with remote data
      await localDataSource.update(remote);
      
      return remote;
    } on SocketException {
      // No internet - return local version
      return model;
    }
  }

  Future<List<MyModel>> getAll(String userId) async {
    try {
      // Try remote first
      final remote = await remoteDataSource.getAll(userId);
      
      // Update local cache
      await localDataSource.insertAll(remote);
      
      return remote;
    } on SocketException {
      // Fall back to local
      return localDataSource.getAll(userId);
    }
  }
}
```

### Step 4: Create Riverpod Providers

```dart
// lib/features/my_feature/presentation/providers/my_feature_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/my_repository.dart';
import '../../data/models/my_model.dart';

// Repository provider
final myRepositoryProvider = Provider((ref) {
  final remote = ref.watch(myRemoteDataSourceProvider);
  final local = ref.watch(myLocalDataSourceProvider);
  return MyRepository(remoteDataSource: remote, localDataSource: local);
});

// Data provider
final myDataProvider = FutureProvider.family<List<MyModel>, String>((ref, userId) async {
  final repo = ref.watch(myRepositoryProvider);
  return repo.getAll(userId);
});

// State provider for filtering
final myFilterProvider = StateProvider<String?>((ref) => null);

// Computed provider
final filteredMyDataProvider = Provider.family<List<MyModel>, String>((ref, userId) {
  final data = ref.watch(myDataProvider(userId));
  final filter = ref.watch(myFilterProvider);

  return data.when(
    data: (items) {
      if (filter == null) return items;
      return items.where((item) => item.name.contains(filter)).toList();
    },
    loading: () => [],
    error: (err, stack) => [],
  );
});
```

### Step 5: Create UI Screens

```dart
// lib/features/my_feature/presentation/screens/my_feature_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/my_feature_providers.dart';

class MyFeatureScreen extends ConsumerWidget {
  const MyFeatureScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get current user
    final user = ref.watch(currentUserProvider).value;
    if (user == null) return const SizedBox();

    // Watch data
    final dataAsync = ref.watch(myDataProvider(user.id));

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Feature'),
      ),
      body: dataAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (items) => items.isEmpty
            ? const Center(child: Text('No items'))
            : ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return MyItemCard(item: item);
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddDialog(BuildContext context) {
    // Show add dialog
  }
}
```

## Working with Drift (Local Database)

### Adding a New Table

```dart
// lib/data/local/database/tables/my_table.dart
import 'package:drift/drift.dart';

@DataClassName('MyTableData')
class MyTable extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get name => text()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
  
  @override
  List<Set<Column>> get uniqueKeys => [
    {userId, name}, // Unique constraint
  ];
}
```

### Update AppDatabase

```dart
// lib/data/local/database/app_database.dart
@DriftDatabase(tables: [
  Users,
  Transactions,
  MyTable, // Add here
])
class AppDatabase extends _$AppDatabase {
  // ... existing code ...
}
```

### Generate Drift code

```bash
flutter pub run build_runner build
```

### Use in DataSource

```dart
class MyLocalDataSource {
  final AppDatabase database;

  Future<void> create(MyModel model) async {
    await database.into(database.myTable).insert(
      MyTableData(
        id: model.id,
        userId: model.userId,
        name: model.name,
      ),
    );
  }

  Future<List<MyModel>> getAll(String userId) async {
    final data = await (database.select(database.myTable)
          ..where((t) => t.userId.equals(userId)))
        .get();
    
    return data.map((row) => MyModel(
      id: row.id,
      userId: row.userId,
      name: row.name,
      createdAt: row.createdAt,
    )).toList();
  }
}
```

## Common Patterns

### Handling Loading States

```dart
final myDataProvider = FutureProvider<List<MyModel>>((ref) async {
  return ref.watch(myRepositoryProvider).getAll(userId);
});

// In widget
myDataAsync.when(
  loading: () => const LoadingWidget(),
  error: (error, st) => ErrorWidget(error: error),
  data: (data) => DataWidget(data: data),
);
```

### Filtering Data

```dart
// State for filter
final filterProvider = StateProvider<String?>((ref) => null);

// Filtered data
final filteredProvider = Provider((ref) {
  final data = ref.watch(dataProvider);
  final filter = ref.watch(filterProvider);
  
  return data.map((items) {
    if (filter == null) return items;
    return items.where((item) => 
      item.name.contains(filter)
    ).toList();
  });
});
```

### Pagination

```dart
final pageProvider = StateProvider<int>((ref) => 0);

final paginatedDataProvider = FutureProvider<List<MyModel>>((ref) async {
  final page = ref.watch(pageProvider);
  final repo = ref.watch(myRepositoryProvider);
  
  return repo.getPage(page);
});
```

### Form Validation

```dart
final formProvider = StateNotifierProvider<FormNotifier, FormState>((ref) {
  return FormNotifier();
});

class FormNotifier extends StateNotifier<FormState> {
  FormNotifier() : super(FormState());
  
  void updateName(String value) {
    state = state.copyWith(
      name: value,
      nameError: value.isEmpty ? 'Name required' : null,
    );
  }
  
  bool isValid() => state.nameError == null;
}
```

## Debugging

### Enable Logging

```dart
import 'package:logger/logger.dart';

final logger = Logger();

// Use in repositories
logger.i('Creating transaction');
logger.e('Error:', error: e);
```

### Inspect Local Database

```dart
// Add to app_database.dart
@DriftDatabase(tables: [...])
class AppDatabase extends _$AppDatabase {
  // ... existing code ...
  
  @override
  int get schemaVersion => 1;
  
  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onUpgrade: (m, from, to) async {
        // Handle migrations
      },
    );
  }
}
```

### Debug Supabase Calls

```dart
// In main.dart
Supabase.initialize(
  url: url,
  anonKey: key,
  debug: true, // Enable debug logging
);
```

## Testing

### Unit Test Example

```dart
// test/features/my_feature/data/repositories/my_repository_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:floosy/features/my_feature/data/repositories/my_repository.dart';

void main() {
  group('MyRepository', () {
    late MockRemoteDataSource mockRemote;
    late MockLocalDataSource mockLocal;
    late MyRepository repository;

    setUp(() {
      mockRemote = MockRemoteDataSource();
      mockLocal = MockLocalDataSource();
      repository = MyRepository(
        remoteDataSource: mockRemote,
        localDataSource: mockLocal,
      );
    });

    test('getAll returns data from remote', () async {
      // Arrange
      const userId = 'user123';
      final expectedData = [MyModel(id: '1', userId: userId, name: 'Item 1')];
      when(mockRemote.getAll(userId))
          .thenAnswer((_) async => expectedData);

      // Act
      final result = await repository.getAll(userId);

      // Assert
      expect(result, equals(expectedData));
      verify(mockRemote.getAll(userId)).called(1);
    });
  });
}
```

### Widget Test Example

```dart
// test/features/my_feature/presentation/screens/my_screen_test.dart
void main() {
  group('MyFeatureScreen', () {
    testWidgets('displays loading state', (tester) async {
      await tester.pumpWidget(
        ProviderContainer(
          overrides: [
            myRepositoryProvider.overrideWithValue(mockRepo),
          ],
          child: MaterialApp(
            home: MyFeatureScreen(),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}
```

## Performance Tips

1. **Use `.select()` on providers** to rebuild only when relevant data changes:
```dart
final nameProvider = Provider((ref) => 
  ref.watch(userProvider.select((user) => user?.name))
);
```

2. **Paginate large lists** instead of loading everything at once

3. **Cache expensive computations** with Provider

4. **Use `const` constructors** everywhere possible

5. **Lazy load** screens and data

6. **Batch Supabase queries** with `select()`

7. **Debounce search/filter** operations

## Common Issues & Solutions

### Issue: Code generation not working
```bash
# Solution:
flutter pub run build_runner clean
flutter pub run build_runner build --delete-conflicting-outputs
```

### Issue: Supabase connection fails
- Check `.env` file has correct credentials
- Verify network connectivity
- Check Supabase project is running

### Issue: RLS prevents data access
- Ensure RLS policies are correctly configured
- Check user_id matches auth.uid()
- Verify you're using anon key, not service role key

### Issue: Offline data doesn't sync
- Check sync_queue table
- Verify network connectivity
- Check sync engine is running

## Next Steps for Development

1. **Complete remaining repositories** (Item, Expense, Category, etc.)
2. **Implement SMS parser** integration with UI
3. **Build sync engine** for offline-first
4. **Create feature screens** (Transactions, Pocket Cash, etc.)
5. **Add tests** for all features
6. **Polish UI** and animations
7. **Performance optimization**
8. **Documentation and deployment**

See [Implementation Roadmap](./implementation-roadmap.md) for detailed step-by-step guide.
