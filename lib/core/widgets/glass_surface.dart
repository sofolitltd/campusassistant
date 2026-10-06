import 'dart:ui';

import 'package:flutter/material.dart';

import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_radius.dart';

/// The iOS-26 style glass used by the bottom search capsule and its filter
/// button: a fully rounded, translucent, blurred surface with a hairline
/// highlight border and a soft, wide shadow. Square [width] == [height] gives
/// a circle.
class GlassSurface extends StatelessWidget {
  const GlassSurface({
    super.key,
    required this.child,
    this.height = 44,
    this.width,
  });

  final Widget child;
  final double height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final radius = BorderRadius.circular(RadiusToken.full);

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: radius,
        boxShadow: [
          BoxShadow(
            color: colors.shadow,
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: radius,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
          child: Container(
            height: height,
            width: width,
            decoration: BoxDecoration(
              borderRadius: radius,
              color: colors.surface.withValues(alpha: isDark ? 0.62 : 0.72),
              border: Border.all(
                color: Colors.white.withValues(alpha: isDark ? 0.14 : 0.8),
                width: 1,
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
