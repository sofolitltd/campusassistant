import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';
import 'tokens/app_elevation.dart';
import 'tokens/app_radius.dart';
import 'tokens/app_spacing.dart';

/// Cached Outfit font family so GoogleFonts.outfit() is called only once.
final TextTheme _outfitTextTheme = GoogleFonts.outfitTextTheme();

ThemeData buildLightTheme() {
  final colors = AppColors.light;
  final colorScheme = ColorScheme.fromSeed(
    seedColor: colors.primaryColor,
    brightness: Brightness.light,
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    cardColor: colors.cardBg,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    scaffoldBackgroundColor: colors.scaffoldBg,
    dividerColor: colorScheme.outlineVariant,
    extensions: const [AppColors.light],
    textTheme: ThemeData.light().textTheme.apply(
      fontFamily: _outfitTextTheme.bodyMedium?.fontFamily,
    ),
    buttonTheme: const ButtonThemeData(alignedDropdown: true),

    // --- Input ---
    inputDecorationTheme: InputDecorationTheme(
      isDense: true,
      filled: true,
      fillColor: colors.surfaceAltBg,
      hintStyle: TextStyle(color: Colors.grey.shade400),
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
        borderSide: BorderSide(color: Colors.grey.shade300, width: 0.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(RadiusToken.lg),
        borderSide: BorderSide(color: colors.primaryColor, width: 1.5),
      ),
    ),

    // --- Buttons ---
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 48),
        backgroundColor: colors.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        visualDensity: VisualDensity.compact,
        textStyle: TextStyle(
          fontFamily: _outfitTextTheme.labelLarge?.fontFamily,
          fontWeight: FontWeight.bold,
          fontSize: 15,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(RadiusToken.lg),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(48, 48),
        visualDensity: VisualDensity.compact,
        foregroundColor: colors.primaryColor,
        side: BorderSide(color: colorScheme.outline),
        textStyle: TextStyle(
          fontFamily: _outfitTextTheme.labelLarge?.fontFamily,
          fontWeight: FontWeight.w500,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(RadiusToken.lg),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        minimumSize: const Size(48, 48),
        visualDensity: VisualDensity.compact,
        foregroundColor: colors.primaryColor,
        textStyle: TextStyle(
          fontFamily: _outfitTextTheme.labelLarge?.fontFamily,
          fontWeight: FontWeight.w500,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(RadiusToken.lg),
        ),
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: colors.primaryColor,
      foregroundColor: Colors.white,
    ),

    // --- Cards ---
    cardTheme: CardThemeData(
      color: colors.cardBg,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(RadiusToken.xl),
      ),
    ),

    // --- AppBar ---
    appBarTheme: AppBarTheme(
      backgroundColor: colors.primaryColor,
      surfaceTintColor: Colors.transparent,
      centerTitle: true,
      elevation: 0,
      titleTextStyle: TextStyle(
        fontFamily: _outfitTextTheme.headlineSmall?.fontFamily,
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      iconTheme: IconThemeData(color: Colors.white),
    ),

    // --- Navigation ---
    navigationBarTheme: NavigationBarThemeData(
      indicatorColor: colors.primaryColor,
      backgroundColor: colors.navBarBg,
      height: 64,
    ),
    navigationRailTheme: NavigationRailThemeData(
      backgroundColor: colorScheme.surface,
    ),

    // --- Dialogs & Sheets ---
    dialogTheme: DialogThemeData(
      backgroundColor: colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(RadiusToken.lg),
      ),
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(RadiusToken.lg),
        ),
      ),
      elevation: ElevationToken.lg,
    ),

    // --- Menus ---
    menuTheme: MenuThemeData(
      style: MenuStyle(
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(RadiusToken.md),
          ),
        ),
        elevation: WidgetStatePropertyAll(ElevationToken.lg),
      ),
    ),

    // --- Dividers ---
    dividerTheme: DividerThemeData(
      color: colorScheme.outlineVariant,
      thickness: 0.5,
      space: 0,
      indent: Spacing.lg,
    ),

    // --- Progress ---
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: colorScheme.primary,
      linearTrackColor: colorScheme.surfaceContainerHighest,
    ),

    // --- SnackBar ---
    snackBarTheme: SnackBarThemeData(
      backgroundColor: colorScheme.onSurface,
      contentTextStyle: TextStyle(color: colorScheme.surface),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(RadiusToken.md),
      ),
    ),

    // --- ListTile ---
    listTileTheme: ListTileThemeData(
      iconColor: colorScheme.onSurfaceVariant,
      contentPadding: const EdgeInsets.symmetric(horizontal: Spacing.lg),
    ),

    // --- Chip ---
    chipTheme: ChipThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(RadiusToken.sm),
      ),
    ),

    // --- Tabs ---
    tabBarTheme: TabBarThemeData(
      indicatorColor: colorScheme.primary,
      labelColor: colorScheme.primary,
      unselectedLabelColor: colorScheme.onSurfaceVariant,
      labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
      indicatorSize: TabBarIndicatorSize.tab,
    ),

    // --- Tooltip ---
    tooltipTheme: TooltipThemeData(
      textStyle: TextStyle(color: colorScheme.onPrimary),
      decoration: BoxDecoration(
        color: colorScheme.onSurface,
        borderRadius: BorderRadius.circular(RadiusToken.sm),
      ),
    ),
  );
}

