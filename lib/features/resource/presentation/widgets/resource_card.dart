import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart' hide Share;

import 'package:uuid/uuid.dart';

import '/features/resource/domain/entities/resource.dart';
import '/features/pdf_tabs/presentation/open_pdf_tab.dart';
import '/core/ads/download_ad_gate.dart';
import '/core/ads/interstitial_ad_manager.dart';
import '/core/ads/rewarded_ad_manager.dart';
import '/core/providers/is_pro_provider.dart';
import '/core/providers/perks_provider.dart';
import '/features/reward/presentation/providers/reward_providers.dart';
import '/features/auth/presentation/providers/user_profile_provider.dart';
import '/core/cache/cache_manager.dart';
import '/core/network/api_endpoints.dart';
import '/core/providers/download_counter_provider.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/theme/app_colors.dart';
import '/features/bookmark/domain/entities/bookmark.dart';
import '/features/bookmark/presentation/providers/bookmark_provider.dart';
import '/features/resource/presentation/providers/downloads_provider.dart';
import '/features/resource/presentation/providers/resource_provider.dart';
import '/features/reward/presentation/widgets/coin_onboarding.dart';
import '/features/reward/presentation/widgets/reward_cost_indicator.dart';
import '/routes/app_route.dart';
import 'resource_info_sheet.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/core/theme/tokens/app_font_size.dart';
import '/core/theme/tokens/app_accents.dart';
import '/core/widgets/app_network_image.dart';
import '/core/network/download_client.dart';

/// Height of the card's top row (course badge / reward cost). The overflow
/// menu is centred on this row so the three line up.
const double _kTopRowHeight = 18;

/// The thumbnail's height. The text column beside it is sized to its own
/// content (not pinned to this), and the row that holds both bottom-aligns
/// them (see `crossAxisAlignment: .end` in build()) so the info-tile/
/// bookmark/download row always sits flush with the thumbnail's bottom
/// edge, whether the title wraps to one line or two.
const double _kContentHeight = 100;
const double _kMenuTapSize = 40;

class ResourceCard extends ConsumerStatefulWidget {
  final Resource resource;

  /// When true, this card automatically opens its content (downloading it
  /// first if needed) as soon as its local-file status is known — used to
  /// deep-link straight to a resource from a "new resource" notification.
  final bool autoOpen;

  const ResourceCard({
    super.key,
    required this.resource,
    this.autoOpen = false,
  });

  @override
  ConsumerState<ResourceCard> createState() => _ResourceCardState();
}

class _ResourceCardState extends ConsumerState<ResourceCard> {
  bool _isLoading = false;
  bool _isPaused = false;
  double _downloadProgress = 0;
  bool _isDownloaded = false;
  // Coins/Pro access already granted for this file in the current session.
  // A download that fails *after* the spend must not re-charge the user on
  // their next tap — the gate re-runs otherwise and spends coins again.
  bool _accessGranted = false;
  bool _isBookmarked = false;
  String? _bookmarkId;
  String? _savedBookmarkId;
  String _localPath = '';
  CancelToken? _cancelToken;

  @override
  void initState() {
    super.initState();
    if (!ref.read(isAdFreeProvider)) {
      ref.read(interstitialAdManagerProvider).preload();
    }
    final statusChecked = _checkFileStatus();
    if (widget.autoOpen) {
      statusChecked.then((_) {
        if (mounted) _handleDownloadTap();
      });
    }
  }

  Future<void> _checkFileStatus() async {
    // No local filesystem on web — path_provider has no web implementation.
    // "Downloaded" isn't a meaningful state there; content just streams.
    if (kIsWeb) return;
    final fileName = _getFileName();
    final directory = await getApplicationDocumentsDirectory();
    _localPath = '${directory.path}/$fileName';
    if (File(_localPath).existsSync()) {
      if (mounted) {
        setState(() {
          _isDownloaded = true;
        });
      }
    }
  }

