import 'dart:developer';

import 'package:apex_restaurant/featchers/orders/data/model/invoice_report_request.dart';

import '../../../../../core/helpers/extensions.dart';
import '../../../../../core/helpers/helper_methods.dart';
import '../../../../../core/helpers/size_helper.dart';
import '../../../../../core/router/routes.dart';
import '../../../data/enums/cart_enum.dart';
import '../../../data/models/invoice_request.dart';
import '../../bloc/cart_bloc.dart';
import '../../bloc/cart_event.dart';
import '../../bloc/cart_state.dart';
import '../../../../payment/presentation/screens/tablet_payment_dialog.dart';
import '../../../../../generated/l10n.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// Fixed bottom bar with the checkout and hold-order actions.
class BottomActionBar extends StatelessWidget {
  const BottomActionBar({super.key});

  void _showPrintDialog(BuildContext parentContext) {
    final cartState = parentContext.read<CartBloc>().state;
    final lang = S.of(parentContext);
    HelperMethods.showPrintDialog(
      context: parentContext,
      title: lang.print,
      kitchenTitle: lang.btnPrintKitchen,
      receiptTitle: lang.btnPrintReceipt,
      receiptFileName: 'Receipt.pdf',

      onPrintReceipt: () {
        HelperMethods.printDirectPdf(
          parentContext,
          cartState.invoiceReportResponse?.fileUrl,
          'Receipt_.pdf',
        );
      },
    );
  }

