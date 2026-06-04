import 'package:apex_restaurant/core/di/debandancy_injection.dart';
import 'package:apex_restaurant/core/helpers/restaurant_constants.dart';
import 'package:apex_restaurant/core/router/router.dart';
import 'package:apex_restaurant/core/theme/app_theme.dart';
import 'package:apex_restaurant/core/theme/size_config.dart';
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
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<ApexRestaurantApp> {
  late final AppRouter _appRouter;

  Locale _locale = Locale(Intl.defaultLocale ?? RestaurantConstants.arabic);

  // ✅ Fixed: all three steps together
  void changeLanguage(Locale locale) async {
    Intl.defaultLocale = locale.languageCode;
    await S.load(locale);
    setState(() {
      _locale = locale;
    });
  }

  @override
  void initState() {
    super.initState();
    _appRouter = AppRouter(changeLanguage);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider<HomeBloc>(create: (_) => getIt<HomeBloc>())],
      child: ScreenUtilInit(
        designSize: const Size(393, 852),
        minTextAdapt: false,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp.router(
            scaffoldMessengerKey: scaffoldMessengerKey,
            debugShowCheckedModeBanner: false,
            key: const Key("connect"),
            themeMode: ThemeMode.light,
            theme: ThemeData(
              datePickerTheme: DatePickerThemeData(
                dayBackgroundColor: WidgetStatePropertyAll(AppColors.white),
                todayForegroundColor: WidgetStatePropertyAll(AppColors.white),
                todayBackgroundColor: WidgetStatePropertyAll(AppColors.white),
                headerBackgroundColor: Colors.white,
                locale: Locale(RestaurantConstants.english),
                backgroundColor: AppColors.white,
              ),
              textTheme: TextTheme(
                bodyMedium: TextStyle(fontSize: SizeConfig.fontSize3),
                labelMedium: TextStyle(fontSize: SizeConfig.fontSize3),
                titleMedium: TextStyle(fontSize: SizeConfig.fontSize3),
              ),
              fontFamily: RestaurantConstants.cairoFont,
            ),
            locale: _locale,
            localizationsDelegates: const [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: S.delegate.supportedLocales,
            routerConfig: _appRouter.router,
          );
        },
      ),
    );
  }
}
