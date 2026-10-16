import 'dart:io' show File;

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

/// Native (Android, iOS, Windows, macOS, Linux) database connection.
/// Uses sqlite3 via FFI through Drift's NativeDatabase.
///
/// ANR FIX: [NativeDatabase.createInBackground] runs every SQL statement on
/// a background isolate. The previous `NativeDatabase(file)` executed all
/// SQLite work synchronously on the UI/main isolate, so the constant
/// database traffic (5-second SMS polling pipeline, screen loads, summary
/// providers, remote-merge writes) saturated the platform main thread and
/// froze the app (ANR) when entering heavy pages like Transactions.
/// The API, schema and query semantics are unchanged.
LazyDatabase connectToDatabase() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final db = NativeDatabase.createInBackground(
      File(p.join(dir.path, 'floosy.db')),
    );
    return db;
  });
}
