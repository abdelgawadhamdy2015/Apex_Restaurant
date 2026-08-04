import 'package:flutter/material.dart';

class AppRadioGroup<T> extends StatelessWidget {
  const AppRadioGroup({
    super.key,
    required this.groupValue,
    required this.value,
    required this.label,
    required this.onChanged,
    this.enabled = true,
  });

  final T value;
  final T? groupValue;
  final Widget label;
  final ValueChanged<T?> onChanged;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return RadioGroup<T>(
      groupValue: groupValue,
      onChanged: enabled ? onChanged : (_) {},
      child: InkWell(
        onTap: enabled ? () => onChanged(value) : null,
        borderRadius: BorderRadius.circular(8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(child: label),
            const SizedBox(width: 8),

            Radio<T>(value: value),
          ],
        ),
      ),
    );
  }
}
