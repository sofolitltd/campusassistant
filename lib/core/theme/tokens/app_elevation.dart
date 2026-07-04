/// Elevation scale for the Campus Assistant design system.
///
/// Usage: `Card(elevation: ElevationToken.md)`
/// For custom BoxDecoration shadows, combine with the listed blur/offset.
abstract final class ElevationToken {
  static const double none = 0;
  static const double xs = 1; // subtle dividers
  static const double sm = 2; // search bars, light cards
  static const double md = 4; // default card elevation
  static const double lg = 8; // dialogs, bottom sheets
  static const double xl = 12; // FABs, popups, dropdowns
}
