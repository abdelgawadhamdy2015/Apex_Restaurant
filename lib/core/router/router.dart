import 'package:apex_restaurant/core/di/debandancy_injection.dart';
import 'package:apex_restaurant/core/router/routes.dart';
import 'package:apex_restaurant/core/shared/widgets/location_service_provider.dart';
import 'package:apex_restaurant/featchers/home/presentation/ui/home_screen.dart';
import 'package:apex_restaurant/featchers/login/presentation/providers/auth_bloc.dart';
import 'package:apex_restaurant/featchers/login/ui/forget_password_screen.dart';
import 'package:apex_restaurant/featchers/login/ui/login_screen.dart';
import 'package:apex_restaurant/featchers/onboarding/presentation/ui/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class AppRouter {
  final Function(Locale) changeLanguage;

  AppRouter(this.changeLanguage);

  late final GoRouter router = GoRouter(
    initialLocation: Routes.onBoardingScreen,
    debugLogDiagnostics: true,

    routes: [
      GoRoute(
        path: Routes.onBoardingScreen,
        name: Routes.onBoardingScreen,
        builder: (context, state) {
          return BlocProvider(
            create: (_) => getIt<AuthBloc>(),
            child: const OnBoardingScreen(),
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

              ChangeNotifierProvider<LocationServiceProvider>(
                create: (_) => LocationServiceProvider(),
              ),
            ],
            child: LoginScreen(changeLanguage: changeLanguage),
          );
        },
      ),

      GoRoute(
        path: Routes.forgetPasswordScreen,
        name: Routes.forgetPasswordScreen,
        builder: (context, state) {
          return BlocProvider(
            create: (_) => getIt<AuthBloc>(),
            child: ForgetPasswordScreen(changeLanguage: changeLanguage),
          );
        },
      ),

      GoRoute(
        path: Routes.homeScreen,
        name: Routes.homeScreen,
        builder: (context, state) {
          return BlocProvider(
            create: (_) => getIt<AuthBloc>(),
            child: const HomeScreen(),
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
