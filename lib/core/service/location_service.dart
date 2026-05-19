import 'dart:developer';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

typedef LocationCallback = void Function(LatLng position);

class LocationService {
  final Location _location = Location();
  static LatLng? lastLocation;

  //make singltone pattern from this class
  static final LocationService _instance = LocationService._internal();
  factory LocationService() {
    return _instance;
  }
  LocationService._internal();

  Future<bool> initLocation({
    required LocationCallback onLocationChanged,
    required LocationCallback onInitialLocation,
    Function(dynamic error)? onError,
  }) async {
    try {
      bool serviceEnabled = await _location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await _location.requestService();
        if (!serviceEnabled) return false;
      }
      log("serviceEnabled : $serviceEnabled");
      PermissionStatus permissionGranted = await _location.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await _location.requestPermission();
        if (permissionGranted != PermissionStatus.granted) return false;
      }
      log("permissionGranted : $permissionGranted");

      final locationData = await _location.getLocation();
      final initialPosition = LatLng(
        locationData.latitude!,
        locationData.longitude!,
      );
      onInitialLocation(initialPosition);
      log('Initial location: $initialPosition');

      _location.onLocationChanged
          .listen((LocationData currentLocation) {
            final currentPosition = LatLng(
              currentLocation.latitude!,
              currentLocation.longitude!,
            );
            double distance = Geolocator.distanceBetween(
              lastLocation!.latitude,
              lastLocation!.longitude,
              currentPosition.latitude,
              currentPosition.longitude,
            );
            log(
              'Location changed: $currentPosition, distance: $distance meters',
            );

            if (distance >= 500) {
              lastLocation = currentPosition;
            }
            onLocationChanged(currentPosition);
          })
          .onError((error) {
            log('Location stream error: $error');
            if (onError != null) onError(error);
          });

      return true;
    } catch (e) {
      log('Error initializing location: $e');
      if (onError != null) onError(e);
      return false;
    }
  }
}
