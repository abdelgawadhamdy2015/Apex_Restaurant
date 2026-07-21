import 'package:apex_restaurant/core/di/debandancy_injection.dart';
import 'package:apex_restaurant/core/helpers/restaurant_constants.dart';
import 'package:apex_restaurant/core/router/router.dart';
import 'package:apex_restaurant/core/settings/app_accent_colors.dart';
import 'package:apex_restaurant/core/settings/settings_cubit.dart';
import 'package:apex_restaurant/core/settings/settings_state.dart';
import 'package:apex_restaurant/core/themes/app_theme.dart';
import 'package:apex_restaurant/featchers/cart/presentation/bloc/cart_bloc.dart';
import 'package:apex_restaurant/featchers/home/presentation/bloc/home_bloc.dart';
import 'package:apex_restaurant/generated/l10n.dart';
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
    return MultiBlocProvider(
      providers: [
        BlocProvider<CartBloc>(create: (_) => getIt<CartBloc>()),
        BlocProvider<HomeBloc>(create: (_) => getIt<HomeBloc>()),
        BlocProvider<SettingsCubit>(create: (_) => getIt<SettingsCubit>()),
      ],
      child: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, settings) {
          return ScreenUtilInit(
            designSize: const Size(393, 852),
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
                // This ensures context.spacing and context.iconSizes rebuild automatically
                builder: (context, child) {
                  return MediaQuery(
                    // Scales all system text natively based on fontScale setting
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
