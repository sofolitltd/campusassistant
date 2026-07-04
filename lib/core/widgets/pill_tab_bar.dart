import 'package:flutter/material.dart';

import '/core/theme/tokens/app_radius.dart';
import '/core/theme/tokens/app_spacing.dart';

/// A pill-style segmented tab control with smooth lerp animation.
///
/// Replaces the duplicated `SmoothTabControl`, `AlumniTabControl`,
/// and `CommunityTabs` widgets.
///
/// ```dart
/// PillTabBar(
///   controller: tabController,
///   labels: ['Batch', 'Department', 'University'],
///   onTap: (index) {},
/// )
/// ```
class PillTabBar extends StatelessWidget {
  const PillTabBar({
    super.key,
    required this.controller,
    required this.labels,
    this.onTap,
    this.scrollable = false,
  });

  /// The shared [TabController] driving selection and animation.
  final TabController controller;

  /// Labels for each tab pill.
  final List<String> labels;

  /// Called when a pill is tapped.
  final ValueChanged<int>? onTap;

  /// Whether pills should scroll horizontally when they overflow.
  /// Set to `true` for 5+ labels.
  final bool scrollable;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(Spacing.lg, Spacing.md, Spacing.lg, Spacing.sm),
      child: Container(
        padding: const EdgeInsets.all(Spacing.xs),
        decoration: BoxDecoration(
          color: cs.surfaceContainerHighest.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(RadiusToken.sm),
          border: Border.all(color: cs.outlineVariant, width: 0.5),
        ),
        child: AnimatedBuilder(
          animation: controller.animation!,
          builder: (context, _) {
            if (scrollable) {
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: _buildRow(context),
              );
            }
            return _buildRow(context);
          },
        ),
      ),
    );
  }

  Widget _buildRow(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: Spacing.xs,
      children: List.generate(labels.length, (i) => _buildPill(context, i)),
    );
  }

  Widget _buildPill(BuildContext context, int index) {
    final cs = Theme.of(context).colorScheme;
    final animationValue = controller.animation!.value;
    final progress = (1.0 - (animationValue - index).abs()).clamp(0.0, 1.0);

    final Color pillColor =
        Color.lerp(Colors.transparent, cs.primary, progress)!;
    final Color textColor =
        Color.lerp(cs.onSurfaceVariant, cs.onPrimary, progress)!;
    final Color borderColor = progress > 0.5
        ? cs.primary.withValues(alpha: 0.4)
        : cs.outlineVariant.withValues(alpha: 0.3);

    return GestureDetector(
      onTap: () {
        controller.animateTo(index);
        onTap?.call(index);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: Spacing.lg),
        height: 34,
        decoration: BoxDecoration(
          color: pillColor,
          borderRadius: BorderRadius.circular(RadiusToken.sm),
          border: Border.all(color: borderColor, width: 0.5),
        ),
        child: Center(
          child: Text(
            labels[index],
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: textColor,
              fontWeight:
                  progress > 0.5 ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
