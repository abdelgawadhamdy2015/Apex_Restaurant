import 'package:apex_restaurant/featchers/more_actions/presentation/bloc/more_actions_bloc.dart';
import 'package:apex_restaurant/featchers/orders/presentation/bloc/orders_bloc.dart';
import 'package:apex_restaurant/featchers/tables/presentation/bloc/tables_bloc.dart';

import 'core/di/debandancy_injection.dart';
import 'core/helpers/restaurant_constants.dart';
import 'core/helpers/size_helper.dart';
import 'core/router/router.dart';
import 'core/settings/app_accent_colors.dart';
import 'core/settings/settings_cubit.dart';
import 'core/settings/settings_state.dart';
import 'core/themes/app_theme.dart';
import 'featchers/cart/presentation/bloc/cart_bloc.dart';
import 'featchers/home/presentation/bloc/home_bloc.dart';
import 'featchers/payment/presentation/bloc/payment_bloc.dart';
import 'featchers/pos/presentation/bloc/pos_bloc.dart';
import 'generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

double? originalDevicePixelRatio;
final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

class ApexRestaurantApp extends StatefulWidget {
  const ApexRestaurantApp({super.key});

  @override
  State<ApexRestaurantApp> createState() => _ApexRestaurantAppState();
}

class _ApexRestaurantAppState extends State<ApexRestaurantApp> {
  late final AppRouter _appRouter;
  Locale _locale = Locale(Intl.defaultLocale ?? RestaurantConstants.arabic);
  bool _isOrientationInitialized = false;

  @override
  void initState() {
    super.initState();
    _appRouter = AppRouter(changeLanguage);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }

  void changeLanguage(Locale locale) async {
    Intl.defaultLocale = locale.languageCode;
    await S.load(locale);

    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Initialize orientation logic once using MediaQuery
    if (!_isOrientationInitialized) {
      SizeHelper.init(context);
      _isOrientationInitialized = true;
    }

    return MultiBlocProvider(
      providers: [
        BlocProvider<CartBloc>(create: (_) => getIt<CartBloc>()),
        BlocProvider<HomeBloc>(create: (_) => getIt<HomeBloc>()),
        BlocProvider<PosBloc>(create: (_) => getIt<PosBloc>()),
        BlocProvider(create: (_) => getIt<PaymentBloc>()),
        BlocProvider(create: (_) => getIt<OrdersBloc>()),
        BlocProvider(create: (_) => getIt<TablesBloc>()),
        BlocProvider(create: (_) => getIt<MoreActionsBloc>()),

        BlocProvider<SettingsCubit>(create: (_) => getIt<SettingsCubit>()),
      ],
      child: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, settings) {
          return ScreenUtilInit(
            // Adjust design size conditionally if tablet design specs differ
            designSize: SizeHelper.isTablet
                ? const Size(1024, 768)
                : const Size(393, 852),
            minTextAdapt: false,
            splitScreenMode: true,
            builder: (context, child) {
              return MaterialApp.router(
                scaffoldMessengerKey: scaffoldMessengerKey,
                debugShowCheckedModeBanner: false,
                routerConfig: _appRouter.router,

                // 🌗 DYNAMIC THEME MODES & SCALING
                themeMode: settings.themeMode,

                theme: AppTheme.theme(
                  settings.fontScale.scale,
                  accent: settings.accentColor.color,
                  spacingScale: settings.uiScale.scale,
                  iconScale: settings.iconScale.scale,
                ),
                darkTheme: AppTheme.darkTheme(
                  settings.fontScale.scale,
                  accent: settings.accentColor.color,
                  spacingScale: settings.uiScale.scale,
                  iconScale: settings.iconScale.scale,
                ),

                // 🌍 LOCALE CONFIGURATION
                locale: _locale,
                localizationsDelegates: const [
                  S.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: S.delegate.supportedLocales,

                // 🔄 INJECT SETTINGS INTO CONTEXT FOR EXTENSIONS
                builder: (context, child) {
                  return MediaQuery(
                    data: MediaQuery.of(context).copyWith(
                      textScaler: TextScaler.linear(settings.fontScale.scale),
                    ),
                    child: SettingsInheritedNotifier(
                      settings: settings,
                      child: child ?? const SizedBox.shrink(),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

/// Helper InheritedWidget to make SettingsState easily accessible across extensions
class SettingsInheritedNotifier extends InheritedWidget {
  final SettingsState settings;

  const SettingsInheritedNotifier({
    super.key,
    required this.settings,
    required super.child,
  });

  static SettingsState of(BuildContext context) {
    final result = context
        .dependOnInheritedWidgetOfExactType<SettingsInheritedNotifier>();
    return result?.settings ?? const SettingsState();
  }

  @override
  bool updateShouldNotify(SettingsInheritedNotifier oldWidget) {
    return settings != oldWidget.settings;
  }
}
