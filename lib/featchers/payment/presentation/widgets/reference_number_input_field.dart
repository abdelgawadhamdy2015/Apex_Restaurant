import 'package:apex_restaurant/core/helpers/extensions.dart';
import 'package:apex_restaurant/featchers/payment/presentation/bloc/payment_bloc.dart';
import 'package:apex_restaurant/featchers/payment/presentation/bloc/payment_event.dart';
import 'package:apex_restaurant/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Input field for the card transaction/reference number.
class ReferenceNumberInputField extends StatelessWidget {
  const ReferenceNumberInputField({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;
    final lang = S.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          lang.referenceNumber,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSecondary,
          ),
        ),
        SizedBox(height: spacing.xs),
        TextFormField(
          textAlign: TextAlign.right,
          decoration: InputDecoration(
            hintText: lang.enterTransactionNumber,
            prefixIcon: Icon(
              Icons.subtitles_outlined,
              color: theme.colorScheme.onPrimary,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(spacing.radiusMd),
              borderSide: BorderSide(color: theme.colorScheme.outlineVariant),
            ),
          ),
          onChanged: (val) {
            context.read<PaymentBloc>().add(UpdateReferenceNumberEvent(val));
          },
        ),
      ],
    );
  }
}
