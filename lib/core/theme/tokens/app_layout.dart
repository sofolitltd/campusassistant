/// Width limits for the Campus Assistant design system.
///
/// On web (and tablets) the app is a centred, phone-shaped column — nothing
/// should stretch to the browser width. Pick the token by what the surface is,
/// not by how wide it happens to look:
///
/// - [pageWidth]   — any full page (lists, details, the tab shell).
/// - [formWidth]   — standalone single-purpose forms (sign-up, verification).
/// - [dialogWidth] — `AlertDialog` / `Dialog`; applied globally via `dialogTheme`.
/// - [sheetWidth]  — modal bottom sheets; applied globally via `bottomSheetTheme`.
///
/// For a routed page outside the tab shell, wrap it in `ContentColumn`
/// (`core/widgets/content_column.dart`) instead of hand-writing a
/// `ConstrainedBox`.
abstract final class AppLayout {
  static const double pageWidth = 700;
  static const double formWidth = 480;
  static const double dialogWidth = 440;
  static const double dialogMinWidth = 280;
  static const double sheetWidth = 640;
}
