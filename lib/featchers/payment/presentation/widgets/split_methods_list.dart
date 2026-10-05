import 'package:apex_restaurant/featchers/payment/data/model/payment_method_response_model.dart';
import 'package:flutter/material.dart';

import '../../../../core/helpers/extensions.dart';
import 'split_amount_field.dart';

/// List of payment methods with individual amount inputs, shown when the
/// user picks the "split" payment tab.
class SplitMethodsList extends StatelessWidget {
  const SplitMethodsList({super.key, required this.paymentMethods});

  final List<PaymentMethodResponseModel> paymentMethods;

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;

    if (paymentMethods.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: paymentMethods
          .map(
            (paymentMethod) => Padding(
              padding: EdgeInsets.only(bottom: spacing.sm),
              child: SplitMethodRow(paymentMethod: paymentMethod),
            ),
          )
          .toList(),
    );
  }
}

/// A single payment method row with an amount input.
class SplitMethodRow extends StatelessWidget {
  const SplitMethodRow({super.key, required this.paymentMethod});

  final PaymentMethodResponseModel paymentMethod;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;

    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final paymentMethodId = paymentMethod.paymentMethodId;

    final title = isArabic
        ? paymentMethod.arabicName ?? ''
        : paymentMethod.latinName ?? '';

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: spacing.md,
        vertical: spacing.xs,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.onSurface,
        borderRadius: BorderRadius.circular(spacing.radiusMd),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Row(
        children: [
          Icon(
            _getPaymentIcon(paymentMethod),
            color: _getPaymentColor(paymentMethod),
          ),

          SizedBox(width: spacing.sm),

          Expanded(
            child: Text(
              title,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          if (paymentMethodId != null)
            SizedBox(
              width: 100,
              child: SplitAmountField(
                key: ValueKey('split_$paymentMethodId'),
                paymentMethodId: paymentMethodId,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: theme.colorScheme.surface,
                  hintText: '0.00',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(spacing.radiusSm),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: spacing.sm,
                    vertical: spacing.xs,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  IconData _getPaymentIcon(PaymentMethodResponseModel paymentMethod) {
    switch (paymentMethod.paymentMethodId) {
      case 1:
        return Icons.payments_outlined;

      case 2:
        return Icons.credit_card;

      case 3:
        return Icons.account_balance;

      case 4:
        return Icons.sync_alt;

      default:
        return Icons.payment;
    }
  }

  Color _getPaymentColor(PaymentMethodResponseModel paymentMethod) {
    switch (paymentMethod.paymentMethodId) {
      case 1:
        return Colors.orange;

      case 2:
        return Colors.blue;

      case 3:
        return Colors.indigo;

      case 4:
        return Colors.black87;

      default:
        return Colors.grey;
    }
  }
}
