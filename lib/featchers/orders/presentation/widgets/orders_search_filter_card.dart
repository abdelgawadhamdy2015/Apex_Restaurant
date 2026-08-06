import 'package:apex_restaurant/core/helpers/extensions.dart';
import 'package:apex_restaurant/core/helpers/restaurant_constants.dart';
import 'package:apex_restaurant/core/shared/widgets/date_text_field.dart';
import 'package:apex_restaurant/core/themes/app_colors.dart';
import 'package:apex_restaurant/featchers/orders/data/model/order_model.dart';
import 'package:apex_restaurant/featchers/orders/presentation/bloc/orders_bloc.dart';
import 'package:apex_restaurant/featchers/orders/presentation/bloc/orders_event.dart';
import 'package:apex_restaurant/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Search/filter card shown on the "Previous Orders" tab
/// (invoice number, customer name, and date range filters).
class OrdersSearchFilterCard extends StatelessWidget {
  final TextEditingController invoiceController;
  final TextEditingController customerController;
  final TextEditingController fromDateController;
  final TextEditingController toDateController;
  final S l10n;

  const OrdersSearchFilterCard({
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.invoiceNumberLabel,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onPrimary,
                      ),
                    ),
                    SizedBox(height: spacing.xxs),
                    TextField(
                      controller: invoiceController,
                      decoration: InputDecoration(
                        hintText: l10n.invoiceNumberHint,
                        fillColor: theme.colorScheme.surface,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: spacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.customerNameLabel,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onPrimary,
                      ),
                    ),
                    SizedBox(height: spacing.xxs),
                    TextField(
                      controller: customerController,
                      decoration: InputDecoration(
                        hintText: l10n.customerNameHint,
                        fillColor: theme.colorScheme.surface,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: spacing.md),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.fromDate,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onPrimary,
                      ),
                    ),
                    SizedBox(height: spacing.xxs),
                    DateTextField(
                      controller: fromDateController,
                      type: DateTextFieldType.date,
                      onTap: () async {
                        final dateTime = await DateTextField.pickDateTime(
                          context,
                          type: DateTextFieldType.date,
                        );
                        if (dateTime != null) {
                          fromDateController.text = RestaurantConstants
                              .dateTimeFormat
                              .format(dateTime);
                        }
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(width: spacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.toDate,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onPrimary,
                      ),
                    ),
                    SizedBox(height: spacing.xxs),
                    DateTextField(
                      key: key,
                      controller: toDateController,
                      type: DateTextFieldType.date,
                      onTap: () async {
                        final dateTime = await DateTextField.pickDateTime(
                          context,
                          type: DateTextFieldType.date,
                        );
                        if (dateTime != null) {
                          toDateController.text = RestaurantConstants
                              .dateTimeFormat
                              .format(dateTime);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: spacing.lg),
          ElevatedButton(
            onPressed: () {
              context.read<OrdersBloc>().add(
                FetchOrdersEvent(
                  filter: OrderFilterModel(
                    invoiceNumber: invoiceController.text,
                    customerName: customerController.text,
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
