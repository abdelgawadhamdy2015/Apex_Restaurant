import '../../helpers/restaurant_constants.dart';
import 'package:flutter/material.dart';

class BodyContainer extends StatelessWidget {
  final Widget child;
  final double? height;
  final EdgeInsetsGeometry? padding;

  const BodyContainer({
    super.key,
    required this.child,
    this.height,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      height: height,
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(RestaurantConstants.containerRadius),
          topRight: Radius.circular(RestaurantConstants.containerRadius),
        ),
      ),
      child: child,
    );
  }
}
