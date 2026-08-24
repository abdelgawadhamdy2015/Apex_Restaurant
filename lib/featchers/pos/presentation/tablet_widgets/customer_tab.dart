import 'package:flutter/material.dart';

class PosTabletCustomerTab extends StatelessWidget {
  const PosTabletCustomerTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'قائمة العملاء',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
