import 'package:go_router/go_router.dart';
import 'package:photo_manager/photo_manager.dart';

import '../../features/swipe_page_screen/feature.dart';

final appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      name: 'swipe',
      builder: (context, state) => const SwipePageScreen(),
      routes: [
        GoRoute(
          path: 'recap',
          name: 'recap',
          builder: (context, state) =>
              RecapScreen(photos: state.extra! as List<AssetEntity>),
        ),
      ],
    ),
  ],
);
