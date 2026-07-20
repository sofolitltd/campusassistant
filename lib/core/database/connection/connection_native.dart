import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Native (Android/iOS/desktop) drift connection — backed by a real sqlite3
/// file via FFI. Only ever imported on platforms where dart:ffi exists; see
/// connection_web.dart for the web counterpart.
QueryExecutor openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'campusassistant_offline.db'));
    return NativeDatabase.createInBackground(file);
  });
}
