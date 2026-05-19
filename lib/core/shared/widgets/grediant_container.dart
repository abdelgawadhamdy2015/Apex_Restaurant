import 'package:apex_restaurant/core/theme/colors.dart';
import 'package:flutter/material.dart';

class GradientContainer extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final Widget child;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;

  const GradientContainer({
    super.key,
    this.appBar,
    required this.child,
    this.floatingActionButton,
    this.bottomNavigationBar,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: ColorManger.mainBlueGrediant),
      child: child,
    );
  }
}
