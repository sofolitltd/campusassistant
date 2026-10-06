import 'package:flutter/material.dart';

import '/core/theme/tokens/app_radius.dart';
import '/features/home/widgets/home_section.dart';

/// The brand gradient behind a page's app bar and the rounded corners of the
/// sheet below it — the same gradient the home header uses.
///
/// Wrap a page's [Scaffold] (with a transparent `backgroundColor`) in this
/// instead of giving the scaffold a solid primary colour. The gradient only
/// covers the status bar, the app bar and the sheet's corner radius; below
/// that is the normal page background.
class HeaderGradientBackdrop extends StatelessWidget {
  const HeaderGradientBackdrop({
    super.key,
    required this.child,
    this.extraHeight = 0,
  });

  final Widget child;

  /// Height of anything sitting between the app bar and the sheet (e.g. a
  /// filter row), so the gradient still reaches behind the sheet's corners.
  final double extraHeight;

  @override
  Widget build(BuildContext context) {
    final bandHeight =
        MediaQuery.paddingOf(context).top +
        kToolbarHeight +
        extraHeight +
        RadiusToken.xxxl;

    return Stack(
      children: [
        Positioned.fill(
          child: ColoredBox(color: Theme.of(context).scaffoldBackgroundColor),
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: bandHeight,
          child: DecoratedBox(
            decoration: BoxDecoration(gradient: homeHeaderGradient(context)),
          ),
        ),
        child,
      ],
    );
  }
}