  String _getFileName() {
    final sanitizedTitle = widget.resource.title.replaceAll(
      RegExp('[^A-Za-z0-9]', dotAll: true),
      ' ',
    );
    final shortId = widget.resource.id.length > 5
        ? widget.resource.id.substring(0, 5)
        : widget.resource.id;
    return '${widget.resource.courseCode}-${widget.resource.lessonNo} ${sanitizedTitle}_${widget.resource.type}_$shortId.pdf';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    List<String> contentBatches = List<String>.from(widget.resource.batches);
    contentBatches.sort((a, b) => b.compareTo(a));

    final isCoinFree = ref.watch(isCoinFreeProvider);
    final isProContent = widget.resource.accessLevel == 'pro';

    // Select only the uid: the rest of the profile changing shouldn't
    // rebuild every card on screen.
    final userId = ref.watch(
      userProvider.select((profile) => profile.value?.uid ?? ''),
    );
    final savedBookmarkId = userId.isEmpty
        ? null
        : ref.watch(
            resourceBookmarkIdsProvider(userId)
                .select((ids) => ids[widget.resource.id]),
          );
    // Adopt the server's answer when it changes; between changes the local
    // fields hold the optimistic result of a toggle.
    if (savedBookmarkId != _savedBookmarkId) {
      _savedBookmarkId = savedBookmarkId;
      _bookmarkId = savedBookmarkId;
      _isBookmarked = savedBookmarkId != null;
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(RadiusToken.md + 2),
        color: theme.cardColor,
        border: Border.all(color: context.colors.border),
        boxShadow: [
          BoxShadow(
            color: context.colors.shadow,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(RadiusToken.md + 2),
            onTap: _handleDownloadTap,
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(Spacing.md),
                  child: Row(
                    // Bottom-aligns the details column with the thumbnail
                    // instead of top-aligning them, so the info-tile/
                    // bookmark/download row always sits flush with the
                    // thumbnail's bottom edge — whether the title wraps to
                    // one line or two.
                    crossAxisAlignment: .end,
                    children: [
                      //
                      GestureDetector(
                        onTap: _showInfoBottomSheet,
                        child: _buildThumbnail(
                          isProContent,
                          showRewardCost: !isCoinFree,
                        ),
                      ),
                      const SizedBox(width: Spacing.md),
                      _buildDetails(
                        context,
                        isProContent,
                        showRewardCost: !isCoinFree,
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: Spacing.md + (_kTopRowHeight - _kMenuTapSize) / 2,
                  right: 0,
                  child: _buildPopupMenu(),
                ),
                // bottom: Spacing.md is reliable now (not a guess): the
                // content Row above is bottom-aligned via
                // crossAxisAlignment: .end, so its bottom edge always sits
                // exactly Spacing.md above the card edge — same inset as
                // the Padding.all(Spacing.md) wrapping it — regardless of
                // whether the title wraps to one line or two.
                if (_isLoading || _isPaused)
                  Positioned(
                    bottom: 4,
                    right: 12,
                    child: _buildDownloadStatusAction(),
                  )
                else
                  Positioned(
                    bottom: 0,
                    right: 12,

                    child: Row(
                      mainAxisSize: .min,
                      children: [
                        _buildBookmark(),
                        const SizedBox(width: Spacing.xxs),
                        _buildDownloadStatusAction(),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThumbnail(bool isProContent, {required bool showRewardCost}) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Stack(
      alignment: Alignment.topLeft,
      children: [
        Container(
          width: 88,
          height: _kContentHeight,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(RadiusToken.xs),
            color: isDark
                ? theme.colorScheme.surface.withValues(alpha: 0.5)
                : AccentToken.blue.withValues(alpha: 0.1),
          ),
          foregroundDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(RadiusToken.xs),
            border: Border.all(color: context.colors.borderStrong, width: 1),
          ),
          clipBehavior: .antiAlias,
          child: widget.resource.thumbnailUrl.isEmpty
              ? Icon(
                  LucideIcons.fileText,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                  size: 30,
                )
              : AppNetworkImage(
                  ApiEndpoints.resolveImageUrl(widget.resource.thumbnailUrl),
                  fit: .cover,
                  placeholder: (context) => Icon(
                    LucideIcons.fileText,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                    size: 30,
                  ),
                  errorBuilder: (context, _, _) => Icon(
                    LucideIcons.fileText,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                    size: 30,
                  ),
                ),
        ),
        if (!showRewardCost)
          Positioned(
            left: 4,
            bottom: 4,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: Spacing.sm,
                vertical: Spacing.xxs,
              ),
              decoration: BoxDecoration(
                color: context.colors.success,
                borderRadius: BorderRadius.circular(RadiusToken.full),
              ),
              child: Row(
                mainAxisSize: .min,
                children: [
                  Icon(
                    LucideIcons.checkCheck,
                    size: 10,
                    color: context.colors.onPrimary,
                  ),
                  const SizedBox(width: Spacing.xxs),
                  Text(
                    'FREE',
                    style: TextStyle(
                      fontSize: FontSizeToken.xxs,
                      fontWeight: .bold,
                      color: context.colors.onPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        if (isProContent)
          Positioned(
            top: 4,
            left: 4,
            child: Container(
              padding: const EdgeInsets.all(2.5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(RadiusToken.xs),
                color: context.colors.warning.withValues(alpha: .8),
              ),
              child: Icon(
                LucideIcons.crown,
                color: context.colors.onPrimary,
                size: 15,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildDetails(
    BuildContext context,
    bool isProContent, {
    required bool showRewardCost,
  }) {
    return Expanded(
      child: SizedBox(
        height: _kContentHeight,
        child: Column(
          mainAxisAlignment: .start,
          crossAxisAlignment: .start,
          children: [
            SizedBox(
              height: _kTopRowHeight,
              child: Row(
                crossAxisAlignment: .stretch,
                children: [
                  // Department-wide resources (e.g. a full syllabus) have no
                  // course, so there's nothing to show here.
                  if (widget.resource.courseCode.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Spacing.xs,
                      ),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        // Same fill as the file-size / page tiles below.
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Theme.of(context).colorScheme.surface
                                  .withValues(alpha: 0.5)
                            : context.colors.surfaceAlt,
                        borderRadius: BorderRadius.circular(RadiusToken.xs),
                        border: Border.all(color: context.colors.surfaceAlt),
                      ),
                      child: Text(
                        '${widget.resource.courseCode.toUpperCase()}: ${widget.resource.lessonNo}',
                        style: TextStyle(
                          height: 1,
                          fontSize: FontSizeToken.xxs,
                          fontWeight: .bold,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ),
                  if (isProContent) ...[
                    const SizedBox(width: Spacing.xs),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Spacing.sm,
                      ),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: context.colors.warning.withValues(alpha: .15),
                        borderRadius: BorderRadius.circular(RadiusToken.xs),
                      ),
                      child: Row(
                        mainAxisSize: .min,
                        children: [
                          Icon(
                            LucideIcons.crown,
                            size: 10,
                            color: context.colors.warning,
                          ),
                          const SizedBox(width: Spacing.xxs),
                          Text(
                            'PRO',
                            style: TextStyle(
                              height: 1,
                              fontSize: FontSizeToken.xxs,
                              fontWeight: .bold,
                              color: context.colors.warning,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  if (showRewardCost) ...[
                    const SizedBox(width: Spacing.xs),
                    RewardCostIndicator(
                      resourceId: widget.resource.id,
                      fileSizeBytes: widget.resource.fileSizeBytes,
                      compact: true,
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: Spacing.xs),
            Text(
              widget.resource.title,
              maxLines: 2,
              overflow: .ellipsis,
              style: Theme.of(context).textTheme.bodyMedium
                  ?.copyWith(fontWeight: .bold, height: 1.2),
            ),
            const SizedBox(height: Spacing.xs),
            Text(
              widget.resource.description,
              maxLines: 1,
              overflow: .ellipsis,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                fontWeight: .w500,
                color: Theme.of(context).brightness == Brightness.dark
                    ? context.colors.textMuted
                    : context.colors.textMuted,
                height: 1,
              ),
            ),
            const SizedBox(height: Spacing.sm),

            Spacer(),
            Row(
              children: [
                _buildMiniInfoTile(
                  context,
                  LucideIcons.hardDrive,
                  _getFileSizeStr(widget.resource.fileSizeBytes),
                ),
                const SizedBox(width: Spacing.sm),
                _buildMiniInfoTile(
                  context,
                  LucideIcons.layers,
                  '${widget.resource.pageCount} Page',
                ),

                //
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPopupMenu() {
    final theme = Theme.of(context);
    return PopupMenuButton<String>(
      padding: EdgeInsets.zero,
      color: theme.cardColor,
      tooltip: 'More options',
      child: const SizedBox(
        width: _kMenuTapSize,
        height: _kMenuTapSize,
        child: Center(child: Icon(LucideIcons.ellipsisVertical, size: 18)),
      ),
      onSelected: (value) async {
        switch (value) {
          case 'download':
            await _handleDownloadTap();
          case 'cancel':
            _handleCancelDownload();
          case 'save':
            await _saveToPublicDownloads();
          case 'share':
            await _handleShare();
          case 'open_with':
            await _handleOpenWith();
          case 'delete_local':
            await _handleDeleteLocally();
          case 'info':
            _showInfoBottomSheet();
        }
      },
      itemBuilder: (context) => [
        if (!_isDownloaded && !_isLoading)
          PopupMenuItem(
            height: 34,
            value: 'download',
            child: _PopupItem(
              icon: kIsWeb ? LucideIcons.eye : LucideIcons.download,
              text: kIsWeb ? 'View' : 'Download',
            ),
          ),
        if (_isLoading || _isPaused)
          PopupMenuItem(
            height: 34,
            value: 'cancel',
            child: _PopupItem(
              icon: LucideIcons.circleX,
              text: 'Cancel Download',
              errorColor: theme.appColors.danger,
            ),
          ),
        if (_isDownloaded)
          const PopupMenuItem(
            height: 34,
            value: 'save',
            child: _PopupItem(
              icon: LucideIcons.cloudDownload,
              text: 'Save to Downloads',
            ),
          ),
        const PopupMenuItem(
          height: 34,
          value: 'share',
          child: _PopupItem(icon: LucideIcons.share2, text: 'Share'),
        ),
        if (!kIsWeb)
          const PopupMenuItem(
            height: 34,
            value: 'open_with',
            child: _PopupItem(
              icon: LucideIcons.externalLink,
              text: 'Open with',
            ),
          ),
        if (_isDownloaded)
          PopupMenuItem(
            height: 34,
            value: 'delete_local',
            child: _PopupItem(
              icon: LucideIcons.trash2,
              text: 'Delete Locally',
              errorColor: theme.appColors.danger,
            ),
          ),
        const PopupMenuItem(
          height: 34,
          value: 'info',
          child: _PopupItem(icon: LucideIcons.info, text: 'Info'),
        ),
      ],
    );
  }

  Widget _buildDownloadStatusAction() {
    final theme = Theme.of(context);
    if (_isLoading || _isPaused) {
      return Container(
        padding: const EdgeInsets.only(right: Spacing.md),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(RadiusToken.md),
          border: Border.all(color: context.colors.surfaceAlt),
          boxShadow: [BoxShadow(color: context.colors.shadow, blurRadius: 8)],
        ),
        child: Row(
          mainAxisSize: .min,
          children: [
            IconButton(
              icon: Icon(
                LucideIcons.circleX,
                size: 18,
                color: theme.appColors.danger,
              ),
              onPressed: _handleCancelDownload,
            ),
            IconButton(
              icon: Icon(
                _isPaused ? LucideIcons.play : LucideIcons.pause,
                size: 18,
                color: theme.appColors.primary,
              ),
              onPressed: () => _isPaused ? _resumeDownload() : _pauseDownload(),
            ),
            _buildCircularProgress(),
          ],
        ),
      );
    }
    if (_isDownloaded) {
      return Icon(
        LucideIcons.circleCheck,
        color: context.colors.success,
        size: 20,
      );
    }
    return GestureDetector(
      onTap: _handleDownloadTap,
      child: Icon(
        LucideIcons.circleArrowDown,
        color: theme.colorScheme.primary,
        size: 20,
      ),
    );
  }

  Widget _buildCircularProgress() {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          height: 24,
          width: 24,
          child: CircularProgressIndicator(
            value: _downloadProgress,
            strokeWidth: 3,
            backgroundColor: Theme.of(context).colorScheme.surface
                .withValues(alpha: 0.5),
          ),
        ),
        Text(
          '${(_downloadProgress * 100).toInt()}%',
          style: const TextStyle(fontSize: 8, fontWeight: .bold),
        ),
      ],
    );
  }

  Widget _buildBookmark() {
    final theme = Theme.of(context);
    return IconButton(
      constraints: const BoxConstraints(minWidth: 22, minHeight: 22),
      padding: EdgeInsets.zero,
      onPressed: _handleBookmarkToggle,
      icon: Icon(
        _isBookmarked ? LucideIcons.bookmarkCheck : LucideIcons.bookmark,
        color: _isBookmarked
            ? context.colors.primary
            : theme.colorScheme.onSurface.withValues(alpha: 0.4),
        size: 20,
      ),
    );
  }

  Widget _buildMiniInfoTile(BuildContext context, IconData icon, String value) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.sm,
        vertical: Spacing.xxs,
      ),
      decoration: BoxDecoration(
        color: isDark
            ? theme.colorScheme.surface.withValues(alpha: 0.5)
            : context.colors.surfaceAlt,
        borderRadius: BorderRadius.circular(RadiusToken.xs),
        border: Border.all(color: context.colors.surfaceAlt),
      ),
      child: Row(
        mainAxisSize: .min,
        children: [
          Icon(icon, size: 10, color: context.colors.textMuted),
          const SizedBox(width: Spacing.xs),
          Text(
            value,
            style: TextStyle(
              fontSize: FontSizeToken.xxs,
              color: theme.colorScheme.onSurface,
              fontWeight: .bold,
            ),
          ),
        ],
      ),
    );
  }

  String _getFileSizeStr(int bytes) {
    if (bytes <= 0) return '0.0 MB';
    if (bytes > 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    if (bytes > 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '$bytes B';
  }

  void _showInfoBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(RadiusToken.xl),
        ),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.8,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => ResourceInfoSheet(
          resource: widget.resource,
          scrollController: scrollController,
          isDownloaded: _isDownloaded,
          onDownload: () => _handleDownloadTap(),
          onSaveToDownloads: () => _saveToPublicDownloads(),
          onShare: () => _handleShare(),
          onDeleteLocally: () => _handleDeleteLocally(),
          isBookmarked: _isBookmarked,
          onBookmarkToggle: _handleBookmarkToggle,
        ),
      ),
    );
  }

  void _showProDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pro Feature'),
        content: const Text(
          'This content is for Pro subscribers only. Upgrade to Pro for unlimited access to all resources.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              context.push(AppRoute.subscription.path);
            },
            child: const Text('Go Pro'),
          ),
        ],
      ),
    );
  }

  /// Single gate-check for every "open/download this resource" tap target
  /// (card body, download icon, popup menu, info sheet, open-with) so they
  /// all apply the same Pro → direct, non-Pro+coins → direct, non-Pro+no-coins
  /// → unlock-dialog logic instead of diverging into separate gates. Does
  /// NOT download or open anything itself — only decides access.
  Future<bool> _canAccessResource() async {
    if (_isDownloaded || _accessGranted) return true;

    final isProUser = ref.read(isProUserProvider);
    if (isProUser) {
      _accessGranted = true;
      return true;
    }

    final isProContent = widget.resource.accessLevel == 'pro';
    if (isProContent) {
      _showProDialog(context);
      return false;
    }

    final granted = await _checkRewardGate();
    if (granted) _accessGranted = true;
    return granted;
  }

  Future<void> _handleDownloadTap() async {
    final canAccess = await _canAccessResource();
    if (canAccess) {
      // Coins (or Pro) already granted access above — skip the separate ad
      // gate inside _downloadIfNeeded, otherwise a user who just paid with
      // coins gets shown the ad prompt too.
      await _handleOpenContent(gateAlreadyChecked: true);
    }
  }

  Future<bool> _checkRewardGate() async {
    // Pro or a coin-free access grant: nothing to spend (the API agrees and
    // returns free for these users too).
    if (ref.read(isCoinFreeProvider)) return true;

    final result = await ref
        .read(rewardRepositoryProvider)
        .spend(widget.resource.id);
    final r = result.fold((_) => null, (r) => r);
    // Backend unreachable — don't trap a student behind a flaky network.
    if (r == null) return true;

    if (r['insufficient'] != true) {
      final granted = r['spent'] != null || r['is_pro'] == true;
      if (granted && r['is_pro'] != true) {
        ref.invalidate(rewardBalanceProvider);
        if (mounted) {
          showCoinSpentFeedback(
            context,
            spent: r['spent'] as int? ?? 0,
            balance: r['balance'] as int? ?? 0,
          );
        }
      }
      return granted;
    }

    if (!mounted) return false;
    // Ad-free grant without coin-free: no ad to fall back on, so running out
    // of coins just means downloading free.
    if (ref.read(isAdFreeProvider)) return true;
    return _showOutOfCoinsDialog(
      cost: r['required'] as int? ?? 1,
      balance: r['balance'] as int? ?? 0,
    );
  }

  /// Out of coins: the default path downloads after a skippable
  /// interstitial; watching a rewarded video instead also earns coins. The
  /// coins are a bonus for next time, not spent on this file — a user who
  /// sat through a full video shouldn't see them vanish immediately.
  /// Returns true when the download should proceed (any ad already shown).
  Future<bool> _showOutOfCoinsDialog({
    required int cost,
    required int balance,
  }) async {
    final rewardedManager = ref.read(rewardedAdManagerProvider);
    // google_mobile_ads has no web implementation — web only offers Pro.
    if (!kIsWeb) rewardedManager.preload();

    final choice = await showDialog<_UnlockChoice>(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(RadiusToken.xxl),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            Spacing.xl,
            Spacing.xxl,
            Spacing.xl,
            Spacing.lg,
          ),
          child: Column(
            mainAxisSize: .min,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AccentToken.gold.withValues(alpha: .15),
                ),
                child: Icon(
                  LucideIcons.coins,
                  size: 26,
                  color: AccentToken.gold,
                ),
              ),
              const SizedBox(height: Spacing.lg),
              Text(
                'Out of coins',
                style: Theme.of(context).textTheme.titleLarge
                    ?.copyWith(fontWeight: .bold),
              ),
              const SizedBox(height: Spacing.xs),
              Text(
                '"${widget.resource.title}"',
                textAlign: .center,
                maxLines: 2,
                overflow: .ellipsis,
                style: Theme.of(context).textTheme.bodyMedium
                    ?.copyWith(color: context.colors.textMuted),
              ),
              const SizedBox(height: Spacing.lg),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: Spacing.lg,
                  vertical: Spacing.md,
                ),
                decoration: BoxDecoration(
                  color: context.colors.surfaceAlt,
                  borderRadius: BorderRadius.circular(RadiusToken.lg),
                ),
                child: Row(
                  mainAxisAlignment: .spaceEvenly,
                  children: [
                    _buildCoinStat(context, label: 'Cost', value: cost),
                    Container(
                      width: 1,
                      height: 32,
                      color: context.colors.border,
                    ),
                    _buildCoinStat(
                      context,
                      label: 'You have',
                      value: balance,
                      color: context.colors.danger,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: Spacing.md),
              Text(
                kIsWeb
                    ? 'Downloads without coins need the mobile app. Go Pro for unlimited downloads.'
                    : 'Download now with a short ad, or watch a video to also earn 1 coin.',
                textAlign: .center,
                style: Theme.of(context).textTheme.bodySmall
                    ?.copyWith(color: context.colors.textMuted),
              ),
              const SizedBox(height: Spacing.xl),
              if (!kIsWeb) ...[
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: Spacing.md),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(RadiusToken.lg),
                      ),
                    ),
                    onPressed: () =>
                        Navigator.of(ctx).pop(_UnlockChoice.download),
                    icon: const Icon(LucideIcons.download, size: 18),
                    label: const Text('Download'),
                  ),
                ),
                const SizedBox(height: Spacing.sm),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: Spacing.md),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(RadiusToken.lg),
                      ),
                    ),
                    onPressed: () =>
                        Navigator.of(ctx).pop(_UnlockChoice.watchVideo),
                    icon: const Icon(LucideIcons.circlePlay, size: 18),
                    label: const Text('Watch video • +1 coin'),
                  ),
                ),
                const SizedBox(height: Spacing.xs),
              ],
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.of(ctx).pop(),
                      child: Text(
                        'Not now',
                        style: TextStyle(color: context.colors.textMuted),
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextButton.icon(
                      onPressed: () => Navigator.of(ctx).pop(_UnlockChoice.pro),
                      icon: Icon(
                        LucideIcons.crown,
                        size: 16,
                        color: AccentToken.gold,
                      ),
                      label: Text(
                        'Go Pro',
                        style: TextStyle(color: AccentToken.gold),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    if (!mounted) return false;
    switch (choice) {
      case _UnlockChoice.download:
        await showDownloadInterstitial(ref);
        return true;
      case _UnlockChoice.watchVideo:
        final watched = await rewardedManager.show();
        if (watched) {
          await _claimVideoReward();
        } else {
          // No video available (common on Bangladeshi fill rates) or closed
          // early — fall back to the normal download path.
          await showDownloadInterstitial(ref);
        }
        return true;
      case _UnlockChoice.pro:
        context.push(AppRoute.subscription.path);
        return false;
      case null:
        return false;
    }
  }

  Future<void> _claimVideoReward() async {
    final result = await ref.read(rewardRepositoryProvider).earn();
    if (!mounted) return;
    result.fold(
      // Daily video-reward limit reached — the download still goes ahead.
      (_) {},
      (balance) {
        ref.invalidate(rewardBalanceProvider);
        Fluttertoast.showToast(
          msg: '+1 coin! You now have ${balance.balance}.',
        );
      },
    );
  }

  Widget _buildCoinStat(
    BuildContext context, {
    required String label,
    required int value,
    Color? color,
  }) {
    final statColor = color ?? context.colors.text;
    return Column(
      mainAxisSize: .min,
      children: [
        Row(
          mainAxisSize: .min,
          children: [
            Icon(LucideIcons.coins, size: 14, color: statColor),
            const SizedBox(width: Spacing.xxs),
            Text(
              '$value',
              style: TextStyle(
                fontWeight: .bold,
                fontSize: FontSizeToken.lg,
                color: statColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: Spacing.xxs),
        Text(
          label,
          style: TextStyle(
            fontSize: FontSizeToken.xxs,
            color: context.colors.textMuted,
          ),
        ),
      ],
    );
  }

  Future<void> _handleOpenContent({bool gateAlreadyChecked = false}) async {
    // Web streams the PDF straight from the URL (see PdfViewerPage) — no
    // local download step needed or possible.
    if (kIsWeb) {
      if (mounted) {
        ref.read(resourceRepositoryProvider).recordView(widget.resource.id);
        await openPdfTab(
          context,
          ref,
          resourceId: widget.resource.id,
          filePath: '',
          url: widget.resource.fileUrl,
          title: widget.resource.title,
          thumbnailUrl: widget.resource.thumbnailUrl,
          courseCode: widget.resource.courseCode,
          lessonNo: widget.resource.lessonNo,
        );
      }
      return;
    }

    if (!_isDownloaded) {
      await _downloadIfNeeded(gateAlreadyChecked: gateAlreadyChecked);
    }
    if (_isDownloaded && _localPath.isNotEmpty) {
      if (mounted) {
        ref.read(resourceRepositoryProvider).recordView(widget.resource.id);
        await openPdfTab(
          context,
          ref,
          resourceId: widget.resource.id,
          filePath: _localPath,
          url: widget.resource.fileUrl,
          title: widget.resource.title,
          thumbnailUrl: widget.resource.thumbnailUrl,
          courseCode: widget.resource.courseCode,
          lessonNo: widget.resource.lessonNo,
        );
      }
    }
  }

  Future<void> _downloadIfNeeded({bool gateAlreadyChecked = false}) async {
    // No local filesystem on web — nothing to download to, and the ad gate
    // below relies on google_mobile_ads, which has no web implementation.
    if (kIsWeb) return;
    if (_isDownloaded || _isLoading) return;

    // If coins, Pro, or the out-of-coins dialog already handled access (and
    // any ad), don't show another interstitial on top of it.
    if (!gateAlreadyChecked) await showDownloadInterstitial(ref);
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _isPaused = false;
    });
    _cancelToken = CancelToken();
    final success = await _downloadFile(widget.resource.fileUrl, _localPath);
    if (mounted) {
      setState(() {
        _isLoading = false;
        _isDownloaded = success;
      });
    }
  }

  Future<bool> _downloadFile(String url, String path) async {
    try {
      await _fetchToFile(url, path);
    } catch (e) {
      log('Download error: $e');
      // Devices on networks that can't reach R2's pub-*.r2.dev links (ISP /
      // DNS filtering) fail instantly while the API server itself stays
      // reachable — stream the same object through the backend's already
      // existing, storage-host-whitelisted /proxy route as a fallback.
      if (url.contains('r2.dev')) {
        _cancelToken = CancelToken();
        try {
          await _fetchToFile(
            '${ApiEndpoints.baseUrl}/proxy?url=${Uri.encodeComponent(url)}',
            path,
          );
        } catch (proxyErr) {
          log('Proxy download error: $proxyErr');
          if (mounted) {
            _showDownloadFailedToast();
          }
          return false;
        }
      } else {
        if (mounted) {
          _showDownloadFailedToast();
        }
        return false;
      }
    }
    // Cache metadata for the downloads page
    if (mounted) {
      final cacheManager = ref.read(cacheManagerProvider);
      await cacheDownloadedResourceMetadata(
        cacheManager: cacheManager,
        resource: widget.resource,
      );
      ref.read(resourceRepositoryProvider).recordDownload(widget.resource.id);
      // The downloads page and the study page's badge both list files on
      // disk, so refresh them now the new file is there.
      ref.invalidate(downloadedFilesProvider);
      ref.invalidate(downloadCountProvider);
    }
    return true;
  }

  /// Never fail silently — a user who just paid coins for this file deserves
  /// to know the download (not the payment) failed.
  void _showDownloadFailedToast() {
    Fluttertoast.showToast(
      msg: 'Download failed. Tap the download icon to try again.',
      gravity: ToastGravity.BOTTOM,
    );
  }

  Future<void> _fetchToFile(String target, String path) async {
    await downloadClient.download(
      target,
      path,
      cancelToken: _cancelToken,
      onReceiveProgress: (count, total) {
        if (total != -1 && mounted) {
          setState(() {
            _downloadProgress = count / total;
          });
        }
      },
    );
  }

  void _pauseDownload() {
    _cancelToken?.cancel("pause");
    if (mounted) {
      setState(() {
        _isPaused = true;
        _isLoading = false;
      });
    }
  }

  Future<void> _resumeDownload() async {
    if (mounted) {
      setState(() {
        _isPaused = false;
        _isLoading = true;
      });
    }
    _cancelToken = CancelToken();
    final success = await _downloadFile(widget.resource.fileUrl, _localPath);
    if (mounted) {
      setState(() {
        _isLoading = false;
        _isDownloaded = success;
      });
    }
  }

  void _handleCancelDownload() {
    _cancelToken?.cancel("cancel");
    if (mounted) {
      setState(() {
        _isLoading = false;
        _isPaused = false;
        _downloadProgress = 0;
      });
    }
  }

  Future<void> _handleShare() async {
    // No local file to attach on web — share the link instead.
    if (kIsWeb) {
      await SharePlus.instance.share(
        ShareParams(
          text: '${widget.resource.title}\n${widget.resource.fileUrl}',
        ),
      );
      return;
    }

    if (!_isDownloaded) {
      final canAccess = await _canAccessResource();
      if (!canAccess) return;
      await _downloadIfNeeded(gateAlreadyChecked: true);
    }
    if (_isDownloaded && _localPath.isNotEmpty) {
      await SharePlus.instance.share(
        ShareParams(files: [XFile(_localPath)], text: widget.resource.title),
      );
    }
  }

  Future<void> _handleOpenWith() async {
    if (!_isDownloaded) {
      // Not downloaded yet — apply the same Pro/coin gate as every other
      // download path before fetching the file, instead of falling through
      // to the separate ad-only gate inside _downloadIfNeeded.
      final canAccess = await _canAccessResource();
      if (!canAccess) return;
      await _downloadIfNeeded(gateAlreadyChecked: true);
    }
    // Already downloaded means it was already unlocked earlier — open it
    // straight away, no gate needed.
    if (_isDownloaded && _localPath.isNotEmpty) {
      await OpenFilex.open(_localPath);
    }
  }

  Future<void> _handleDeleteLocally() async {
    try {
      final file = File(_localPath);
      if (file.existsSync()) {
        await file.delete();
        if (mounted) {
          setState(() {
            _isDownloaded = false;
            _accessGranted = false;
            _downloadProgress = 0;
          });
        }
        ref.invalidate(downloadCountProvider);
        ref.invalidate(downloadedFilesProvider);
        Fluttertoast.showToast(msg: 'File deleted locally');
      }
    } catch (e) {
      log('Delete error: $e');
    }
  }

  Future<void> _saveToPublicDownloads() async {
    try {
      if (!_isDownloaded) return;
      final file = File(_localPath);
      Directory? dir = Platform.isAndroid
          ? Directory('/storage/emulated/0/Download/Campus Assistant')
          : await getDownloadsDirectory();
      if (dir != null) {
        await dir.create(recursive: true);
        await file.copy('${dir.path}/${_getFileName()}');
        Fluttertoast.showToast(msg: 'Saved to Downloads');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error saving: $e');
    }
  }

  Future<void> _handleBookmarkToggle() async {
    final userAsync = ref.read(userProvider);
    final userId = userAsync.value?.uid ?? '';
    if (userId.isEmpty) {
      Fluttertoast.showToast(msg: 'Please login to bookmark');
      return;
    }

    if (_isBookmarked && _bookmarkId != null) {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('Remove Bookmark'),
          content: const Text('Are you sure you want to remove this bookmark?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: Text(
                'Remove',
                style: TextStyle(color: context.colors.danger),
              ),
            ),
          ],
        ),
      );
      if (confirmed != true) return;

      final repo = ref.read(bookmarkRepositoryProvider);
      final result = await repo.removeBookmark(_bookmarkId!);
      result.fold(
        (failure) => Fluttertoast.showToast(msg: 'Failed to remove bookmark'),
        (_) {
          if (mounted) {
            setState(() {
              _isBookmarked = false;
              _bookmarkId = null;
            });
          }
          ref.invalidate(userBookmarksProvider);
          Fluttertoast.showToast(msg: 'Bookmark removed');
        },
      );
    } else {
      final bookmark = Bookmark(
        id: Uuid().v4(),
        userId: userId,
        entityType: 'resource',
        entityId: widget.resource.id,
      );
      final repo = ref.read(bookmarkRepositoryProvider);
      final result = await repo.addBookmark(bookmark);
      result.fold(
        (failure) => Fluttertoast.showToast(msg: 'Failed to add bookmark'),
        (_) {
          if (mounted) {
            setState(() {
              _isBookmarked = true;
              _bookmarkId = bookmark.id;
            });
          }
          ref.invalidate(userBookmarksProvider);
          Fluttertoast.showToast(msg: 'Bookmarked');
        },
      );
    }
  }
}

class _PopupItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color? errorColor;
  const _PopupItem({required this.icon, required this.text, this.errorColor});
  @override
  Widget build(BuildContext context) => Row(
    children: [
      Icon(icon, size: 16, color: errorColor),
      const SizedBox(width: Spacing.sm),
      Text(
        text,
        style: TextStyle(fontSize: FontSizeToken.md, color: errorColor),
      ),
    ],
  );
}

enum _UnlockChoice { download, watchVideo, pro }
