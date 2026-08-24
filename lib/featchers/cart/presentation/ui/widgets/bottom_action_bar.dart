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
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// Fixed bottom bar with the checkout and hold-order actions.
class BottomActionBar extends StatelessWidget {
  const BottomActionBar({super.key, required this.canEdit});
  final bool canEdit;

  void _checkout(BuildContext context) {
    // Validate cart state before proceeding to checkout
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

    return BlocListener<CartBloc, CartState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == CartStatus.pindingSuccess) {
          // إظهار الرسالة من successMessage وليس errorMessage
          final message =
              state.successMessage ?? S.of(context).savedSuccessfully;

          HelperMethods.showSnackBar(
            context: context,
            message: message,
            isError: false,
          );

          // مسح عناصر السلة بعد تعليق/حفظ الطلب بنجاح
          context.read<CartBloc>().add(ClearCartEvent());

          // التوجيه إلى شاشة الـ POS وإغلاق باقي الشاشات
          context.goNamed(Routes.posScreen);
        } else if (state.status == CartStatus.pindingFailure) {
          HelperMethods.showSnackBar(
            context: context,
            message: state.errorMessage ?? S.of(context).somethingWentWrong,
            isError: true,
          );
        }
      },
      child: BlocSelector<CartBloc, CartState, CartOrderType>(
        selector: (state) => state.selectedOrderType,
        builder: (context, selectedOrderType) {
          return Container(
            padding: EdgeInsets.all(spacing.md),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              border: Border(
                top: BorderSide(color: theme.colorScheme.outlineVariant),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
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
                    onPressed: canEdit ? () => _checkout(context) : null,
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
                  onPressed: canEdit
                      ? () {
                          final state = context.read<CartBloc>().state;

                          if (selectedOrderType == CartOrderType.DINE_IN) {
                            context.read<CartBloc>().add(
                              SaveTableOrderEvent(
                                request:
                                    state.toSaveRestaurantPosInvoiceRequest,
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
                    selectedOrderType == CartOrderType.DINE_IN
                        ? lang.save
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
