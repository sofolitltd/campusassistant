import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

final downloadCountProvider = FutureProvider.autoDispose<int>((ref) async {
  try {
    final directory = await getApplicationDocumentsDirectory();
    // Use listSync() to get all files in the directory
    final List<FileSystemEntity> allFiles = directory.listSync();

    // Filter for PDF files specifically to match your file view logic
    final pdfFiles = allFiles.where((file) {
      return file is File && file.path.toLowerCase().endsWith('.pdf');
    }).toList();

    return pdfFiles.length;
  } catch (e) {
    debugPrint('Error counting local files: $e');
    return 0;
  }
});
