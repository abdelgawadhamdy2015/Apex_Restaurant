import 'package:apex_restaurant/apex_restaurant_app.dart';
import 'package:apex_restaurant/core/di/debandancy_injection.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await setupGetIt();

  runApp(const ApexRestaurantApp());
}
