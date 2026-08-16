import '../../../../core/helpers/extensions.dart';
import '../../../../core/themes/app_colors.dart';
import '../../data/model/payment_request_model.dart';
import '../bloc/payment_bloc.dart';
import '../bloc/payment_event.dart';
import '../../../../generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PaymentMethodTabs extends StatelessWidget {
  const PaymentMethodTabs({super.key});

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;
    final lang = S.of(context);
    final selectedMethod = context.select(
      (PaymentBloc bloc) => bloc.state.selectedMethod,
    );

    return Container(
      padding: EdgeInsets.all(spacing.xs / 2),
      decoration: BoxDecoration(
        color: context.appExtraTheme.togelBackground,
        borderRadius: BorderRadius.circular(spacing.radiusMd),
      ),
      child: Row(
        children: [
          _PaymentTabItem(
            label: lang.paymentMethodCash,
            icon: Icons.payments_outlined,
            isSelected: selectedMethod == PaymentMethodType.cash,
            onTap: () => context.read<PaymentBloc>().add(
              const ChangePaymentMethodEvent(PaymentMethodType.cash),
            ),
          ),
          _PaymentTabItem(
            label: lang.paymentMethodCard,
            icon: Icons.credit_card,
            isSelected: selectedMethod == PaymentMethodType.card,
            onTap: () => context.read<PaymentBloc>().add(
              const ChangePaymentMethodEvent(PaymentMethodType.card),
            ),
          ),
          _PaymentTabItem(
            label: lang.paymentMethodOther,
            icon: Icons.more_horiz,
            isSelected: selectedMethod == PaymentMethodType.split,
            onTap: () => context.read<PaymentBloc>().add(
              const ChangePaymentMethodEvent(PaymentMethodType.split),
            ),
          ),
        ],
      ),
    );
  }
}

class _PaymentTabItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _PaymentTabItem({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: spacing.sm),
          decoration: BoxDecoration(
            color: isSelected ? theme.colorScheme.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(spacing.radiusSm),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 18,
                color: isSelected
                    ? AppColors.white
                    : theme.colorScheme.onPrimary,
              ),
              SizedBox(width: spacing.xs),
              Text(
                label,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: isSelected
                      ? AppColors.white
                      : theme.colorScheme.onPrimary,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
