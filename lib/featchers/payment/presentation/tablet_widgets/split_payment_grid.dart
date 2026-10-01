import 'package:apex_restaurant/core/helpers/extensions.dart';
import 'package:apex_restaurant/featchers/payment/data/model/payment_method_response_model.dart';
import 'package:apex_restaurant/featchers/payment/presentation/bloc/payment_bloc.dart';
import 'package:apex_restaurant/featchers/payment/presentation/bloc/payment_event.dart';
import 'package:apex_restaurant/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// 2-column grid of payment methods with individual amount inputs.
class SplitPaymentGrid extends StatelessWidget {
  const SplitPaymentGrid({super.key, required this.paymentMethods});

  final List<PaymentMethodResponseModel> paymentMethods;

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;

    if (paymentMethods.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        for (int i = 0; i < paymentMethods.length; i += 2)
          Padding(
            padding: EdgeInsets.only(bottom: spacing.sm),
            child: Row(
              children: [
                Expanded(
                  child: _SplitMethodCell(paymentMethod: paymentMethods[i]),
                ),
                SizedBox(width: spacing.sm),
                Expanded(
                  child: i + 1 < paymentMethods.length
                      ? _SplitMethodCell(paymentMethod: paymentMethods[i + 1])
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _SplitMethodCell extends StatelessWidget {
  const _SplitMethodCell({required this.paymentMethod});

  final PaymentMethodResponseModel paymentMethod;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;
    final state = context.select((PaymentBloc bloc) => bloc.state);
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    final title = isArabic
        ? paymentMethod.arabicName ?? ''
        : paymentMethod.latinName ?? '';

    final paymentMethodId = paymentMethod.paymentMethodId;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: spacing.sm,
        vertical: spacing.xs,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.onSurface,
        borderRadius: BorderRadius.circular(spacing.radiusMd),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: InkWell(
              onDoubleTap: paymentMethodId == null
                  ? null
                  : () {
                      context.read<PaymentBloc>().add(
                        UpdateSplitAmountEvent(
                          paymentMethodId: paymentMethodId,
                          amount: state
                              .totalAmount, // Set to total amount on double tap
                        ),
                      );
                    },
              child: TextField(
                controller: TextEditingController(
                  text: paymentMethodId == null
                      ? ''
                      : state.splitAmounts[paymentMethodId]?.toStringAsFixed(
                              2,
                            ) ??
                            '',
                ),
                decoration: InputDecoration(
                  isDense: true,
                  filled: true,
                  fillColor: theme.colorScheme.surface,
                  hintText: '0.00',
                  prefixText: '${S.of(context).currencySarShort} ',
                  prefixStyle: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSecondary,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: spacing.xs,
                    vertical: spacing.xs,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(spacing.radiusSm),
                    borderSide: BorderSide(
                      color: theme.colorScheme.outlineVariant,
                    ),
                  ),
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                onChanged: paymentMethodId == null
                    ? null
                    : (value) {
                        final amount = double.tryParse(value) ?? 0.0;

                        context.read<PaymentBloc>().add(
                          UpdateSplitAmountEvent(
                            paymentMethodId: paymentMethodId,
                            amount: amount,
                          ),
                        );
                      },
              ),
            ),
          ),

          SizedBox(width: spacing.xxs),
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.end,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onPrimary,
              ),
            ),
          ),

          SizedBox(width: spacing.xs),

          Icon(
            _getPaymentIcon(paymentMethodId),
            size: 20,
            color: theme.colorScheme.primary,
          ),
        ],
      ),
    );
  }

  IconData _getPaymentIcon(int? paymentMethodId) {
    switch (paymentMethodId) {
      case 1:
        return Icons.payments_outlined;

      case 2:
        return Icons.credit_card;

      case 3:
        return Icons.account_balance;

      case 4:
        return Icons.sync_alt;

      case 5:
        return Icons.star_border;

      case 6:
        return Icons.card_giftcard_outlined;

      default:
        return Icons.payment;
    }
  }
}
