import 'package:flutter/material.dart';

import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/core/theme/tokens/app_font_size.dart';

/// Page-number pagination bar (prev/next + numbered page buttons), matching
/// the style used on the All Students page.
class NumberedPagination extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final int startIndex;
  final int endIndex;
  final ValueChanged<int> onPageChanged;

  const NumberedPagination({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    required this.startIndex,
    required this.endIndex,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    List<int> pageNumbers;
    if (totalPages <= 5) {
      pageNumbers = List.generate(totalPages, (i) => i + 1);
    } else if (currentPage <= 3) {
      pageNumbers = [1, 2, 3, 4, 5];
    } else if (currentPage >= totalPages - 2) {
      pageNumbers = [
        totalPages - 4,
        totalPages - 3,
        totalPages - 2,
        totalPages - 1,
        totalPages,
      ];
    } else {
      pageNumbers = [
        currentPage - 2,
        currentPage - 1,
        currentPage,
        currentPage + 1,
        currentPage + 2,
      ];
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.lg,
        vertical: Spacing.sm,
      ),
      decoration: BoxDecoration(
        color: colors.surfaceAlt,
        border: Border(top: BorderSide(color: colors.border)),
      ),
      child: Column(
        children: [
          Text(
            'Showing $startIndex-$endIndex of $totalItems',
            style: TextStyle(
              fontSize: FontSizeToken.sm,
              color: colors.textMuted,
            ),
          ),
          const SizedBox(height: Spacing.sm),
          Row(
            mainAxisAlignment: .center,
            children: [
              _PageButton(
                icon: Icons.chevron_left,
                isEnabled: currentPage > 1,
                onTap: () => onPageChanged(currentPage - 1),
              ),
              const SizedBox(width: Spacing.xs),
              ...pageNumbers.map(
                (page) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Spacing.xxs),
                  child: _PageNumberButton(
                    page: page,
                    isSelected: page == currentPage,
                    onTap: () => onPageChanged(page),
                  ),
                ),
              ),
              const SizedBox(width: Spacing.xs),
              _PageButton(
                icon: Icons.chevron_right,
                isEnabled: currentPage < totalPages,
                onTap: () => onPageChanged(currentPage + 1),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PageButton extends StatelessWidget {
  final IconData icon;
  final bool isEnabled;
  final VoidCallback onTap;

  const _PageButton({
    required this.icon,
    required this.isEnabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return InkWell(
      onTap: isEnabled ? onTap : null,
      borderRadius: BorderRadius.circular(RadiusToken.md),
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(RadiusToken.md),
          border: Border.all(color: colors.border),
        ),
        child: Icon(
          icon,
          size: 20,
          color: isEnabled ? colors.text : colors.textSubtle,
        ),
      ),
    );
  }
}

class _PageNumberButton extends StatelessWidget {
  final int page;
  final bool isSelected;
  final VoidCallback onTap;

  const _PageNumberButton({
    required this.page,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(RadiusToken.md),
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: isSelected ? colors.primary : colors.surface,
          borderRadius: BorderRadius.circular(RadiusToken.md),
          border: Border.all(
            color: isSelected ? colors.primary : colors.border,
          ),
        ),
        child: Center(
          child: Text(
            '$page',
            style: TextStyle(
              fontSize: FontSizeToken.md,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              color: isSelected ? colors.onPrimary : colors.text,
            ),
          ),
        ),
      ),
    );
  }
}
