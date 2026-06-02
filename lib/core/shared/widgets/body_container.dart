import 'package:apex_restaurant/core/helpers/restaurant_constants.dart';
import 'package:apex_restaurant/core/theme/app_theme.dart';
import 'package:apex_restaurant/core/theme/size_config.dart';
import 'package:flutter/material.dart';

class BodyContainer extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final Widget child;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
  final double? height;
  final EdgeInsets? padding;
  const BodyContainer({
    super.key,
    this.appBar,
    required this.child,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.height,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: padding ?? SizeConfig().getScreenPadding(),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(RestaurantConstants.containerRadius),
          topRight: Radius.circular(RestaurantConstants.containerRadius),
        ),
      ),
      child: child,
    );
  }
}
