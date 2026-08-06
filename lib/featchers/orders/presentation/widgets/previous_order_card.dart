import 'package:apex_restaurant/core/helpers/extensions.dart';
import 'package:apex_restaurant/featchers/orders/data/model/order_model.dart';
import 'package:apex_restaurant/generated/l10n.dart';
import 'package:flutter/material.dart';

/// Card representing a single completed order on the "Previous Orders" tab.
class PreviousOrderCard extends StatelessWidget {
  final OrderModel order;
  final S l10n;

  const PreviousOrderCard({super.key, required this.order, required this.l10n});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;
    final iconSizes = context.iconSizes;

    return Container(
      margin: EdgeInsets.only(bottom: spacing.md),
      padding: EdgeInsets.all(spacing.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(spacing.radiusLg),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                order.invoiceNumber,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: iconSizes.sm,
                    color: theme.colorScheme.onSecondary,
                  ),
                  SizedBox(width: spacing.xxs),
                  Text(
                    '${order.dateTime.year}-${order.dateTime.month.toString().padLeft(2, '0')}-${order.dateTime.day.toString().padLeft(2, '0')} |${order.dateTime.hour}:${order.dateTime.minute.toString().padLeft(2, '0')}  ',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Divider(height: spacing.lg, color: theme.colorScheme.outlineVariant),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.customer,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSecondary,
                    ),
                  ),
                  Text(
                    order.customerName ?? '',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    l10n.total,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSecondary,
                    ),
                  ),
                  Text(
                    l10n.priceWithCurrency(
                      order.totalAmount.toStringAsFixed(2),
                    ),
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: spacing.md),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: Icon(
                    Icons.visibility_outlined,
                    color: theme.colorScheme.primary,
                    size: iconSizes.sm,
                  ),
                  label: Text(
                    l10n.preview,
                    style: TextStyle(color: theme.colorScheme.primary),
                  ),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: context.appExtraTheme.secondaryBackground,
                    side: BorderSide.none,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(spacing.radiusLg),
                    ),
                  ),
                ),
              ),
              SizedBox(width: spacing.sm),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: Icon(
                    Icons.print_outlined,
                    color: theme.colorScheme.secondary,
                    size: iconSizes.sm,
                  ),
                  label: Text(
                    l10n.print,
                    style: TextStyle(color: theme.colorScheme.secondary),
                  ),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: theme.colorScheme.secondary.withOpacity(
                      0.12,
                    ),
                    side: BorderSide.none,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(spacing.radiusLg),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
