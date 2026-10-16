import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_font_size.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/features/auth/presentation/providers/user_profile_provider.dart';
import '/features/resource/presentation/widgets/resource_card.dart';
import '../providers/bookmark_provider.dart';

/// App-bar bookmark icon with a count badge. Tapping it lists every
/// bookmarked resource — the same full list on every page this button
/// appears on, so a bookmark saved from anywhere is reachable from
/// anywhere, without having to navigate back to where it was saved.
class BookmarkAppBarButton extends ConsumerWidget {
  const BookmarkAppBarButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final userId = ref.watch(userProvider).value?.uid ?? '';
    final count =
        ref.watch(scopedBookmarkResourcesProvider(userId)).value?.length ?? 0;

    return IconButton(
      tooltip: 'Bookmarks',
      onPressed: () => _showSheet(context, userId),
      icon: Stack(
        clipBehavior: Clip.none,
        children: [
          Icon(LucideIcons.bookmark, color: colors.onPrimary),
          if (count > 0)
            Positioned(
              right: -8,
              top: -6,
              child: Container(
                constraints: const BoxConstraints(minWidth: 16),
                padding: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color: colors.onPrimary,
                  borderRadius: BorderRadius.circular(RadiusToken.full),
                ),
                child: Text(
                  count > 99 ? '99+' : '$count',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: colors.primary,
                    fontSize: 10,
                    height: 1.4,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _showSheet(BuildContext context, String userId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(RadiusToken.xxl),
        ),
      ),
      builder: (sheetContext) => ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(sheetContext).height * 0.75,
        ),
        child: _BookmarkSheet(userId: userId),
      ),
    );
  }
}

class _BookmarkSheet extends ConsumerWidget {
  const _BookmarkSheet({required this.userId});

  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final async = ref.watch(scopedBookmarkResourcesProvider(userId));

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: Spacing.md),
        Center(
          child: Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: colors.borderStrong,
              borderRadius: BorderRadius.circular(RadiusToken.full),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(
            Spacing.lg,
            Spacing.sm,
            Spacing.sm,
            Spacing.sm,
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'Bookmarks',
                  style: TextStyle(
                    fontSize: FontSizeToken.xl,
                    fontWeight: FontWeight.bold,
                    color: colors.text,
                  ),
                ),
              ),
              IconButton(
                tooltip: 'Close',
                onPressed: () => Navigator.of(context).pop(),
                icon: Icon(LucideIcons.x, size: 20, color: colors.textMuted),
              ),
            ],
          ),
        ),
        Flexible(
          child: async.when(
            loading: () => const Padding(
              padding: EdgeInsets.all(Spacing.xl),
              child: Center(child: CupertinoActivityIndicator()),
            ),
            error: (_, _) => Padding(
              padding: const EdgeInsets.all(Spacing.xl),
              child: Center(
                child: Text(
                  "Couldn't load bookmarks",
                  style: TextStyle(color: colors.textMuted),
                ),
              ),
            ),
            data: (resources) {
              if (resources.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.all(Spacing.xl),
                  child: Center(
                    child: Text(
                      'No bookmarks here yet',
                      style: TextStyle(color: colors.textMuted),
                    ),
                  ),
                );
              }
              return ListView.separated(
                shrinkWrap: true,
                padding: const EdgeInsets.fromLTRB(
                  Spacing.lg,
                  0,
                  Spacing.lg,
                  Spacing.xl,
                ),
                itemCount: resources.length,
                separatorBuilder: (_, _) => const SizedBox(height: Spacing.md),
                itemBuilder: (_, i) => ResourceCard(resource: resources[i]),
              );
            },
          ),
        ),
      ],
    );
  }
}
