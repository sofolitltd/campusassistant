import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';
import 'tokens/app_elevation.dart';
import 'tokens/app_radius.dart';
import 'tokens/app_spacing.dart';

/// Brand primary color used as the Material 3 seed.
const Color _brandPrimary = Color(0xFF6C7BFF);

/// Cached Outfit font family so GoogleFonts.outfit() is called only once.
final TextTheme _outfitTextTheme = GoogleFonts.outfitTextTheme();

ThemeData buildLightTheme() {
  final colorScheme = ColorScheme.fromSeed(
    seedColor: _brandPrimary,
    brightness: Brightness.light,
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    cardColor: colorScheme.surface,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    scaffoldBackgroundColor: const Color(0xFFFAFAFA),
    dividerColor: colorScheme.outlineVariant,
    extensions: const [AppColors.light],
    textTheme: ThemeData.light().textTheme.apply(
      fontFamily: _outfitTextTheme.bodyMedium?.fontFamily,
    ),
    buttonTheme: const ButtonThemeData(alignedDropdown: true),

    // --- Input ---
    inputDecorationTheme: InputDecorationTheme(
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(
        vertical: Spacing.md,
        horizontal: Spacing.md,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(RadiusToken.md),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(RadiusToken.md),
        borderSide: BorderSide(color: colorScheme.outline, width: 0.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(RadiusToken.md),
        borderSide: BorderSide(color: colorScheme.primary, width: 1),
      ),
    ),

    // --- Buttons ---
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(48, 48),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: ElevationToken.sm,
        visualDensity: VisualDensity.compact,
        textStyle: TextStyle(
          fontFamily: _outfitTextTheme.labelLarge?.fontFamily,
          fontWeight: FontWeight.w500,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(RadiusToken.md),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(48, 48),
        visualDensity: VisualDensity.compact,
        foregroundColor: colorScheme.primary,
        side: BorderSide(color: colorScheme.outline),
        textStyle: TextStyle(
          fontFamily: _outfitTextTheme.labelLarge?.fontFamily,
          fontWeight: FontWeight.w500,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(RadiusToken.md),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        minimumSize: const Size(48, 48),
        visualDensity: VisualDensity.compact,
        foregroundColor: colorScheme.primary,
        textStyle: TextStyle(
          fontFamily: _outfitTextTheme.labelLarge?.fontFamily,
          fontWeight: FontWeight.w500,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(RadiusToken.md),
        ),
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: colorScheme.primary,
      foregroundColor: colorScheme.onPrimary,
    ),

    // --- Cards ---
    cardTheme: CardThemeData(
      color: colorScheme.surface,
      elevation: ElevationToken.md,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(RadiusToken.md),
      ),
    ),

    // --- AppBar ---
    appBarTheme: AppBarTheme(
      backgroundColor: colorScheme.surface,
      surfaceTintColor: colorScheme.surface,
      centerTitle: true,
      elevation: 0,
      titleTextStyle: TextStyle(
        fontFamily: _outfitTextTheme.headlineSmall?.fontFamily,
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: colorScheme.onSurface,
      ),
      iconTheme: IconThemeData(color: colorScheme.onSurface),
    ),

    // --- Navigation ---
    navigationBarTheme: NavigationBarThemeData(
      indicatorColor: colorScheme.outlineVariant,
      backgroundColor: colorScheme.surface,
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
      labelStyle: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
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
  final colorScheme = ColorScheme.fromSeed(
    seedColor: _brandPrimary,
    brightness: Brightness.dark,
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme.copyWith(
      // Override surface-related tones to match our app's exact dark palette
      surface: const Color(0xFF323541),
      surfaceContainerHighest: const Color(0xFF363944),
      onSurface: const Color(0xFFE8E9ED),
      onSurfaceVariant: const Color(0xFFBEC0C8),
      outline: const Color(0xFF424550),
      outlineVariant: const Color(0xFF3A3D48),
    ),
    cardColor: const Color(0xFF323541),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    scaffoldBackgroundColor: const Color(0xFF252831),
    dividerColor: const Color(0xFF3A3D48),
    extensions: const [AppColors.dark],
    textTheme: ThemeData.dark().textTheme.apply(
      fontFamily: _outfitTextTheme.bodyMedium?.fontFamily,
    ),
    buttonTheme: const ButtonThemeData(alignedDropdown: true),

    // --- Input ---
    inputDecorationTheme: InputDecorationTheme(
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(
        vertical: Spacing.md,
        horizontal: Spacing.md,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(RadiusToken.md),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(RadiusToken.md),
        borderSide: const BorderSide(color: Color(0xFF424550), width: 0.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(RadiusToken.md),
        borderSide: BorderSide(color: colorScheme.primary, width: 1),
      ),
      fillColor: const Color(0xFF2C2F3A),
      filled: true,
    ),

    // --- Buttons ---
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(48, 48),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: ElevationToken.sm,
        visualDensity: VisualDensity.compact,
        textStyle: TextStyle(
          fontFamily: _outfitTextTheme.labelLarge?.fontFamily,
          fontWeight: FontWeight.w500,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(RadiusToken.md),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(48, 48),
        visualDensity: VisualDensity.compact,
        foregroundColor: colorScheme.primary,
        side: BorderSide(color: colorScheme.outline),
        textStyle: TextStyle(
          fontFamily: _outfitTextTheme.labelLarge?.fontFamily,
          fontWeight: FontWeight.w500,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(RadiusToken.md),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        minimumSize: const Size(48, 48),
        visualDensity: VisualDensity.compact,
        foregroundColor: colorScheme.primary,
        textStyle: TextStyle(
          fontFamily: _outfitTextTheme.labelLarge?.fontFamily,
          fontWeight: FontWeight.w500,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(RadiusToken.md),
        ),
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: colorScheme.primary,
      foregroundColor: colorScheme.onPrimary,
    ),

    // --- Cards ---
    cardTheme: CardThemeData(
      color: const Color(0xFF323541),
      elevation: ElevationToken.md,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(RadiusToken.md),
      ),
    ),

    // --- AppBar ---
    appBarTheme: AppBarTheme(
      backgroundColor: const Color(0xFF2C2F3A),
      surfaceTintColor: Colors.transparent,
      centerTitle: true,
      elevation: 0,
      titleTextStyle: TextStyle(
        fontFamily: _outfitTextTheme.headlineSmall?.fontFamily,
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: colorScheme.onSurface,
      ),
      iconTheme: IconThemeData(color: colorScheme.onSurface),
    ),

    // --- Navigation ---
    navigationBarTheme: NavigationBarThemeData(
      indicatorColor: const Color(0xFF3D4050),
      backgroundColor: const Color(0xFF2C2F3A),
      height: 64,
    ),
    navigationRailTheme: NavigationRailThemeData(
      backgroundColor: const Color(0xFF2C2F3A),
    ),

    // --- Dialogs & Sheets ---
    dialogTheme: DialogThemeData(
      backgroundColor: const Color(0xFF323541),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(RadiusToken.lg),
      ),
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: const Color(0xFF323541),
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
      color: const Color(0xFF3A3D48),
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
      labelStyle: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
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
