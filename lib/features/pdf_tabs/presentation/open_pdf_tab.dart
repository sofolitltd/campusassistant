import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/features/pdf_tabs/domain/pdf_tab.dart';
import '/features/pdf_tabs/presentation/providers/pdf_tabs_provider.dart';
import '/features/pdf_tabs/presentation/screens/pdf_tabs_page.dart';

/// Opens (or activates, if already open) a PDF as a tab and pushes the
/// shared [PdfTabsPage]. Every "open this resource's PDF" call site should
/// go through this instead of pushing PdfViewerPage directly, so all opened
/// PDFs land in the same tab strip.
///
/// Known v1 limitation: if a [PdfTabsPage] route is already on the stack,
/// this still pushes a new one (both read the same tab state, so they look
/// identical) rather than popping back to the existing instance — accepted
/// trade-off to avoid cross-navigator route lookups.
Future<void> openPdfTab(
  BuildContext context,
  WidgetRef ref, {
  required String resourceId,
  required String filePath,
  required String url,
  required String title,
  String? thumbnailUrl,
  String? courseCode,
  int? lessonNo,
}) async {
  ref
      .read(pdfTabsProvider.notifier)
      .openTab(
        PdfTab(
          resourceId: resourceId,
          filePath: filePath,
          url: url,
          title: title,
          thumbnailUrl: thumbnailUrl,
          courseCode: courseCode,
          lessonNo: lessonNo,
        ),
      );

  await Navigator.of(
    context,
    rootNavigator: true,
  ).push(MaterialPageRoute(builder: (_) => const PdfTabsPage()));
}
