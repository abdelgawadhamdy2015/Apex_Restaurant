import 'package:apex_restaurant/core/helpers/extensions.dart';
import 'package:apex_restaurant/core/helpers/helper_methods.dart';
import 'package:apex_restaurant/core/themes/app_colors.dart';
import 'package:apex_restaurant/featchers/cart/presentation/bloc/cart_bloc.dart';
import 'package:apex_restaurant/featchers/cart/presentation/bloc/cart_event.dart';
import 'package:apex_restaurant/featchers/payment/data/model/payment_success_model.dart';
import 'package:apex_restaurant/featchers/payment/presentation/bloc/payment_bloc.dart';
import 'package:apex_restaurant/featchers/payment/presentation/bloc/payment_event.dart';
import 'package:apex_restaurant/featchers/pos/presentation/bloc/pos_bloc.dart';
import 'package:apex_restaurant/featchers/pos/presentation/bloc/pos_event.dart';
import 'package:apex_restaurant/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class PaymentSuccess extends StatelessWidget {
  final PaymentSuccessModel model;

  const PaymentSuccess({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;
    final appExtraTheme = context.appExtraTheme;
    final lang = S.of(context);

    final String formattedDate = lang.formattedDateTime(
      model.transactionTime.year,
      model.transactionTime.month.toString().padLeft(2, '0'),
      model.transactionTime.day.toString().padLeft(2, '0'),
      model.transactionTime.hour.toString().padLeft(2, '0'),
      model.transactionTime.minute.toString().padLeft(2, '0'),
    );

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: appExtraTheme.successGradient),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: spacing.lg,
              vertical: spacing.md,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: spacing.md),

                // Success Icon Badge
                Center(
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: const BoxDecoration(
                      color: Color(0xFFD4F3D6),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Icon(
                        Icons.check_circle,
                        color: appExtraTheme.greenBackground,
                        size: 56,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: spacing.md),

                // Title & Subtitle
                Text(
                  lang.paymentSuccessful,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF0F172A),
                  ),
                ),
                SizedBox(height: spacing.xs),
                Text(
                  lang.orderProcessedSuccessfully,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFF64748B),
                  ),
                ),
                SizedBox(height: spacing.lg),

                // Invoice Card
                Container(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.onSurface,
                    borderRadius: BorderRadius.circular(spacing.radiusLg),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Card Header
                      Container(
                        padding: EdgeInsets.all(spacing.md),
                        decoration: BoxDecoration(
                          color: appExtraTheme.secondaryBackground,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(spacing.radiusLg),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  lang.orderNumber,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onSecondary,
                                  ),
                                ),
                                Text(
                                  model.orderNumber.startsWith('#')
                                      ? model.orderNumber
                                      : '#${model.orderNumber}',
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    color: theme.colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  lang.invoiceNumber,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onSecondary,
                                  ),
                                ),
                                Text(
                                  model.invoiceNumber,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: theme.colorScheme.onPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Card Details Body
                      Padding(
                        padding: EdgeInsets.all(spacing.md),
                        child: Column(
                          children: [
                            _InfoRow(
                              label: lang.totalPaid,
                              value: lang.priceWithCurrency(
                                model.totalPaid.toStringAsFixed(2),
                              ),
                              isBold: true,
                            ),
                            SizedBox(height: spacing.sm),
                            _InfoRow(
                              label: lang.paymentMethod,
                              value: model.paymentMethodName,
                              iconWidget: Icon(
                                Icons.credit_card,
                                size: 18,
                                color: theme.colorScheme.tertiary,
                              ),
                            ),
                            SizedBox(height: spacing.sm),
                            _InfoRow(
                              label: lang.transactionDate,
                              value: formattedDate,
                            ),

                            Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: spacing.md,
                              ),
                              child: const Divider(
                                height: 1,
                                color: Color(0xFFF1F5F9),
                              ),
                            ),

                            // Order Details Title
                            Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                lang.orderDetails,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: const Color(0xFF94A3B8),
                                ),
                              ),
                            ),
                            SizedBox(height: spacing.sm),

                            // Order Items List
                            ...model.items.map(
                              (item) => Padding(
                                padding: EdgeInsets.only(bottom: spacing.md),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.name,
                                          style: theme.textTheme.bodyMedium
                                              ?.copyWith(
                                                fontWeight: FontWeight.bold,
                                                color:
                                                    theme.colorScheme.onPrimary,
                                              ),
                                        ),
                                        Text(
                                          lang.quantityWithCount(item.quantity),
                                          style: theme.textTheme.bodySmall
                                              ?.copyWith(
                                                color: theme
                                                    .colorScheme
                                                    .onSecondary,
                                              ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      lang.priceWithCurrency(
                                        item.price.toStringAsFixed(2),
                                      ),
                                      style: theme.textTheme.bodyMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: theme.colorScheme.onPrimary,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: spacing.xl),

                // Action Buttons
                const _SuccessActionButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SuccessActionButtons extends StatelessWidget {
  const _SuccessActionButtons();

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;
    final theme = Theme.of(context);
    final lang = S.of(context);
    final state = context.read<PaymentBloc>().state;

    return Column(
      children: [
        _CustomActionButton(
          label: lang.btnNewOrder,
          icon: Icons.add_shopping_cart,
          backgroundColor: theme.colorScheme.primary,
          contentColor: AppColors.white,
          onTap: () {
            final cartBloc = context.read<CartBloc>();
            context.read<PaymentBloc>().add(ClearPaymentEvent());
            cartBloc.add(ClearCartEvent());
            context.pop();
          },
        ),
        SizedBox(height: spacing.sm),
        _CustomActionButton(
          label: lang.btnPrintReceipt,
          icon: Icons.print_outlined,
          onTap: () {
            final fileUrl = state.successResponseModel?.printingCheque?.fileURL;
            HelperMethods.printDirectPdf(context, fileUrl, 'Receipt');
          },
        ),
        SizedBox(height: spacing.sm),
        _CustomActionButton(
          label: lang.btnPrintKitchen,
          icon: Icons.soup_kitchen_outlined,
          onTap: () {
            final fileUrl = state.successResponseModel?.printingCheque?.fileURL;
            HelperMethods.printDirectPdf(context, fileUrl, 'Kitchen_Ticket');
          },
        ),
        SizedBox(height: spacing.sm),
        _CustomActionButton(
          label: lang.btnPreviousOrders,
          icon: Icons.shopping_bag_outlined,
          onTap: () {
            final cartBloc = context.read<CartBloc>();
            context.read<PaymentBloc>().add(ClearPaymentEvent());
            cartBloc.add(ClearCartEvent());
            context.pop();
            context.read<PosBloc>().add(
              SelectedNavIndexEvent(selectedNavIndex: 1),
            );
          },
        ),
      ],
    );
  }
}

class _CustomActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color? backgroundColor;
  final Color? contentColor;
  final VoidCallback onTap;

  const _CustomActionButton({
    required this.label,
    required this.icon,
    this.backgroundColor,
    required this.onTap,
    this.contentColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(spacing.radiusMd),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: spacing.md),
          decoration: BoxDecoration(
            color: backgroundColor ?? theme.colorScheme.onSurface,
            borderRadius: BorderRadius.circular(spacing.radiusMd),
            border: Border.all(color: theme.colorScheme.primary, width: 1.5),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: contentColor ?? theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: spacing.sm),
              Icon(
                icon,
                color: contentColor ?? theme.colorScheme.primary,
                size: 22,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Widget? iconWidget;
  final bool isBold;

  const _InfoRow({
    required this.label,
    required this.value,
    this.iconWidget,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSecondary,
          ),
        ),
        Row(
          children: [
            if (iconWidget != null) ...[iconWidget!, const SizedBox(width: 6)],
            Text(
              value,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
                color: theme.colorScheme.onPrimary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
