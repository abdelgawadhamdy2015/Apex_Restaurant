import 'package:apex_restaurant/no_internet_screen.dart';
import 'package:flutter/material.dart';

class NetworkBanner extends StatelessWidget {
  final bool isOffline;
  const NetworkBanner({super.key, required this.isOffline});

  @override
  Widget build(BuildContext context) {
    if (!isOffline) return const SizedBox.shrink();
    return NoInternetScreen();
  }
}
