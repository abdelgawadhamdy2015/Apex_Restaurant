import 'package:apex_restaurant/core/helpers/extensions.dart';
import 'package:apex_restaurant/generated/l10n.dart';
import 'package:flutter/material.dart';

enum DateTextFieldType { date, time, dateTime }

class DateTextField extends StatelessWidget {
  final String? label;
  final TextEditingController controller;
  final VoidCallback onTap;
  final DateTextFieldType type;

  const DateTextField({
    super.key,
    this.label,
    required this.controller,
    required this.onTap,
    this.type = DateTextFieldType.date,
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
            style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          SizedBox(height: context.spacing.sm),
        ],
        TextFormField(
          controller: controller,
          readOnly: true,
          onTap: onTap,
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            hintText: S.of(context).selectDateAndTimeError,
            contentPadding: const EdgeInsets.only(right: 4),
            hintStyle: textTheme.bodyMedium,
            suffixIcon: Icon(_suffixIcon),
          ),
        ),
      ],
    );
  }

  /// Helper method to pick DateTime (Date then Time sequentially)
  static Future<DateTime?> pickDateTime(
    BuildContext context, {
    DateTime? initialDate,
  }) async {
    final now = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate ?? now,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate == null || !context.mounted) return null;

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initialDate ?? now),
    );

    if (pickedTime == null) return null;

    return DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );
  }
}