ThemeData buildDarkTheme() {
  final colors = AppColors.dark;
  final colorScheme = ColorScheme.fromSeed(
    seedColor: colors.primaryColor,
    brightness: Brightness.dark,
  );

  final ColorScheme darkColorScheme = colorScheme.copyWith(
    surface: colors.cardBg,
    surfaceContainerHighest: colors.surfaceAltBg,
    onSurface: const Color(0xFFE8E9ED),
    onSurfaceVariant: const Color(0xFFB0B0B0),
    outline: const Color(0xFF333333),
    outlineVariant: const Color(0xFF2E2E2E),
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: darkColorScheme,
    cardColor: colors.cardBg,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    scaffoldBackgroundColor: colors.scaffoldBg,
    dividerColor: const Color(0xFF2E2E2E),
    extensions: const [AppColors.dark],
    textTheme: ThemeData.dark().textTheme.apply(
      fontFamily: _outfitTextTheme.bodyMedium?.fontFamily,
    ),
    buttonTheme: const ButtonThemeData(alignedDropdown: true),

    // --- Input ---
    inputDecorationTheme: InputDecorationTheme(
      isDense: true,
      filled: true,
      fillColor: colors.surfaceAltBg,
      hintStyle: const TextStyle(color: Color(0xFF888888)),
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
        borderSide: const BorderSide(color: Color(0xFF333333), width: 0.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(RadiusToken.lg),
        borderSide: BorderSide(color: colors.primaryColor, width: 1.5),
      ),
    ),

    // --- Buttons ---
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 48),
        backgroundColor: colors.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        visualDensity: VisualDensity.compact,
        textStyle: TextStyle(
          fontFamily: _outfitTextTheme.labelLarge?.fontFamily,
          fontWeight: FontWeight.bold,
          fontSize: 15,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(RadiusToken.lg),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(48, 48),
        visualDensity: VisualDensity.compact,
        foregroundColor: colors.primaryColor,
        side: const BorderSide(color: Color(0xFF333333)),
        textStyle: TextStyle(
          fontFamily: _outfitTextTheme.labelLarge?.fontFamily,
          fontWeight: FontWeight.w500,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(RadiusToken.lg),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        minimumSize: const Size(48, 48),
        visualDensity: VisualDensity.compact,
        foregroundColor: colors.primaryColor,
        textStyle: TextStyle(
          fontFamily: _outfitTextTheme.labelLarge?.fontFamily,
          fontWeight: FontWeight.w500,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(RadiusToken.lg),
        ),
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: colors.primaryColor,
      foregroundColor: Colors.white,
    ),

    // --- Cards ---
    cardTheme: CardThemeData(
      color: colors.cardBg,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(RadiusToken.xl),
      ),
    ),

    // --- AppBar ---
    appBarTheme: AppBarTheme(
      backgroundColor: colors.primaryColor,
      surfaceTintColor: Colors.transparent,
      centerTitle: true,
      elevation: 0,
      titleTextStyle: TextStyle(
        fontFamily: _outfitTextTheme.headlineSmall?.fontFamily,
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      iconTheme: IconThemeData(color: Colors.white),
    ),

    // --- Navigation ---
    navigationBarTheme: NavigationBarThemeData(
      indicatorColor: colors.primaryColor,
      backgroundColor: colors.navBarBg,
      height: 64,
    ),
    navigationRailTheme: NavigationRailThemeData(backgroundColor: colors.navBarBg),

    // --- Dialogs & Sheets ---
    dialogTheme: DialogThemeData(
      backgroundColor: colors.cardBg,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(RadiusToken.xl),
      ),
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: colors.cardBg,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(RadiusToken.xl),
        ),
      ),
      elevation: 0,
    ),

    // --- Menus ---
    menuTheme: MenuThemeData(
      style: MenuStyle(
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(RadiusToken.lg),
          ),
        ),
        elevation: WidgetStatePropertyAll(ElevationToken.lg),
      ),
    ),

    // --- Dividers ---
    dividerTheme: DividerThemeData(
      color: const Color(0xFF2E2E2E),
      thickness: 0.5,
      space: 0,
      indent: Spacing.lg,
    ),

    // --- Progress ---
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: colors.primaryColor,
      linearTrackColor: colors.surfaceAltBg,
    ),

    // --- SnackBar ---
    snackBarTheme: SnackBarThemeData(
      backgroundColor: colors.cardBg,
      contentTextStyle: TextStyle(color: darkColorScheme.onSurface),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(RadiusToken.lg),
      ),
    ),

    // --- ListTile ---
    listTileTheme: ListTileThemeData(
      iconColor: darkColorScheme.onSurfaceVariant,
      contentPadding: const EdgeInsets.symmetric(horizontal: Spacing.lg),
    ),

    // --- Chip ---
    chipTheme: ChipThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(RadiusToken.md),
      ),
    ),

    // --- Tabs ---
    tabBarTheme: TabBarThemeData(
      indicatorColor: colors.primaryColor,
      labelColor: colors.primaryColor,
      unselectedLabelColor: darkColorScheme.onSurfaceVariant,
      labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
      indicatorSize: TabBarIndicatorSize.tab,
    ),

    // --- Tooltip ---
    tooltipTheme: TooltipThemeData(
      textStyle: TextStyle(color: Colors.white),
      decoration: BoxDecoration(
        color: colors.cardBg,
        borderRadius: BorderRadius.circular(RadiusToken.md),
      ),
    ),
  );
}
