import 'package:flutter/material.dart';

/// Border radius scale for the Campus Assistant design system.
///
/// Usage: `BorderRadius.circular(RadiusToken.md)`
/// Convenience: `RadiusToken.circular(RadiusToken.md)`
abstract final class RadiusToken {
  static const double xs = 4;
  static const double sm = 6;
  static const double md = 8; // default for cards, buttons, dialogs
  static const double lg = 12; // section cards, featured containers
  static const double xl = 16; // hero cards, emergency contacts
  static const double xxl = 20; // floating search bars
  static const double full = 999; // circular / pills

  /// Convenience: `RadiusToken.circular(RadiusToken.md)`
  static BorderRadius circular(double radius) => BorderRadius.circular(radius);
}
