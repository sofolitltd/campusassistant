import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

final downloadCountProvider = FutureProvider.autoDispose<int>((ref) async {
  try {
    final directory = await getApplicationDocumentsDirectory();
    // Use listSync() to get all files in the directory
    final List<FileSystemEntity> allFiles = directory.listSync();

    // Filter for PDF files that match the resource download pattern
    final pdfFiles = allFiles.where((file) {
      if (file is! File || !file.path.toLowerCase().endsWith('.pdf')) return false;
      final name = file.path.split('/').last.replaceAll('.pdf', '');
      final parts = name.split('_');
      if (parts.length < 2) return false;
      final type = parts[parts.length - 2];
      return {'note', 'book', 'question', 'syllabus', 'research'}.contains(type);
    }).toList();

    return pdfFiles.length;
  } catch (e) {
    debugPrint('Error counting local files: $e');
    return 0;
  }
});
