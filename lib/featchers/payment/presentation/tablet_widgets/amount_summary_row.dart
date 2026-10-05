import 'package:apex_restaurant/core/helpers/extensions.dart';
import 'package:apex_restaurant/core/themes/app_colors.dart';
import 'package:apex_restaurant/featchers/payment/presentation/bloc/payment_bloc.dart';
import 'package:apex_restaurant/featchers/payment/presentation/bloc/payment_event.dart';
import 'package:apex_restaurant/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Side-by-side "المتبقي" (remaining, read-only) and "المسدد" (paid,
/// editable) fields — shown for the نقدي (cash) and شبكة (card) tabs.
class AmountSummaryRow extends StatefulWidget {
  const AmountSummaryRow({super.key});

  @override
  State<AmountSummaryRow> createState() => _AmountSummaryRowState();
}

class _AmountSummaryRowState extends State<AmountSummaryRow> {
  late final TextEditingController _paidController;

  @override
  void initState() {
    super.initState();

    final state = context.read<PaymentBloc>().state;

    _paidController = TextEditingController(
      text: state.paidAmount.toStringAsFixed(2),
    );
  }

  @override
  void dispose() {
    _paidController.dispose();
    super.dispose();
  }

  /// Updates both the TextField and the Bloc state.
  void _setPaidAmount(double amount) {
    final formattedAmount = amount.toStringAsFixed(2);

    // Update TextField
    _paidController.value = TextEditingValue(
      text: formattedAmount,
      selection: TextSelection.collapsed(offset: formattedAmount.length),
    );

    // Update Bloc
    context.read<PaymentBloc>().add(UpdatePaidAmountEvent(amount));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;
    final state = context.watch<PaymentBloc>().state;
    final lang = S.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ---------------------------------------------------------------
        // Paid Amount - Editable
        // ---------------------------------------------------------------
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                lang.amountPaid,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSecondary,
                ),
              ),
              SizedBox(height: spacing.xs),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: theme.colorScheme.primary,
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(spacing.radiusMd),
                ),
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onDoubleTap: () {
                    // Set paid amount = total amount
                    _setPaidAmount(state.totalAmount);
                  },
                  child: TextFormField(
                    controller: _paidController,

                    // Keep numbers LTR even when the app language is Arabic.
                    textDirection: TextDirection.ltr,
                    textAlign: TextAlign.left,

                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                      signed: false,
                    ),

                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'^\d*\.?\d{0,2}'),
                      ),
                    ],

                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),

                    decoration: InputDecoration(
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: spacing.sm,
                        vertical: spacing.md,
                      ),
                      prefixText: '${lang.currencySarShort} ',
                      prefixStyle: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSecondary,
                      ),
                    ),

                    onChanged: (value) {
                      final parsed = double.tryParse(value) ?? 0.0;

                      context.read<PaymentBloc>().add(
                        UpdatePaidAmountEvent(parsed),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),

        SizedBox(width: spacing.md),

        // ---------------------------------------------------------------
        // Remaining Amount - Read Only
        // ---------------------------------------------------------------
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                lang.amountRemaining,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSecondary,
                ),
              ),
              SizedBox(height: spacing.xs),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: spacing.sm,
                  vertical: spacing.md,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(spacing.radiusMd),
                  border: Border.all(color: theme.colorScheme.outlineVariant),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      lang.currencySarShort,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSecondary,
                      ),
                    ),
                    Text(
                      state.remainingAmount.toStringAsFixed(2),
                      textDirection: TextDirection.ltr,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: AppColors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
