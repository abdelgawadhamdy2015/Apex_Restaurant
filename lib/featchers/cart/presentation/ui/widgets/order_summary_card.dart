import 'package:apex_restaurant/core/helpers/extensions.dart';
import 'package:apex_restaurant/core/themes/app_colors.dart';
import 'package:apex_restaurant/featchers/cart/data/enums/cart_enum.dart';
import 'package:apex_restaurant/featchers/cart/presentation/bloc/cart_bloc.dart';
import 'package:apex_restaurant/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Shows subtotal, discount, delivery fee (when applicable), VAT and
/// the grand total for the current cart.
class OrderSummaryCard extends StatelessWidget {
  const OrderSummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = context.watch<CartBloc>().state;
    final spacing = context.spacing;
    final lang = S.of(context);
    final showDeliveryFee =
        state.selectedOrderType == CartOrderType.DELIVERY ||
        state.selectedOrderType == CartOrderType.DELIVERY_COMPANY;
    final dineInFee = state.selectedOrderType == CartOrderType.DINE_IN;
    final tobacoActive = state.tobaccoTaxAmount > 0;
    return Container(
      padding: EdgeInsets.all(spacing.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.onSurface,
        borderRadius: BorderRadius.circular(spacing.radiusLg),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Column(
        children: [
          _SummaryRow(
            title: lang.subtotal,
            value: '${state.subtotal.toStringAsFixed(2)} ${lang.currencySar}',
          ),
          SizedBox(height: spacing.xs),
          _SummaryRow(
            title: lang.discountCoupon,
            value:
                '-${state.totalDiscountAmount.toStringAsFixed(2)} ${lang.currencySar}',
            isSuccess: true,
          ),
          if (showDeliveryFee) ...[
            SizedBox(height: spacing.xs),
            _SummaryRow(
              title: lang.deliveryFee,
              value:
                  '${state.settingsModel?.posRestaurant?.deliveryCost?.toStringAsFixed(2) ?? 0} ${lang.currencySar}',
            ),
          ],
          if (dineInFee)
            _SummaryRow(
              title: lang.dineInCost,
              value:
                  '${state.dineInCost.toStringAsFixed(2)} ${lang.currencySar}',
            ),
          if (tobacoActive)
            _SummaryRow(
              title: lang.tobaccoVat,
              value:
                  '${state.tobaccoTaxAmount.toStringAsFixed(2)} ${lang.currencySar}',
            ),
          SizedBox(height: spacing.xs),
          _SummaryRow(
            title: lang.vatPrecentage(
              state.settingsModel?.vat?.vatDefaultValue ?? 0,
            ),
            value: '${state.vatAmount.toStringAsFixed(2)} ${lang.currencySar}',
          ),
          Divider(height: spacing.xl, color: theme.colorScheme.outlineVariant),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                lang.grandTotal,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${state.grandTotal.toStringAsFixed(2)} ${lang.currencySar}',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.title,
    required this.value,
    this.isSuccess = false,
  });

  final String title;
  final String value;
  final bool isSuccess;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = isSuccess ? AppColors.green : null;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: theme.textTheme.bodySmall?.copyWith(
            color: color ?? theme.colorScheme.onPrimary,
          ),
        ),
        Text(
          value,
          style: theme.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: color ?? theme.colorScheme.onSecondary,
          ),
        ),
      ],
    );
  }
}
