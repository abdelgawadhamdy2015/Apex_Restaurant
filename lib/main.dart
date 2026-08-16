import 'apex_restaurant_app.dart';
import 'core/di/debandancy_injection.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await setupGetIt();

  runApp(const ApexRestaurantApp());
}
