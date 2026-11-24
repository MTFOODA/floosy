import 'package:drift/drift.dart';

// Fail closed rather than storing financial data in plain IndexedDB.
LazyDatabase connectToDatabase() => LazyDatabase(() async {
  throw UnsupportedError(
    'The encrypted financial vault requires the native Floosy app.',
  );
});
