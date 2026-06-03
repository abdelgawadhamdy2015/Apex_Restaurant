import 'package:apex_restaurant/core/helpers/restaurant_constants.dart';
import 'package:apex_restaurant/core/router/router.dart';
import 'package:apex_restaurant/core/theme/app_theme.dart';
import 'package:apex_restaurant/core/theme/size_config.dart';
import 'package:apex_restaurant/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

double? originalDevicePixelRatio;
final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

// test
class ApexRestaurantApp extends StatefulWidget {
  const ApexRestaurantApp({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<ApexRestaurantApp> {
  // final FCMService _fcmService = FCMService();
  late final AppRouter _appRouter;
  // static const platform = MethodChannel(
  //   RestaurantConstants.methodChannelMapKey,
  // );
  Locale _locale = Locale(Intl.defaultLocale ?? RestaurantConstants.arabic);
  late S lang;
  void changeLanguage(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  // Future<void> sendApiKeyToNative() async {
  //   // String? apiKey = dotenv.env['GOOGLE_MAPS_API_KEY'];
  //   if (Platform.isIOS) {
  //     try {
  //       await platform.invokeMethod('setApiKey', {"apiKey": Env.mapApiKey});
  //       log(Env.mapApiKey);
  //     } on PlatformException catch (e, stackTrace) {
  //       CrashlyticsLogger.logError(
  //         screen: "Apex Attendance App",
  //         error: e,
  //         stackTrace: stackTrace,
  //       );
  //       if (kDebugMode) {
  //         print("Failed to send API Key: ${e.message}");
  //       }
  //     }
  //   }
  // }

  // Future<void> _initializeServices() async {
  //   // Initialize FCM for push notifications (offline)
  //   await _fcmService.initialize();

  //   // Initialize SignalR for real-time notifications (online)
  // }

  @override
  void initState() {
    super.initState();
    // sendApiKeyToNative();
    //  _initializeServices();
    _appRouter = AppRouter(changeLanguage);

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
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
          locale: _locale, // Keep your dynamic locale
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
    );
  }
}
