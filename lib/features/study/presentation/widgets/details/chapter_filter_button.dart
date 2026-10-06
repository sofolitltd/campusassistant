import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/features/chapter/domain/entities/chapter.dart';
import 'chapter_tile.dart';
import '/core/widgets/inline_search_bar.dart';
import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/core/theme/tokens/app_font_size.dart';

class ChapterFilterButton extends ConsumerWidget {
  final AsyncValue<List<Chapter>> chaptersAsync;
  final String selectedChapterNo;
  final Function(Chapter) onChapterSelected;
  final bool redBg;

  const ChapterFilterButton({
    super.key,
    required this.chaptersAsync,
    required this.selectedChapterNo,
    required this.onChapterSelected,
    this.redBg = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return chaptersAsync.when(
      data: (chapters) {
        if (chapters.isEmpty) return const SizedBox();

        final selectedChapter = chapters.firstWhere(
          (c) => c.chapterNo.toString() == selectedChapterNo,
          orElse: () => chapters.first,
        );

        return GestureDetector(
          onTap: () => _showChapterSheet(context, chapters),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: Spacing.md,
              vertical: Spacing.xs,
            ),
            decoration: BoxDecoration(
              color: redBg
                  ? context.colors.surface.withValues(alpha: 0.15)
                  : null,
              border: Border.all(
                color: redBg
                    ? context.colors.onPrimary.withValues(alpha: 0.4)
                    : context.colors.borderStrong,
              ),
              borderRadius: BorderRadius.circular(RadiusToken.md),
            ),
            child: Row(
              mainAxisSize: .min,
              children: [
                Icon(
                  LucideIcons.bookOpen,
                  size: 14,
                  color: redBg
                      ? context.colors.onPrimary
                      : theme.colorScheme.onSurface,
                ),
                const SizedBox(width: Spacing.sm),
                Text(
                  'Chapter',
                  style: TextStyle(
                    fontSize: FontSizeToken.md,
                    fontWeight: .w500,
                    color: redBg
                        ? context.colors.onPrimary
                        : theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(width: Spacing.xs),
                Flexible(
                  child: Text(
                    '${selectedChapter.chapterNo}',
                    style: TextStyle(
                      fontSize: FontSizeToken.md,
                      fontWeight: .bold,
                      color: redBg
                          ? context.colors.onPrimary
                          : theme.colorScheme.onSurface,
                    ),
                    maxLines: 1,
                    overflow: .ellipsis,
                  ),
                ),
                const SizedBox(width: Spacing.xs),
                Icon(
                  Icons.keyboard_arrow_down,
                  size: 16,
                  color: redBg
                      ? context.colors.onPrimary
                      : theme.colorScheme.onSurface,
                ),
              ],
            ),
          ),
        );
      },
      loading: () => SizedBox(
        width: 100,
        height: 32,
        child: Center(
          child: CupertinoActivityIndicator(color: context.colors.onPrimary),
        ),
      ),
      error: (_, _) => const SizedBox(),
    );
  }

  void _showChapterSheet(BuildContext context, List<Chapter> chapters) {
    final theme = Theme.of(context);
    String searchText = '';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: theme.scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(RadiusToken.xxl),
        ),
      ),
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            final filteredChapters = searchText.isEmpty
                ? chapters
                : chapters
                      .where(
                        (c) =>
                            c.chapterTitle.toLowerCase().contains(
                              searchText.toLowerCase(),
                            ) ||
                            c.chapterNo.toString().contains(searchText),
                      )
                      .toList();

            return Container(
              height: MediaQuery.of(context).size.height * 0.7,
              padding: const EdgeInsets.only(top: Spacing.md),
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: context.colors.borderStrong,
                        borderRadius: BorderRadius.circular(RadiusToken.xs),
                      ),
                    ),
                  ),
                  const SizedBox(height: Spacing.lg),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Spacing.xl),
                    child: Row(
                      mainAxisAlignment: .spaceBetween,
                      children: [
                        Text(
                          'Select Chapter',
                          style: TextStyle(
                            fontSize: FontSizeToken.xl,
                            fontWeight: .bold,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Icon(
                            LucideIcons.x,
                            size: 20,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: Spacing.lg),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Spacing.xl),
                    child: InlineSearchBar(
                      hintText: 'Search chapter...',
                      onChanged: (v) => setState(() => searchText = v),
                    ),
                  ),
                  const SizedBox(height: Spacing.lg),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Spacing.md,
                      ),
                      itemCount: filteredChapters.length,
                      itemBuilder: (context, index) {
                        final chapter = filteredChapters[index];
                        final isSelected =
                            chapter.chapterNo.toString() == selectedChapterNo;

                        return ChapterTile(
                          chapter: chapter,
                          isSelected: isSelected,
                          onTap: () {
                            onChapterSelected(chapter);
                            Navigator.pop(context);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
