import 'package:flutter/material.dart';

/// Custom `ThemeExtension` colors beyond what `ColorScheme` provides.
@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.academicRowBg,
    required this.logoutButtonBg,
    required this.iconContainerBg,
    required this.primaryColor,
    required this.successColor,
    required this.warningColor,
    required this.infoColor,
    required this.destructiveColor,
    required this.scaffoldBg,
    required this.cardBg,
    required this.surfaceAltBg,
    required this.navBarBg,
  });

  // -- Existing slots --
  final Color academicRowBg;
  final Color logoutButtonBg;
  final Color iconContainerBg;

  // -- Semantic slots --
  final Color primaryColor;
  final Color successColor;
  final Color warningColor;
  final Color infoColor;
  final Color destructiveColor;

  // -- Background slots --
  final Color scaffoldBg;
  final Color cardBg;
  final Color surfaceAltBg;
  final Color navBarBg;

  static const light = AppColors(
    academicRowBg: Color(0xFFF5F6FA),
    logoutButtonBg: Color(0xFFFFEBEE),
    iconContainerBg: Color(0xFFF5F5F5),
    primaryColor: Color(0xFF4DB6AC),
    successColor: Color(0xFF22C55E),
    warningColor: Color(0xFFF59E0B),
    infoColor: Color(0xFF3B82F6),
    destructiveColor: Color(0xFF00897B),
    scaffoldBg: Color(0xFFF9F9F8),
    cardBg: Colors.white,
    surfaceAltBg: Color(0xFFF5F5F5),
    navBarBg: Colors.white,
  );

  static const dark = AppColors(
    academicRowBg: Color(0xFF2A2D38),
    logoutButtonBg: Color(0xFF3D1F2A),
    iconContainerBg: Color(0xFF363944),
    primaryColor: Color(0xFF4DB6AC),
    successColor: Color(0xFF4ADE80),
    warningColor: Color(0xFFFBBF24),
    infoColor: Color(0xFF60A5FA),
    destructiveColor: Color(0xFF4DB6AC),
    scaffoldBg: Color.fromARGB(255, 18, 18, 18),
    cardBg: Color(0xFF1E1E1E),
    surfaceAltBg: Color(0xFF2A2A2A),
    navBarBg: Color(0xFF1A1A1A),
  );

  @override
  ThemeExtension<AppColors> copyWith({
    Color? academicRowBg,
    Color? logoutButtonBg,
    Color? iconContainerBg,
    Color? primaryColor,
    Color? successColor,
    Color? warningColor,
    Color? infoColor,
    Color? destructiveColor,
    Color? scaffoldBg,
    Color? cardBg,
    Color? surfaceAltBg,
    Color? navBarBg,
  }) {
    return AppColors(
      academicRowBg: academicRowBg ?? this.academicRowBg,
      logoutButtonBg: logoutButtonBg ?? this.logoutButtonBg,
      iconContainerBg: iconContainerBg ?? this.iconContainerBg,
      primaryColor: primaryColor ?? this.primaryColor,
      successColor: successColor ?? this.successColor,
      warningColor: warningColor ?? this.warningColor,
      infoColor: infoColor ?? this.infoColor,
      destructiveColor: destructiveColor ?? this.destructiveColor,
      scaffoldBg: scaffoldBg ?? this.scaffoldBg,
      cardBg: cardBg ?? this.cardBg,
      surfaceAltBg: surfaceAltBg ?? this.surfaceAltBg,
      navBarBg: navBarBg ?? this.navBarBg,
    );
  }

  @override
  ThemeExtension<AppColors> lerp(
    covariant ThemeExtension<AppColors>? other,
    double t,
  ) {
    if (other == null) return this;
    final o = other as AppColors;
    return AppColors(
      academicRowBg: Color.lerp(academicRowBg, o.academicRowBg, t)!,
      logoutButtonBg: Color.lerp(logoutButtonBg, o.logoutButtonBg, t)!,
      iconContainerBg: Color.lerp(iconContainerBg, o.iconContainerBg, t)!,
      primaryColor: Color.lerp(primaryColor, o.primaryColor, t)!,
      successColor: Color.lerp(successColor, o.successColor, t)!,
      warningColor: Color.lerp(warningColor, o.warningColor, t)!,
      infoColor: Color.lerp(infoColor, o.infoColor, t)!,
      destructiveColor: Color.lerp(destructiveColor, o.destructiveColor, t)!,
      scaffoldBg: Color.lerp(scaffoldBg, o.scaffoldBg, t)!,
      cardBg: Color.lerp(cardBg, o.cardBg, t)!,
      surfaceAltBg: Color.lerp(surfaceAltBg, o.surfaceAltBg, t)!,
      navBarBg: Color.lerp(navBarBg, o.navBarBg, t)!,
    );
  }
}

extension AppColorScheme on ThemeData {
  AppColors get appColors => extension<AppColors>()!;
}
