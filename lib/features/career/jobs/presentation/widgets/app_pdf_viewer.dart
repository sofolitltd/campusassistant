import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdfx/pdfx.dart';

import '/core/theme/tokens/app_spacing.dart';

class AppPdfViewer extends StatefulWidget {
  final String url;
  const AppPdfViewer({super.key, required this.url});

  @override
  State<AppPdfViewer> createState() => _AppPdfViewerState();
}

class _AppPdfViewerState extends State<AppPdfViewer> {
  PdfControllerPinch? _pdfController;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    if (!kIsWeb) _loadPdf();
  }

  Future<void> _loadPdf() async {
    try {
      final file = await _getCachedPdfFile(widget.url);
      if (file != null) {
        _pdfController = PdfControllerPinch(
          document: PdfDocument.openFile(file.path),
        );
        if (mounted) setState(() => _isLoading = false);
      }
    } catch (e) {
      debugPrint('Error loading PDF: $e');
    }
  }

  Future<File?> _getCachedPdfFile(String url) async {
    final directory = await getApplicationDocumentsDirectory();
    final fileName = "${url.split('/').last.split('?').first}.pdf";
    final filePath = "${directory.path}/$fileName";
    final file = File(filePath);

    if (await file.exists()) return file;

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        await file.writeAsBytes(response.bodyBytes);
        return file;
      }
    } catch (e) {
      debugPrint("Error downloading PDF: $e");
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    if (kIsWeb) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(LucideIcons.fileText, size: 48, color: cs.outline),
            const SizedBox(height: Spacing.md),
            Text(
              'PDF viewing not supported on web',
              style: TextStyle(color: cs.onSurfaceVariant),
            ),
          ],
        ),
      );
    }
    if (_isLoading) return const Center(child: CircularProgressIndicator());
    if (_pdfController == null) {
      return Center(
        child: Text('Could not load PDF', style: TextStyle(color: cs.onSurface)),
      );
    }
    return PdfViewPinch(controller: _pdfController!);
  }

  @override
  void dispose() {
    _pdfController?.dispose();
    super.dispose();
  }
}