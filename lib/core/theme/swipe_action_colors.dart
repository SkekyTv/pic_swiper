import 'package:flutter/material.dart';

@immutable
class SwipeActionColors extends ThemeExtension<SwipeActionColors> {
  const SwipeActionColors({required this.keep, required this.delete});

  final Color keep;
  final Color delete;

  static const light = SwipeActionColors(
    keep: Color(0xFFE53935),
    delete: Color(0xFFFBC02D),
  );

  static const dark = SwipeActionColors(
    keep: Color(0xFFEF5350),
    delete: Color(0xFFFFD54F),
  );

  @override
  SwipeActionColors copyWith({Color? keep, Color? delete}) {
    return SwipeActionColors(
      keep: keep ?? this.keep,
      delete: delete ?? this.delete,
    );
  }

  @override
  SwipeActionColors lerp(ThemeExtension<SwipeActionColors>? other, double t) {
    if (other is! SwipeActionColors) return this;
    return SwipeActionColors(
      keep: Color.lerp(keep, other.keep, t)!,
      delete: Color.lerp(delete, other.delete, t)!,
    );
  }
}
