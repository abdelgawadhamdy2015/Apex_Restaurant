import '../../../../core/helpers/extensions.dart';
import '../../../../core/themes/app_colors.dart';
import '../../data/model/pinding_invoice_model.dart';
import '../bloc/orders_bloc.dart';
import '../bloc/orders_event.dart';
import '../bloc/orders_state.dart';
import '../../../../generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Collapsible card representing a single held order, with an expandable
/// item list and restore/delete actions.
class HeldOrderExpandableCard extends StatefulWidget {
  final PindingInvoiceModel order;
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

    final invoiceId = order.invoiceId;
    final queueNumber = order.orderNumber?.toString() ?? '';
    final invoiceCode = order.code ?? '';
    final invoiceDate = order.invoiceDate;
    final itemsCount = order.itemsCount ?? 0;
    final invoiceTotal = order.invoiceTotal ?? 0.0;
    final items = order.items ?? const <PindingInvoiceItemModel>[];

    return SingleChildScrollView(
      child: Container(
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
                        queueNumber,
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
                          invoiceCode,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              invoiceDate != null
                                  ? ' ${invoiceDate.hour}:${invoiceDate.minute.toString().padLeft(2, '0')}  ص'
                                  : '',
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
                          itemsCount == 1
                              ? l10n.singleItemCount
                              : l10n.itemsCount(itemsCount),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSecondary,
                          ),
                        ),
                        Text(
                          l10n.priceWithCurrency(
                            invoiceTotal.toStringAsFixed(2),
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
                    ...items.map((item) {
                      final itemName = item.itemNameAr ?? '';
                      final itemQuantity = (item.quantity ?? 0).toInt();
                      final itemTotal = item.total ?? 0.0;

                      return Padding(
                        padding: EdgeInsets.only(bottom: spacing.xs),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text(
                                  itemName,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(width: spacing.xs),
                                Text(
                                  '${itemQuantity}x',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              l10n.priceWithCurrency(
                                itemTotal.toStringAsFixed(2),
                              ),
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                    SizedBox(height: spacing.md),
                    Row(
                      children: [
                        Expanded(
                          child: BlocBuilder<OrdersBloc, OrdersState>(
                            buildWhen: (prev, curr) =>
                                prev.restoringInvoiceId !=
                                curr.restoringInvoiceId,
                            builder: (context, state) {
                              final isRestoring =
                                  invoiceId != null &&
                                  state.restoringInvoiceId == invoiceId;

                              return ElevatedButton.icon(
                                onPressed: invoiceId == null || isRestoring
                                    ? null
                                    : () {
                                        context.read<OrdersBloc>().add(
                                          RestoreOrderEvent(
                                            invoiceId: invoiceId,
                                            canEdite:
                                                state
                                                    .restoredInvoice
                                                    ?.invoice
                                                    ?.canEdit ??
                                                false,
                                            isPending: true,
                                          ),
                                        );
                                      },
                                icon: isRestoring
                                    ? SizedBox(
                                        width: iconSizes.sm,
                                        height: iconSizes.sm,
                                        child: const CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: AppColors.white,
                                        ),
                                      )
                                    : Icon(
                                        Icons.history,
                                        color: AppColors.white,
                                        size: iconSizes.sm,
                                      ),
                                label: Text(
                                  l10n.restoreOrder,
                                  style: const TextStyle(
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
                              );
                            },
                          ),
                        ),
                        SizedBox(width: spacing.sm),

                        Expanded(
                          child: TextButton.icon(
                            onPressed: invoiceId == null
                                ? null
                                : () {
                                    context.read<OrdersBloc>().add(
                                      DeleteOrderEvent(id: invoiceId),
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
                                  .withValues(alpha: 0.1),
                              padding: EdgeInsets.symmetric(
                                horizontal: spacing.sm,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  spacing.radiusMd,
                                ),
                                side: BorderSide(
                                  color: theme.colorScheme.errorContainer
                                      .withValues(alpha: 0.20),
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
      ),
    );
  }
}
