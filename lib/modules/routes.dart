// ignore_for_file: unnecessary_lambdas

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qlevar_router/qlevar_router.dart';

import '../blocs/authentication/authentication_bloc.dart';
import '../common/deferred_loader/deferred_loader.dart';
import '../constants/screens.dart';
import 'auth/login/login.screen.dart' deferred as log_in;
import 'dashboard/dashboard_screen.dart' deferred as dashboard;
import 'landing/landing_screen.dart' deferred as landing;
import 'splash/splash_screen.dart';

class AppRouter {
  static void initialize() {
    QR.settings.pagesType = const QMaterialPage();

    QR.setUrlStrategy();
  }

  static List<QRoute> allRoutes() {
    return <QRoute>[
      QRoute(
        path: Screens.splash,
        name: Screens.splash,
        builder: () => const SplashScreen(),
      ),
      QRoute(
        path: Screens.landing,
        name: Screens.landing,
        builder: () => landing.LandingScreen(),
        middleware: [
          DeferredLoader(landing.loadLibrary),
        ],
      ),
      QRoute(
        path: Screens.logIn,
        name: Screens.logIn,
        builder: () => BlocProvider<AuthenticationBloc>(
          create: (_) => AuthenticationBloc.instance(),
          child: log_in.LogInScreen(),
        ),
        middleware: [
          DeferredLoader(log_in.loadLibrary),
        ],
      ),
      QRoute(
        path: Screens.dashboard,
        name: Screens.dashboard,
        builder: () => dashboard.DashboardScreen(),
        middleware: [
          DeferredLoader(dashboard.loadLibrary),
        ],
      ),
    ];
  }
}
