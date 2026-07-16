import 'package:apex_restaurant/core/helpers/helper_methods.dart';
import 'package:apex_restaurant/core/shared/widgets/mytextfile.dart';
import 'package:flutter/material.dart';

class DateTextField extends StatelessWidget {
  final String? label;
  final TextEditingController controller;
  final VoidCallback onTap;
  final bool isDate;

  const DateTextField({
    super.key,
    this.label,
    required this.controller,
    required this.onTap,
    this.isDate = true,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          HelperMethods.verticalSpacing(.01),
        ],
        MyTextForm(
          controller: controller,
          readOnly: true,
          onTap: onTap,
          textAlign: TextAlign.center,
          excep: label,
          contentPadding: const EdgeInsets.only(right: 4),
          hintStyle: textTheme.bodyMedium,
          inputTextStyle: textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
          suffixIcon: Icon(isDate ? Icons.calendar_today : Icons.access_time),
        ),
      ],
    );
  }
}
