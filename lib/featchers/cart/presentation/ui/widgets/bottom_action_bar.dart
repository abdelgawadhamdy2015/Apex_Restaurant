import 'package:apex_restaurant/core/helpers/extensions.dart';
import 'package:apex_restaurant/core/helpers/helper_methods.dart';
import 'package:apex_restaurant/core/router/routes.dart';
import 'package:apex_restaurant/featchers/cart/data/models/invoice_request_model.dart';
import 'package:apex_restaurant/featchers/cart/presentation/bloc/cart_bloc.dart';
import 'package:apex_restaurant/featchers/cart/presentation/bloc/cart_event.dart';
import 'package:apex_restaurant/featchers/cart/presentation/bloc/cart_state.dart';
import 'package:apex_restaurant/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// Fixed bottom bar with the checkout and hold-order actions.
class BottomActionBar extends StatelessWidget {
  const BottomActionBar({super.key});

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
            OrderType.takeaway &&
        (context.read<CartBloc>().state.takeawayDateTime == null ||
            context.read<CartBloc>().state.takeawayDateTime!.isBefore(
              DateTime.now(),
            ))) {
      HelperMethods.showSnackBar(
        context: context,
        message: S.of(context).pleaseSelectValidTakeawayDateTime,
        isError: true,
      );
      return;
    }
    if (context.read<CartBloc>().state.selectedOrderType == OrderType.dineIn &&
        (context.read<CartBloc>().state.selectedTable == null ||
            context.read<CartBloc>().state.selectedWaiter == null)) {
      {
        HelperMethods.showSnackBar(
          context: context,
          message: S.of(context).pleaseSelectValidDineInTableandWaiter,
          isError: true,
        );
        return;
      }
    }

    if (context.read<CartBloc>().state.selectedOrderType ==
            OrderType.delivery &&
        (context.read<CartBloc>().state.selectedDeliveryMan == null ||
            context.read<CartBloc>().state.selectedAddress == null)) {
      {
        HelperMethods.showSnackBar(
          context: context,
          message: S.of(context).pleaseSelectValidDeliveryManAndAddress,
          isError: true,
        );
        return;
      }
    }

    if (context.read<CartBloc>().state.selectedOrderType ==
            OrderType.deliveryCompany &&
        context.read<CartBloc>().state.selectedDeliveryCompany == null) {
      {
        HelperMethods.showSnackBar(
          context: context,
          message: S.of(context).pleaseSelectValidDeliveryCompany,
          isError: true,
        );
        return;
      }
    }

    final SaveInvoiceRequestModel invoiceRequestModel = context
        .read<CartBloc>()
        .state
        .toSaveInvoiceRequestModel;
    context.pushNamed(Routes.paymentScreen, extra: invoiceRequestModel);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;
    final icons = context.iconSizes;
    final lang = S.of(context);

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
                foregroundColor: theme.colorScheme.onPrimary,
                padding: EdgeInsets.symmetric(
                  vertical: spacing.sm + spacing.xxs / 2,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(spacing.radiusMd),
                ),
              ),
              onPressed: () => _checkout(context),
              icon: Icon(Icons.payments_outlined, size: icons.md),
              label: Text(
                lang.checkout,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
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
              side: BorderSide(color: theme.colorScheme.outline),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(spacing.radiusMd),
              ),
            ),
            onPressed: () =>
                context.read<CartBloc>().add(HoldOrderSubmittedEvent()),
            icon: Icon(
              Icons.pause_circle_outline,
              color: theme.colorScheme.onSurface,
              size: icons.md,
            ),
            label: Text(
              lang.holdOrder,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
