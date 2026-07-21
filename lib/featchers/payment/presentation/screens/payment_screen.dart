import 'package:apex_restaurant/core/helpers/extensions.dart';
import 'package:apex_restaurant/featchers/payment/data/model/payment_request_model.dart';
import 'package:apex_restaurant/featchers/payment/presentation/bloc/payment_bloc.dart';
import 'package:apex_restaurant/featchers/payment/presentation/bloc/payment_event.dart';
import 'package:apex_restaurant/featchers/payment/presentation/bloc/payment_state.dart';
import 'package:apex_restaurant/featchers/payment/presentation/widgets/payment_success.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('الدفع'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: BlocConsumer<PaymentBloc, PaymentState>(
        listener: (context, state) {
          if (state.status == PaymentStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? 'حدث خطأ ما'),
                backgroundColor: theme.colorScheme.error,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state.status == PaymentStatus.success &&
              state.successModel != null) {
            return PaymentSuccess(model: state.successModel!);
          }

          return SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(spacing.md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const _TotalAmountCard(),
                        SizedBox(height: spacing.md),
                        const _PaymentMethodTabs(),
                        SizedBox(height: spacing.md),
                        if (state.selectedMethod == PaymentMethodType.split)
                          const _SplitMethodsList()
                        else ...[
                          const _DueAmountCard(),
                          SizedBox(height: spacing.md),
                          const _PaidAmountInputField(),
                          SizedBox(height: spacing.md),
                          if (state.selectedMethod == PaymentMethodType.cash)
                            const _RemainingAmountCard()
                          else if (state.selectedMethod ==
                              PaymentMethodType.card)
                            const _ReferenceNumberInputField(),
                        ],
                      ],
                    ),
                  ),
                ),
                _BottomActionButtons(state: state),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _TotalAmountCard extends StatelessWidget {
  const _TotalAmountCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;
    final state = context.watch<PaymentBloc>().state;

    return Container(
      padding: EdgeInsets.all(spacing.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(spacing.radiusMd),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'إجمالي المبلغ المطلوب',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              Row(
                children: [
                  Text(
                    state.totalAmount.toStringAsFixed(2),
                    style: theme.textTheme.headlineMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: spacing.xs),
                  Text(
                    'ريال سعودي',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Spacer(),
          Container(
            padding: EdgeInsets.all(spacing.sm),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer.withOpacity(.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.receipt_long,
              color: theme.colorScheme.primary,
              size: 28,
            ),
          ),
        ],
      ),
    );
  }
}

class _PaymentMethodTabs extends StatelessWidget {
  const _PaymentMethodTabs();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;
    final selectedMethod = context.select(
      (PaymentBloc bloc) => bloc.state.selectedMethod,
    );

    return Container(
      padding: EdgeInsets.all(spacing.xs / 2),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(spacing.radiusMd),
      ),
      child: Row(
        children: [
          _TabItem(
            label: 'نقدي',
            icon: Icons.payments_outlined,
            isSelected: selectedMethod == PaymentMethodType.cash,
            onTap: () => context.read<PaymentBloc>().add(
              const ChangePaymentMethodEvent(PaymentMethodType.cash),
            ),
          ),
          _TabItem(
            label: 'شبكة',
            icon: Icons.credit_card,
            isSelected: selectedMethod == PaymentMethodType.card,
            onTap: () => context.read<PaymentBloc>().add(
              const ChangePaymentMethodEvent(PaymentMethodType.card),
            ),
          ),
          _TabItem(
            label: '... أخرى',
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

class _TabItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabItem({
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
                    ? theme.colorScheme.onPrimary
                    : theme.colorScheme.onSurfaceVariant,
              ),
              SizedBox(width: spacing.xs),
              Text(
                label,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: isSelected
                      ? theme.colorScheme.onPrimary
                      : theme.colorScheme.onSurfaceVariant,
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

class _DueAmountCard extends StatelessWidget {
  const _DueAmountCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;
    final state = context.watch<PaymentBloc>().state;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'المستحق',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        SizedBox(height: spacing.xs),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(spacing.md),
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer.withOpacity(0.2),
            borderRadius: BorderRadius.circular(spacing.radiusMd),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                state.totalAmount.toStringAsFixed(2),
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              Text(
                'ر.س',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PaidAmountInputField extends StatelessWidget {
  const _PaidAmountInputField();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;
    final state = context.watch<PaymentBloc>().state;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'المسدد',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        SizedBox(height: spacing.xs),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: spacing.md,
            vertical: spacing.xs,
          ),
          decoration: BoxDecoration(
            border: Border.all(color: theme.colorScheme.primary, width: 1.5),
            borderRadius: BorderRadius.circular(spacing.radiusMd),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  initialValue: state.paidAmount.toStringAsFixed(2),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.start,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    suffix: Text(
                      'ر.س',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  onChanged: (val) {
                    final parsed = double.tryParse(val) ?? 0.0;
                    context.read<PaymentBloc>().add(
                      UpdatePaidAmountEvent(parsed),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _RemainingAmountCard extends StatelessWidget {
  const _RemainingAmountCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;
    final state = context.watch<PaymentBloc>().state;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'المتبقي',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        SizedBox(height: spacing.xs),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(spacing.md),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(spacing.radiusMd),
            border: Border.all(
              color: theme.colorScheme.outlineVariant,
              style: BorderStyle.solid,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'ر.س',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              Text(
                state.remainingAmount.toStringAsFixed(2),
                style: theme.textTheme.titleLarge?.copyWith(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ReferenceNumberInputField extends StatelessWidget {
  const _ReferenceNumberInputField();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'رقم المرجع',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        SizedBox(height: spacing.xs),
        TextFormField(
          textAlign: TextAlign.right,
          decoration: InputDecoration(
            hintText: 'ادخل رقم العملية .....',
            prefixIcon: Icon(
              Icons.subtitles_outlined,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(spacing.radiusMd),
              borderSide: BorderSide(color: theme.colorScheme.outlineVariant),
            ),
          ),
          onChanged: (val) {
            context.read<PaymentBloc>().add(UpdateReferenceNumberEvent(val));
          },
        ),
      ],
    );
  }
}

class _SplitMethodsList extends StatelessWidget {
  const _SplitMethodsList();

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;

    final methods = [
      _SplitItemData(
        title: 'نقدي',
        icon: Icons.payments_outlined,
        color: Colors.orange,
      ),
      _SplitItemData(
        title: 'شبكة',
        icon: Icons.credit_card,
        color: Colors.blue,
      ),
      _SplitItemData(
        title: 'فيزا',
        icon: Icons.account_balance,
        color: Colors.indigo,
      ),
      _SplitItemData(
        title: 'تحويل بنكي',
        icon: Icons.sync_alt,
        color: Colors.black87,
      ),
      _SplitItemData(
        title: 'نقاط الولاء',
        icon: Icons.stars,
        color: Colors.indigo,
      ),
      _SplitItemData(
        title: 'قسيمة شراء',
        icon: Icons.confirmation_number_outlined,
        color: Colors.black87,
      ),
      _SplitItemData(title: 'آجل', icon: Icons.history, color: Colors.black87),
    ];

    return Column(
      children: methods
          .map(
            (e) => Padding(
              padding: EdgeInsets.only(bottom: spacing.sm),
              child: _SplitMethodRow(item: e),
            ),
          )
          .toList(),
    );
  }
}

class _SplitItemData {
  final String title;
  final IconData icon;
  final Color color;

  _SplitItemData({
    required this.title,
    required this.icon,
    required this.color,
  });
}

class _SplitMethodRow extends StatelessWidget {
  final _SplitItemData item;

  const _SplitMethodRow({required this.item});

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
        color: theme.colorScheme.surface,
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
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomActionButtons extends StatelessWidget {
  final PaymentState state;

  const _BottomActionButtons({required this.state});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;

    return Container(
      padding: EdgeInsets.all(spacing.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          top: BorderSide(color: theme.colorScheme.outlineVariant),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: ElevatedButton.icon(
              onPressed: state.status == PaymentStatus.loading
                  ? null
                  : () {
                      context.read<PaymentBloc>().add(
                        const SubmitPaymentEvent('12345'),
                      );
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: spacing.md),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(spacing.radiusMd),
                ),
              ),
              icon: state.status == PaymentStatus.loading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Icon(Icons.check_circle_outline),
              label: const Text('سداد'),
            ),
          ),
          SizedBox(width: spacing.md),
          Expanded(
            flex: 1,
            child: OutlinedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: spacing.md),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(spacing.radiusMd),
                ),
              ),
              child: const Text('إلغاء'),
            ),
          ),
        ],
      ),
    );
  }
}
