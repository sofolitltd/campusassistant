import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:open_filex/open_filex.dart';
import 'package:share_plus/share_plus.dart' hide Share;

import '../../../../core/cache/cache_manager.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/theme/tokens/app_radius.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../routes/app_route.dart';
import '../../../../widgets/pdf_viewer_page.dart';
import '../../domain/entities/downloaded_file.dart';
import '../providers/downloads_provider.dart';
import '../../../auth/presentation/providers/user_profile_provider.dart';
import '../../../bookmark/domain/entities/bookmark.dart';
import '../../../bookmark/presentation/providers/bookmark_provider.dart';
import 'package:uuid/uuid.dart';
import 'resource_info_sheet.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/core/theme/tokens/app_font_size.dart';
import '/core/theme/tokens/app_accents.dart';

/// Same metrics as [ResourceCard], so downloaded files look like every other
/// content card.
const double _kTopRowHeight = 18;
const double _kContentHeight = 99;
const double _kMenuTapSize = 40;

class DownloadedResourceCard extends ConsumerWidget {
  final DownloadedFile downloadedFile;
  final VoidCallback onDeleted;

  const DownloadedResourceCard({
    super.key,
    required this.downloadedFile,
    required this.onDeleted,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final resource = downloadedFile.resource;

    final userId = ref.watch(userProvider).value?.uid ?? '';
    final isBookmarked =
        userId.isNotEmpty &&
        ref
                .watch(userBookmarksProvider(userId))
                .whenOrNull(
                  data: (bookmarks) => bookmarks.any(
                    (b) =>
                        b.entityType == 'resource' && b.entityId == resource.id,
                  ),
                ) ==
            true;

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
            onTap: () {
              Navigator.of(context, rootNavigator: true).push(
                MaterialPageRoute(
                  builder: (_) => PdfViewerPage(
                    filePath: downloadedFile.localPath,
                    url: resource.fileUrl,
                    title: resource.title,
                  ),
                ),
              );
            },
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(Spacing.md),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => _showInfoBottomSheet(context),
                        child: _buildThumbnail(context, isDark, theme),
                      ),
                      const SizedBox(width: Spacing.md),
                      _buildDetails(context, isDark, theme),
                    ],
                  ),
                ),
                Positioned(
                  top: Spacing.md + (_kTopRowHeight - _kMenuTapSize) / 2,
                  right: 0,
                  child: _buildPopupMenu(context, ref, isBookmarked),
                ),
                Positioned(
                  bottom: -4,
                  right: 12,
                  child: Row(
                    mainAxisSize: .min,
                    children: [
                      IconButton(
                        constraints: const BoxConstraints(
                          minWidth: 22,
                          minHeight: 22,
                        ),
                        padding: EdgeInsets.zero,
                        onPressed: () =>
                            _handleBookmarkToggle(context, ref, isBookmarked),
                        icon: Icon(
                          isBookmarked
                              ? LucideIcons.bookmarkCheck
                              : LucideIcons.bookmark,
                          color: isBookmarked
                              ? context.colors.primary
                              : theme.colorScheme.onSurface.withValues(
                                  alpha: 0.4,
                                ),
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: Spacing.xxs),
                      Icon(
                        LucideIcons.circleCheck,
                        color: context.colors.success,
                        size: 20,
                      ),
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

  Widget _buildThumbnail(BuildContext context, bool isDark, ThemeData theme) {
    final resource = downloadedFile.resource;
    return Stack(
      alignment: Alignment.topLeft,
      children: [
        Container(
          width: 84,
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
          child: resource.thumbnailUrl.isNotEmpty
              ? CachedNetworkImage(
                  imageUrl: ApiEndpoints.resolveImageUrl(resource.thumbnailUrl),
                  fit: .cover,
                  placeholder: (context, _) => Icon(
                    LucideIcons.fileText,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                    size: 30,
                  ),
                  errorWidget: (context, _, _) => Icon(
                    LucideIcons.fileText,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                    size: 30,
                  ),
                )
              : Icon(
                  LucideIcons.fileText,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                  size: 30,
                ),
        ),
      ],
    );
  }

  Widget _buildDetails(BuildContext context, bool isDark, ThemeData theme) {
    final resource = downloadedFile.resource;
    final fileSize = _getFileSizeStr(downloadedFile.fileSizeBytes);
    final dateStr =
        '${downloadedFile.modifiedAt.day}/${downloadedFile.modifiedAt.month}/${downloadedFile.modifiedAt.year}';

    return Expanded(
      child: SizedBox(
        height: _kContentHeight,
        child: Column(
          crossAxisAlignment: .start,
          mainAxisAlignment: .start,
          children: [
            SizedBox(
              height: _kTopRowHeight,
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Spacing.xs,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: isDark
                          ? theme.colorScheme.surface.withValues(alpha: 0.5)
                          : context.colors.surfaceAlt,
                      borderRadius: BorderRadius.circular(RadiusToken.xs),
                      border: Border.all(color: context.colors.surfaceAlt),
                    ),
                    child: Text(
                      '${resource.courseCode.toUpperCase()}: ${resource.lessonNo}',
                      style: TextStyle(
                        height: 1,
                        fontSize: FontSizeToken.xxs,
                        fontWeight: .bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: Spacing.xs),
            Text(
              resource.title,
              maxLines: 2,
              overflow: .ellipsis,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: .bold,
                height: 1.2,
              ),
            ),
            const SizedBox(height: Spacing.xs),
            Text(
              resource.description.isNotEmpty
                  ? resource.description
                  : resource.type,
              maxLines: 1,
              overflow: .ellipsis,
              style: theme.textTheme.labelMedium?.copyWith(
                fontWeight: .w500,
                color: context.colors.textMuted,
                height: 1,
              ),
            ),
            const Spacer(),
            Row(
              children: [
                _buildMiniInfoTile(
                  context,
                  theme,
                  isDark,
                  LucideIcons.hardDrive,
                  fileSize,
                ),
                const SizedBox(width: Spacing.sm),
                _buildMiniInfoTile(
                  context,
                  theme,
                  isDark,
                  LucideIcons.calendar,
                  dateStr,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniInfoTile(
    BuildContext context,
    ThemeData theme,
    bool isDark,
    IconData icon,
    String value,
  ) {
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

  Widget _buildPopupMenu(
    BuildContext context,
    WidgetRef ref,
    bool isBookmarked,
  ) {
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
          case 'open':
            await OpenFilex.open(downloadedFile.localPath);
          case 'share':
            await SharePlus.instance.share(
              ShareParams(
                files: [XFile(downloadedFile.localPath)],
                text: downloadedFile.resource.title,
              ),
            );
          case 'info':
            _showInfoBottomSheet(context);
          case 'bookmark':
            await _handleBookmarkToggle(context, ref, isBookmarked);
          case 'view_course':
            _navigateToCourse(context);
          case 'delete':
            await _deleteFile(context, ref);
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          height: 34,
          value: 'open',
          child: _PopupItem(icon: LucideIcons.externalLink, text: 'Open with'),
        ),
        const PopupMenuItem(
          height: 34,
          value: 'share',
          child: _PopupItem(icon: LucideIcons.share2, text: 'Share'),
        ),
        const PopupMenuItem(
          height: 34,
          value: 'info',
          child: _PopupItem(icon: LucideIcons.info, text: 'Info'),
        ),
        PopupMenuItem(
          height: 34,
          value: 'bookmark',
          child: _PopupItem(
            icon: isBookmarked
                ? LucideIcons.bookmarkCheck
                : LucideIcons.bookmark,
            text: isBookmarked ? 'Remove Bookmark' : 'Bookmark',
            errorColor: isBookmarked ? theme.appColors.danger : null,
          ),
        ),
        if (downloadedFile.resource.id.isNotEmpty)
          const PopupMenuItem(
            height: 34,
            value: 'view_course',
            child: _PopupItem(
              icon: LucideIcons.arrowRightFromLine,
              text: 'View in Course',
            ),
          ),
        PopupMenuItem(
          height: 34,
          value: 'delete',
          child: _PopupItem(
            icon: LucideIcons.trash2,
            text: 'Delete',
            errorColor: theme.appColors.danger,
          ),
        ),
      ],
    );
  }

  Future<void> _handleBookmarkToggle(
    BuildContext context,
    WidgetRef ref,
    bool isBookmarked,
  ) async {
    final userAsync = ref.read(userProvider);
    final userId = userAsync.value?.uid ?? '';
    if (userId.isEmpty) {
      Fluttertoast.showToast(msg: 'Please login to bookmark');
      return;
    }

    if (isBookmarked) {
      final bookmarks = ref.read(userBookmarksProvider(userId)).value ?? [];
      final match = bookmarks.where(
        (b) =>
            b.entityType == 'resource' &&
            b.entityId == downloadedFile.resource.id,
      );
      final bookmarkId = match.isNotEmpty ? match.first.id : null;
      if (bookmarkId == null) return;

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

      final result = await ref
          .read(bookmarkRepositoryProvider)
          .removeBookmark(bookmarkId);
      result.fold(
        (failure) => Fluttertoast.showToast(msg: 'Failed to remove bookmark'),
        (_) {
          ref.invalidate(userBookmarksProvider);
          Fluttertoast.showToast(msg: 'Bookmark removed');
        },
      );
    } else {
      final bookmark = Bookmark(
        id: const Uuid().v4(),
        userId: userId,
        entityType: 'resource',
        entityId: downloadedFile.resource.id,
      );
      final result = await ref
          .read(bookmarkRepositoryProvider)
          .addBookmark(bookmark);
      result.fold(
        (failure) => Fluttertoast.showToast(msg: 'Failed to add bookmark'),
        (_) {
          ref.invalidate(userBookmarksProvider);
          Fluttertoast.showToast(msg: 'Bookmarked');
        },
      );
    }
  }

  void _showInfoBottomSheet(BuildContext context) {
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
          resource: downloadedFile.resource,
          scrollController: scrollController,
        ),
      ),
    );
  }

  void _navigateToCourse(BuildContext context) {
    final resource = downloadedFile.resource;
    if (resource.universityId.isEmpty || resource.departmentId.isEmpty) return;
    context.push(
      '${AppRoute.courseDetails.path}/${resource.universityId}/${resource.departmentId}/${resource.courseCode}',
    );
  }

  Future<void> _deleteFile(BuildContext context, WidgetRef ref) async {
    final destructiveColor = context.colors.danger;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        titlePadding: const EdgeInsets.fromLTRB(24, 16, 8, 0),
        title: Row(
          children: [
            const Expanded(child: Text('Delete File?')),
            IconButton(
              tooltip: 'Close',
              onPressed: () => Navigator.pop(ctx, false),
              icon: Icon(
                LucideIcons.x,
                size: 20,
                color: context.colors.textMuted,
              ),
            ),
          ],
        ),
        content: const Text(
          'This will permanently remove the file from your local storage.',
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: destructiveColor),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(
              'Delete',
              style: TextStyle(color: context.colors.onPrimary),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      final file = File(downloadedFile.localPath);
      if (file.existsSync()) await file.delete();
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error deleting file');
      return;
    }

    // Remove cached metadata
    final shortId = downloadedFile.shortId;
    if (shortId.isNotEmpty) {
      final cacheManager = ref.read(cacheManagerProvider);
      await removeDownloadedResourceMetadata(
        cacheManager: cacheManager,
        shortId: shortId,
      );
    }

    Fluttertoast.showToast(msg: 'File deleted');
    onDeleted();
  }

  String _getFileSizeStr(int bytes) {
    if (bytes <= 0) return '0.0 MB';
    if (bytes > 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    if (bytes > 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '$bytes B';
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
