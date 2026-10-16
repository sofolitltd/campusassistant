import 'package:material_ui/material_ui.dart';

import '/core/theme/tokens/app_layout.dart';

/// Centres [child] in a column no wider than [maxWidth], on the normal page
/// background.
///
/// Wrap a whole routed page (its `Scaffold` included) so the app bar, body and
/// snack bars all share the column and the side margins stay a neutral colour.
/// Pages inside the tab shell already get this from `ScaffoldWithNavBar`; use
/// it for routes that opt out with `parentNavigatorKey: rootNavigatorKey`.
class ContentColumn extends StatelessWidget {
  const ContentColumn({
    super.key,
    required this.child,
    this.maxWidth = AppLayout.pageWidth,
  });

  final Widget child;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: child,
        ),
      ),
    );
  }
}
