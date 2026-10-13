import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/features/pdf_tabs/presentation/providers/pdf_tabs_provider.dart';
import '/widgets/pdf_viewer_page.dart';

/// Hosts a few open PDFs without losing each one's scroll position/zoom —
/// every open tab stays mounted (via [IndexedStack]) instead of being
/// rebuilt on switch. Switching/closing tabs happens through the on-demand
/// tab switcher sheet opened from [PdfViewerPage]'s tab-switch button, not a
/// persistent bottom bar — that way the PDF viewport keeps the full screen
/// height until the user actually asks to switch tabs.
class PdfTabsPage extends ConsumerWidget {
  const PdfTabsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Auto-close this screen once the last tab is closed from the switcher.
    ref.listen(pdfTabsProvider, (previous, next) {
      if (next.tabs.isEmpty && (previous?.tabs.isNotEmpty ?? false)) {
        Navigator.of(context).maybePop();
      }
    });

    final state = ref.watch(pdfTabsProvider);
    final tabs = state.tabs;

    if (tabs.isEmpty) {
      // Briefly true right before the ref.listen pop above completes.
      return const Scaffold(body: SizedBox.shrink());
    }

    var activeIndex = tabs.indexWhere((t) => t.url == state.activeUrl);
    if (activeIndex == -1) activeIndex = tabs.length - 1;

    return Scaffold(
      body: IndexedStack(
        index: activeIndex,
        children: [
          for (final tab in tabs)
            // Pauses the inactive tabs' tickers (scroll/zoom animations,
            // page-load spinners) so they aren't competing for frame budget
            // with the one the user is actually switching to — IndexedStack
            // keeps every tab's SfPdfViewer mounted for instant switching,
            // but there's no reason the ones off-screen should keep
            // animating in the background.
            TickerMode(
              enabled: tab.url == state.activeUrl,
              child: PdfViewerPage(
                key: ValueKey(tab.url),
                filePath: tab.filePath,
                url: tab.url,
                title: tab.title,
              ),
            ),
        ],
      ),
    );
  }
}
