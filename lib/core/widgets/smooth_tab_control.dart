import 'package:flutter/material.dart';

import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/core/theme/tokens/app_font_size.dart';

class SmoothTabControl extends StatelessWidget {
  final TabController tabController;
  final List<String> labels;
  final ValueChanged<int>? onTabChanged;

  const SmoothTabControl({
    super.key,
    required this.tabController,
    required this.labels,
    this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        Spacing.lg,
        Spacing.lg,
        Spacing.lg,
        Spacing.sm,
      ),
      child: Container(
        padding: const EdgeInsets.all(Spacing.sm),
        decoration: BoxDecoration(
          color: colors.surfaceAlt,
          borderRadius: BorderRadius.circular(RadiusToken.md),
          border: Border.all(color: colors.border, width: 1),
        ),
        child: AnimatedBuilder(
          animation: tabController.animation!,
          builder: (context, child) {
            return SingleChildScrollView(
              scrollDirection: .horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                mainAxisSize: .min,
                spacing: 8,
                children: List.generate(labels.length, (index) {
                  return _buildTab(labels[index], index, colors);
                }),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTab(String label, int index, AppColors colors) {
    final double animationValue = tabController.animation!.value;
    final double progress = (1.0 - (animationValue - index).abs()).clamp(
      0.0,
      1.0,
    );

    // The selected pill inverts against the surface in both themes, which is
    // exactly what surfaceInverse/textInverse mean — no brightness check needed.
    final Color activeColor = colors.surfaceInverse;
    final Color inactiveColor = colors.surface;
    final Color activeTextColor = colors.textInverse;
    final Color inactiveTextColor = colors.textMuted;

    return GestureDetector(
      onTap: () {
        tabController.animateTo(index);
        onTabChanged?.call(index);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: Spacing.lg),
        height: 32,
        decoration: BoxDecoration(
          color: Color.lerp(inactiveColor, activeColor, progress),
          borderRadius: BorderRadius.circular(RadiusToken.sm),
          // Both lerp ends were already identical, so the border never
          // animated — it's just the border colour.
          border: Border.all(color: colors.borderStrong, width: 1),
          boxShadow: progress > 0.5
              ? [
                  BoxShadow(
                    color: activeColor.withValues(alpha: 0.1 * progress),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: Color.lerp(inactiveTextColor, activeTextColor, progress),
              fontWeight: progress > 0.5 ? FontWeight.bold : FontWeight.w600,
              fontSize: FontSizeToken.sm,
            ),
          ),
        ),
      ),
    );
  }
}
