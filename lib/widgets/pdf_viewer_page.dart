import 'dart:io';

import 'package:cupertino_ui/cupertino_ui.dart' show CupertinoActivityIndicator;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '/core/database/app_database.dart';
import '/core/network/api_endpoints.dart';
import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/core/theme/tokens/app_font_size.dart';
import '/core/widgets/header_gradient_backdrop.dart';
import '/features/pdf_tabs/presentation/providers/pdf_tabs_provider.dart';
import '/features/pdf_tabs/presentation/widgets/pdf_tab_switcher_sheet.dart';
import '/core/widgets/content_column.dart';
import 'pdf_viewer_actions_menu.dart';

/// Cache entity type used to remember the last page read per document (keyed
/// by [PdfViewerPage.url], which is stable across both the streamed-on-web
/// and downloaded-on-native cases). Kept alive far longer than the API-data
/// TTLs in [CacheTTL] since this is reading progress, not fetched data.
const _lastPageEntityType = 'pdf_last_page';
const _lastPageTtl = Duration(days: 365);

class PdfViewerPage extends ConsumerStatefulWidget {
  final String filePath;
  final String title;
  final String url;

  const PdfViewerPage({
    super.key,
    required this.filePath,
    required this.title,
    required this.url,
  });

  @override
  ConsumerState<PdfViewerPage> createState() => _PdfViewerPageState();
}

enum _LoadState { loading, loaded, failed }

class _PdfViewerPageState extends ConsumerState<PdfViewerPage> {
  GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  final PdfViewerController _pdfController = PdfViewerController();

  bool _showAppBar = true;
  bool _isLandscape = false;

