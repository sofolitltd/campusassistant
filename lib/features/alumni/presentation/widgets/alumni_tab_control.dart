import 'package:flutter/material.dart';

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
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
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
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                spacing: 8,
                children: [
                  _buildSmoothTab('Batch', 0, isDark),
                  _buildSmoothTab('Department', 1, isDark),
                  _buildSmoothTab('University', 2, isDark),
                  _buildSmoothTab('National', 3, isDark),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSmoothTab(String label, int index, bool isDark) {
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
      onTap: () {
        tabController.animateTo(index);
        onTabChanged(index);
      },
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
            style: TextStyle(
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
