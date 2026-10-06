import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/features/auth/presentation/providers/user_profile_provider.dart';
import '/features/bookmark/domain/entities/bookmark.dart';
import '/features/bookmark/presentation/providers/bookmark_provider.dart';
import '/features/resource/presentation/widgets/resource_card.dart';
import '/features/resource/data/models/resource_model.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/core/widgets/custom_header_layout.dart';
import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_font_size.dart';

class BookmarkPage extends ConsumerStatefulWidget {
  const BookmarkPage({super.key});

  @override
  ConsumerState<BookmarkPage> createState() => _BookmarkPageState();
}

class _BookmarkPageState extends ConsumerState<BookmarkPage> {
  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(userProvider);
    final userId = userAsync.value?.uid ?? '';

    final bookmarksAsync = ref.watch(userBookmarksProvider(userId));

    return CustomHeaderLayout(
      title: 'Saved Bookmarks',
      showSearchBar: false,
      body: bookmarksAsync.when(
        loading: () => const Center(child: CupertinoActivityIndicator()),
        error: (e, _) => Center(
          child: Column(
            mainAxisAlignment: .center,
            children: [
              Icon(
                LucideIcons.alertCircle,
                size: 48,
                color: context.colors.danger,
              ),
              const SizedBox(height: Spacing.lg),
              Text('Error: $e', textAlign: .center),
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
                mainAxisAlignment: .center,
                children: [
                  Icon(
                    LucideIcons.bookmark,
                    size: 64,
                    color: context.colors.borderStrong,
                  ),
                  const SizedBox(height: Spacing.lg),
                  Text(
                    'No bookmarks yet',
                    style: TextStyle(
                      fontSize: FontSizeToken.lg,
                      color: context.colors.textMuted,
                    ),
                  ),
                  const SizedBox(height: Spacing.sm),
                  Text(
                    'Bookmark notes, videos, and other resources',
                    style: TextStyle(
                      fontSize: FontSizeToken.md,
                      color: context.colors.textSubtle,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(Spacing.lg),
            itemCount: bookmarks.length,
            separatorBuilder: (_, _) => const SizedBox(height: Spacing.md),
            itemBuilder: (context, index) {
              final bookmark = bookmarks[index];
              return _BookmarkResourceItem(bookmark: bookmark);
            },
          );
        },
      ),
    );
  }
}

class _BookmarkResourceItem extends ConsumerStatefulWidget {
  final Bookmark bookmark;
  const _BookmarkResourceItem({required this.bookmark});
  @override
  ConsumerState<_BookmarkResourceItem> createState() =>
      _BookmarkResourceItemState();
}

class _BookmarkResourceItemState extends ConsumerState<_BookmarkResourceItem> {
  @override
  Widget build(BuildContext context) {
    final detailAsync = ref.watch(
      entityDetailProvider((
        type: widget.bookmark.entityType,
        id: widget.bookmark.entityId,
      )),
    );

    return detailAsync.when(
      loading: () => const SizedBox(
        height: 110,
        child: Center(child: CupertinoActivityIndicator()),
      ),
      error: (_, _) => Container(
        height: 110,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(RadiusToken.md),
          border: Border.all(
            color: Theme.of(context).brightness == Brightness.dark
                ? context.colors.border
                : context.colors.border,
          ),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: .center,
            children: [
              Icon(
                LucideIcons.alertCircle,
                size: 20,
                color: context.colors.danger,
              ),
              SizedBox(width: Spacing.sm),
              Text('Couldn\'t load this bookmark'),
            ],
          ),
        ),
      ),
      data: (detail) {
        if (detail is! Map<String, dynamic>) {
          return const SizedBox.shrink();
        }
        final resource = ResourceModel.fromJson(detail).toEntity();
        return ResourceCard(resource: resource);
      },
    );
  }
}
