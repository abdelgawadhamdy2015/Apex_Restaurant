import 'package:apex_restaurant/featchers/cart/data/models/invoice_request.dart';

import '../di/debandancy_injection.dart';
import 'routes.dart';
import '../shared/widgets/settings_screen.dart';
import '../../featchers/cart/data/models/cart_screen_args.dart';
import '../../featchers/cart/data/models/pos_client_model.dart';
import '../../featchers/cart/presentation/ui/screens/add_customer_screen.dart';
import '../../featchers/cart/presentation/ui/screens/cart_screen.dart';
import '../../featchers/more_actions/presentation/screens/cashier_custody.dart';
import '../../featchers/more_actions/presentation/screens/custody_log_screen.dart';
import '../../featchers/more_actions/presentation/screens/returns_screen.dart';
import '../../featchers/home/presentation/pages/home_page.dart';
import '../../featchers/login/presentation/bloc/auth_bloc.dart';
import '../../featchers/login/presentation/pages/forget_password_page.dart';
import '../../featchers/login/presentation/pages/login_page.dart';
import '../../featchers/onboarding/presentation/pages/onboarding_page.dart';
import '../../featchers/orders/presentation/bloc/orders_bloc.dart';
import '../../featchers/orders/presentation/pages/orders_screen.dart';
import '../../featchers/payment/presentation/screens/payment_screen.dart';
import '../../featchers/pos/presentation/pages/pos_page.dart';
import '../../featchers/tables/data/models/tables_screen_arg.dart';
import '../../featchers/tables/presentation/bloc/tables_bloc.dart';
import '../../featchers/tables/presentation/pages/tables_screen.dart';
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
          return HomePage(changeLanguage: changeLanguage);
        },
      ),
      GoRoute(
        path: Routes.posScreen,
        name: Routes.posScreen,
        builder: (context, state) {
          return PosPage(changeLanguage: changeLanguage);
        },
      ),
      GoRoute(
        path: Routes.cartScreen,
        name: Routes.cartScreen,
        builder: (context, state) {
          final extra = state.extra as CartScreenArgs?;

          return CartScreen(args: extra);
        },
      ),
      GoRoute(
        path: Routes.addCustomerScreen,
        name: Routes.addCustomerScreen,
        builder: (context, state) {
          final extra = state.extra as PosClientModel?;
          return AddCustomerScreen(selectedPerson: extra);
        },
      ),
      GoRoute(
        path: Routes.paymentScreen,
        name: Routes.paymentScreen,
        builder: (context, state) {
          final saveRestaurantPosInvoiceRequest =
              state.extra as SaveRestaurantPosInvoiceRequest;
          return PaymentScreen(
            invoiceRequestModel: saveRestaurantPosInvoiceRequest,
          );
        },
      ),

      GoRoute(
        path: Routes.ordersScreen,
        name: Routes.ordersScreen,
        builder: (context, state) {
          return BlocProvider(
            create: (context) => getIt<OrdersBloc>(),
            child: OrdersScreen(),
          );
        },
      ),
      GoRoute(
        path: Routes.tableScreen,
        name: Routes.tableScreen,
        builder: (context, state) {
          final args = state.extra as TablesScreenArgs;

          return BlocProvider(
            create: (_) => getIt<TablesBloc>(),
            child: TablesScreen(
              branchId: args.branchId,
              personList: args.personList,
              inCartScreen: args.inCartScreen,
            ),
          );
        },
      ),
      GoRoute(
        path: Routes.cashierCustodyScreen,
        name: Routes.cashierCustodyScreen,
        builder: (context, state) {
          return const CashierCustodyScreen();
        },
      ),
      GoRoute(
        path: Routes.custodyLogScreen,
        name: Routes.custodyLogScreen,
        builder: (context, state) {
          return const CustodyLogScreen();
        },
      ),
      GoRoute(
        path: Routes.returnsScreen,
        name: Routes.returnsScreen,
        builder: (context, state) {
          return const ReturnsScreen();
        },
      ),
      GoRoute(
        path: Routes.settingsScreen,
        name: Routes.settingsScreen,
        builder: (context, state) {
          return const SettingsScreen();
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
