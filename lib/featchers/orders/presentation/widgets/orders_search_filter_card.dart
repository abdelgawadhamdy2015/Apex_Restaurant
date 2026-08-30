import '../../../../core/helpers/extensions.dart';
import '../../../../core/helpers/restaurant_constants.dart';
import '../../../../core/shared/widgets/date_text_field.dart';
import '../../../../core/themes/app_colors.dart';
import '../../data/model/get_previous_invoice_request.dart';
import '../bloc/orders_bloc.dart';
import '../bloc/orders_event.dart';
import '../bloc/orders_state.dart';
import '../../../../generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ignore: must_be_immutable
class OrdersSearchFilterCard extends StatelessWidget {
  final TextEditingController invoiceController;
  final TextEditingController customerController;
  final TextEditingController fromDateController;
  final TextEditingController toDateController;
  final S l10n;

  OrdersSearchFilterCard({
    super.key,
    required this.invoiceController,
    required this.customerController,
    required this.fromDateController,
    required this.toDateController,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;
    final iconSizes = context.iconSizes;

    return Container(
      padding: EdgeInsets.all(spacing.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.onSurface,
        borderRadius: BorderRadius.circular(spacing.radiusLg),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: invoiceController,
                  decoration: InputDecoration(
                    label: Text(l10n.invoiceNumberLabel),
                    hintText: l10n.invoiceNumberHint,
                    fillColor: theme.colorScheme.surface,
                  ),
                ),
              ),
              SizedBox(width: spacing.sm),
              Expanded(
                child: TextField(
                  controller: customerController,
                  decoration: InputDecoration(
                    label: Text(l10n.customerNameLabel),
                    hintText: l10n.customerNameHint,
                    fillColor: theme.colorScheme.surface,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: spacing.md),
          Row(
            children: [
              Expanded(
                child: DateTextField(
                  label: l10n.fromDate,
                  controller: fromDateController,
                  type: DateTextFieldType.date,
                  onTap: () async {
                    final dateTime = await DateTextField.pickDateTime(
                      context,
                      type: DateTextFieldType.date,
                    );
                    if (dateTime != null) {
                      context.read<OrdersBloc>().add(
                        SelectDateEvent(dateTime: dateTime, isFrom: true),
                      );

                      fromDateController.text = RestaurantConstants.dateFormat
                          .format(dateTime);
                    }
                  },
                ),
              ),
              SizedBox(width: spacing.sm),
              Expanded(
                child: DateTextField(
                  label: l10n.toDate,
                  key: key,
                  controller: toDateController,
                  type: DateTextFieldType.date,
                  onTap: () async {
                    final dateTime = await DateTextField.pickDateTime(
                      context,
                      type: DateTextFieldType.date,
                    );

                    if (dateTime != null) {
                      context.read<OrdersBloc>().add(
                        SelectDateEvent(dateTime: dateTime, isFrom: false),
                      );

                      toDateController.text = RestaurantConstants.dateFormat
                          .format(dateTime);
                    }
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: spacing.lg),
          ElevatedButton(
            onPressed: () {
              context.read<OrdersBloc>().add(
                FetchPreviousInvoicesEvent(
                  request: GetPreviousInvoiceRequest(
                    pageNumber: 1,
                    pageSize: kOrdersPageSize,
                    invoiceCode: invoiceController.text.trim().isEmpty
                        ? null
                        : invoiceController.text.trim(),
                    personName: customerController.text.trim().isEmpty
                        ? null
                        : customerController.text.trim(),
                    fromDate: context.read<OrdersBloc>().state.fromDate,
                    toDate: context.read<OrdersBloc>().state.toDate,
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 48),
              backgroundColor: theme.colorScheme.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(spacing.radiusLg),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.search, color: AppColors.white, size: iconSizes.md),
                SizedBox(width: spacing.xs),
                Text(
                  l10n.search,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
