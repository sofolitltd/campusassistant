import 'package:flutter/material.dart';

import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_font_size.dart';
import '/core/theme/tokens/app_spacing.dart';

/// The app's one filter / category chip: compact, no checkmark, solid primary
/// when selected. Matches the study search page; use it for every
/// single-select chip row instead of a raw [ChoiceChip].
class AppChoiceChip extends StatelessWidget {
  const AppChoiceChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  /// Height of a horizontally scrolling row of these chips.
  static const double rowHeight = 30;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return ChoiceChip(
      showCheckmark: false,
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
      selectedColor: colors.primary,
      labelStyle: TextStyle(
        fontSize: FontSizeToken.sm,
        color: selected ? colors.onPrimary : null,
        fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
      ),
      labelPadding: const EdgeInsets.symmetric(horizontal: Spacing.xs),
      padding: const EdgeInsets.symmetric(horizontal: Spacing.sm, vertical: 0),
      visualDensity: VisualDensity.compact,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}
