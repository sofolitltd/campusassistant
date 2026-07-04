import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

ThemeData buildLightTheme() {
  final colorScheme = ColorScheme.fromSeed(
    seedColor: Colors.white,
    brightness: Brightness.light,
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    cardColor: Colors.white,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    scaffoldBackgroundColor: const Color.fromARGB(255, 250, 250, 250),
    extensions: const [AppColors.light],
    textTheme: ThemeData.light().textTheme.apply(
      fontFamily: GoogleFonts.outfit().fontFamily,
    ),
    buttonTheme: const ButtonThemeData(alignedDropdown: true),
    inputDecorationTheme: const InputDecorationTheme(
      isDense: true,
      contentPadding: EdgeInsets.symmetric(
        vertical: 10.0,
        horizontal: 12.0,
      ),
      border: OutlineInputBorder(),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(48, 48),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        visualDensity: VisualDensity.compact,
        textStyle: TextStyle(
          fontFamily: GoogleFonts.outfit().fontFamily,
          fontWeight: FontWeight.w400,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(48, 48),
        visualDensity: VisualDensity.compact,
        foregroundColor: Colors.black,
        textStyle: TextStyle(
          fontFamily: GoogleFonts.outfit().fontFamily,
          fontWeight: FontWeight.w500,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        minimumSize: const Size(48, 48),
        visualDensity: VisualDensity.compact,
        foregroundColor: Colors.black,
        textStyle: TextStyle(
          fontFamily: GoogleFonts.outfit().fontFamily,
          fontWeight: FontWeight.w500,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 4,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      centerTitle: false,
      elevation: 0,
      titleTextStyle: GoogleFonts.outfit(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      indicatorColor: Colors.grey.shade200,
      backgroundColor: Colors.white,
      height: 64,
    ),
    navigationRailTheme: const NavigationRailThemeData(
      backgroundColor: Colors.white,
    ),
    dialogTheme: DialogThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Colors.teal,
      foregroundColor: Colors.white,
    ),
  );
}

ThemeData buildDarkTheme() {
  final colorScheme = ColorScheme.dark(
    primary: const Color(0xFF7B8AFF),
    onPrimary: Colors.white,
    primaryContainer: const Color(0xFF2D3154),
    secondary: const Color(0xFF8B9AFF),
    onSecondary: Colors.white,
    surface: const Color(0xFF2C2F3A),
    onSurface: const Color(0xFFE8E9ED),
    surfaceContainerHighest: const Color(0xFF363944),
    onSurfaceVariant: const Color(0xFFBEC0C8),
    outline: const Color(0xFF7A7D89),
    outlineVariant: const Color(0xFF424550),
    error: const Color(0xFFFF6B6B),
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    cardColor: const Color(0xFF323541),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    scaffoldBackgroundColor: const Color(0xFF252831),
    extensions: const [AppColors.dark],
    textTheme: ThemeData.dark().textTheme.apply(
      fontFamily: GoogleFonts.outfit().fontFamily,
    ),
    dividerColor: const Color(0xFF3A3D48),
    buttonTheme: const ButtonThemeData(alignedDropdown: true),
    inputDecorationTheme: InputDecorationTheme(
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(
        vertical: 10.0,
        horizontal: 12.0,
      ),
      border: const OutlineInputBorder(),
      fillColor: const Color(0xFF2C2F3A),
      filled: true,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(48, 48),
        backgroundColor: const Color(0xFF6C7BFF),
        foregroundColor: Colors.white,
        visualDensity: VisualDensity.compact,
        textStyle: TextStyle(
          fontFamily: GoogleFonts.outfit().fontFamily,
          fontWeight: FontWeight.w400,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(48, 48),
        visualDensity: VisualDensity.compact,
        foregroundColor: const Color(0xFF7B8AFF),
        side: const BorderSide(color: Color(0xFF424550)),
        textStyle: TextStyle(
          fontFamily: GoogleFonts.outfit().fontFamily,
          fontWeight: FontWeight.w500,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        minimumSize: const Size(48, 48),
        visualDensity: VisualDensity.compact,
        foregroundColor: const Color(0xFF7B8AFF),
        textStyle: TextStyle(
          fontFamily: GoogleFonts.outfit().fontFamily,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: const Color(0xFF2C2F3A),
      surfaceTintColor: Colors.transparent,
      centerTitle: false,
      elevation: 0,
      titleTextStyle: GoogleFonts.outfit(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: const Color(0xFFE8E9ED),
      ),
    ),
    cardTheme: CardThemeData(
      color: const Color(0xFF323541),
      elevation: 4,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      indicatorColor: const Color(0xFF3D4050),
      backgroundColor: const Color(0xFF2C2F3A),
      height: 64,
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: const Color(0xFF323541),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color(0xFF6C7BFF),
      foregroundColor: Colors.white,
    ),
  );
}
