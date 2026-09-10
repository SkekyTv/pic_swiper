import 'package:flutter/material.dart';

import '../../../../core/theme/theme.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final swipeColors = Theme.of(context).extension<SwipeActionColors>()!;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.favorite, size: 64, color: swipeColors.keep),
          const SizedBox(height: 16),
          Text(
            'pic-swiper',
            style: TextStyle(
              color: colorScheme.onSurface,
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 32),
          const CircularProgressIndicator(),
        ],
      ),
    );
  }
}
