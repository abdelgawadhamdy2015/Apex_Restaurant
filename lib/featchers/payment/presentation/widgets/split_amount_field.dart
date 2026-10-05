import 'dart:math' as math;

import 'package:apex_restaurant/featchers/payment/presentation/bloc/payment_bloc.dart';
import 'package:apex_restaurant/featchers/payment/presentation/bloc/payment_event.dart';
import 'package:apex_restaurant/featchers/payment/presentation/bloc/payment_state.dart';
import 'package:apex_restaurant/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Amount input for one payment method in the split tab.
/// Behaves like the "paid" field in [AmountSummaryRow]:
///  - keeps its own controller (typing / cursor are never reset)
///  - only accepts numbers with up to 2 decimals
///  - double tap fills the remaining amount
class SplitAmountField extends StatefulWidget {
  const SplitAmountField({
    super.key,
    required this.paymentMethodId,
    this.showCurrencyPrefix = false,
    this.decoration,
  });

  final int paymentMethodId;
  final bool showCurrencyPrefix;

  /// Optional decoration override (the grid and the list look different).
  final InputDecoration? decoration;

  @override
  State<SplitAmountField> createState() => _SplitAmountFieldState();
}

class _SplitAmountFieldState extends State<SplitAmountField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();

    final amount = context
        .read<PaymentBloc>()
        .state
        .splitAmounts[widget.paymentMethodId];

    _controller = TextEditingController(text: _format(amount));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _format(double? amount) =>
      (amount == null || amount == 0) ? '' : amount.toStringAsFixed(2);

  /// Updates both the TextField and the Bloc (same as _setPaidAmount).
  void _setAmount(double amount) {
    final text = amount.toStringAsFixed(2);

    _controller.value = TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );

    context.read<PaymentBloc>().add(
      UpdateSplitAmountEvent(
        paymentMethodId: widget.paymentMethodId,
        amount: amount,
      ),
    );
  }

  void _fillRemaining() {
    final state = context.read<PaymentBloc>().state;
    final current = state.splitAmounts[widget.paymentMethodId] ?? 0.0;

    _setAmount(math.max(0.0, state.remainingAmount + current));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final decoration =
        widget.decoration ??
        InputDecoration(
          isDense: true,
          filled: true,
          fillColor: theme.colorScheme.surface,
          hintText: '0.00',
          prefixText: widget.showCurrencyPrefix
              ? '${S.of(context).currencySarShort} '
              : null,
          prefixStyle: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSecondary,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: theme.colorScheme.outlineVariant),
          ),
        );

    return BlocListener<PaymentBloc, PaymentState>(
      // Only react when THIS method's amount changed.
      listenWhen: (prev, curr) =>
          prev.splitAmounts[widget.paymentMethodId] !=
          curr.splitAmounts[widget.paymentMethodId],
      listener: (context, state) {
        final next = state.splitAmounts[widget.paymentMethodId] ?? 0.0;
        final current = double.tryParse(_controller.text) ?? 0.0;

        // Change came from typing -> don't touch the text/cursor.
        if ((current - next).abs() < 0.001) return;

        // Change came from outside (reset, auto-fill, ...) -> sync text.
        final text = _format(next);
        _controller.value = TextEditingValue(
          text: text,
          selection: TextSelection.collapsed(offset: text.length),
        );
      },
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onDoubleTap: _fillRemaining,
        child: TextField(
          controller: _controller,

          // Keep numbers LTR even when the app language is Arabic.
          textDirection: TextDirection.ltr,
          textAlign: TextAlign.left,

          keyboardType: const TextInputType.numberWithOptions(
            decimal: true,
            signed: false,
          ),

          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
          ],

          decoration: decoration,

          onChanged: (value) {
            context.read<PaymentBloc>().add(
              UpdateSplitAmountEvent(
                paymentMethodId: widget.paymentMethodId,
                amount: double.tryParse(value) ?? 0.0,
              ),
            );
          },
        ),
      ),
    );
  }
}
