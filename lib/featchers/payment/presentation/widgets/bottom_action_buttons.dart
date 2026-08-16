import '../../../../core/helpers/extensions.dart';
import '../../../cart/data/models/invoice_request.dart';
import '../../data/model/payment_request_model.dart';
import '../bloc/payment_bloc.dart';
import '../bloc/payment_event.dart';
import '../bloc/payment_state.dart';
import '../../../../generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Bottom bar with "Pay" and "Cancel" actions. Builds the final payment
/// payload from the current [PaymentState] and submits it via [PaymentBloc].
class BottomActionButtons extends StatelessWidget {
  final PaymentState state;
  final SaveRestaurantPosInvoiceRequest invoiceRequestModel;

  const BottomActionButtons({
    super.key,
    required this.state,
    required this.invoiceRequestModel,
  });

  /// Resolves selected payment methods into SavePaymentModel list
  List<RestaurantPosPaymentRequest> _buildPayments() {
    if (state.selectedMethod == PaymentMethodType.split) {
      // Return split method entries that have an amount > 0
      return state.splitAmounts.entries
          .where((e) => e.value > 0)
          .map(
            (e) => RestaurantPosPaymentRequest(
              paymentMethodId: e.key,
              amount: e.value,
            ),
          )
          .toList();
    } else {
      // 1 = Cash, 2 = Card/POS Terminal
      final int methodId = state.selectedMethod == PaymentMethodType.cash
          ? 1
          : 2;
      return [
        RestaurantPosPaymentRequest(
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
                      final finalInvoiceRequest =
                          SaveRestaurantPosInvoiceRequest(
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
                backgroundColor: context.appExtraTheme.greenBackground,
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
            child: ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: spacing.md),
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: context.appExtraTheme.cancelPorder),
                  borderRadius: BorderRadius.circular(spacing.radiusMd),
                ),
              ),
              child: Text(lang.cancel, style: theme.textTheme.bodyMedium),
            ),
          ),
        ],
      ),
    );
  }
}
