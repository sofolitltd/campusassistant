import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/core/theme/tokens/app_font_size.dart';

class BatchTile extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  /// Fills its grid cell (no outer margin, outlined) instead of a list row.
  final bool grid;

  const BatchTile({
    super.key,
    required this.title,
    required this.isSelected,
    required this.onTap,
    this.grid = false,
  });

  @override
  Widget build(BuildContext context) {
    final primary = context.colors.primary;
    final selectedBg = context.colors.primarySubtle;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: grid
            ? EdgeInsets.zero
            : const EdgeInsets.symmetric(
                vertical: Spacing.xxs,
                horizontal: Spacing.sm,
              ),
        padding: EdgeInsets.symmetric(
          horizontal: grid ? Spacing.md : Spacing.lg,
          vertical: grid ? Spacing.sm : Spacing.md,
        ),
        decoration: BoxDecoration(
          color: isSelected ? selectedBg : Colors.transparent,
          borderRadius: BorderRadius.circular(RadiusToken.md),
          border: grid
              ? Border.all(color: isSelected ? primary : context.colors.border)
              : null,
        ),
        child: Row(
          mainAxisAlignment: .spaceBetween,
          children: [
            Expanded(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: FontSizeToken.lg,
                  color: isSelected ? primary : (context.colors.text),
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),
            if (isSelected) Icon(LucideIcons.check, color: primary, size: 20),
          ],
        ),
      ),
    );
  }
}
