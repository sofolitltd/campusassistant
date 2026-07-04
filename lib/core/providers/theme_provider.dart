import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:campusassistant/features/auth/presentation/providers/auth_provider.dart';

class ThemeNotifier extends Notifier<ThemeMode> {
  static const _key = 'theme_mode';

  @override
  ThemeMode build() {
    _loadTheme();
    return ThemeMode.system;
  }

  Future<void> _loadTheme() async {
    final secureStorage = ref.read(secureStorageProvider);
    final savedTheme = await secureStorage.read(key: _key);
    if (savedTheme != null) {
      final mode = ThemeMode.values.firstWhere(
        (e) => e.name == savedTheme,
        orElse: () => ThemeMode.system,
      );
      state = mode;
    }
  }

  Future<void> setTheme(ThemeMode mode) async {
    state = mode;
    final secureStorage = ref.read(secureStorageProvider);
    await secureStorage.write(key: _key, value: mode.name);
  }
}

final themeProvider = NotifierProvider<ThemeNotifier, ThemeMode>(ThemeNotifier.new);
