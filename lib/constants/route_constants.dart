import 'package:go_router/go_router.dart';
import 'package:pocketark/views/home/views/home_view.dart';

import '../views/terms/views/terms_view.dart';
import '../views/splash/views/splash_view.dart';

final List<GoRoute> kRoutes = <GoRoute>[
  GoRoute(
    path: '/',
    builder: (_, __) => const SplashView(),
  ),
  GoRoute(
    path: '/terms',
    builder: (_, __) => const TermsView(),
  ),
  GoRoute(
    path: '/home',
    builder: (_, __) => const HomeView(),
  ),
];

final GoRouter kRouter = GoRouter(
  routes: kRoutes,
);
