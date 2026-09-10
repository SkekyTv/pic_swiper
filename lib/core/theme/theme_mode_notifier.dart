import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'theme_mode_repository.dart';

part 'theme_mode_notifier.g.dart';

@riverpod
class ThemeModeNotifier extends _$ThemeModeNotifier {
  @override
  Future<ThemeMode> build() {
    final repository = ref.watch(themeModeRepositoryProvider);
    return repository.readThemeMode();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = AsyncData(mode);
    final repository = ref.read(themeModeRepositoryProvider);
    await repository.saveThemeMode(mode);
  }
}
