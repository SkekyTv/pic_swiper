import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'theme_mode_repository.g.dart';

const _themeModePrefsKey = 'theme_mode';

abstract interface class ThemeModeRepository {
  Future<ThemeMode> readThemeMode();

  Future<void> saveThemeMode(ThemeMode mode);
}

class SharedPreferencesThemeModeRepository implements ThemeModeRepository {
  @override
  Future<ThemeMode> readThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString(_themeModePrefsKey);
    return ThemeMode.values.firstWhere(
      (mode) => mode.name == stored,
      orElse: () => ThemeMode.system,
    );
  }

  @override
  Future<void> saveThemeMode(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeModePrefsKey, mode.name);
  }
}

@riverpod
ThemeModeRepository themeModeRepository(Ref ref) {
  return SharedPreferencesThemeModeRepository();
}
