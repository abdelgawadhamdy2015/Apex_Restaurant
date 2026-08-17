import 'package:apex_restaurant/core/helpers/extensions.dart';
import 'package:apex_restaurant/featchers/payment/presentation/bloc/payment_bloc.dart';
import 'package:apex_restaurant/featchers/payment/presentation/bloc/payment_event.dart';
import 'package:apex_restaurant/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// 2-column grid of payment methods with individual amount inputs, shown
/// when the user picks the "أخرى" (Other) payment tab.
class SplitPaymentGrid extends StatelessWidget {
  const SplitPaymentGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;
    final lang = S.of(context);

    final methods = <_SplitMethodData>[
      _SplitMethodData(
        id: 1,
        title: lang.paymentMethodCash,
        icon: Icons.payments_outlined,
        enabled: true,
      ),
      _SplitMethodData(
        id: 2,
        title: lang.paymentMethodCard,
        icon: Icons.credit_card,
        enabled: true,
      ),
      _SplitMethodData(
        id: 3,
        title: lang.paymentMethodVisa,
        icon: Icons.account_balance,
        enabled: true,
      ),
      _SplitMethodData(
        id: 4,
        title: lang.paymentMethodBankTransfer,
        icon: Icons.sync_alt,
        enabled: true,
      ),
      _SplitMethodData(
        id: 5,
        title: lang.paymentMethodLoyalty,
        icon: Icons.star_border,
        enabled: false,
      ),
      _SplitMethodData(
        id: 6,
        title: lang.paymentMethodVoucher,
        icon: Icons.card_giftcard_outlined,
        enabled: false,
      ),
    ];

    return Column(
      children: [
        for (int i = 0; i < methods.length; i += 2)
          Padding(
            padding: EdgeInsets.only(bottom: spacing.sm),
            child: Row(
              children: [
                Expanded(child: _SplitMethodCell(item: methods[i])),
                SizedBox(width: spacing.sm),
                Expanded(
                  child: i + 1 < methods.length
                      ? _SplitMethodCell(item: methods[i + 1])
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _SplitMethodData {
  final int id;
  final String title;
  final IconData icon;
  final bool enabled;

  _SplitMethodData({
    required this.id,
    required this.title,
    required this.icon,
    required this.enabled,
  });
}

class _SplitMethodCell extends StatelessWidget {
  final _SplitMethodData item;
  const _SplitMethodCell({required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;
    final lang = S.of(context);

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
          SizedBox(
            width: 78,
            child: TextField(
              enabled: item.enabled,
              decoration: InputDecoration(
                isDense: true,
                filled: true,
                fillColor: item.enabled
                    ? theme.colorScheme.surface
                    : theme.colorScheme.surface.withOpacity(0.4),
                hintText: '0.00',
                prefixText: '${lang.currencySarShort} ',
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
              keyboardType: TextInputType.number,
              onChanged: item.enabled
                  ? (val) {
                      final amount = double.tryParse(val) ?? 0.0;
                      context.read<PaymentBloc>().add(
                        UpdateSplitAmountEvent(
                          paymentMethodId: item.id,
                          amount: amount,
                        ),
                      );
                    }
                  : null,
            ),
          ),
          const Spacer(),
          Text(
            item.title,
            textAlign: TextAlign.end,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: item.enabled
                  ? theme.colorScheme.onPrimary
                  : theme.colorScheme.onSecondary,
            ),
          ),
          SizedBox(width: spacing.xs),
          Icon(
            item.icon,
            size: 20,
            color: item.enabled
                ? theme.colorScheme.primary
                : theme.colorScheme.onSecondary,
          ),
        ],
      ),
    );
  }
}
