import 'package:apex_restaurant/core/helpers/extensions.dart';
import 'package:apex_restaurant/featchers/payment/data/model/payment_success_model.dart';
import 'package:flutter/material.dart';

class PaymentSuccess extends StatelessWidget {
  final PaymentSuccessModel model;

  const PaymentSuccess({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;

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
            'تم الدفع بنجاح',
            textAlign: TextAlign.center,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: spacing.xs),
          Text(
            'تمت معالجة الطلب بنجاح وإرساله للمطبخ',
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
                            'رقم الطلب',
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
                            'رقم الفاتورة',
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
                        label: 'إجمالي المبلغ المدفوع',
                        value: '${model.totalPaid.toStringAsFixed(2)} ر.س',
                        isBold: true,
                      ),
                      SizedBox(height: spacing.sm),
                      _InfoRow(
                        label: 'طريقة الدفع',
                        value: model.paymentMethodName,
                        icon: Icons.credit_card,
                      ),
                      SizedBox(height: spacing.sm),
                      _InfoRow(
                        label: 'تاريخ العملية',
                        value:
                            '${model.transactionTime.year}/${model.transactionTime.month}/${model.transactionTime.day} - ${model.transactionTime.hour}:${model.transactionTime.minute}',
                      ),
                      Divider(
                        height: spacing.lg * 2,
                        color: theme.colorScheme.outlineVariant,
                      ),

                      // Order Items
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'تفاصيل الطلب',
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
                                    'الكمية: ${item.quantity}',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: theme.colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                '${item.price.toStringAsFixed(2)} ر.س',
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
          _SuccessActionButtons(),
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

    return Column(
      children: [
        // طلب جديد (New Order - Primary Style)
        _CustomActionButton(
          label: 'طلب جديد',
          icon: Icons.shopping_cart_outlined,
          backgroundColor: theme.colorScheme.primary,
          contentColor: theme.colorScheme.onPrimary,
          borderColor: theme.colorScheme.primary,
          onTap: () {
            // TODO: Handle new order
          },
        ),
        SizedBox(height: spacing.xs),

        // طباعة إيصال (Print Receipt)
        _CustomActionButton(
          label: 'طباعة إيصال',
          icon: Icons.print_outlined,
          backgroundColor: Colors.transparent,
          contentColor: theme.colorScheme.primary,
          borderColor: theme.colorScheme.primary,
          onTap: () {
            // TODO: Handle print receipt
          },
        ),
        SizedBox(height: spacing.xs),

        // طباعة مطبخ (Print Kitchen)
        _CustomActionButton(
          label: 'طباعة مطبخ',
          icon: Icons.soup_kitchen_outlined,
          backgroundColor: Colors.transparent,
          contentColor: theme.colorScheme.primary,
          borderColor: theme.colorScheme.primary,
          onTap: () {
            // TODO: Handle print kitchen
          },
        ),
        SizedBox(height: spacing.xs),

        // الطلبات السابقة (Previous Orders)
        _CustomActionButton(
          label: 'الطلبات السابقة',
          icon: Icons.shopping_bag_outlined,
          backgroundColor: Colors.transparent,
          contentColor: theme.colorScheme.primary,
          borderColor: theme.colorScheme.primary,
          onTap: () {
            // TODO: Handle navigate to previous orders
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
              Icon(icon, size: 18, color: Colors.orange),
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
