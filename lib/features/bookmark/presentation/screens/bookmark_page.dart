import 'package:cached_network_image/cached_network_image.dart';
import '/core/theme/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/features/auth/presentation/providers/user_profile_provider.dart';
import '/features/bookmark/domain/entities/bookmark.dart';
import '/features/bookmark/presentation/providers/bookmark_provider.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/core/widgets/red_header_layout.dart';

class BookmarkPage extends ConsumerStatefulWidget {
  const BookmarkPage({super.key});

  @override
  ConsumerState<BookmarkPage> createState() => _BookmarkPageState();
}

class _BookmarkPageState extends ConsumerState<BookmarkPage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final userAsync = ref.watch(userProvider);
    final userId = userAsync.value?.uid ?? '';

    final bookmarksAsync = ref.watch(userBookmarksProvider(userId));

    return RedHeaderLayout(
      title: 'Saved Bookmarks',
      showSearchBar: false,
      body: bookmarksAsync.when(
        loading: () => const Center(child: CupertinoActivityIndicator()),
        error: (e, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(LucideIcons.alertCircle, size: 48, color: Colors.red[300]),
              const SizedBox(height: Spacing.lg),
              Text('Error: $e', textAlign: TextAlign.center),
              const SizedBox(height: Spacing.lg),
              ElevatedButton.icon(
                onPressed: () => ref.invalidate(userBookmarksProvider(userId)),
                icon: const Icon(Icons.refresh, size: 18),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (bookmarks) {
          if (bookmarks.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    LucideIcons.bookmark,
                    size: 64,
                    color: isDark ? Colors.white24 : Colors.grey.shade300,
                  ),
                  const SizedBox(height: Spacing.lg),
                  Text(
                    'No bookmarks yet',
                    style: TextStyle(
                      fontSize: 16,
                      color: isDark ? Colors.white70 : Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Bookmark resources, teachers, and more',
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark ? Colors.white38 : Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: bookmarks.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final bookmark = bookmarks[index];
              return _BookmarkCard(bookmark: bookmark);
            },
          );
        },
      ),
    );
  }
}

class _BookmarkCard extends ConsumerStatefulWidget {
  final Bookmark bookmark;
  const _BookmarkCard({required this.bookmark});
  @override
  ConsumerState<_BookmarkCard> createState() => _BookmarkCardState();
}

class _BookmarkCardState extends ConsumerState<_BookmarkCard> {
  bool _isRemoving = false;

  Future<void> _handleUnbookmark() async {
    setState(() => _isRemoving = true);
    final repo = ref.read(bookmarkRepositoryProvider);
    final result = await repo.removeBookmark(widget.bookmark.id);
    result.fold(
      (failure) {
        if (mounted) {
          Fluttertoast.showToast(msg: 'Failed to remove bookmark');
          setState(() => _isRemoving = false);
        }
      },
      (_) {
        ref.invalidate(userBookmarksProvider);
      },
    );
  }

  String _entityName(dynamic detail, String fallback) {
    if (detail is Map<String, dynamic>) {
      return (detail['title'] ?? detail['name'] ?? detail['username'] ?? fallback)
          .toString();
    }
    return fallback;
  }

  IconData _iconForType(String type) {
    final t = type.toLowerCase();
    if (t == 'resource') return LucideIcons.fileText;
    if (t == 'teacher' || t == 'faculty') return LucideIcons.graduationCap;
    if (t == 'user' || t == 'student') return LucideIcons.user;
    return LucideIcons.bookmark;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final detailAsync = ref.watch(
      entityDetailProvider((type: widget.bookmark.entityType, id: widget.bookmark.entityId)),
    );

    final entityName = detailAsync.when(
      loading: () => 'Loading...',
      error: (_, __) => 'Unknown ${widget.bookmark.entityType}',
      data: (detail) => _entityName(detail, widget.bookmark.entityId),
    );

    final thumbnailUrl = detailAsync.whenOrNull(
      data: (detail) {
        if (detail is Map<String, dynamic>) {
          return detail['thumbnailUrl']?.toString() ?? detail['thumbnail_url']?.toString() ?? '';
        }
        return '';
      },
    );

    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(RadiusToken.md),
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
            onTap: () {},
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      _buildThumbnail(theme, isDark, thumbnailUrl ?? ''),
                      const SizedBox(width: 12),
                      _buildDetails(theme, isDark, entityName),
                    ],
                  ),
                ),
                Positioned(top: -4, right: -6, child: _buildPopupMenu()),
                Positioned(
                  bottom: -4,
                  right: 12,
                  child: _isRemoving
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : IconButton(
                          constraints: const BoxConstraints(minWidth: 22, minHeight: 22),
                          padding: EdgeInsets.zero,
                          onPressed: _handleUnbookmark,
                          icon: Icon(
                            LucideIcons.bookmarkCheck,
                            color: Colors.teal,
                            size: 20,
                          ),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThumbnail(ThemeData theme, bool isDark, String thumbnailUrl) {
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
                : Colors.teal.withValues(alpha: 0.08),
            border: Border.all(
              color: isDark ? Colors.white24 : Colors.grey.shade300,
              width: 1,
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: thumbnailUrl.isNotEmpty
              ? CachedNetworkImage(
                  imageUrl: thumbnailUrl,
                  fit: BoxFit.cover,
                  placeholder: (context, _) => Icon(
                    _iconForType(widget.bookmark.entityType),
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                    size: 30,
                  ),
                  errorWidget: (context, _, _) => Icon(
                    _iconForType(widget.bookmark.entityType),
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                    size: 30,
                  ),
                )
              : Icon(
                  _iconForType(widget.bookmark.entityType),
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                  size: 30,
                ),
        ),
      ],
    );
  }

  Widget _buildDetails(ThemeData theme, bool isDark, String entityName) {
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
                widget.bookmark.entityType.toUpperCase(),
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
              entityName,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                height: 1.2,
              ),
            ),
            const Spacer(),
            Text(
              widget.bookmark.entityId,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: isDark ? Colors.white70 : Colors.grey.shade600,
                height: 1,
              ),
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
      icon: const Icon(LucideIcons.ellipsisVertical, size: 16),
      onSelected: (value) async {
        switch (value) {
          case 'remove':
            _handleUnbookmark();
            break;
          case 'info':
            Fluttertoast.showToast(
              msg: '${widget.bookmark.entityType}: ${widget.bookmark.entityId}',
            );
            break;
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          height: 34,
          value: 'info',
          child: _BookmarkPopupItem(icon: LucideIcons.info, text: 'Info'),
        ),
        PopupMenuItem(
          height: 34,
          value: 'remove',
          child: _BookmarkPopupItem(
            icon: LucideIcons.bookmarkX,
            text: 'Remove Bookmark',
            errorColor: theme.appColors.destructiveColor,
          ),
        ),
      ],
    );
  }
}

class _BookmarkPopupItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color? errorColor;
  const _BookmarkPopupItem({required this.icon, required this.text, this.errorColor});
  @override
  Widget build(BuildContext context) => Row(
    children: [
      Icon(icon, size: 16, color: errorColor),
      const SizedBox(width: 8),
      Text(text, style: TextStyle(fontSize: 13, color: errorColor)),
    ],
  );
}
