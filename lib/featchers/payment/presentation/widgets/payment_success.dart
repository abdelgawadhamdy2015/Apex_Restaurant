import 'package:apex_restaurant/core/helpers/extensions.dart';
import 'package:apex_restaurant/core/router/routes.dart';
import 'package:apex_restaurant/featchers/cart/presentation/bloc/cart_bloc.dart';
import 'package:apex_restaurant/featchers/cart/presentation/bloc/cart_event.dart';
import 'package:apex_restaurant/featchers/payment/data/model/payment_success_model.dart';
import 'package:apex_restaurant/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class PaymentSuccess extends StatelessWidget {
  final PaymentSuccessModel model;

  const PaymentSuccess({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;
    final l10n = S.of(context);

    final String formattedDate = l10n.formattedDateTime(
      model.transactionTime.year,
      model.transactionTime.month.toString().padLeft(2, '0'),
      model.transactionTime.day.toString().padLeft(2, '0'),
      model.transactionTime.hour.toString().padLeft(2, '0'),
      model.transactionTime.minute.toString().padLeft(2, '0'),
    );

    return SingleChildScrollView(
      padding: EdgeInsets.all(spacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: CircleAvatar(
              radius: 36,
              backgroundColor: Colors.green.shade100,
              child: const Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 48,
              ),
            ),
          ),
          SizedBox(height: spacing.md),
          Text(
            l10n.paymentSuccessful,
            textAlign: TextAlign.center,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: spacing.xs),
          Text(
            l10n.orderProcessedSuccessfully,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: spacing.lg),

          // Invoice Card
          Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(spacing.radiusLg),
              border: Border.all(color: theme.colorScheme.outlineVariant),
            ),
            child: Column(
              children: [
                // Card Header
                Container(
                  padding: EdgeInsets.all(spacing.md),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer.withOpacity(0.3),
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(spacing.radiusLg),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.orderNumber,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          Text(
                            model.orderNumber,
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.invoiceNumber,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          Text(
                            model.invoiceNumber,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Divider(height: 1, color: theme.colorScheme.outlineVariant),

                // Transaction summary
                Padding(
                  padding: EdgeInsets.all(spacing.md),
                  child: Column(
                    children: [
                      _InfoRow(
                        label: l10n.totalPaid,
                        value: l10n.priceWithCurrency(
                          model.totalPaid.toStringAsFixed(2),
                        ),
                        isBold: true,
                      ),
                      SizedBox(height: spacing.sm),
                      _InfoRow(
                        label: l10n.paymentMethod,
                        value: model.paymentMethodName,
                        icon: Icons.credit_card,
                      ),
                      SizedBox(height: spacing.sm),
                      _InfoRow(
                        label: l10n.transactionDate,
                        value: formattedDate,
                      ),
                      Divider(
                        height: spacing.lg * 2,
                        color: theme.colorScheme.outlineVariant,
                      ),

                      // Order Items
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          l10n.orderDetails,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                      SizedBox(height: spacing.sm),
                      ...model.items.map(
                        (item) => Padding(
                          padding: EdgeInsets.only(bottom: spacing.sm),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.name,
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    l10n.quantityWithCount(item.quantity),
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: theme.colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                l10n.priceWithCurrency(
                                  item.price.toStringAsFixed(2),
                                ),
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: spacing.xl),

          // Actions
          const _SuccessActionButtons(),
        ],
      ),
    );
  }
}

class _SuccessActionButtons extends StatelessWidget {
  const _SuccessActionButtons();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;
    final lang = S.of(context);

    return Column(
      children: [
        _CustomActionButton(
          label: lang.btnNewOrder,
          icon: Icons.shopping_cart_outlined,
          backgroundColor: theme.colorScheme.primary,
          contentColor: theme.colorScheme.onPrimary,
          borderColor: theme.colorScheme.primary,
          onTap: () {
            final cartBloc = context.read<CartBloc>();
            cartBloc.add(ClearCartEvent());
            context.goNamed(Routes.posScreen);
          },
        ),
        SizedBox(height: spacing.xs),

        _CustomActionButton(
          label: lang.btnPrintReceipt,
          icon: Icons.print_outlined,
          backgroundColor: Colors.transparent,
          contentColor: theme.colorScheme.primary,
          borderColor: theme.colorScheme.primary,
          onTap: () {},
        ),
        SizedBox(height: spacing.xs),

        _CustomActionButton(
          label: lang.btnPrintKitchen,
          icon: Icons.soup_kitchen_outlined,
          backgroundColor: Colors.transparent,
          contentColor: theme.colorScheme.primary,
          borderColor: theme.colorScheme.primary,
          onTap: () {},
        ),
        SizedBox(height: spacing.xs),

        _CustomActionButton(
          label: lang.btnPreviousOrders,
          icon: Icons.shopping_bag_outlined,
          backgroundColor: Colors.transparent,
          contentColor: theme.colorScheme.primary,
          borderColor: theme.colorScheme.primary,
          onTap: () {
            final cartBloc = context.read<CartBloc>();
            cartBloc.add(ClearCartEvent());
            context.goNamed(Routes.ordersScreen);
          },
        ),
      ],
    );
  }
}

class _CustomActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color backgroundColor;
  final Color contentColor;
  final Color borderColor;
  final VoidCallback onTap;

  const _CustomActionButton({
    required this.label,
    required this.icon,
    required this.backgroundColor,
    required this.contentColor,
    required this.borderColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(spacing.radiusMd),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: spacing.md),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(spacing.radiusMd),
            border: Border.all(color: borderColor, width: 1.5),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: contentColor, size: theme.iconTheme.size),
              SizedBox(width: spacing.sm),
              Text(
                label,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: contentColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData? icon;
  final bool isBold;

  const _InfoRow({
    required this.label,
    required this.value,
    this.icon,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        Row(
          children: [
            if (icon != null) ...[
              const SizedBox(width: 6),
              Icon(icon, size: 18, color: theme.colorScheme.secondary),
            ],
            Text(
              value,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
