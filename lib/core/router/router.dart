import 'package:apex_restaurant/core/di/debandancy_injection.dart';
import 'package:apex_restaurant/core/router/routes.dart';
import 'package:apex_restaurant/featchers/home/presentation/bloc/home_bloc.dart';
import 'package:apex_restaurant/featchers/home/presentation/pages/home_page.dart';
import 'package:apex_restaurant/featchers/login/presentation/bloc/auth_bloc.dart';
import 'package:apex_restaurant/featchers/login/presentation/pages/forget_password_page.dart';
import 'package:apex_restaurant/featchers/login/presentation/pages/login_page.dart';
import 'package:apex_restaurant/featchers/onboarding/presentation/pages/onboarding_page.dart';
import 'package:apex_restaurant/featchers/pos/presentation/pages/pos_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class AppRouter {
  final Function(Locale) changeLanguage;
  static final navigatorKey = GlobalKey<NavigatorState>();

  AppRouter(this.changeLanguage);

  late final GoRouter router = GoRouter(
    initialLocation: Routes.onBoardingScreen,
    debugLogDiagnostics: true,
    navigatorKey: navigatorKey,
    routes: [
      GoRoute(
        path: Routes.onBoardingScreen,
        name: Routes.onBoardingScreen,
        builder: (context, state) {
          return BlocProvider(
            create: (_) => getIt<AuthBloc>(),
            child: const OnBoardingPage(),
          );
        },
      ),
      GoRoute(
        path: Routes.loginScreen,
        name: Routes.loginScreen,
        builder: (context, state) {
          return MultiProvider(
            providers: [
              BlocProvider<AuthBloc>(create: (_) => getIt<AuthBloc>()),
            ],
            child: LoginPage(changeLanguage: changeLanguage),
          );
        },
      ),

      GoRoute(
        path: Routes.forgetPasswordScreen,
        name: Routes.forgetPasswordScreen,
        builder: (context, state) {
          return BlocProvider(
            create: (_) => getIt<AuthBloc>(),
            child: ForgetPasswordPage(changeLanguage: changeLanguage),
          );
        },
      ),

      GoRoute(
        path: Routes.homeScreen,
        name: Routes.homeScreen,
        builder: (context, state) {
          return BlocProvider(
            create: (_) => getIt<HomeBloc>(),
            child: const HomePage(),
          );
        },
      ),
      GoRoute(
        path: Routes.posScreen,
        name: Routes.posScreen,
        builder: (context, state) {
          return BlocProvider(
            create: (_) => getIt<AuthBloc>(),
            child: const PosPage(),
          );
        },
      ),
    ],

    errorBuilder: (context, state) {
      return Scaffold(
        body: Center(child: Text('No route defined for ${state.uri}')),
      );
    },
  );
}
