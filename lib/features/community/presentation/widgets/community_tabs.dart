import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/core/theme/tokens/app_font_size.dart';

class CommunityTabs extends StatelessWidget {
  final TabController tabController;

  const CommunityTabs({super.key, required this.tabController});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Align(
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          Spacing.lg,
          Spacing.lg,
          Spacing.lg,
          Spacing.sm,
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
              return Row(
                spacing: 8,
                mainAxisSize: .min,
                children: [
                  _buildTab(context, 'Batch', 0, isDark),
                  _buildTab(context, 'Department', 1, isDark),
                  _buildTab(context, 'University', 2, isDark),
                  _buildTab(context, 'Saved', 3, isDark),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTab(BuildContext context, String label, int index, bool isDark) {
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
      onTap: () => tabController.animateTo(index),
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
            style: GoogleFonts.outfit(
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
