import 'package:material_ui/material_ui.dart';

/// The app's one loading spinner.
///
/// With no [color] it is brand teal on a page, and inside a Material button it
/// takes the button's label colour — so it stays visible on the light grey a
/// button turns while disabled during a submit.
class AppLoader extends StatelessWidget {
  const AppLoader({super.key, this.color, this.size = 20, this.strokeWidth});

  final Color? color;
  final double size;
  final double? strokeWidth;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size,
      child: CircularProgressIndicator(
        color: color ?? _defaultColor(context),
        strokeWidth: strokeWidth ?? (size / 8).clamp(2.0, 4.0),
        strokeCap: StrokeCap.round,
      ),
    );
  }

  static Color _defaultColor(BuildContext context) {
    var inButton = false;
    context.visitAncestorElements((element) {
      inButton = element.widget is ButtonStyleButton;
      return !inButton;
    });
    final fallback = Theme.of(context).colorScheme.primary;
    return inButton ? (IconTheme.of(context).color ?? fallback) : fallback;
  }
}
