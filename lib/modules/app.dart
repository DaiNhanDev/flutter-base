// import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:qlevar_router/qlevar_router.dart';

import '../blocs/connectivity/connectivity_bloc.dart';
import '../blocs/language/language_bloc.dart';
import '../blocs/launching/launching_bloc.dart';
import '../blocs/loader/loader_bloc.dart';
import '../blocs/session/session_bloc.dart';
import '../blocs/show_message/show_message_bloc.dart';
import '../common/common.dart';
import '../constants/screens.dart';
import '../global/app_route_observer.dart';
import '../global/app_routing.dart';
import '../global/localization.dart';
import '../theme/default_theme.dart';
import 'app/app_showing/app_showing.dart';
import 'routes.dart';

class Application extends StatelessWidget {
  const Application({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<LanguageBloc>(create: (_) => LanguageBloc.instance()),
          BlocProvider<ConnectivityBloc>(
            create: (_) =>
                ConnectivityBloc.instance()..add(ConnectivityChecked()),
          ),
          BlocProvider<LoaderBloc>(create: (_) => LoaderBloc.instance()),
          BlocProvider<ShowMessageBloc>(
              create: (_) => ShowMessageBloc.instance()),
                      BlocProvider<LaunchingBloc>(
          create: (_) =>
              LaunchingBloc.instance()..add(LaunchingPreloadDataStarted()),
        ),
          BlocProvider<SessionBloc>(create: (_) => SessionBloc.instance()),
        ],
        child: MultiBlocListener(
          listeners: [
            BlocListener<SessionBloc, SessionState>(
              listenWhen: (previous, current) =>
                  current is SessionUserReadyToSetUpMessasing ||
                  current is SessionSignOutSuccess,
              listener: (_, state) async {
                log.info('Session State >> $state');
                if (state is SessionUserReadyToSetUpMessasing) {
                  await Future.delayed(const Duration(seconds: 1));

                  // start to subscribe all user's topics
                } else if (state is SessionSignOutSuccess) {
                  AppRouting().pushReplacementNamed(Screens.logIn);
                }
              },
            )
          ],
          child: BlocBuilder<LanguageBloc, LanguageState>(
            buildWhen: (previousState, state) {
              return state is LanguageInitial || state is LanguageUpdateSuccess;
            },
            builder: (_, languageState) {
              return MaterialApp.router(
              routeInformationParser: const QRouteInformationParser(),
              routerDelegate: QRouterDelegate(
                AppRouter.allRoutes(),
                observers: [
                  AppRouteObserver(),
                ],
                initPath: Screens.splash,
              ),
              localizationsDelegates: const [
                SLocalizationsDelegate(),
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: languageState.supportedLocales,
              locale: languageState.locale,
              title: 'Boilerplate Web App',
              theme: DefaultTheme().build(context),
              debugShowCheckedModeBanner: false,
              restorationScopeId: 'Boilerplate Web App',
              builder: (context, child) => AppShowing(app: child!),
              scaffoldMessengerKey: AppRouting().scaffoldMessengerState,
              );
            },
          ),
        ));
  }
}
