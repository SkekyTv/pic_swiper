import 'package:go_router/go_router.dart';

import '../../features/swipe_page_screen/feature.dart';

final appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      name: 'swipe',
      builder: (context, state) => const SwipePageScreen(),
    ),
  ],
);
