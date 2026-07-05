import 'package:flutter/material.dart';

import '/core/theme/tokens/app_radius.dart';

/// A reusable styled tab bar with a pill-shaped indicator and rounded container.
///
/// Based on the study page's custom tab design, extracted for use across
/// the profile page, home favorites section, and study page itself.
///
/// ```dart
/// SectionTabBar(
///   controller: tabController,
///   tabs: const [
///     Tab(text: 'First'),
///     Tab(text: 'Second'),
///   ],
/// )
/// ```
class SectionTabBar extends StatelessWidget {
  const SectionTabBar({
    super.key,
    required this.controller,
    required this.tabs,
    this.labelStyle,
    this.unselectedLabelStyle,
    this.isScrollable = false,
  });

  /// The shared [TabController] driving selection and animation.
  final TabController controller;

  /// The list of [Tab] widgets to display.
  final List<Widget> tabs;

  /// Optional override for the active tab label style.
  final TextStyle? labelStyle;

  /// Optional override for the inactive tab label style.
  final TextStyle? unselectedLabelStyle;

  /// Whether the tabs are scrollable (default: false).
  final bool isScrollable;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: 40,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isDark ? Colors.white10 : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(RadiusToken.md),
      ),
      child: TabBar(
        isScrollable: isScrollable,
        tabAlignment: isScrollable ? TabAlignment.start : null,
        controller: controller,
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(RadiusToken.sm),
          color: isDark ? Colors.grey.shade800 : Colors.white,
          boxShadow: [
            if (!isDark)
              BoxShadow(
                color: Colors.black.withAlpha(12),
                blurRadius: 2,
                offset: const Offset(0, 1),
              ),
          ],
        ),
        labelColor: isDark ? Colors.white : Colors.black87,
        unselectedLabelColor:
            isDark ? Colors.white54 : Colors.grey.shade600,
        labelStyle: labelStyle ??
            const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
        unselectedLabelStyle: unselectedLabelStyle ??
            const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 13,
            ),
        dividerColor: Colors.transparent,
        tabs: tabs,
      ),
    );
  }
}
