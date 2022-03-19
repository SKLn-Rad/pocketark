import 'package:go_router/go_router.dart';

import '../views/splash/views/splash_view.dart';

final List<GoRoute> kRoutes = <GoRoute>[
  GoRoute(
    path: '/',
    builder: (_, __) => const SplashView(),
  ),
];

final GoRouter kRouter = GoRouter(
  routes: kRoutes,
);
