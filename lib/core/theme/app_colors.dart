import 'package:flutter/material.dart';

/// The single source of colour for the app.
///
/// ## The rule
///
/// Use `context.colors.<role>` and nothing else. No `Colors.*`, no
/// `Color(0xFF…)`, no `Theme.of(context).colorScheme.*` outside this
/// directory. `scripts/check_colors.sh` enforces that new violations can't be
/// added.
///
/// ## Naming
///
/// Roles are `category` + optional modifier, and the same names exist as CSS
/// variables in the admin panel — one vocabulary, two implementations:
///
/// * **Brand**   `primary`, `primaryPressed`, `primarySubtle`, `onPrimary`
/// * **Text**    `text`, `textMuted`, `textSubtle`, `textInverse`
/// * **Surface** `bg`, `surface`, `surfaceAlt`, `surfaceInverse`
/// * **Line**    `border`, `borderStrong`
/// * **Status**  `success` / `onSuccess` / `successSubtle`, and the same
///   triple for `warning`, `danger`, `info`
///
/// `*Subtle` is a tinted fill (chips, banners); `on*` is the content that sits
/// on top of that fill. Every role carries both a light and a dark value, so a
/// call site never needs to know which theme is active.
@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    // Brand
    required this.primary,
    required this.primaryPressed,
    required this.primarySubtle,
    required this.onPrimary,
    // Text
    required this.text,
    required this.textMuted,
    required this.textSubtle,
    required this.textInverse,
    // Surface
    required this.bg,
    required this.surface,
    required this.surfaceAlt,
    required this.surfaceInverse,
    // Line
    required this.border,
    required this.borderStrong,
    // Status
    required this.success,
    required this.onSuccess,
    required this.successSubtle,
    required this.warning,
    required this.onWarning,
    required this.warningSubtle,
    required this.danger,
    required this.onDanger,
    required this.dangerSubtle,
    required this.info,
    required this.onInfo,
    required this.infoSubtle,
    // Accent
    required this.accent,
    required this.accentSubtle,
    // Media
    required this.scrim,
    required this.onScrim,
    // Effect
    required this.shadow,
  });

  // -- Brand --
  final Color primary;
  final Color primaryPressed;
  final Color primarySubtle;
  final Color onPrimary;

  // -- Text --
  final Color text;
  final Color textMuted;
  final Color textSubtle;
  final Color textInverse;

  // -- Surface --
  final Color bg;
  final Color surface;
  final Color surfaceAlt;
  final Color surfaceInverse;

  // -- Line --
  final Color border;
  final Color borderStrong;

  // -- Status --
  final Color success;
  final Color onSuccess;
  final Color successSubtle;
  final Color warning;
  final Color onWarning;
  final Color warningSubtle;
  final Color danger;
  final Color onDanger;
  final Color dangerSubtle;
  final Color info;
  final Color onInfo;
  final Color infoSubtle;

  // -- Accent --
  /// The one decorative hue, for category tiles and highlights that carry no
  /// status meaning. Use `primary` for brand and the status roles for state.
  final Color accent;
  final Color accentSubtle;

  // -- Media --
  /// Overlay base for content on photos and video (viewers, hero headers).
  /// Same in both themes because the photo, not the theme, sets the backdrop.
  final Color scrim;

  /// Icons and text drawn on a [scrim].
  final Color onScrim;

  // -- Effect --
  /// Box-shadow colour, alpha already applied. Always black-based (shadows are
  /// occlusion, not brand), but stronger in dark mode where less contrast is
  /// available against the surface.
  final Color shadow;

  // ---------------------------------------------------------------------------
  // Legacy aliases.
  //
  // The pre-migration field names, kept so the ~85 existing call sites keep
  // compiling while feature screens are converted. Prefer the role names above
  // in new code; these will be removed once the burn-down finishes.
  // ---------------------------------------------------------------------------

  @Deprecated('Use primary')
  Color get primaryColor => primary;
  @Deprecated('Use success')
  Color get successColor => success;
  @Deprecated('Use warning')
  Color get warningColor => warning;
  @Deprecated('Use info')
  Color get infoColor => info;

  /// Was teal in both themes, which made Delete look identical to Confirm.
  /// Now correctly red — this is a deliberate behaviour change.
  @Deprecated('Use danger')
  Color get destructiveColor => danger;

  @Deprecated('Use bg')
  Color get scaffoldBg => bg;
  @Deprecated('Use surface')
  Color get cardBg => surface;
  @Deprecated('Use surfaceAlt')
  Color get surfaceAltBg => surfaceAlt;
  @Deprecated('Use surface')
  Color get navBarBg => surface;
  @Deprecated('Use surfaceAlt')
  Color get academicRowBg => surfaceAlt;
  @Deprecated('Use dangerSubtle')
  Color get logoutButtonBg => dangerSubtle;
  @Deprecated('Use surfaceAlt')
  Color get iconContainerBg => surfaceAlt;

  // ---------------------------------------------------------------------------

  /// Neutrals are teal-tinted rather than pure grey so the UI reads as one
  /// system. `text` is #14211F rather than pure black — #000 on white causes
  /// halation and looks harsh on OLED.
  static const light = AppColors(
    primary: Color(0xFF26A69A),
    primaryPressed: Color(0xFF004D40),
    primarySubtle: Color(0xFFE0F2F1),
    onPrimary: Color(0xFFFFFFFF),
    text: Color(0xFF14211F),
    textMuted: Color(0xFF5A6B68),
    textSubtle: Color(0xFF8A9997),
    textInverse: Color(0xFFEAF0EF),
    bg: Color(0xFFF7F9F9),
    surface: Color(0xFFFFFFFF),
    surfaceAlt: Color(0xFFEFF4F3),
    surfaceInverse: Color(0xFF14211F),
    border: Color(0xFFE2E8E7),
    borderStrong: Color(0xFFC9D4D2),
    success: Color(0xFF15803D),
    onSuccess: Color(0xFFFFFFFF),
    successSubtle: Color(0xFFDCFCE7),
    warning: Color(0xFFB45309),
    onWarning: Color(0xFFFFFFFF),
    warningSubtle: Color(0xFFFEF3C7),
    danger: Color(0xFFD93036),
    onDanger: Color(0xFFFFFFFF),
    dangerSubtle: Color(0xFFFEE2E2),
    info: Color(0xFF4338CA),
    onInfo: Color(0xFFFFFFFF),
    infoSubtle: Color(0xFFE0E7FF),
    accent: Color(0xFF8B5CF6),
    accentSubtle: Color(0xFFEDE9FE),
    scrim: Color(0xFF000000),
    onScrim: Color(0xFFFFFFFF),
    shadow: Color(0x14000000),
  );

  /// The dark primary stays #4DB6AC: it has enough luminance to sit on both
  /// #F7F9F9 and #101414, so "primary" keeps the same identity across themes
  /// instead of flipping between a dark and a light colour.
  static const dark = AppColors(
    primary: Color(0xFF4DB6AC),
    primaryPressed: Color(0xFF26A69A),
    primarySubtle: Color(0xFF1F3B38),
    onPrimary: Color(0xFF06201D),
    text: Color(0xFFEAF0EF),
    textMuted: Color(0xFF9AAAA7),
    textSubtle: Color(0xFF6E7E7B),
    textInverse: Color(0xFF14211F),
    bg: Color(0xFF101414),
    surface: Color(0xFF1A1F1F),
    surfaceAlt: Color(0xFF232929),
    surfaceInverse: Color(0xFFEAF0EF),
    border: Color(0xFF2A3130),
    borderStrong: Color(0xFF3C4544),
    success: Color(0xFF4ADE80),
    onSuccess: Color(0xFF052E16),
    successSubtle: Color(0xFF14321F),
    warning: Color(0xFFFBBF24),
    onWarning: Color(0xFF2A1A05),
    warningSubtle: Color(0xFF3A2A0B),
    danger: Color(0xFFFF6369),
    onDanger: Color(0xFF2E0709),
    dangerSubtle: Color(0xFF3D1F22),
    info: Color(0xFF818CF8),
    onInfo: Color(0xFF14133A),
    infoSubtle: Color(0xFF232152),
    accent: Color(0xFFA78BFA),
    accentSubtle: Color(0xFF2A2150),
    scrim: Color(0xFF000000),
    onScrim: Color(0xFFFFFFFF),
    shadow: Color(0x40000000),
  );

  @override
  ThemeExtension<AppColors> copyWith({
    Color? primary,
    Color? primaryPressed,
    Color? primarySubtle,
    Color? onPrimary,
    Color? text,
    Color? textMuted,
    Color? textSubtle,
    Color? textInverse,
    Color? bg,
    Color? surface,
    Color? surfaceAlt,
    Color? surfaceInverse,
    Color? border,
    Color? borderStrong,
    Color? success,
    Color? onSuccess,
    Color? successSubtle,
    Color? warning,
    Color? onWarning,
    Color? warningSubtle,
    Color? danger,
    Color? onDanger,
    Color? dangerSubtle,
    Color? info,
    Color? onInfo,
    Color? infoSubtle,
    Color? accent,
    Color? accentSubtle,
    Color? scrim,
    Color? onScrim,
    Color? shadow,
  }) {
    return AppColors(
      primary: primary ?? this.primary,
      primaryPressed: primaryPressed ?? this.primaryPressed,
      primarySubtle: primarySubtle ?? this.primarySubtle,
      onPrimary: onPrimary ?? this.onPrimary,
      text: text ?? this.text,
      textMuted: textMuted ?? this.textMuted,
      textSubtle: textSubtle ?? this.textSubtle,
      textInverse: textInverse ?? this.textInverse,
      bg: bg ?? this.bg,
      surface: surface ?? this.surface,
      surfaceAlt: surfaceAlt ?? this.surfaceAlt,
      surfaceInverse: surfaceInverse ?? this.surfaceInverse,
      border: border ?? this.border,
      borderStrong: borderStrong ?? this.borderStrong,
      success: success ?? this.success,
      onSuccess: onSuccess ?? this.onSuccess,
      successSubtle: successSubtle ?? this.successSubtle,
      warning: warning ?? this.warning,
      onWarning: onWarning ?? this.onWarning,
      warningSubtle: warningSubtle ?? this.warningSubtle,
      danger: danger ?? this.danger,
      onDanger: onDanger ?? this.onDanger,
      dangerSubtle: dangerSubtle ?? this.dangerSubtle,
      info: info ?? this.info,
      onInfo: onInfo ?? this.onInfo,
      infoSubtle: infoSubtle ?? this.infoSubtle,
      accent: accent ?? this.accent,
      accentSubtle: accentSubtle ?? this.accentSubtle,
      scrim: scrim ?? this.scrim,
      onScrim: onScrim ?? this.onScrim,
      shadow: shadow ?? this.shadow,
    );
  }

  @override
  ThemeExtension<AppColors> lerp(
    covariant ThemeExtension<AppColors>? other,
    double t,
  ) {
    if (other is! AppColors) return this;
    return AppColors(
      primary: Color.lerp(primary, other.primary, t)!,
      primaryPressed: Color.lerp(primaryPressed, other.primaryPressed, t)!,
      primarySubtle: Color.lerp(primarySubtle, other.primarySubtle, t)!,
      onPrimary: Color.lerp(onPrimary, other.onPrimary, t)!,
      text: Color.lerp(text, other.text, t)!,
      textMuted: Color.lerp(textMuted, other.textMuted, t)!,
      textSubtle: Color.lerp(textSubtle, other.textSubtle, t)!,
      textInverse: Color.lerp(textInverse, other.textInverse, t)!,
      bg: Color.lerp(bg, other.bg, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceAlt: Color.lerp(surfaceAlt, other.surfaceAlt, t)!,
      surfaceInverse: Color.lerp(surfaceInverse, other.surfaceInverse, t)!,
      border: Color.lerp(border, other.border, t)!,
      borderStrong: Color.lerp(borderStrong, other.borderStrong, t)!,
      success: Color.lerp(success, other.success, t)!,
      onSuccess: Color.lerp(onSuccess, other.onSuccess, t)!,
      successSubtle: Color.lerp(successSubtle, other.successSubtle, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      onWarning: Color.lerp(onWarning, other.onWarning, t)!,
      warningSubtle: Color.lerp(warningSubtle, other.warningSubtle, t)!,
      danger: Color.lerp(danger, other.danger, t)!,
      onDanger: Color.lerp(onDanger, other.onDanger, t)!,
      dangerSubtle: Color.lerp(dangerSubtle, other.dangerSubtle, t)!,
      info: Color.lerp(info, other.info, t)!,
      onInfo: Color.lerp(onInfo, other.onInfo, t)!,
      infoSubtle: Color.lerp(infoSubtle, other.infoSubtle, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      accentSubtle: Color.lerp(accentSubtle, other.accentSubtle, t)!,
      scrim: Color.lerp(scrim, other.scrim, t)!,
      onScrim: Color.lerp(onScrim, other.onScrim, t)!,
      shadow: Color.lerp(shadow, other.shadow, t)!,
    );
  }
}

/// The accessor. `context.colors.primary` — 21 characters, shorter than
/// `Colors.white`.
///
/// That is not a cosmetic detail: the previous accessor was
/// `Theme.of(context).appColors.primaryColor` at 44 characters, and it lost to
/// `Colors.white` in 91% of files. A design system only holds if the correct
/// call is also the easiest one to type.
extension AppColorsX on BuildContext {
  AppColors get colors => Theme.of(this).extension<AppColors>()!;
}

/// Legacy accessor, kept so existing `Theme.of(context).appColors` call sites
/// keep working during the burn-down.
extension AppColorScheme on ThemeData {
  @Deprecated('Use context.colors instead')
  AppColors get appColors => extension<AppColors>()!;
}
