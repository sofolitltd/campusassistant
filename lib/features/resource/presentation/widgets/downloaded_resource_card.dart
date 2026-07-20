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
        borderRadius: BorderRadius.circular(RadiusToken.md),
        color: theme.cardColor,
        border: Border.all(
          color: isDark ? Colors.white10 : Colors.grey.shade200,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(RadiusToken.sm),
            onTap: () {
              Navigator.push(
                context,
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
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => _showInfoBottomSheet(context),
                        child: _buildThumbnail(isDark, theme),
                      ),
                      const SizedBox(width: 12),
                      _buildDetails(isDark, theme),
                    ],
                  ),
                ),
                Positioned(
                  top: 0,
                  right: -6,
                  child: _buildPopupMenu(context, ref, isBookmarked),
                ),
                Positioned(
                  bottom: -4,
                  right: 12,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
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
                              ? Colors.teal
                              : theme.colorScheme.onSurface.withValues(
                                  alpha: 0.4,
                                ),
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 2),
                      const Icon(
                        LucideIcons.circleCheck,
                        color: Colors.green,
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

  Widget _buildThumbnail(bool isDark, ThemeData theme) {
    final resource = downloadedFile.resource;
    return Stack(
      alignment: Alignment.topLeft,
      children: [
        Container(
          width: 80,
          height: 90,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: isDark
                ? theme.colorScheme.surface.withValues(alpha: 0.5)
                : Colors.blueAccent.shade100.withValues(alpha: 0.1),
            border: Border.all(
              color: isDark ? Colors.white24 : Colors.grey.shade300,
              width: 1,
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: resource.thumbnailUrl.isNotEmpty
              ? CachedNetworkImage(
                  imageUrl: ApiEndpoints.resolveImageUrl(resource.thumbnailUrl),
                  fit: BoxFit.cover,
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

  Widget _buildDetails(bool isDark, ThemeData theme) {
    final resource = downloadedFile.resource;
    final fileSize = _getFileSizeStr(downloadedFile.fileSizeBytes);
    final dateStr =
        '${downloadedFile.modifiedAt.day}/${downloadedFile.modifiedAt.month}/${downloadedFile.modifiedAt.year}';

    return Expanded(
      child: SizedBox(
        height: 95,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.teal.withValues(alpha: .5),
                borderRadius: BorderRadius.circular(2.5),
              ),
              child: Text(
                '${resource.courseCode.toUpperCase()}: ${resource.lessonNo}',
                style: const TextStyle(
                  height: 1,
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              resource.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              resource.description.isNotEmpty
                  ? resource.description
                  : resource.type,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: isDark ? Colors.white70 : Colors.grey.shade600,
                height: 1,
              ),
            ),
            const Spacer(),
            Row(
              children: [
                _buildMiniInfoTile(
                  theme,
                  isDark,
                  LucideIcons.hardDrive,
                  fileSize,
                ),
                const SizedBox(width: 8),
                _buildMiniInfoTile(
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
    ThemeData theme,
    bool isDark,
    IconData icon,
    String value,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: isDark
            ? theme.colorScheme.surface.withValues(alpha: 0.5)
            : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: isDark ? Colors.white10 : Colors.grey.shade100,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 10,
            color: isDark ? Colors.white70 : Colors.grey.shade600,
          ),
          const SizedBox(width: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 9,
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.bold,
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
      icon: const Icon(LucideIcons.ellipsisVertical, size: 16),
      onSelected: (value) async {
        switch (value) {
          case 'open':
            await OpenFilex.open(downloadedFile.localPath);
            break;
          case 'share':
            await SharePlus.instance.share(
              ShareParams(
                files: [XFile(downloadedFile.localPath)],
                text: downloadedFile.resource.title,
              ),
            );
            break;
          case 'info':
            _showInfoBottomSheet(context);
            break;
          case 'bookmark':
            await _handleBookmarkToggle(context, ref, isBookmarked);
            break;
          case 'view_course':
            _navigateToCourse(context);
            break;
          case 'delete':
            await _deleteFile(context, ref);
            break;
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
            errorColor: isBookmarked ? theme.appColors.destructiveColor : null,
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
            errorColor: theme.appColors.destructiveColor,
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
                style: TextStyle(
                  color: Theme.of(context).appColors.destructiveColor,
                ),
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
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
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
    final destructiveColor = Theme.of(context).appColors.destructiveColor;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete File?'),
        content: const Text(
          'This will permanently remove the file from your local storage.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: destructiveColor),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
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
      const SizedBox(width: 8),
      Text(text, style: TextStyle(fontSize: 13, color: errorColor)),
    ],
  );
}
