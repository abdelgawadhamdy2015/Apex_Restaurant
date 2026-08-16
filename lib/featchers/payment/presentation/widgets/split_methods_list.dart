import '../../../../core/helpers/extensions.dart';
import '../bloc/payment_bloc.dart';
import '../bloc/payment_event.dart';
import '../../../../generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// List of payment methods with individual amount inputs, shown when the
/// user picks the "split" payment tab.
class SplitMethodsList extends StatelessWidget {
  const SplitMethodsList({super.key});

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;
    final lang = S.of(context);

    final methods = [
      SplitItemData(
        paymentMethodId: 1, // Cash
        title: lang.paymentMethodCash,
        icon: Icons.payments_outlined,
        color: Colors.orange,
      ),
      SplitItemData(
        paymentMethodId: 2, // Card
        title: lang.paymentMethodCard,
        icon: Icons.credit_card,
        color: Colors.blue,
      ),
      SplitItemData(
        paymentMethodId: 3, // Visa
        title: lang.paymentMethodVisa,
        icon: Icons.account_balance,
        color: Colors.indigo,
      ),
      SplitItemData(
        paymentMethodId: 4, // Bank Transfer
        title: lang.paymentMethodBankTransfer,
        icon: Icons.sync_alt,
        color: Colors.black87,
      ),
    ];

    return Column(
      children: methods
          .map(
            (e) => Padding(
              padding: EdgeInsets.only(bottom: spacing.sm),
              child: SplitMethodRow(item: e),
            ),
          )
          .toList(),
    );
  }
}

/// Data for a single row in [SplitMethodsList].
class SplitItemData {
  final int paymentMethodId;
  final String title;
  final IconData icon;
  final Color color;

  SplitItemData({
    required this.paymentMethodId,
    required this.title,
    required this.icon,
    required this.color,
  });
}

/// A single payment method row with an amount input, used by [SplitMethodsList].
class SplitMethodRow extends StatelessWidget {
  final SplitItemData item;

  const SplitMethodRow({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;

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
          Icon(item.icon, color: item.color),
          SizedBox(width: spacing.sm),
          Text(
            item.title,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          SizedBox(
            width: 100,
            child: TextField(
              decoration: InputDecoration(
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
              keyboardType: TextInputType.number,
              onChanged: (val) {
                final amount = double.tryParse(val) ?? 0.0;
                context.read<PaymentBloc>().add(
                  UpdateSplitAmountEvent(
                    paymentMethodId: item.paymentMethodId,
                    amount: amount,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
