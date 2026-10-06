import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';
import 'tokens/app_control.dart';
import 'tokens/app_elevation.dart';
import 'tokens/app_radius.dart';
import 'tokens/app_spacing.dart';
import '/core/theme/tokens/app_font_size.dart';

/// Cached Outfit font family so GoogleFonts.outfit() is called only once.
final String? _outfitFamily = GoogleFonts.outfit().fontFamily;

ThemeData buildLightTheme() => _buildTheme(AppColors.light, Brightness.light);

ThemeData buildDarkTheme() => _buildTheme(AppColors.dark, Brightness.dark);

ThemeData buildMarketLightTheme() =>
    _withMarketCards(_buildTheme(AppColors.marketLight, Brightness.light));

ThemeData buildMarketDarkTheme() =>
    _withMarketCards(_buildTheme(AppColors.marketDark, Brightness.dark));

/// Gives every Material `Card` in the market the same chrome as the main
/// app's section cards: large radius, hairline outline and a soft shadow.
ThemeData _withMarketCards(ThemeData base) {
  final c = base.extension<AppColors>()!;
  return base.copyWith(
    cardTheme: CardThemeData(
      color: c.surface,
      elevation: 3,
      shadowColor: c.shadow,
      surfaceTintColor: Colors.transparent,
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(RadiusToken.lg),
        side: BorderSide(color: c.border),
      ),
    ),
  );
}

/// Builds a [ColorScheme] by hand from [AppColors].
///
/// Deliberately NOT `ColorScheme.fromSeed`. Seeding hands Material's tonal
/// algorithm control of every role, which is why the brand teal previously
/// arrived on screen as a set of generated tones nobody chose. Every role here
/// maps to a value from the palette instead.
///
/// `ColorScheme` itself can't be avoided — every Material widget reads it — so
/// the goal is to author it rather than escape it. `useMaterial3` stays on:
/// turning it off would revert widget geometry to 2014-era Material, which is
/// a separate (and unwanted) change.
ColorScheme _schemeFrom(AppColors c, Brightness brightness) {
  return ColorScheme(
    brightness: brightness,
    primary: c.primary,
    onPrimary: c.onPrimary,
    primaryContainer: c.primarySubtle,
    onPrimaryContainer: brightness == Brightness.light
        ? c.primaryPressed
        : c.text,
    secondary: c.primary,
    onSecondary: c.onPrimary,
    secondaryContainer: c.primarySubtle,
    onSecondaryContainer: brightness == Brightness.light
        ? c.primaryPressed
        : c.text,
    tertiary: c.info,
    onTertiary: c.onInfo,
    tertiaryContainer: c.infoSubtle,
    onTertiaryContainer: brightness == Brightness.light ? c.info : c.text,
    error: c.danger,
    onError: c.onDanger,
    errorContainer: c.dangerSubtle,
    onErrorContainer: brightness == Brightness.light ? c.danger : c.text,
    surface: c.surface,
    onSurface: c.text,
    surfaceContainerLowest: c.surface,
    surfaceContainerLow: c.bg,
    surfaceContainer: c.surfaceAlt,
    surfaceContainerHigh: c.surfaceAlt,
    surfaceContainerHighest: c.surfaceAlt,
    onSurfaceVariant: c.textMuted,
    outline: c.borderStrong,
    outlineVariant: c.border,
    inverseSurface: c.surfaceInverse,
    onInverseSurface: c.textInverse,
    inversePrimary: c.primarySubtle,
    shadow: const Color(0xFF000000),
    scrim: const Color(0xFF000000),
  );
}

