import 'package:apex_restaurant/core/helpers/extensions.dart';
import 'package:apex_restaurant/core/helpers/helper_methods.dart';
import 'package:apex_restaurant/featchers/cart/data/models/invoice_request_model.dart';
import 'package:apex_restaurant/featchers/payment/data/model/payment_request_model.dart';
import 'package:apex_restaurant/featchers/payment/presentation/bloc/payment_bloc.dart';
import 'package:apex_restaurant/featchers/payment/presentation/bloc/payment_state.dart';
import 'package:apex_restaurant/featchers/payment/presentation/widgets/bottom_action_buttons.dart';
import 'package:apex_restaurant/featchers/payment/presentation/widgets/paid_amount_input_field.dart';
import 'package:apex_restaurant/featchers/payment/presentation/widgets/payment_method_tabs.dart';
import 'package:apex_restaurant/featchers/payment/presentation/widgets/payment_success.dart';
import 'package:apex_restaurant/featchers/payment/presentation/widgets/reference_number_input_field.dart';
import 'package:apex_restaurant/featchers/payment/presentation/widgets/remaining_amount_card.dart';
import 'package:apex_restaurant/featchers/payment/presentation/widgets/split_methods_list.dart';
import 'package:apex_restaurant/featchers/payment/presentation/widgets/total_amount_card.dart';
import 'package:apex_restaurant/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TabletPaymentDialog extends StatelessWidget {
  const TabletPaymentDialog({super.key, required this.invoiceRequestModel});

  final SaveInvoiceRequestModel invoiceRequestModel;

  /// Helper method to show the dialog
  static Future<void> show(
    BuildContext context, {
    required SaveInvoiceRequestModel invoiceRequestModel,
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
            return Container(
              width: 540,
              constraints: const BoxConstraints(maxHeight: 680),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(spacing.radiusLg),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(spacing.radiusLg),
                child: PaymentSuccess(model: state.successModel!),
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
                  // Dialog Header
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: spacing.md,
                      vertical: spacing.sm,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.close),
                        ),
                        Text(
                          lang.payment,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 48), // Spacer to balance icon
                      ],
                    ),
                  ),
                  const Divider(height: 1),

                  // Content Body
                  Flexible(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.all(spacing.md),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const TotalAmountCard(),
                          SizedBox(height: spacing.md),
                          const PaymentMethodTabs(),
                          SizedBox(height: spacing.md),
                          if (state.selectedMethod ==
                              PaymentMethodType.split) ...[
                            const SplitMethodsList(),
                          ] else ...[
                            if (state.selectedMethod ==
                                PaymentMethodType.cash) ...[
                              const PaidAmountInputField(),
                              SizedBox(height: spacing.md),
                              const RemainingAmountCard(),
                            ] else if (state.selectedMethod ==
                                PaymentMethodType.card) ...[
                              const PaidAmountInputField(),
                              SizedBox(height: spacing.md),
                              const ReferenceNumberInputField(),
                            ],
                          ],
                        ],
                      ),
                    ),
                  ),

                  // Actions Footer
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
