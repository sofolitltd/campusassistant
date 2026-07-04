import 'package:flutter/material.dart';

/// Custom `ThemeExtension` colors beyond what `ColorScheme` provides.
@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.academicRowBg,
    required this.logoutButtonBg,
    required this.iconContainerBg,
    required this.successColor,
    required this.warningColor,
    required this.infoColor,
  });

  // -- Existing slots --
  final Color academicRowBg;
  final Color logoutButtonBg;
  final Color iconContainerBg;

  // -- New semantic slots --
  final Color successColor;
  final Color warningColor;
  final Color infoColor;

  static const light = AppColors(
    academicRowBg: Color(0xFFF5F6FA),
    logoutButtonBg: Color(0xFFFFEBEE),
    iconContainerBg: Color(0xFFF5F5F5),
    successColor: Color(0xFF22C55E),
    warningColor: Color(0xFFF59E0B),
    infoColor: Color(0xFF3B82F6),
  );

  static const dark = AppColors(
    academicRowBg: Color(0xFF2A2D38),
    logoutButtonBg: Color(0xFF3D1F2A),
    iconContainerBg: Color(0xFF363944),
    successColor: Color(0xFF4ADE80),
    warningColor: Color(0xFFFBBF24),
    infoColor: Color(0xFF60A5FA),
  );

  @override
  ThemeExtension<AppColors> copyWith({
    Color? academicRowBg,
    Color? logoutButtonBg,
    Color? iconContainerBg,
    Color? successColor,
    Color? warningColor,
    Color? infoColor,
  }) {
    return AppColors(
      academicRowBg: academicRowBg ?? this.academicRowBg,
      logoutButtonBg: logoutButtonBg ?? this.logoutButtonBg,
      iconContainerBg: iconContainerBg ?? this.iconContainerBg,
      successColor: successColor ?? this.successColor,
      warningColor: warningColor ?? this.warningColor,
      infoColor: infoColor ?? this.infoColor,
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
      successColor: Color.lerp(successColor, o.successColor, t)!,
      warningColor: Color.lerp(warningColor, o.warningColor, t)!,
      infoColor: Color.lerp(infoColor, o.infoColor, t)!,
    );
  }
}

extension AppColorScheme on ThemeData {
  AppColors get appColors => extension<AppColors>()!;
}
