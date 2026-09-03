import '../../../../core/helpers/extensions.dart';
import '../../../../core/themes/font_weight_helper.dart';
import '../bloc/payment_bloc.dart';
import '../../../../generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Card showing the total amount required for the invoice being paid.
class TotalAmountCard extends StatelessWidget {
  const TotalAmountCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;
    final state = context.watch<PaymentBloc>().state;
    final lang = S.of(context);

    return Container(
      padding: EdgeInsets.all(spacing.md),
      decoration: BoxDecoration(
        color: context.appExtraTheme.totalAmountColor,
        borderRadius: BorderRadius.circular(spacing.radiusMd),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                lang.totalAmountRequired,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSecondary,
                  fontWeight: FontWeightHelper.bold,
                ),
              ),
              Row(
                children: [
                  Text(
                    state.totalAmount.toStringAsFixed(2),
                    style: theme.textTheme.headlineMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: spacing.xs),
                  Text(
                    lang.currencySarShort,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSecondary,
                      fontWeight: FontWeightHelper.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Spacer(),
          Container(
            padding: EdgeInsets.all(spacing.sm),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.receipt_long,
              color: theme.colorScheme.primary,
              size: 28,
            ),
          ),
        ],
      ),
    );
  }
}
