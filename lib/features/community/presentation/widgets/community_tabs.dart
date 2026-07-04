import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CommunityTabs extends StatelessWidget {
  final TabController tabController;

  const CommunityTabs({super.key, required this.tabController});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Align(
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isDark
                ? Colors.white.withValues(alpha: 0.05)
                : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isDark ? Colors.white10 : Colors.grey.shade200,
              width: 1,
            ),
          ),
          child: AnimatedBuilder(
            animation: tabController.animation!,
            builder: (context, child) {
              return Row(
                spacing: 8,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildTab('Batch', 0, isDark),
                  _buildTab('Department', 1, isDark),
                  _buildTab('University', 2, isDark),
                  _buildTab('Saved', 3, isDark),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTab(String label, int index, bool isDark) {
    final double animationValue = tabController.animation!.value;
    final double progress = (1.0 - (animationValue - index).abs()).clamp(
      0.0,
      1.0,
    );

    final Color activeColor = isDark ? Colors.white : Colors.black;
    final Color inactiveColor = isDark
        ? Colors.white.withValues(alpha: 0.05)
        : Colors.white;
    final Color activeTextColor = isDark ? Colors.black : Colors.white;
    final Color inactiveTextColor = Colors.grey.shade600;

    return GestureDetector(
      onTap: () => tabController.animateTo(index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        height: 32,
        decoration: BoxDecoration(
          color: Color.lerp(inactiveColor, activeColor, progress),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: Color.lerp(
              isDark ? Colors.white24 : Colors.grey.shade300,
              isDark ? Colors.white24 : Colors.grey.shade300,
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
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }
}
