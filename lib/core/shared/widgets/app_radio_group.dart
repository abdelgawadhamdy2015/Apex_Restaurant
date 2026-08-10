import 'package:apex_restaurant/core/themes/app_colors.dart';
import 'package:flutter/material.dart';

class AppRadioGroup<T> extends StatelessWidget {
  const AppRadioGroup({
    super.key,
    required this.groupValue,
    required this.value,
    required this.label,
    required this.onChanged,
    this.enabled = true,
    this.selectedColor,
    this.unselectedColor,
  });

  final T value;
  final T? groupValue;
  final Widget label;
  final ValueChanged<T?> onChanged;
  final bool enabled;

  final Color? selectedColor;
  final Color? unselectedColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return RadioGroup<T>(
      groupValue: groupValue,
      onChanged: enabled ? onChanged : (_) {},
      child: InkWell(
        onTap: enabled ? () => onChanged(value) : null,
        borderRadius: BorderRadius.circular(8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Radio<T>(
              enabled: enabled,
              value: value,
              fillColor: WidgetStateProperty.resolveWith<Color>((states) {
                if (states.contains(WidgetState.disabled)) {
                  return AppColors.grey;
                }

                if (states.contains(WidgetState.selected)) {
                  return selectedColor ?? theme.colorScheme.primary;
                }

                return unselectedColor ?? theme.colorScheme.onPrimary;
              }),
            ),
            const SizedBox(width: 8),
            Flexible(child: label),
          ],
        ),
      ),
    );
  }
}
