import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// Flutter's default web scroll behavior already allows mouse-drag on most
/// versions, but making it explicit here removes any doubt and covers
/// trackpad too — belt-and-suspenders alongside MouseWheelHorizontalScroll
/// (which handles the vertical-wheel-to-horizontal-scroll translation that
/// no ScrollBehavior setting covers).
class AppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    PointerDeviceKind.trackpad,
    PointerDeviceKind.stylus,
    PointerDeviceKind.invertedStylus,
  };
}
