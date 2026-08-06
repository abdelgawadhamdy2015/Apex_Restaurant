import 'package:apex_restaurant/core/helpers/extensions.dart';
import 'package:apex_restaurant/featchers/payment/presentation/bloc/payment_bloc.dart';
import 'package:apex_restaurant/featchers/payment/presentation/bloc/payment_event.dart';
import 'package:apex_restaurant/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Editable field for the amount paid by the customer.
class PaidAmountInputField extends StatelessWidget {
  const PaidAmountInputField({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;
    final state = context.watch<PaymentBloc>().state;
    final lang = S.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          lang.amountPaid,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSecondary,
          ),
        ),
        SizedBox(height: spacing.xs),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: theme.colorScheme.primary, width: 1.5),
            borderRadius: BorderRadius.circular(spacing.radiusMd),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  initialValue: state.paidAmount.toStringAsFixed(2),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.start,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    suffix: Text(
                      lang.currencySarShort,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  onChanged: (val) {
                    final parsed = double.tryParse(val) ?? 0.0;
                    context.read<PaymentBloc>().add(
                      UpdatePaidAmountEvent(parsed),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
