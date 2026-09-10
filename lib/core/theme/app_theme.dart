import 'package:flutter/material.dart';

import 'swipe_action_colors.dart';

class AppTheme {
  const AppTheme._();

  static ThemeData light() {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.deepPurple,
        brightness: Brightness.light,
      ),
      extensions: const [SwipeActionColors.light],
    );
  }

  static ThemeData dark() {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.deepPurple,
        brightness: Brightness.dark,
      ),
      extensions: const [SwipeActionColors.dark],
    );
  }
}
