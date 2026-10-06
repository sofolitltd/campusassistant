import 'package:flutter/material.dart';

import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/theme/tokens/app_elevation.dart';
import '/core/theme/tokens/app_spacing.dart';

/// A reusable card wrapper matching the app's standard card style.
///
/// Surface, border and shadow all come from [AppColors], so it reads
/// correctly in both themes. Radius defaults to [RadiusToken.md]; pass
/// [RadiusToken.lg] for feature/section cards (the home page does).
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
    this.radius = RadiusToken.md,
    this.gradient,
    this.color,
    this.borderColor,
    this.shadow = true,
  });

  /// Inner padding. Defaults to [Spacing.lg] (16px).
  final EdgeInsetsGeometry? padding;

  /// Outer margin. Defaults to EdgeInsets.zero.
  final EdgeInsetsGeometry? margin;

  /// The widget inside the card.
  final Widget? child;

  /// When set, the whole card is tappable with an ink ripple clipped to its
  /// rounded shape.
  final VoidCallback? onTap;

  /// Corner radius. Use a [RadiusToken] value.
  final double radius;

  /// Replaces the flat surface fill (hero/promo cards).
  final Gradient? gradient;

  /// Flat fill; defaults to `colors.surface`. Ignored when [gradient] is set.
  final Color? color;

  /// Border colour; defaults to `colors.border`.
  final Color? borderColor;

  /// Whether to draw the soft drop shadow.
  final bool shadow;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final shape = BorderRadius.circular(radius);

    Widget content = Padding(
      padding: padding ?? const EdgeInsets.all(Spacing.lg),
      child: child,
    );

    // Material + InkWell sit *inside* the decorated box: an InkWell wrapped
    // around a Container paints its ripple underneath the Container's own
    // background, so it would never be visible.
    if (onTap != null) {
      content = Material(
        type: MaterialType.transparency,
        child: InkWell(borderRadius: shape, onTap: onTap, child: content),
      );
    }

    final card = Container(
      decoration: BoxDecoration(
        color: gradient == null ? (color ?? colors.surface) : null,
        gradient: gradient,
        borderRadius: shape,
        border: Border.all(color: borderColor ?? colors.border, width: 1),
        boxShadow: shadow
            ? [
                BoxShadow(
                  color: colors.shadow,
                  blurRadius: ElevationToken.md,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      // Clip so children (images, ripples) respect the rounded corners.
      child: ClipRRect(borderRadius: shape, child: content),
    );

    return margin != null ? Padding(padding: margin!, child: card) : card;
  }
}
