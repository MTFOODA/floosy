// ignore_for_file: deprecated_member_use
// The drift web variant is deprecated in favour of wasm, but is still
// functional and requires no extra web assets (sqlite3.wasm / drift_worker.js).
// Migrating to package:drift/wasm.dart will be tracked separately.
import 'package:drift/drift.dart';
import 'package:drift/web.dart';

/// Web database connection.
/// Uses Drift's WebDatabase backed by IndexedDB.
LazyDatabase connectToDatabase() {
  return LazyDatabase(() async {
    return WebDatabase('floosy_web_db');
  });
}
