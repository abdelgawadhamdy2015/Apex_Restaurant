import 'package:apex_restaurant/core/helpers/extensions.dart';
import 'package:apex_restaurant/core/helpers/helper_methods.dart';
import 'package:apex_restaurant/core/shared/widgets/custom_app_bar.dart';
import 'package:apex_restaurant/featchers/cart/data/models/invoice_request_model.dart';
import 'package:apex_restaurant/featchers/payment/data/model/payment_request_model.dart';
import 'package:apex_restaurant/featchers/payment/presentation/bloc/payment_bloc.dart';
import 'package:apex_restaurant/featchers/payment/presentation/bloc/payment_state.dart';
import 'package:apex_restaurant/featchers/payment/presentation/widgets/bottom_action_buttons.dart';
import 'package:apex_restaurant/featchers/payment/presentation/widgets/due_amount_card.dart';
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

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key, required this.invoiceRequestModel});

  final SaveInvoiceRequestModel invoiceRequestModel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;
    final lang = S.of(context);

    return BlocConsumer<PaymentBloc, PaymentState>(
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
          return PaymentSuccess(model: state.successModel!);
        }

        return Scaffold(
          backgroundColor: theme.colorScheme.surface,
          appBar: CustomAppBar(
            title: lang.payment,
            centerTitle: true,
            showBackButton: false,
          ),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(spacing.md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const TotalAmountCard(),
                        SizedBox(height: spacing.md),
                        const PaymentMethodTabs(),
                        SizedBox(height: spacing.md),
                        const DueAmountCard(),
                        SizedBox(height: spacing.md),
                        if (state.selectedMethod ==
                            PaymentMethodType.split) ...[
                          const SplitMethodsList(),
                        ] else ...[
                          const PaidAmountInputField(),
                          SizedBox(height: spacing.md),
                          if (state.selectedMethod == PaymentMethodType.cash)
                            const RemainingAmountCard()
                          else if (state.selectedMethod ==
                              PaymentMethodType.card)
                            const ReferenceNumberInputField(),
                        ],
                      ],
                    ),
                  ),
                ),
                BottomActionButtons(
                  state: state,
                  invoiceRequestModel: invoiceRequestModel,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
