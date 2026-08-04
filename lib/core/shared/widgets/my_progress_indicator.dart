import 'package:apex_restaurant/core/themes/app_colors.dart';
import 'package:flutter/material.dart';

class MyProgressIndicator extends StatefulWidget {
  const MyProgressIndicator({super.key, this.scale});
  final double? scale;

  @override
  State<MyProgressIndicator> createState() => _MyProgressIndicatorState();
}

class _MyProgressIndicatorState extends State<MyProgressIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool isPlaying = false;
  int maxDuration = 2;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        color: AppColors.primaryLight,
        value: _controller.value,
      ),
    );
  }
}