  void _checkout(BuildContext context) {
    final cart = context.read<CartBloc>().state;
    if (cart.isCalculating) return;
    if (cart.calculationResult == null) {
      HelperMethods.showSnackBar(
        context: context,
        message: S.of(context).somethingWentWrong,
        isError: true,
      );
      return;
    }
    if (context.read<CartBloc>().state.items.isEmpty) {
      HelperMethods.showSnackBar(
        context: context,
        message: S.of(context).cartIsEmpty,
        isError: true,
      );
      return;
    }
    if (context.read<CartBloc>().state.selectedPerson == null) {
      HelperMethods.showSnackBar(
        context: context,
        message: S.of(context).pleaseSelectValidCustomer,
        isError: true,
      );
      return;
    }
    if (context.read<CartBloc>().state.selectedOrderType ==
            CartOrderType.FROMBRANCH &&
        (context.read<CartBloc>().state.fromBranchDateTime == null ||
            context.read<CartBloc>().state.fromBranchDateTime!.isBefore(
              DateTime.now(),
            ))) {
      HelperMethods.showSnackBar(
        context: context,
        message: S.of(context).pleaseSelectValidFromBranchDateTime,
        isError: true,
      );
      return;
    }
    if (context.read<CartBloc>().state.selectedOrderType ==
            CartOrderType.DINE_IN &&
        (context.read<CartBloc>().state.selectedTable == null ||
            context.read<CartBloc>().state.selectedWaiter == null)) {
      HelperMethods.showSnackBar(
        context: context,
        message: S.of(context).pleaseSelectValidDineInTableandWaiter,
        isError: true,
      );
      return;
    }

    if (context.read<CartBloc>().state.selectedOrderType ==
            CartOrderType.DELIVERY &&
        (context.read<CartBloc>().state.selectedDeliveryMan == null ||
            context.read<CartBloc>().state.selectedAddress == null)) {
      HelperMethods.showSnackBar(
        context: context,
        message: S.of(context).pleaseSelectValidDeliveryManAndAddress,
        isError: true,
      );
      return;
    }

    if (context.read<CartBloc>().state.selectedOrderType ==
            CartOrderType.DELIVERY_COMPANY &&
        context.read<CartBloc>().state.selectedDeliveryCompany == null) {
      HelperMethods.showSnackBar(
        context: context,
        message: S.of(context).pleaseSelectValidDeliveryCompany,
        isError: true,
      );
      return;
    }

    final SaveRestaurantPosInvoiceRequest invoiceRequestModel = context
        .read<CartBloc>()
        .state
        .toSaveRestaurantPosInvoiceRequest;
    if (SizeHelper.isMobile == true) {
      context.pushNamed(Routes.paymentScreen, extra: invoiceRequestModel);
    } else {
      TabletPaymentDialog.show(
        context,
        invoiceRequestModel: invoiceRequestModel,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;
    final icons = context.iconSizes;
    final lang = S.of(context);
    final canEdit = context.select((CartBloc c) => c.state.canEditInvoice);
    final isReturnInvoice = context.select(
      (CartBloc bloc) => bloc.state.isReturnInvoice,
    );
    return BlocListener<CartBloc, CartState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == CartStatus.pindingSuccess ||
            state.status == CartStatus.saveDineInInvoiceSuccess) {
          // إظهار الرسالة من successMessage وليس errorMessage
          final message =
              state.successMessage ?? S.of(context).savedSuccessfully;

          HelperMethods.showSnackBar(
            context: context,
            message: message,
            isError: false,
          );

          // مسح عناصر السلة بعد حفظ الطلب بنجاح
          context.read<CartBloc>().add(ClearCartEvent());
          if (state.status == CartStatus.pindingSuccess) {
            context.pushReplacementNamed(Routes.posScreen);
          }
        } else if (state.status == CartStatus.pindingFailure ||
            state.status == CartStatus.saveDineInInvoiceFailure) {
          HelperMethods.showSnackBar(
            context: context,
            message: state.errorMessage ?? S.of(context).somethingWentWrong,
            isError: true,
          );
        } else if (state.status == CartStatus.invoiceReportSuccess) {
          _showPrintDialog(context);
        }
      },
      child: BlocSelector<CartBloc, CartState, List<dynamic>>(
        selector: (state) => [state.selectedOrderType, state.status],
        builder: (context, selectedOrderTypeAndStatus) {
          final isCalculating =
              selectedOrderTypeAndStatus[1] == CartStatus.itemsUpdateing;

          return Container(
            padding: EdgeInsets.all(spacing.md),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              border: Border(
                top: BorderSide(color: theme.colorScheme.outlineVariant),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: spacing.sm - spacing.xxs / 2,
                  offset: Offset(0, -spacing.xxs),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                        vertical: spacing.sm + spacing.xxs / 2,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(spacing.radiusMd),
                      ),
                    ),
                    onPressed:
                        (canEdit || isReturnInvoice == true) && !isCalculating
                        ? () => _checkout(context)
                        : null,

                    icon: Icon(Icons.payments_outlined, size: icons.md),
                    label: Text(
                      lang.checkout,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                SizedBox(width: spacing.sm),

                if (isReturnInvoice != true)
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: spacing.md,
                        vertical: spacing.sm + spacing.xxs / 2,
                      ),
                      backgroundColor: theme.colorScheme.onSurface,
                      side: BorderSide(color: theme.colorScheme.outlineVariant),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(spacing.radiusMd),
                      ),
                    ),
                    onPressed: canEdit && !isCalculating
                        ? () {
                            final state = context.read<CartBloc>().state;

                            if (selectedOrderTypeAndStatus[0] ==
                                CartOrderType.DINE_IN) {
                              // final invoiceCode =
                              //     state.SaveTableData?.data?.eInvoiceCode;
                              final invoiceId = state.saveTableData?.invoiceId;
                              // final invoiceTypeId =
                              //     state.SaveTableData?.data?.invoiceTypeId;
                              log(
                                "invoice  : ${state.saveTableData?.invoiceId}",
                              );
                              context.read<CartBloc>().add(
                                GetInvoiceReportEvent(
                                  request: InvoiceReportRequest(
                                    invoiceId: invoiceId,
                                  ),
                                ),
                              );
                            } else {
                              context.read<CartBloc>().add(
                                HoldOrderEvent(
                                  request:
                                      state.toSaveRestaurantPosInvoiceRequest,
                                ),
                              );
                            }
                          }
                        : null,
                    icon: Icon(
                      Icons.pause_circle_outline,
                      color: theme.colorScheme.onPrimary,
                      size: icons.md,
                    ),
                    label: Text(
                      selectedOrderTypeAndStatus[0] == CartOrderType.DINE_IN
                          ? lang.print
                          : lang.holdOrder,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
