import 'package:apex_restaurant/core/helpers/helper_methods.dart';
import 'package:apex_restaurant/core/shared/widgets/location_service_provider.dart';
import 'package:apex_restaurant/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class LocationAwareWidget extends StatelessWidget {
  final Widget child;

  LocationAwareWidget({required this.child, super.key});
  bool dialogIsApear = false;
  @override
  Widget build(BuildContext context) {
    return Consumer<LocationServiceProvider>(
      builder: (context, locationService, _) {
        // Listen for location service status changes
        if (!locationService.isLocationServiceEnabled && !dialogIsApear) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (ModalRoute.of(context)?.isCurrent == true) {
              _showLocationDisabledDialog(context);
            }
          });
        }
        return child;
      },
    );
  }

  void _showLocationDisabledDialog(BuildContext context) {
    dialogIsApear = true;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(S.of(context).locationServicesDisabled),
          content: Text(S.of(context).requestLocationPermission),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Geolocator.openLocationSettings();
              },
              child: Text(S.of(context).openSetting),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                HelperMethods.exitApp();
              },
              child: Text(S.of(context).closeApp),
            ),
          ],
        );
      },
    );
  }
}
