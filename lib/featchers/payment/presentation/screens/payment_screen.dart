import 'package:apex_restaurant/core/helpers/extensions.dart';
import 'package:apex_restaurant/featchers/cart/data/models/invoice_request_model.dart';
import 'package:apex_restaurant/featchers/payment/data/model/payment_request_model.dart';
import 'package:apex_restaurant/featchers/payment/presentation/bloc/payment_bloc.dart';
import 'package:apex_restaurant/featchers/payment/presentation/bloc/payment_event.dart';
import 'package:apex_restaurant/featchers/payment/presentation/bloc/payment_state.dart';
import 'package:apex_restaurant/featchers/payment/presentation/widgets/payment_success.dart';
import 'package:apex_restaurant/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key, required this.invoiceRequestModel});

  final SaveInvoiceRequestModel invoiceRequestModel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;
    final lang = S.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(lang.payment),
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
                content: Text(state.errorMessage ?? lang.somethingWentWrong),
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
                _BottomActionButtons(
                  state: state,
                  invoiceRequestModel: invoiceRequestModel,
                ),
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
    final lang = S.of(context);

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
                lang.totalAmountRequired,
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
                    lang.currencySar,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Spacer(),
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
    final lang = S.of(context);
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
            label: lang.paymentMethodCash,
            icon: Icons.payments_outlined,
            isSelected: selectedMethod == PaymentMethodType.cash,
            onTap: () => context.read<PaymentBloc>().add(
              const ChangePaymentMethodEvent(PaymentMethodType.cash),
            ),
          ),
          _TabItem(
            label: lang.paymentMethodCard,
            icon: Icons.credit_card,
            isSelected: selectedMethod == PaymentMethodType.card,
            onTap: () => context.read<PaymentBloc>().add(
              const ChangePaymentMethodEvent(PaymentMethodType.card),
            ),
          ),
          _TabItem(
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
    final lang = S.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          lang.amountDue,
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
                lang.currencySarShort,
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
    final lang = S.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          lang.amountPaid,
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
                      lang.currencySarShort,
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
    final lang = S.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          lang.amountRemaining,
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
                lang.currencySarShort,
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
    final lang = S.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          lang.referenceNumber,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        SizedBox(height: spacing.xs),
        TextFormField(
          textAlign: TextAlign.right,
          decoration: InputDecoration(
            hintText: lang.enterTransactionNumber,
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
    final lang = S.of(context);

    final methods = [
      _SplitItemData(
        paymentMethodId: 1, // Cash
        title: lang.paymentMethodCash,
        icon: Icons.payments_outlined,
        color: Colors.orange,
      ),
      _SplitItemData(
        paymentMethodId: 2, // Card
        title: lang.paymentMethodCard,
        icon: Icons.credit_card,
        color: Colors.blue,
      ),
      _SplitItemData(
        paymentMethodId: 3, // Visa
        title: lang.paymentMethodVisa,
        icon: Icons.account_balance,
        color: Colors.indigo,
      ),
      _SplitItemData(
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
              child: _SplitMethodRow(item: e),
            ),
          )
          .toList(),
    );
  }
}

class _SplitItemData {
  final int paymentMethodId;
  final String title;
  final IconData icon;
  final Color color;

  _SplitItemData({
    required this.paymentMethodId,
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

class _BottomActionButtons extends StatelessWidget {
  final PaymentState state;
  final SaveInvoiceRequestModel invoiceRequestModel;

  const _BottomActionButtons({
    required this.state,
    required this.invoiceRequestModel,
  });

  /// Resolves selected payment methods into SavePaymentModel list
  List<SavePaymentModel> _buildPayments() {
    if (state.selectedMethod == PaymentMethodType.split) {
      // Return split method entries that have an amount > 0
      return state.splitAmounts.entries
          .where((e) => e.value > 0)
          .map((e) => SavePaymentModel(paymentMethodId: e.key, amount: e.value))
          .toList();
    } else {
      // 1 = Cash, 2 = Card/POS Terminal
      final int methodId = state.selectedMethod == PaymentMethodType.cash
          ? 1
          : 2;
      return [
        SavePaymentModel(
          paymentMethodId: methodId,
          amount: state.paidAmount > 0 ? state.paidAmount : state.totalAmount,
        ),
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;
    final lang = S.of(context);

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
                      // 1. Build payment methods list based on current selection
                      final paymentsList = _buildPayments();

                      // 2. Combine invoiceRequestModel + mapped payment methods
                      final finalInvoiceRequest = SaveInvoiceRequestModel(
                        invoice: invoiceRequestModel.invoice,
                        items: invoiceRequestModel.items,
                        payments: paymentsList,
                        gediaKey: state.referenceNumber,
                      );

                      // 3. Trigger submit payment event with complete payload
                      context.read<PaymentBloc>().add(
                        SubmitPaymentEvent(finalInvoiceRequest),
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
              label: Text(lang.pay),
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
              child: Text(lang.cancel),
            ),
          ),
        ],
      ),
    );
  }
}
