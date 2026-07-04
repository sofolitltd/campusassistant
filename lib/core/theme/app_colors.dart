import 'package:flutter/material.dart';

@immutable
class AppColors extends ThemeExtension<AppColors> {
  final Color academicRowBg;
  final Color logoutButtonBg;
  final Color iconContainerBg;

  const AppColors({
    required this.academicRowBg,
    required this.logoutButtonBg,
    required this.iconContainerBg,
  });

  static const light = AppColors(
    academicRowBg: Color(0xFFF5F6FA),
    logoutButtonBg: Color(0xFFFFEBEE),
    iconContainerBg: Color(0xFFF5F5F5),
  );

  static const dark = AppColors(
    academicRowBg: Color(0xFF2A2D38),
    logoutButtonBg: Color(0xFF3D1F2A),
    iconContainerBg: Color(0xFF363944),
  );

  @override
  ThemeExtension<AppColors> copyWith({
    Color? academicRowBg,
    Color? logoutButtonBg,
    Color? iconContainerBg,
  }) {
    return AppColors(
      academicRowBg: academicRowBg ?? this.academicRowBg,
      logoutButtonBg: logoutButtonBg ?? this.logoutButtonBg,
      iconContainerBg: iconContainerBg ?? this.iconContainerBg,
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
    );
  }
}

extension AppColorScheme on ThemeData {
  AppColors get appColors => extension<AppColors>()!;
}
