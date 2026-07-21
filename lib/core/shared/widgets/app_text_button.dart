import 'package:apex_restaurant/core/themes/app_colors.dart';
import 'package:flutter/material.dart';

class AppButtonText extends StatelessWidget {
  final double? borderRadius;
  final Color? backgroundColor;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;
  final String buttonText;
  final VoidCallback? onPressed;
  final LinearGradient? linearGradient;
  final IconData? icon;
  final TextStyle? textStyle;

  const AppButtonText({
    super.key,
    this.borderRadius,
    this.backgroundColor,
    this.padding,
    this.width,
    this.height,
    required this.buttonText,
    required this.onPressed,
    this.linearGradient,
    this.icon,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    final resolvedTextStyle =
        textStyle ??
        Theme.of(context).textTheme.labelLarge?.copyWith(color: Colors.white);

    return SizedBox(
      width: width,
      height: height ?? 48,
      child: DecoratedBox(
        decoration: linearGradient != null
            ? BoxDecoration(
                borderRadius: BorderRadius.circular(borderRadius ?? 8),
                gradient: linearGradient,
              )
            : const BoxDecoration(),
        child: TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(
            backgroundColor: linearGradient == null
                ? (onPressed != null
                      ? backgroundColor ?? AppColors.primary
                      : AppColors.textSecondary)
                : Colors.transparent,
            padding:
                padding ??
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius ?? 8),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(buttonText, style: resolvedTextStyle),
              if (icon != null) ...[
                const SizedBox(width: 8),
                Icon(
                  icon,
                  color: resolvedTextStyle?.color ?? Colors.white,
                  size: resolvedTextStyle?.fontSize,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
