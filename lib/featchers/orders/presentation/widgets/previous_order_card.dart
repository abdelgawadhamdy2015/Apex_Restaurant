import 'dart:developer';

import 'package:apex_restaurant/core/helpers/helper_methods.dart';
import 'package:apex_restaurant/core/shared/model/print_kitchen_request.dart';
import 'package:apex_restaurant/featchers/cart/data/enums/cart_enum.dart';
import 'package:apex_restaurant/featchers/orders/data/model/invoice_report_request.dart';
import 'package:apex_restaurant/featchers/orders/presentation/bloc/orders_state.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/helpers/extensions.dart';
import '../../data/model/previous_invoice_model.dart';
import '../bloc/orders_bloc.dart';
import '../bloc/orders_event.dart';
import '../../../../generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Card representing a single completed order on the "Previous Orders" tab.
class PreviousOrderCard extends StatefulWidget {
  final PreviousInvoiceModel order;
  final S lang;

  const PreviousOrderCard({super.key, required this.order, required this.lang});

  @override
  State<PreviousOrderCard> createState() => _PreviousOrderCardState();
}

class _PreviousOrderCardState extends State<PreviousOrderCard> {
  /// True only on the card whose print button was tapped.
  /// This stops every other card in the list from reacting to the same state.
  bool _waitingForReport = false;

  PreviousInvoiceModel get order => widget.order;
  S get lang => widget.lang;

  void _showPrintDialog(BuildContext parentContext) {
    final theme = Theme.of(context);
    final spacing = parentContext.spacing;
    final orderState = parentContext.read<OrdersBloc>().state;
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: theme.colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(spacing.radiusLg),
          ),
          title: Text(
            lang.print,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.order.posType == CartOrderType.DINE_IN.apiValue)
                _PrintOptionButton(
                  icon: Icons.restaurant_outlined,
                  title: lang.btnPrintKitchen,
                  color: theme.colorScheme.primary,
                  onPressed: () {
                    _waitingForReport = true; // <-- add this

                    context.read<OrdersBloc>().add(
                      PrintKitchenReportEvent(
                        request: PrintKitchenRequest(
                          invoiceId: order.invoiceId ?? 0,
                        ),
                      ),
                    );
                    dialogContext.pop();
                  },
                ),
              SizedBox(height: spacing.sm),
              _PrintOptionButton(
                icon: Icons.receipt_long_outlined,
                title: lang.btnPrintReceipt,
                color: theme.colorScheme.secondary,
                onPressed: () {
                  HelperMethods.printDirectPdf(
                    context,
                    orderState.invoiceReport?.fileUrl,
                    "Receipt_${order.invoiceCode}.pdf",
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;
    final iconSizes = context.iconSizes;

    final invoiceCode = order.invoiceCode ?? '';
    final invoiceDate = order.invoiceDate;
    final personName = order.personNameAr ?? '';
    final totalAmount = order.totalAmount ?? 0.0;

    return BlocListener<OrdersBloc, OrdersState>(
      listenWhen: (previous, current) =>
          _waitingForReport &&
          previous.status != current.status &&
          (current.status == OrdersStatus.invoiceReportSuccess ||
              current.status == OrdersStatus.invoiceReportFailure ||
              current.status == OrdersStatus.printKitchenFailure ||
              current.status == OrdersStatus.printKitchenSuccess),
      listener: (context, state) {
        _waitingForReport = false;

        if (state.status == OrdersStatus.invoiceReportSuccess) {
          _showPrintDialog(context);
        } else if (state.status == OrdersStatus.invoiceReportFailure) {
          HelperMethods.showSnackBar(
            context: context,
            message: state.errorMessage ?? 'فشل استرجاع التقرير',
            isError: true,
          );
        } else if (state.status == OrdersStatus.printKitchenFailure) {
          log("printKitchenFailure");

          HelperMethods.showSnackBar(
            context: context,
            message: state.errorMessage ?? "'فشل طباعة الفاتورة",
            isError: true,
          );
        } else if (state.status == OrdersStatus.printKitchenSuccess) {
          log("success");
          HelperMethods.showSnackBar(
            context: context,
            message: state.errorMessage ?? " تم طباعة الفاتورة بنجاح",
            isError: false,
          );
        }
      },
      child: Container(
        margin: EdgeInsets.only(bottom: spacing.md),
        padding: EdgeInsets.all(spacing.md),
        decoration: BoxDecoration(
          color: theme.colorScheme.onSurface,
          borderRadius: BorderRadius.circular(spacing.radiusLg),
          border: Border.all(color: theme.colorScheme.outlineVariant),
          boxShadow: [
            BoxShadow(
              color: context.appExtraTheme.shadowColor,
              offset: const Offset(-5, 0),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  invoiceCode,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: iconSizes.sm,
                      color: theme.colorScheme.onSecondary,
                    ),
                    SizedBox(width: spacing.xxs),
                    Text(
                      invoiceDate != null
                          ? '${invoiceDate.year}-'
                                '${invoiceDate.month.toString().padLeft(2, '0')}-'
                                '${invoiceDate.day.toString().padLeft(2, '0')} | '
                                '${invoiceDate.hour}:'
                                '${invoiceDate.minute.toString().padLeft(2, '0')}'
                          : '',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            Divider(
              height: spacing.lg,
              color: theme.colorScheme.outlineVariant,
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lang.customer,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSecondary,
                      ),
                    ),
                    Text(
                      personName,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      lang.total,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSecondary,
                      ),
                    ),
                    Text(
                      lang.priceWithCurrency(totalAmount.toStringAsFixed(2)),
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            SizedBox(height: spacing.md),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      context.read<OrdersBloc>().add(
                        RestoreOrderEvent(
                          invoiceId: order.invoiceId ?? 0,
                          canEdite: false,
                        ),
                      );
                    },
                    icon: Icon(
                      Icons.visibility_outlined,
                      color: theme.colorScheme.primary,
                      size: iconSizes.sm,
                    ),
                    label: Text(
                      lang.preview,
                      style: TextStyle(color: theme.colorScheme.primary),
                    ),
                    style: OutlinedButton.styleFrom(
                      backgroundColor:
                          context.appExtraTheme.secondaryBackground,
                      side: BorderSide.none,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(spacing.radiusLg),
                      ),
                    ),
                  ),
                ),

                SizedBox(width: spacing.sm),

                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _waitingForReport
                        ? null
                        : () {
                            // Mark THIS card as the one waiting for the report.
                            _waitingForReport = true;
                            context.read<OrdersBloc>().add(
                              GetInvoiceReportEvent(
                                request: InvoiceReportRequest(
                                  invoiceId: order.invoiceId ?? 0,
                                ),
                              ),
                            );
                          },
                    icon: Icon(
                      Icons.print_outlined,
                      color: theme.colorScheme.secondary,
                      size: iconSizes.sm,
                    ),
                    label: Text(
                      lang.print,
                      style: TextStyle(color: theme.colorScheme.secondary),
                    ),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: theme.colorScheme.secondary.withValues(
                        alpha: 0.12,
                      ),
                      side: BorderSide.none,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(spacing.radiusLg),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _PrintOptionButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onPressed;

  const _PrintOptionButton({
    required this.icon,
    required this.title,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;
    final iconSizes = context.iconSizes;

    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: color, size: iconSizes.md),
        label: Text(
          title,
          style: theme.textTheme.titleSmall?.copyWith(
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: spacing.md),
          backgroundColor: color.withValues(alpha: 0.08),
          side: BorderSide(color: color.withValues(alpha: 0.25)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(spacing.radiusMd),
          ),
        ),
      ),
    );
  }
}
