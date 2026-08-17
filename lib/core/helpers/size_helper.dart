import 'dart:developer';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class SizeHelper {
  static double? _width;
  static double? _height;
  static bool _isTablet = false;

  static double? get width => _width;
  static double? get height => _height;
  static bool get isTablet => _isTablet;
  static bool get isMobile => !_isTablet;

  static void init(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    _width = mediaQuery.size.width;
    _height = mediaQuery.size.height;

    // Standard Flutter tablet detection based on shortest side (600dp threshold)
    _isTablet = mediaQuery.size.shortestSide >= 600;

    log("Width: $_width, Height: $_height, IsTablet: $_isTablet");

    _applyOrientationLock();
  }

  static void _applyOrientationLock() {
    if (_isTablet) {
      // Lock Tablets to Landscape Only
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    } else {
      // Allow Mobile to rotate freely (or restrict to portrait + landscape)
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    }
  }
}
