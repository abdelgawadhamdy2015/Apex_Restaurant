import 'package:apex_restaurant/core/helpers/extensions.dart';
import 'package:apex_restaurant/core/themes/app_colors.dart';
import 'package:apex_restaurant/featchers/orders/data/model/order_model.dart';
import 'package:apex_restaurant/featchers/orders/presentation/bloc/orders_bloc.dart';
import 'package:apex_restaurant/featchers/orders/presentation/bloc/orders_event.dart';
import 'package:apex_restaurant/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Collapsible card representing a single held order, with an expandable
/// item list and restore/delete actions.
class HeldOrderExpandableCard extends StatefulWidget {
  final OrderModel order;
  final S l10n;

  const HeldOrderExpandableCard({
    super.key,
    required this.order,
    required this.l10n,
  });

  @override
  State<HeldOrderExpandableCard> createState() =>
      _HeldOrderExpandableCardState();
}

class _HeldOrderExpandableCardState extends State<HeldOrderExpandableCard> {
  bool _isExpanded = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;
    final iconSizes = context.iconSizes;
    final buttonTheme = context.appExtraTheme;
    final l10n = widget.l10n;
    final order = widget.order;

    return Container(
      margin: EdgeInsets.only(bottom: spacing.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.onSurface,
        borderRadius: BorderRadius.circular(spacing.radiusLg),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Column(
        children: [
          // Collapsible Header
          InkWell(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            child: Padding(
              padding: EdgeInsets.all(spacing.md),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: spacing.sm,
                      vertical: spacing.xs,
                    ),
                    decoration: BoxDecoration(
                      color: buttonTheme.background,
                      borderRadius: BorderRadius.circular(spacing.radiusLg),
                    ),
                    child: Text(
                      order.orderQueueNumber ?? '',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.onPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(width: spacing.lg),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        order.invoiceNumber,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            ' ${order.dateTime.hour}:${order.dateTime.minute.toString().padLeft(2, '0')}  ص',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSecondary,
                            ),
                          ),
                          SizedBox(width: spacing.xxs),
                          Icon(
                            Icons.access_time,
                            size: iconSizes.sm,
                            color: theme.colorScheme.onSecondary,
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(width: spacing.sm),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        order.itemsCount == 1
                            ? l10n.singleItemCount
                            : l10n.itemsCount(order.itemsCount),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSecondary,
                        ),
                      ),
                      Text(
                        l10n.priceWithCurrency(
                          order.totalAmount.toStringAsFixed(2),
                        ),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: spacing.sm),

                  Icon(
                    _isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: theme.colorScheme.onSecondary,
                    size: iconSizes.md,
                  ),
                ],
              ),
            ),
          ),

          // Expanded Content Body
          if (_isExpanded) ...[
            Divider(height: 1, color: theme.colorScheme.outlineVariant),
            Padding(
              padding: EdgeInsets.all(spacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      l10n.orderDetails,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSecondary,
                      ),
                    ),
                  ),
                  SizedBox(height: spacing.sm),
                  ...order.items.map(
                    (item) => Padding(
                      padding: EdgeInsets.only(bottom: spacing.xs),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                item.name,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: spacing.xs),

                              Text(
                                '${item.quantity}x',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            l10n.priceWithCurrency(
                              item.price.toStringAsFixed(2),
                            ),
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: spacing.md),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            context.read<OrdersBloc>().add(
                              RestoreOrderEvent(order.id),
                            );
                          },
                          icon: Icon(
                            Icons.history,
                            color: AppColors.white,
                            size: iconSizes.sm,
                          ),
                          label: Text(
                            l10n.restoreOrder,
                            style: TextStyle(
                              color: AppColors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.colorScheme.primary,
                            padding: EdgeInsets.symmetric(
                              horizontal: spacing.sm,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                spacing.radiusSm,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: spacing.sm),

                      Expanded(
                        child: TextButton.icon(
                          onPressed: () {
                            context.read<OrdersBloc>().add(
                              DeleteOrderEvent(order.id),
                            );
                          },
                          icon: Icon(
                            Icons.delete,
                            color: theme.colorScheme.errorContainer,
                            size: iconSizes.sm,
                          ),
                          label: Text(
                            l10n.deleteOrder,
                            style: TextStyle(
                              color: theme.colorScheme.errorContainer,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: TextButton.styleFrom(
                            backgroundColor: theme.colorScheme.errorContainer
                                .withOpacity(0.1),
                            padding: EdgeInsets.symmetric(
                              horizontal: spacing.sm,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                spacing.radiusMd,
                              ),
                              side: BorderSide(
                                color: theme.colorScheme.errorContainer
                                    .withOpacity(0.20),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
