import 'package:apex_restaurant/core/helpers/extensions.dart';
import 'package:apex_restaurant/generated/l10n.dart';
import 'package:flutter/material.dart';

enum DateTextFieldType { date, time, dateTime }

class DateTextField extends StatelessWidget {
  final String? label;
  final TextEditingController controller;
  final VoidCallback onTap;
  final DateTextFieldType type;
  final Color? fillColor;
  const DateTextField({
    super.key,
    this.label,
    required this.controller,
    required this.onTap,
    this.type = DateTextFieldType.date,
    this.fillColor,
  });

  IconData get _suffixIcon {
    switch (type) {
      case DateTextFieldType.date:
        return Icons.calendar_today;
      case DateTextFieldType.time:
        return Icons.access_time;
      case DateTextFieldType.dateTime:
        return Icons.event_note;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSecondary,
            ),
          ),
          SizedBox(height: context.spacing.sm),
        ],
        TextFormField(
          controller: controller,
          readOnly: true,
          onTap: onTap,
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            fillColor: fillColor ?? theme.colorScheme.surface,
            hintText: S.of(context).selectDateAndTimeError,
            contentPadding: EdgeInsets.symmetric(
              horizontal: context.spacing.xxs,
            ),
            hintStyle: textTheme.bodyMedium,
            prefixIcon: Icon(
              _suffixIcon,
              color: theme.colorScheme.onPrimary,
              size: context.iconSizes.sm,
            ),
          ),
        ),
      ],
    );
  }

  /// Helper method to pick DateTime (Date then Time sequentially).
  ///
  /// No manual [Theme] override is needed here anymore — both
  /// [showDatePicker] and [showTimePicker] automatically inherit the
  /// app's ambient `Theme.of(context)`, which already carries the correct
  /// `datePickerTheme` / `timePickerTheme` for whichever mode (light/dark)
  /// is currently active, via `AppTheme`.
  static Future<DateTime?> pickDateTime(
    BuildContext context, {
    DateTime? initialDate,
    DateTextFieldType? type,
  }) async {
    final now = DateTime.now();
    DateTime? pickedDate;

    if (type == DateTextFieldType.dateTime || type == DateTextFieldType.date) {
      pickedDate = await showDatePicker(
        context: context,
        initialDate: initialDate ?? now,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
      );

      if (pickedDate == null || !context.mounted) return null;

      if (type == DateTextFieldType.date) {
        return pickedDate;
      }
    }

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initialDate ?? now),
    );

    if (pickedTime == null) return null;
    if (type == DateTextFieldType.time) {
      return DateTime(0, 0, 0, pickedTime.hour, pickedTime.minute);
    }
    return DateTime(
      pickedDate!.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );
  }
}