ThemeData _buildTheme(AppColors colors, Brightness brightness) {
  final isLight = brightness == Brightness.light;
  final scheme = _schemeFrom(colors, brightness);
  final baseText = isLight
      ? ThemeData.light().textTheme
      : ThemeData.dark().textTheme;

  return ThemeData(
    useMaterial3: true,
    brightness: brightness,
    colorScheme: scheme,
    // M3 would otherwise derive this as `surface` in dark mode, turning every
    // `Theme.of(context).primaryColor` use grey instead of brand teal.
    primaryColor: colors.primary,
    cardColor: colors.surface,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    scaffoldBackgroundColor: colors.bg,
    dividerColor: colors.border,
    extensions: [colors],
    textTheme: baseText.apply(
      fontFamily: _outfitFamily,
      bodyColor: colors.text,
      displayColor: colors.text,
    ),
    buttonTheme: const ButtonThemeData(alignedDropdown: true),

    // --- Input ---
    inputDecorationTheme: InputDecorationTheme(
      isDense: true,
      filled: true,
      fillColor: colors.surfaceAlt,
      hintStyle: TextStyle(color: colors.textSubtle),
      contentPadding: const EdgeInsets.symmetric(
        vertical: Spacing.md,
        horizontal: Spacing.md,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(RadiusToken.lg),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(RadiusToken.lg),
        borderSide: BorderSide(color: colors.border, width: 0.5),
      ),
      // Without this a disabled field falls back to `border` (none) and
      // loses its outline.
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(RadiusToken.lg),
        borderSide: BorderSide(color: colors.border, width: 0.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(RadiusToken.lg),
        borderSide: BorderSide(color: colors.primary, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(RadiusToken.lg),
        borderSide: BorderSide(color: colors.danger, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(RadiusToken.lg),
        borderSide: BorderSide(color: colors.danger, width: 1.5),
      ),
    ),

    // --- Buttons ---
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, ControlToken.height),
        backgroundColor: colors.primary,
        foregroundColor: colors.onPrimary,
        elevation: 0,
        textStyle: TextStyle(
          fontFamily: _outfitFamily,
          fontWeight: .bold,
          fontSize: FontSizeToken.lg,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(RadiusToken.lg),
        ),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size(64, ControlToken.height),
        elevation: 0,
        textStyle: TextStyle(
          fontFamily: _outfitFamily,
          fontWeight: .bold,
          fontSize: FontSizeToken.lg,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(RadiusToken.lg),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(48, ControlToken.height),
        foregroundColor: colors.primary,
        side: BorderSide(color: colors.primary),
        textStyle: TextStyle(fontFamily: _outfitFamily, fontWeight: .w500),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(RadiusToken.lg),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        minimumSize: const Size(48, ControlToken.height),
        foregroundColor: colors.primary,
        textStyle: TextStyle(fontFamily: _outfitFamily, fontWeight: .w500),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(RadiusToken.lg),
        ),
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: colors.primary,
      foregroundColor: colors.onPrimary,
    ),

    // --- Cards ---
    cardTheme: CardThemeData(
      color: colors.surface,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(RadiusToken.md),
      ),
    ),

    // --- AppBar ---
    appBarTheme: AppBarTheme(
      backgroundColor: colors.primary,
      surfaceTintColor: Colors.transparent,
      centerTitle: true,
      elevation: 0,
      titleTextStyle: TextStyle(
        fontFamily: _outfitFamily,
        fontSize: isLight ? 18 : 16,
        fontWeight: .bold,
        color: colors.onPrimary,
      ),
      iconTheme: IconThemeData(color: colors.onPrimary),
    ),

    // --- Navigation ---
    navigationBarTheme: NavigationBarThemeData(
      indicatorColor: colors.primary,
      backgroundColor: colors.surface,
      height: 64,
    ),
    navigationRailTheme: NavigationRailThemeData(
      backgroundColor: colors.surface,
    ),

    // --- Dialogs & Sheets ---
    dialogTheme: DialogThemeData(
      backgroundColor: colors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          isLight ? RadiusToken.lg : RadiusToken.xl,
        ),
      ),
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: colors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(isLight ? RadiusToken.lg : RadiusToken.xl),
        ),
      ),
      elevation: isLight ? ElevationToken.lg : 0,
    ),

    // --- Menus ---
    menuTheme: MenuThemeData(
      style: MenuStyle(
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              isLight ? RadiusToken.md : RadiusToken.lg,
            ),
          ),
        ),
        elevation: const WidgetStatePropertyAll(ElevationToken.lg),
      ),
    ),

    // --- Dividers ---
    dividerTheme: DividerThemeData(
      color: colors.border,
      thickness: 0.5,
      space: 0,
      indent: Spacing.lg,
    ),

    // --- Progress ---
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: colors.primary,
      linearTrackColor: colors.surfaceAlt,
    ),

    // --- SnackBar ---
    snackBarTheme: SnackBarThemeData(
      backgroundColor: isLight ? colors.surfaceInverse : colors.surface,
      contentTextStyle: TextStyle(
        color: isLight ? colors.textInverse : colors.text,
      ),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          isLight ? RadiusToken.md : RadiusToken.lg,
        ),
      ),
    ),

    // --- ListTile ---
    listTileTheme: ListTileThemeData(
      iconColor: colors.textMuted,
      contentPadding: const EdgeInsets.symmetric(horizontal: Spacing.lg),
    ),

    // --- Chip ---
    chipTheme: ChipThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          isLight ? RadiusToken.sm : RadiusToken.md,
        ),
      ),
    ),

    // --- Tabs ---
    tabBarTheme: TabBarThemeData(
      indicatorColor: colors.primary,
      labelColor: colors.primary,
      unselectedLabelColor: colors.textMuted,
      labelStyle: const TextStyle(
        fontSize: FontSizeToken.sm,
        fontWeight: .w500,
      ),
      indicatorSize: TabBarIndicatorSize.tab,
    ),

    // --- Tooltip ---
    tooltipTheme: TooltipThemeData(
      textStyle: TextStyle(color: isLight ? colors.textInverse : colors.text),
      decoration: BoxDecoration(
        color: isLight ? colors.surfaceInverse : colors.surface,
        borderRadius: BorderRadius.circular(RadiusToken.md),
      ),
    ),
  );
}
