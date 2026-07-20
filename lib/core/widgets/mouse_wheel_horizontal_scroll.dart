import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// Wraps a horizontally-scrolling widget so the vertical mouse wheel also
/// scrolls it — browsers/Flutter don't translate vertical wheel deltas into
/// horizontal scroll for a custom Scrollable on their own, so on web/desktop
/// a horizontal rail otherwise only responds to click-drag, not the wheel.
class MouseWheelHorizontalScroll extends StatelessWidget {
  final ScrollController controller;
  final Widget child;

  const MouseWheelHorizontalScroll({
    super.key,
    required this.controller,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerSignal: (event) {
        if (event is! PointerScrollEvent || !controller.hasClients) return;
        final delta = event.scrollDelta.dy != 0
            ? event.scrollDelta.dy
            : event.scrollDelta.dx;
        final target = (controller.offset + delta).clamp(
          controller.position.minScrollExtent,
          controller.position.maxScrollExtent,
        );
        controller.jumpTo(target);
      },
      child: child,
    );
  }
}
