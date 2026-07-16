import 'package:apex_restaurant/core/di/debandancy_injection.dart';
import 'package:apex_restaurant/core/helpers/restaurant_constants.dart';
import 'package:apex_restaurant/core/router/router.dart';
import 'package:apex_restaurant/core/settings/app_accent_colors.dart';
import 'package:apex_restaurant/core/settings/settings_cubit.dart';
import 'package:apex_restaurant/core/settings/settings_state.dart';
import 'package:apex_restaurant/core/themes/app_theme.dart';
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
  // ignore: library_private_types_in_public_api
  _ApexRestaurantAppState createState() => _ApexRestaurantAppState();
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

                // 🌗 THEME (FULLY DYNAMIC)
                theme: AppTheme.theme(
                  settings.fontScale.scale,
                  accent: settings.accentColor.color,
                ),

                darkTheme: AppTheme.darkTheme(
                  settings.fontScale.scale,
                  accent: settings.accentColor.color,
                ),
                themeMode: settings.themeMode,

                // 🌍 LOCALE
                locale: _locale,

                localizationsDelegates: const [
                  S.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: S.delegate.supportedLocales,
              );
            },
          );
        },
      ),
    );
  }
}
