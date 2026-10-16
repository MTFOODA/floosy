import 'package:drift/drift.dart';

// Conditional import: web stub vs real implementation.
import 'database_connection_web.dart'
    if (dart.library.io) 'database_connection_native.dart';

/// Opens a platform-appropriate Drift database connection.
LazyDatabase openDatabaseConnection() {
  return connectToDatabase();
}
