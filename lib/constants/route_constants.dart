// Package imports:
import 'package:go_router/go_router.dart';

// Project imports:
import '../views/events/views/events_view.dart';
import '../views/settings/views/settings_view.dart';
import '../views/splash/views/splash_view.dart';
import '../views/terms/views/terms_view.dart';

const String kRoutePathSplash = '/';
const String kRoutePathTerms = '/terms';
const String kRoutePathEvents = '/events';
const String kRoutePathSettings = '/settings';

final List<GoRoute> kRoutes = <GoRoute>[
  GoRoute(
    path: kRoutePathSplash,
    builder: (_, __) => const SplashView(),
  ),
  GoRoute(
    path: kRoutePathTerms,
    builder: (_, __) => const TermsView(),
  ),
  GoRoute(
    path: kRoutePathEvents,
    builder: (_, __) => const EventsView(),
  ),
  GoRoute(
    path: kRoutePathSettings,
    builder: (_, __) => const SettingsView(),
  ),
];

final GoRouter kRouter = GoRouter(
  routes: kRoutes,
);
