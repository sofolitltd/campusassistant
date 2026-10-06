import 'package:flutter/material.dart';
import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/core/theme/tokens/app_font_size.dart';

class AlumniTabControl extends StatelessWidget {
  final TabController tabController;
  final ValueChanged<int> onTabChanged;

  const AlumniTabControl({
    super.key,
    required this.tabController,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        Spacing.lg,
        Spacing.sm,
        Spacing.lg,
        Spacing.md,
      ),
      child: Container(
        padding: const EdgeInsets.all(Spacing.sm),
        decoration: BoxDecoration(
          color: context.colors.surfaceAlt,
          borderRadius: BorderRadius.circular(RadiusToken.md),
          border: Border.all(color: context.colors.border, width: 1),
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
                children: [
                  _buildSmoothTab(context, 'Batch', 0, isDark),
                  _buildSmoothTab(context, 'Department', 1, isDark),
                  _buildSmoothTab(context, 'University', 2, isDark),
                  _buildSmoothTab(context, 'National', 3, isDark),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSmoothTab(
    BuildContext context,
    String label,
    int index,
    bool isDark,
  ) {
    final double animationValue = tabController.animation!.value;
    final double progress = (1.0 - (animationValue - index).abs()).clamp(
      0.0,
      1.0,
    );

    final Color activeColor = context.colors.text;
    final Color inactiveColor = context.colors.onPrimary;
    final Color activeTextColor = context.colors.onPrimary;
    final Color inactiveTextColor = context.colors.textMuted;

    return GestureDetector(
      onTap: () {
        tabController.animateTo(index);
        onTabChanged(index);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: Spacing.lg),
        height: 32,
        decoration: BoxDecoration(
          color: Color.lerp(inactiveColor, activeColor, progress),
          borderRadius: BorderRadius.circular(RadiusToken.sm),
          border: Border.all(
            color: Color.lerp(
              context.colors.borderStrong,
              context.colors.borderStrong,
              progress,
            )!,
            width: 1,
          ),
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
