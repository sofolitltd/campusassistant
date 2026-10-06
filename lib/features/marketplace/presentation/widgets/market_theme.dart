import 'package:flutter/material.dart';

import '/core/theme/app_theme.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/theme/app_colors.dart';

/// Re-skins everything beneath it with the Campus Market palette, following
/// the app's current light/dark brightness.
class MarketTheme extends StatelessWidget {
  final Widget child;
  const MarketTheme({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Theme(
      data: isDark ? buildMarketDarkTheme() : buildMarketLightTheme(),
      child: child,
    );
  }
}

/// Page body with rounded top corners that overlaps the coloured app bar.
/// The Scaffold behind it must use `colors.primary` as its background.
class MarketBody extends StatelessWidget {
  final Widget child;
  const MarketBody({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(RadiusToken.xxxl),
      ),
      child: ColoredBox(color: context.colors.bg, child: child),
    );
  }
}
