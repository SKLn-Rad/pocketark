import 'package:go_router/go_router.dart';

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
];

final GoRouter kRouter = GoRouter(
  routes: kRoutes,
);
