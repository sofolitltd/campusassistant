import 'package:flutter/painting.dart';

/// Decorative accent hues for category tiles, avatars and charts.
///
/// These are not status colours (use `AppColors.success` / `warning` /
/// `danger` / `info` for that) and are the same in light and dark themes.
///
/// Usage: `AccentToken.blue`
abstract final class AccentToken {
  static const Color blue = Color(0xFF3B82F6);
  static const Color blueDeep = Color(0xFF2563EB);
  static const Color violet = Color(0xFF8B5CF6);
  static const Color indigo = Color(0xFF6366F1);
  static const Color periwinkle = Color(0xFF6C7BFF);
  static const Color teal = Color(0xFF14B8A6);
  static const Color green = Color(0xFF22C55E);
  static const Color yellow = Color(0xFFFACC15);
  static const Color amber = Color(0xFFF59E0B);
  static const Color gold = Color(0xFFD4AF37);
  static const Color goldLight = Color(0xFFF5D76E);
  static const Color goldDeep = Color(0xFF9A7B0A);
  static const Color onGold = Color(0xFF3B2A00);
  static const Color orange = Color(0xFFF97316);
  static const Color red = Color(0xFFEF4444);
  static const Color rose = Color(0xFFE11D48);
  static const Color pink = Color(0xFFEC4899);
  static const Color gray = Color(0xFF6B7280);
}
