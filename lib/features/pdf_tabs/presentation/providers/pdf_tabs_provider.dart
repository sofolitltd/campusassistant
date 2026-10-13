import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/features/pdf_tabs/domain/pdf_tab.dart';

/// Session-only (not persisted) state for the open-PDF tab strip. Resets on
/// app restart, same as closing all tabs in a browser between sessions.
class PdfTabsState {
  final List<PdfTab> tabs;
  final String? activeUrl;

  const PdfTabsState({this.tabs = const [], this.activeUrl});

  PdfTabsState copyWith({List<PdfTab>? tabs, String? activeUrl}) {
    return PdfTabsState(
      tabs: tabs ?? this.tabs,
      activeUrl: activeUrl ?? this.activeUrl,
    );
  }
}

/// Keeps at most [maxTabs] PDFs open at once — syncfusion_flutter_pdfviewer
/// is a heavyweight native renderer, so keeping unlimited tabs alive (as
/// IndexedStack does, to preserve scroll/zoom) risks real memory pressure on
/// low-end devices. Opening a 5th tab evicts the oldest non-active one; the
/// evicted resource's last-read page is still safe (PdfViewerPage persists
/// that separately via OfflineDatabase), so reopening it just re-renders.
class PdfTabsNotifier extends Notifier<PdfTabsState> {
  static const maxTabs = 4;

  @override
  PdfTabsState build() => const PdfTabsState();

  void openTab(PdfTab tab) {
    final existingIndex = state.tabs.indexWhere((t) => t.url == tab.url);
    if (existingIndex != -1) {
      state = state.copyWith(activeUrl: tab.url);
      return;
    }

    var tabs = [...state.tabs, tab];
    if (tabs.length > maxTabs) {
      final evictIndex = tabs.indexWhere((t) => t.url != state.activeUrl);
      tabs = [...tabs]..removeAt(evictIndex == -1 ? 0 : evictIndex);
    }
    state = PdfTabsState(tabs: tabs, activeUrl: tab.url);
  }

  void setActive(String url) {
    if (!state.tabs.any((t) => t.url == url)) return;
    state = state.copyWith(activeUrl: url);
  }

  void closeTab(String url) {
    final tabs = state.tabs.where((t) => t.url != url).toList();
    var activeUrl = state.activeUrl;
    if (activeUrl == url) {
      activeUrl = tabs.isNotEmpty ? tabs.last.url : null;
    }
    state = PdfTabsState(tabs: tabs, activeUrl: activeUrl);
  }
}

final pdfTabsProvider = NotifierProvider<PdfTabsNotifier, PdfTabsState>(
  PdfTabsNotifier.new,
);
