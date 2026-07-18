import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/features/chapter/domain/entities/chapter.dart';
import 'chapter_tile.dart';

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
    final isDark = theme.brightness == Brightness.dark;

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
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: redBg ? Colors.white.withValues(alpha: 0.15) : null,
              border: Border.all(
                color: redBg
                    ? Colors.white.withValues(alpha: 0.4)
                    : isDark
                    ? Colors.white24
                    : Colors.grey.shade300,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  LucideIcons.bookOpen,
                  size: 14,
                  color: redBg ? Colors.white : theme.colorScheme.onSurface,
                ),
                const SizedBox(width: 6),
                Text(
                  'Chapter',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: redBg ? Colors.white : theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(width: 4),
                Flexible(
                  child: Text(
                    '${selectedChapter.chapterNo}',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: redBg ? Colors.white : theme.colorScheme.onSurface,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.keyboard_arrow_down,
                  size: 16,
                  color: redBg ? Colors.white : theme.colorScheme.onSurface,
                ),
              ],
            ),
          ),
        );
      },
      loading: () => const SizedBox(
        width: 100,
        height: 32,
        child: Center(child: CupertinoActivityIndicator(color: Colors.white)),
      ),
      error: (_, _) => const SizedBox(),
    );
  }

  void _showChapterSheet(BuildContext context, List<Chapter> chapters) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    String searchText = '';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: theme.scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
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
              padding: const EdgeInsets.only(top: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: isDark ? Colors.white24 : Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Select Chapter',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
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
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      height: 44,
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.white.withAlpha(12)
                            : Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isDark ? Colors.white10 : Colors.grey.shade200,
                        ),
                      ),
                      child: TextField(
                        onChanged: (v) => setState(() => searchText = v),
                        decoration: InputDecoration(
                          hintText: 'Search chapter...',
                          hintStyle: TextStyle(
                            color: isDark
                                ? Colors.white54
                                : Colors.grey.shade400,
                            fontSize: 14,
                          ),
                          prefixIcon: Icon(
                            LucideIcons.search,
                            size: 18,
                            color: isDark
                                ? Colors.white54
                                : Colors.grey.shade400,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 12,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
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
