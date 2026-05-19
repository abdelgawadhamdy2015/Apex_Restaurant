import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class LocationServiceProvider with ChangeNotifier {
  StreamSubscription<ServiceStatus>? _serviceStatusSubscription;
  bool _isLocationServiceEnabled = true;

  bool get isLocationServiceEnabled => _isLocationServiceEnabled;

  LocationServiceProvider() {
    _init();
  }

  Future<void> _init() async {
    // Check initial location service status
    _isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();
    notifyListeners();

    // Request permission
    await _checkAndRequestLocationPermission();

    // Monitor location service status
    _serviceStatusSubscription = Geolocator.getServiceStatusStream().listen(
      (ServiceStatus status) {
        _isLocationServiceEnabled = status == ServiceStatus.enabled;
        notifyListeners();
      },
    );
  }

  Future<void> _checkAndRequestLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        _isLocationServiceEnabled = false;
        notifyListeners();
      }
    }
  }

  @override
  void dispose() {
    _serviceStatusSubscription?.cancel();
    super.dispose();
  }
}
