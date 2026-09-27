import '../../../../core/helpers/extensions.dart';
import '../../../../core/helpers/helper_methods.dart';
import '../../../../core/shared/widgets/custom_app_bar.dart';
import '../../../cart/data/models/invoice_request.dart';
import '../../data/model/payment_request_model.dart';
import '../bloc/payment_bloc.dart';
import '../bloc/payment_event.dart';
import '../bloc/payment_state.dart';
import '../widgets/bottom_action_buttons.dart';
import '../widgets/due_amount_card.dart';
import '../widgets/paid_amount_input_field.dart';
import '../widgets/payment_method_tabs.dart';
import '../widgets/payment_success.dart';
import '../widgets/reference_number_input_field.dart';
import '../widgets/remaining_amount_card.dart';
import '../widgets/split_methods_list.dart';
import '../widgets/total_amount_card.dart';
import '../../../../generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key, required this.invoiceRequestModel});

  final SaveRestaurantPosInvoiceRequest invoiceRequestModel;

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PaymentBloc>().add(
        InitializePaymentEvent(
          totalAmount: widget.invoiceRequestModel.invoice.totalInvoicePrice,
        ),
      );
      context.read<PaymentBloc>().add(FetchPaymentMethodsEvent());
    });
  }

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
                          SplitMethodsList(
                            paymentMethods: state.paymentMethods ?? [],
                          ),
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
                  invoiceRequestModel: widget.invoiceRequestModel,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
