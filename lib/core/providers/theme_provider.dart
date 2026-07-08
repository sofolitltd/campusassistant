import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:campusassistant/features/auth/presentation/providers/auth_provider.dart';

class ThemeNotifier extends AsyncNotifier<ThemeMode> {
  static const _key = 'theme_mode';

  @override
  Future<ThemeMode> build() async {
    final secureStorage = ref.watch(secureStorageProvider);
    final savedTheme = await secureStorage.read(key: _key);
    if (savedTheme != null) {
      return ThemeMode.values.firstWhere(
        (e) => e.name == savedTheme,
        orElse: () => ThemeMode.system,
      );
    }
    return ThemeMode.system;
  }

  Future<void> setTheme(ThemeMode mode) async {
    state = AsyncValue.data(mode);
    final secureStorage = ref.read(secureStorageProvider);
    await secureStorage.write(key: _key, value: mode.name);
  }
}

final themeProvider =
    AsyncNotifierProvider<ThemeNotifier, ThemeMode>(ThemeNotifier.new);
