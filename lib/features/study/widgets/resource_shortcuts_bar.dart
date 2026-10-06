import 'package:campusassistant/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '/core/widgets/mouse_wheel_horizontal_scroll.dart';
import '/features/study/data/models/study_shortcut.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/core/theme/tokens/app_font_size.dart';

class ResourceShortcutsBar extends StatefulWidget {
  final int bookmarkCount;
  final int downloadCount;

  const ResourceShortcutsBar({
    super.key,
    required this.bookmarkCount,
    required this.downloadCount,
  });

  @override
  State<ResourceShortcutsBar> createState() => _ResourceShortcutsBarState();
}

class _ResourceShortcutsBarState extends State<ResourceShortcutsBar> {
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bookmarkCount = widget.bookmarkCount;
    final downloadCount = widget.downloadCount;

    return SizedBox(
      height: 124,
      child: MouseWheelHorizontalScroll(
        controller: _scrollController,
        child: ListView.builder(
          controller: _scrollController,
          scrollDirection: .horizontal,
          padding: const EdgeInsets.fromLTRB(
            Spacing.lg,
            Spacing.lg,
            Spacing.lg,
            Spacing.sm,
          ),
          itemCount: allShortcuts.length,
          itemBuilder: (context, index) {
            final shortcut = allShortcuts[index];
            final isBookmark = shortcut.imageUrl == 'bookmark';
            final isDownload = shortcut.imageUrl == 'download';
            int count = 0;
            if (isBookmark) count = bookmarkCount;
            if (isDownload) count = downloadCount;

            return GestureDetector(
              onTap: () {
                if (shortcut.isNamedRoute) {
                  context.pushNamed(shortcut.route);
                } else {
                  context.push(shortcut.route);
                }
              },
              child: Container(
                width: 100,
                margin: const EdgeInsets.only(right: Spacing.md),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(RadiusToken.xl),
                  border: Border.all(color: context.colors.border),
                  boxShadow: [
                    BoxShadow(
                      color: context.colors.shadow.withAlpha(8),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.fromLTRB(
                  Spacing.md,
                  Spacing.md,
                  Spacing.md,
                  Spacing.md,
                ),
                child: Column(
                  mainAxisAlignment: .center,
                  children: [
                    Stack(
                      clipBehavior: .none,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(Spacing.md),
                          decoration: BoxDecoration(
                            // color: shortcut.color,
                            color: Theme.of(
                              context,
                            ).appColors.primary.withValues(alpha: .1),

                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            shortcut.icon,
                            // color: Colors.white,
                            color: context.colors.primary,

                            size: 22,
                          ),
                        ),
                        if (count > 0)
                          Positioned(
                            right: -4,
                            top: -4,
                            child: Container(
                              padding: const EdgeInsets.all(Spacing.xs),
                              decoration: BoxDecoration(
                                color: context.colors.danger,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: theme.cardColor,
                                  width: 2,
                                ),
                              ),
                              constraints: const BoxConstraints(
                                minWidth: 20,
                                minHeight: 20,
                              ),
                              child: Text(
                                count.toString(),
                                style: TextStyle(
                                  color: context.colors.onPrimary,
                                  fontSize: FontSizeToken.xxs,
                                  fontWeight: .bold,
                                ),
                                textAlign: .center,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: Spacing.sm),
                    Text(
                      shortcut.name,
                      maxLines: 2,
                      overflow: .ellipsis,
                      textAlign: .center,

                      style: TextStyle(
                        fontWeight: .bold,
                        fontSize: FontSizeToken.xxs,
                        height: 1.3,
                        color: context.colors.text,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
