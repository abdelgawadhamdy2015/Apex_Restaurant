import 'package:apex_restaurant/core/helpers/restaurant_constants.dart';
import 'package:apex_restaurant/featchers/more_actions/data/model/get_all_pos_invoice_request.dart';
import 'package:apex_restaurant/featchers/more_actions/presentation/bloc/more_actions_bloc.dart';
import 'package:apex_restaurant/featchers/more_actions/presentation/bloc/more_actions_event.dart';
import 'package:apex_restaurant/featchers/more_actions/presentation/bloc/more_actions_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/helpers/extensions.dart';
import '../../../../core/shared/widgets/custom_app_bar.dart';
import '../../../../generated/l10n.dart';
import 'package:flutter/material.dart';

class ReturnsScreen extends StatefulWidget {
  const ReturnsScreen({super.key});

  @override
  State<ReturnsScreen> createState() => _ReturnsScreenState();
}

class _ReturnsScreenState extends State<ReturnsScreen> {
  final TextEditingController _invoiceController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  int? _expandedIndex = 2;

  @override
  void dispose() {
    _invoiceController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lang = S.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final spacing = context.spacing;

    return Scaffold(
      backgroundColor: colorScheme.outlineVariant,
      appBar: CustomAppBar(
        title: lang.returns,
        showBackButton: true,
        onBackPressed: () => Navigator.of(context).pop(),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(spacing.md),
        child: BlocBuilder<MoreActionsBloc, MoreActionsState>(
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. Search Filter Card
                _buildSearchCard(context),
                SizedBox(height: spacing.md),
                ...state.invoices.map((e) {
                  return _InvoiceCard(
                    invoiceNumber: e.invoiceType,
                    time: RestaurantConstants.hoursFormat.format(e.invoiceDate),
                    itemsCountText: lang.itemsCount(5),
                    totalAmount: "${e.totalPrice} ${lang.currencySar}",
                    isExpanded: _expandedIndex == 0,
                    onTap: () => setState(() {
                      _expandedIndex = _expandedIndex == 0 ? null : 0;
                    }),
                  );
                }),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSearchCard(BuildContext context) {
    final lang = S.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final spacing = context.spacing;
    final iconSizes = context.iconSizes;
    final moreActionState = context.read<MoreActionsBloc>().state;
    final hintStyle = theme.textTheme.bodyMedium?.copyWith(
      color: colorScheme.onSurfaceVariant,
    );
    final fieldBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(spacing.radiusSm),
      borderSide: BorderSide(color: colorScheme.outlineVariant),
    );

    return Container(
      padding: EdgeInsets.all(spacing.md),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(spacing.radiusMd),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            lang.invoiceNumber,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: spacing.xxs),
          TextField(
            controller: _invoiceController,
            style: theme.textTheme.bodyMedium,
            decoration: InputDecoration(
              hintText: lang.invoiceNumberExample,
              hintStyle: hintStyle,
              filled: true,
              fillColor: colorScheme.outlineVariant.withOpacity(0.3),
              contentPadding: EdgeInsets.symmetric(
                horizontal: spacing.sm,
                vertical: spacing.xs,
              ),
              border: fieldBorder,
              enabledBorder: fieldBorder,
            ),
          ),
          SizedBox(height: spacing.sm),

          Text(
            lang.date,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: spacing.xxs),
          TextField(
            controller: _dateController,
            readOnly: true,
            style: theme.textTheme.bodyMedium,
            onTap: () async {
              await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2020),
                lastDate: DateTime(2030),
              );
            },
            decoration: InputDecoration(
              hintText: lang.dateFormatHint,
              hintStyle: hintStyle,
              filled: true,
              fillColor: colorScheme.outlineVariant.withOpacity(0.3),
              suffixIcon: Icon(
                Icons.calendar_today_outlined,
                size: iconSizes.sm,
                color: colorScheme.onSurfaceVariant,
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: spacing.sm,
                vertical: spacing.xs,
              ),
              border: fieldBorder,
              enabledBorder: fieldBorder,
            ),
          ),
          SizedBox(height: spacing.md),

          ElevatedButton.icon(
            onPressed: () {
              context.read<MoreActionsBloc>().add(
                FetchAllInvoicesEvent(
                  request: GetAllPosInvoiceRequest(
                    pageNumber: 1,
                    pageSize: 20,
                    invoiceTypeId: 11,
                    financialYearId: 1,
                    invoiceDate: moreActionState.fromDate,
                    invoiceType: moreActionState.invoiceType,
                  ),
                ),
              );
            },
            icon: Icon(Icons.search, size: iconSizes.sm),
            label: Text(
              lang.search,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
              padding: EdgeInsets.symmetric(vertical: spacing.sm),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(spacing.radiusSm),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InvoiceCard extends StatelessWidget {
  final String invoiceNumber;
  final String time;
  final String itemsCountText;
  final String totalAmount;
  final bool isExpanded;
  final VoidCallback onTap;

  const _InvoiceCard({
    required this.invoiceNumber,
    required this.time,
    required this.itemsCountText,
    required this.totalAmount,
    required this.isExpanded,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final lang = S.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final appExtraTheme = context.appExtraTheme;
    final spacing = context.spacing;
    final iconSizes = context.iconSizes;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(spacing.radiusMd),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(spacing.radiusMd),
            child: Padding(
              padding: EdgeInsets.all(spacing.md),
              child: Row(
                children: [
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    size: iconSizes.sm,
                    color: colorScheme.onPrimary,
                  ),
                  const Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        itemsCountText,
                        style: theme.textTheme.bodySmall?.copyWith(),
                      ),
                      SizedBox(height: spacing.xxs),
                      Text(
                        totalAmount,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: spacing.lg),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        invoiceNumber,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: spacing.xxs),
                      Row(
                        children: [
                          Text(
                            time,
                            style: theme.textTheme.bodySmall?.copyWith(),
                          ),
                          SizedBox(width: spacing.xxs),
                          Icon(Icons.access_time, size: iconSizes.xs),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          if (isExpanded) ...[
            Divider(height: 1, color: colorScheme.outlineVariant),
            Padding(
              padding: EdgeInsets.all(spacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      lang.orderDetails,
                      style: theme.textTheme.bodySmall?.copyWith(),
                    ),
                  ),
                  SizedBox(height: spacing.sm),

                  // ...items!.map(
                  //   (item) => Padding(
                  //     padding: EdgeInsets.only(bottom: spacing.xs),
                  //     child: Column(
                  //       children: [
                  //         Row(
                  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //           children: [
                  //             Text(
                  //               item.price,
                  //               style: theme.textTheme.bodyMedium?.copyWith(
                  //                 fontWeight: FontWeight.bold,
                  //               ),
                  //             ),
                  //             Row(
                  //               children: [
                  //                 Text(
                  //                   item.name,
                  //                   style: theme.textTheme.bodyMedium?.copyWith(
                  //                     fontWeight: FontWeight.w600,
                  //                   ),
                  //                 ),
                  //                 SizedBox(width: spacing.xs),
                  //                 Text(
                  //                   item.quantity,
                  //                   style: theme.textTheme.bodyMedium?.copyWith(
                  //                     fontWeight: FontWeight.bold,
                  //                   ),
                  //                 ),
                  //               ],
                  //             ),
                  //           ],
                  //         ),
                  //         SizedBox(height: spacing.xs),
                  //         Divider(
                  //           height: 1,
                  //           color: colorScheme.outlineVariant.withOpacity(0.5),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  SizedBox(height: spacing.md),

                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: appExtraTheme.greenBackground
                                .withOpacity(0.1),
                            foregroundColor: appExtraTheme.greenBackground,
                            elevation: 0,
                            padding: EdgeInsets.symmetric(vertical: spacing.sm),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                spacing.radiusSm,
                              ),
                              side: BorderSide(
                                color: appExtraTheme.greenBackground
                                    .withOpacity(0.4),
                              ),
                            ),
                          ),
                          child: Text(
                            lang.fullReturn,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: spacing.sm),

                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colorScheme.primary.withOpacity(
                              0.1,
                            ),
                            foregroundColor: colorScheme.primary,
                            elevation: 0,
                            padding: EdgeInsets.symmetric(vertical: spacing.sm),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                spacing.radiusSm,
                              ),
                              side: BorderSide(
                                color: colorScheme.primary.withOpacity(0.3),
                              ),
                            ),
                          ),
                          child: Text(
                            lang.partialReturn,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.primary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _OrderSubItem {
  final String name;
  final String quantity;
  final String price;

  const _OrderSubItem({
    required this.name,
    required this.quantity,
    required this.price,
  });
}