  _LoadState _loadState = _LoadState.loading;
  String? _loadErrorMessage;

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    _pdfController.dispose();
    super.dispose();
  }

  void _toggleAppBar() {
    setState(() {
      _showAppBar = !_showAppBar;
    });
  }

  void _toggleOrientation() {
    setState(() {
      _isLandscape = !_isLandscape;
    });
    if (_isLandscape) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    } else {
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    }
  }

  Future<void> _onDocumentLoaded(PdfDocumentLoadedDetails details) async {
    setState(() {
      _loadState = _LoadState.loaded;
    });
    await _restoreLastReadPage();
  }

  void _onDocumentLoadFailed(PdfDocumentLoadFailedDetails details) {
    setState(() {
      _loadState = _LoadState.failed;
      _loadErrorMessage = details.description;
    });
  }

  void _onPageChanged(PdfPageChangedDetails details) {
    _saveLastReadPage(details.newPageNumber);
  }

  // Web has no Drift/sqlite3 connection (see app_database.dart), so reading
  // progress simply isn't persisted there.
  OfflineDatabase? get _db => kIsWeb ? null : ref.read(offlineDatabaseProvider);

  Future<void> _restoreLastReadPage() async {
    final db = _db;
    if (db == null || widget.url.isEmpty) return;
    final cached = await db.getCachedEntity(
      entityType: _lastPageEntityType,
      entityKey: widget.url,
    );
    final page = cached?['page'] as int?;
    if (page == null || page < 1 || page > _pdfController.pageCount) return;
    if (page == 1) return; // already there
    if (!mounted) return;
    _pdfController.jumpToPage(page);
  }

  void _saveLastReadPage(int page) {
    final db = _db;
    if (db == null || widget.url.isEmpty) return;
    db.cacheEntity(
      entityType: _lastPageEntityType,
      entityKey: widget.url,
      data: {'page': page},
      ttl: _lastPageTtl,
    );
  }

  @override
  Widget build(BuildContext context) {
    final tabCount = ref.watch(pdfTabsProvider.select((s) => s.tabs.length));

    // Capped here (not at the call sites) so the single viewer and every tab in
    // PdfTabsPage share one width.
    return ContentColumn(
      child: HeaderGradientBackdrop(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: _showAppBar
              ? AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  scrolledUnderElevation: 0,
                  centerTitle: false,
                  iconTheme: IconThemeData(color: context.colors.onPrimary),
                  title: Text(
                    widget.title,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontWeight: .bold,
                      color: context.colors.onPrimary,
                    ),
                  ),

                  actions: [
                    if (tabCount > 1)
                      IconButton(
                        icon: Badge(
                          label: Text('$tabCount'),
                          backgroundColor: context.colors.primary,
                          textColor: context.colors.onPrimary,
                          child: const Icon(LucideIcons.layers, size: 20),
                        ),
                        onPressed: () => showPdfTabSwitcherSheet(context),
                        tooltip: 'Open tabs',
                      ),
                    IconButton(
                      icon: Icon(
                        _isLandscape
                            ? LucideIcons.rotateCcwSquare
                            : LucideIcons.rotateCwSquare,
                        size: 20,
                      ),
                      onPressed: _toggleOrientation,
                      tooltip: _isLandscape ? 'Portrait' : 'Landscape',
                    ),
                    PdfViewerActionsMenu(
                      filePath: widget.filePath,
                      url: widget.url,
                      title: widget.title,
                    ),
                  ],
                )
              : null,
          body: Container(
            width: double.infinity,
            decoration: const BoxDecoration(borderRadius: _sheetRadius)
                .copyWith(color: Theme.of(context).scaffoldBackgroundColor),
            child: ClipRRect(
              borderRadius: _sheetRadius,
              child: SafeArea(
                top: !_showAppBar, // app bar already reserves the status bar
                bottom: false,
                child: Stack(
                  children: [
                    Offstage(
                      offstage: _loadState == _LoadState.failed,
                      child: kIsWeb
                          ? SfPdfViewer.network(
                              // Same proxy used for images — R2 has no CORS
                              // policy, so a direct cross-origin fetch of the
                              // PDF bytes fails on web even though it works
                              // fine natively (no CORS there).
                              ApiEndpoints.resolveImageUrl(widget.url),
                              key: _pdfViewerKey,
                              controller: _pdfController,
                              onTap: (details) => _toggleAppBar(),
                              onDocumentLoaded: _onDocumentLoaded,
                              onDocumentLoadFailed: _onDocumentLoadFailed,
                              onPageChanged: _onPageChanged,
                              canShowScrollHead: true,
                              canShowPaginationDialog: true,
                              pageSpacing: 4,
                            )
                          : SfPdfViewer.file(
                              File(widget.filePath),
                              key: _pdfViewerKey,
                              controller: _pdfController,
                              onTap: (details) => _toggleAppBar(),
                              onDocumentLoaded: _onDocumentLoaded,
                              onDocumentLoadFailed: _onDocumentLoadFailed,
                              onPageChanged: _onPageChanged,
                              canShowScrollHead: true,
                              canShowPaginationDialog: true,
                              pageSpacing: 4,
                            ),
                    ),
                    if (_loadState == _LoadState.loading)
                      const Center(
                        child: CupertinoActivityIndicator(radius: 14),
                      ),
                    if (_loadState == _LoadState.failed)
                      _buildErrorState(context),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(Spacing.lg),
        child: Column(
          mainAxisSize: .min,
          children: [
            Icon(
              LucideIcons.fileWarning,
              size: 40,
              color: context.colors.danger,
            ),
            const SizedBox(height: Spacing.md),
            Text(
              'Couldn\'t open this PDF',
              style: TextStyle(
                fontWeight: .bold,
                fontSize: FontSizeToken.lg,
                color: context.colors.text,
              ),
              textAlign: .center,
            ),
            if (_loadErrorMessage != null) ...[
              const SizedBox(height: Spacing.xs),
              Text(
                _loadErrorMessage!,
                style: TextStyle(
                  fontSize: FontSizeToken.sm,
                  color: context.colors.textMuted,
                ),
                textAlign: .center,
              ),
            ],
            const SizedBox(height: Spacing.lg),
            FilledButton.icon(
              onPressed: () => setState(() {
                _loadState = _LoadState.loading;
                _loadErrorMessage = null;
                // A fresh key forces SfPdfViewer to rebuild from scratch,
                // re-attempting the load (there is no reload() on its
                // controller/state).
                _pdfViewerKey = GlobalKey();
              }),
              icon: const Icon(LucideIcons.refreshCw, size: 16),
              label: const Text('Try again'),
            ),
          ],
        ),
      ),
    );
  }
}

const _sheetRadius = BorderRadius.vertical(
  top: Radius.circular(RadiusToken.xxxl),
);
