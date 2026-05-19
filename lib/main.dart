import 'package:apex_restaurant/apex_restaurant_app.dart';
import 'package:apex_restaurant/core/di/debandancy_injection.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  setupGetIt();
  runApp(const ApexRestaurantApp());
}
