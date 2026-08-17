import 'package:apex_restaurant/core/helpers/extensions.dart';
import 'package:apex_restaurant/core/helpers/helper_methods.dart';
import 'package:apex_restaurant/featchers/cart/data/models/invoice_request.dart';
import 'package:apex_restaurant/featchers/payment/data/model/payment_request_model.dart';
import 'package:apex_restaurant/featchers/payment/presentation/bloc/payment_bloc.dart';
import 'package:apex_restaurant/featchers/payment/presentation/bloc/payment_state.dart';
import 'package:apex_restaurant/featchers/payment/presentation/tablet_widgets/amount_summary_row.dart';
import 'package:apex_restaurant/featchers/payment/presentation/tablet_widgets/split_payment_grid.dart';
import 'package:apex_restaurant/featchers/payment/presentation/tablet_widgets/tablet_payment_success.dart';
import 'package:apex_restaurant/featchers/payment/presentation/widgets/bottom_action_buttons.dart';
import 'package:apex_restaurant/featchers/payment/presentation/widgets/payment_method_tabs.dart';
import 'package:apex_restaurant/featchers/payment/presentation/widgets/reference_number_input_field.dart';
import 'package:apex_restaurant/featchers/payment/presentation/widgets/total_amount_card.dart';
import 'package:apex_restaurant/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TabletPaymentDialog extends StatelessWidget {
  const TabletPaymentDialog({super.key, required this.invoiceRequestModel});

  final SaveRestaurantPosInvoiceRequest invoiceRequestModel;

  static Future<void> show(
    BuildContext context, {
    required SaveRestaurantPosInvoiceRequest invoiceRequestModel,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) =>
          TabletPaymentDialog(invoiceRequestModel: invoiceRequestModel),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;
    final lang = S.of(context);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(
        horizontal: spacing.xl,
        vertical: spacing.lg,
      ),
      child: BlocConsumer<PaymentBloc, PaymentState>(
        listener: (context, state) {
          if (state.status == PaymentStatus.error) {
            HelperMethods.showSnackBar(
              context: context,
              message: state.errorMessage ?? lang.somethingWentWrong,
              isError: true,
            );
          }
        },
        builder: (context, state) {
          if (state.status == PaymentStatus.success &&
              state.successModel != null) {
            // context.pop();
            return Container(
              width: 540,
              constraints: const BoxConstraints(maxHeight: 680),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(spacing.radiusLg),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(spacing.radiusLg),
                child: TabletPaymentSuccess(model: state.successModel!),
              ),
            );
          }

          return Container(
            width: 520,
            constraints: const BoxConstraints(maxHeight: 700),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(spacing.radiusLg),
              border: Border.all(color: theme.colorScheme.outlineVariant),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(spacing.radiusLg),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header — close (X) on the leading edge, title centered.
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: spacing.md,
                      vertical: spacing.sm,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(width: 48), // balances the close icon
                        Text(
                          lang.payment,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),

                  // Content
                  Flexible(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.all(spacing.md),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const PaymentMethodTabs(),
                          SizedBox(height: spacing.md),
                          const TotalAmountCard(),
                          SizedBox(height: spacing.md),
                          if (state.selectedMethod ==
                              PaymentMethodType.split) ...[
                            const SplitPaymentGrid(),
                          ] else ...[
                            const AmountSummaryRow(),
                            if (state.selectedMethod ==
                                PaymentMethodType.card) ...[
                              SizedBox(height: spacing.md),
                              const ReferenceNumberInputField(),
                            ],
                          ],
                        ],
                      ),
                    ),
                  ),

                  // Footer
                  BottomActionButtons(
                    state: state,
                    invoiceRequestModel: invoiceRequestModel,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
