import 'package:drift/drift.dart';

/// Web has no drift connection — offlineDatabaseProvider already guards
/// against constructing OfflineDatabase on web, so this only exists to keep
/// the conditional import in app_database.dart resolvable. Must not import
/// drift/native.dart (or anything that pulls in sqlite3's FFI bindings) —
/// dart:ffi's `external` functions can't be compiled for web at all.
QueryExecutor openConnection() {
  throw UnsupportedError('Drift database not available on web');
}
