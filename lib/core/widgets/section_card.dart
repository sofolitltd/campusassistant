import 'package:flutter/material.dart';

import '/core/theme/tokens/app_radius.dart';
import '/core/theme/tokens/app_elevation.dart';
import '/core/theme/tokens/app_spacing.dart';

/// A reusable card wrapper matching the app's standard card style.
///
/// Light: white background, thin border, subtle shadow, 12px radius.
/// Dark: [cardColor] background, half-opaque border, same radius.
///
/// ```dart
/// SectionCard(
///   padding: const EdgeInsets.all(Spacing.lg),
///   child: Column(children: [...]),
/// )
/// ```
class SectionCard extends StatelessWidget {
  const SectionCard({
    super.key,
    this.padding,
    this.margin,
    this.child,
    this.onTap,
  });

  /// Inner padding. Defaults to [Spacing.lg] (16px).
  final EdgeInsetsGeometry? padding;

  /// Outer margin. Defaults to EdgeInsets.zero.
  final EdgeInsetsGeometry? margin;

  /// The widget inside the card.
  final Widget? child;

  /// When set, wraps the card in an [InkWell] for tap interaction.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cs = Theme.of(context).colorScheme;

    final card = Container(
      padding: padding ?? const EdgeInsets.all(Spacing.lg),
      decoration: BoxDecoration(
        color: isDark ? cs.surface : Colors.white,
        borderRadius: BorderRadius.circular(RadiusToken.md),
        border: Border.all(
          color: isDark ? Colors.white10 : cs.outlineVariant,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: ElevationToken.md,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );

    if (onTap != null) {
      return InkWell(
        borderRadius: BorderRadius.circular(RadiusToken.md),
        onTap: onTap,
        child: card,
      );
    }

    if (margin != null) {
      return Padding(padding: margin!, child: card);
    }

    return card;
  }
}
