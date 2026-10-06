import 'package:flutter/material.dart';

import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/core/theme/tokens/app_font_size.dart';

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
    final colors = context.colors;

    return Container(
      height: 40,
      padding: const EdgeInsets.all(Spacing.xs),
      decoration: BoxDecoration(
        color: colors.surfaceAlt,
        borderRadius: BorderRadius.circular(RadiusToken.md),
      ),
      child: TabBar(
        isScrollable: isScrollable,
        tabAlignment: isScrollable ? TabAlignment.start : null,
        controller: controller,
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(RadiusToken.sm),
          color: colors.surface,
          boxShadow: [
            BoxShadow(
              color: colors.shadow,
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        labelColor: colors.text,
        unselectedLabelColor: colors.textMuted,
        labelStyle:
            labelStyle ??
            const TextStyle(fontWeight: .bold, fontSize: FontSizeToken.md),
        unselectedLabelStyle:
            unselectedLabelStyle ??
            const TextStyle(fontWeight: .w500, fontSize: FontSizeToken.md),
        dividerColor: Colors.transparent,
        tabs: tabs,
      ),
    );
  }
}
