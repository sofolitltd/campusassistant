import 'package:material_ui/material_ui.dart';

/// Owns a [TextEditingController] for the lifetime of its subtree.
///
/// For dialogs and bottom sheets built inline from a closure: creating the
/// controller in the calling method leaks it, and disposing it when
/// `showDialog`/`showModalBottomSheet` completes is too early — that future
/// resolves on pop, while the route is still animating out with the
/// TextField attached. This disposes when the route's subtree is torn down.
class TextControllerScope extends StatefulWidget {
  const TextControllerScope({
    super.key,
    this.initialText,
    required this.builder,
  });

  final String? initialText;
  final Widget Function(BuildContext context, TextEditingController controller)
  builder;

  @override
  State<TextControllerScope> createState() => _TextControllerScopeState();
}

class _TextControllerScopeState extends State<TextControllerScope> {
  late final TextEditingController _controller = TextEditingController(
    text: widget.initialText,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.builder(context, _controller);
}
