import '/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/features/chapter/domain/entities/chapter.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/core/theme/tokens/app_font_size.dart';

class ChapterTile extends StatelessWidget {
  final Chapter chapter;
  final bool isSelected;
  final VoidCallback onTap;

  const ChapterTile({
    super.key,
    required this.chapter,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final primary = context.colors.primary;
    final selectedBg = context.colors.primarySubtle;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(
          vertical: Spacing.xxs,
          horizontal: Spacing.sm,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: Spacing.lg,
          vertical: Spacing.md,
        ),
        decoration: BoxDecoration(
          color: isSelected ? selectedBg : Colors.transparent,
          borderRadius: BorderRadius.circular(RadiusToken.md),
        ),
        child: Row(
          mainAxisAlignment: .spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  Text(
                    'Chapter ${chapter.chapterNo}',
                    style: TextStyle(
                      fontSize: FontSizeToken.sm,
                      color: isSelected ? primary : (context.colors.textMuted),
                      fontWeight: .w500,
                    ),
                  ),
                  const SizedBox(height: Spacing.xxs),
                  Text(
                    chapter.chapterTitle,
                    style: TextStyle(
                      fontSize: FontSizeToken.lg,
                      color: isSelected ? primary : (context.colors.text),
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                    maxLines: 2,
                    overflow: .ellipsis,
                  ),
                ],
              ),
            ),
            if (isSelected) Icon(LucideIcons.check, color: primary, size: 20),
          ],
        ),
      ),
    );
  }
}
