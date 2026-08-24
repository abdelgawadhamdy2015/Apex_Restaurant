import 'package:apex_restaurant/apex_restaurant_app.dart';
import 'package:apex_restaurant/core/di/debandancy_injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupGetIt();
  // Determine physical screen size before UI builds
  final window = WidgetsBinding.instance.platformDispatcher.views.first;
  final size = window.physicalSize / window.devicePixelRatio;
  final isTablet = size.shortestSide >= 600;

  if (isTablet) {
    // Lock iPad strictly to landscape
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  } else {
    // Allow Mobile to rotate freely
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  runApp(const ApexRestaurantApp());
}
