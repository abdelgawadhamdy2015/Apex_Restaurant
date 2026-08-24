import 'package:apex_restaurant/core/helpers/restaurant_constants.dart';
import 'package:apex_restaurant/core/themes/app_colors.dart';
import 'package:apex_restaurant/featchers/more_actions/data/model/get_all_pos_invoice_request.dart';
import 'package:apex_restaurant/featchers/more_actions/presentation/bloc/more_actions_bloc.dart';
import 'package:apex_restaurant/featchers/more_actions/presentation/bloc/more_actions_event.dart';
import 'package:apex_restaurant/featchers/more_actions/presentation/bloc/more_actions_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/helpers/extensions.dart';
import '../../../../generated/l10n.dart';

class TabletReturnsScreen extends StatefulWidget {
  const TabletReturnsScreen({super.key});

  @override
  State<TabletReturnsScreen> createState() => _TabletReturnsScreenState();
}

class _TabletReturnsScreenState extends State<TabletReturnsScreen> {
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

    return Padding(
      padding: EdgeInsets.all(spacing.lg),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left Side: Invoices List
          Expanded(flex: 2, child: _buildSearchCard(context)),
          SizedBox(width: spacing.lg),

          // Right Side: Search Filter Card
          Expanded(
            flex: 3,
            child: Container(
              padding: EdgeInsets.all(spacing.md),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(spacing.radiusLg),
                border: Border.all(color: colorScheme.outlineVariant),
              ),
              child: SingleChildScrollView(
                child: BlocBuilder<MoreActionsBloc, MoreActionsState>(
                  builder: (context, state) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(bottom: spacing.sm),
                          child: Text(
                            lang.invoices,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        ...state.invoices.map((e) {
                          return _InvoiceCard(
                            invoiceNumber: e.invoiceType,
                            time: RestaurantConstants.hoursFormat.format(
                              e.invoiceDate,
                            ),
                            itemsCountText: lang.itemsCount(5),
                            totalAmount: "${e.totalPrice} ${lang.currencySar}",
                            isExpanded:
                                _expandedIndex == state.invoices.indexOf(e) + 1,
                            onTap: () => setState(() {
                              _expandedIndex =
                                  _expandedIndex ==
                                      state.invoices.indexOf(e) + 1
                                  ? null
                                  : state.invoices.indexOf(e) + 1;
                            }),
                          );
                        }),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchCard(BuildContext context) {
    final lang = S.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final spacing = context.spacing;
    final moreActionState = context.read<MoreActionsBloc>().state;
    return Container(
      padding: EdgeInsets.all(spacing.lg),
      decoration: BoxDecoration(
        color: colorScheme.onSurface,
        borderRadius: BorderRadius.circular(spacing.radiusLg),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            lang.invoiceNumber,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: spacing.xs),
          TextField(
            controller: _invoiceController,
            decoration: InputDecoration(
              hintText: lang.invoiceNumberExample,
              hintStyle: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSecondary,
              ),
              filled: true,
              fillColor: colorScheme.surfaceContainerHighest.withOpacity(0.3),
              contentPadding: EdgeInsets.symmetric(
                horizontal: spacing.md,
                vertical: spacing.sm,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(spacing.radiusMd),
                borderSide: BorderSide(color: colorScheme.outlineVariant),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(spacing.radiusMd),
                borderSide: BorderSide(color: colorScheme.outlineVariant),
              ),
            ),
          ),
          SizedBox(height: spacing.md),
          Text(
            lang.date,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: spacing.xs),
          TextField(
            controller: _dateController,
            readOnly: true,
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2020),
                lastDate: DateTime(2030),
              );
              if (date == null) return;
              setState(() {
                _dateController.text = RestaurantConstants.dateFormat.format(
                  date,
                );
              });
            },
            decoration: InputDecoration(
              hintText: lang.dateFormatHint,
              hintStyle: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSecondary,
              ),
              filled: true,
              fillColor: colorScheme.surfaceContainerHighest.withOpacity(0.3),
              prefixIcon: Icon(
                Icons.calendar_today_outlined,
                size: context.iconSizes.sm,
                color: colorScheme.onSecondary,
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: spacing.md,
                vertical: spacing.sm,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(spacing.radiusMd),
                borderSide: BorderSide(color: colorScheme.outlineVariant),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(spacing.radiusMd),
                borderSide: BorderSide(color: colorScheme.outlineVariant),
              ),
            ),
          ),
          SizedBox(height: spacing.xl),
          SizedBox(
            height: 48,
            child: ElevatedButton.icon(
              onPressed: () {
                context.read<MoreActionsBloc>().add(
                  FetchAllInvoicesEvent(
                    request: GetAllPosInvoiceRequest(
                      pageNumber: 1,
                      pageSize: 20,
                      invoiceTypeId: 11,
                      financialYearId: 1,
                      invoiceDate: moreActionState.fromDate,
                      invoiceType: _invoiceController.text,
                    ),
                  ),
                );
              },
              icon: Icon(
                Icons.search,
                size: context.iconSizes.md,
                color: AppColors.white,
              ),
              label: Text(
                lang.search,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(spacing.radiusMd),
                ),
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
    final spacing = context.spacing;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(spacing.radiusMd),
        border: Border.all(color: colorScheme.outlineVariant),
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
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            time,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSecondary,
                            ),
                          ),
                          SizedBox(width: spacing.xxs),
                          Icon(
                            Icons.access_time,
                            size: context.iconSizes.xs,
                            color: colorScheme.onSecondary,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Spacer(),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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

                  SizedBox(width: spacing.xl),

                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: colorScheme.onSecondary,
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
                  //             Row(
                  //               children: [
                  //                 Text(
                  //                   item.quantity,
                  //                   style: theme.textTheme.bodyMedium?.copyWith(
                  //                     fontWeight: FontWeight.bold,
                  //                   ),
                  //                 ),
                  //                 SizedBox(width: spacing.xs),
                  //                 Text(
                  //                   item.name,
                  //                   style: theme.textTheme.bodyMedium?.copyWith(
                  //                     fontWeight: FontWeight.w600,
                  //                   ),
                  //                 ),
                  //               ],
                  //             ),
                  //             Text(
                  //               item.price,
                  //               style: theme.textTheme.bodyMedium?.copyWith(
                  //                 fontWeight: FontWeight.bold,
                  //               ),
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
                        child: OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            backgroundColor: context
                                .appExtraTheme
                                .greenBackground
                                .withOpacity(.1),
                            foregroundColor:
                                context.appExtraTheme.greenBackground,
                            side: BorderSide(
                              color: context.appExtraTheme.greenBackground
                                  .withOpacity(.2),
                            ),
                            padding: EdgeInsets.symmetric(vertical: spacing.sm),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                spacing.radiusSm,
                              ),
                            ),
                          ),
                          child: Text(
                            lang.fullReturn,
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: context.appExtraTheme.greenBackground,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: spacing.sm),

                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            backgroundColor: context.appExtraTheme.background
                                .withOpacity(.1),
                            foregroundColor: context.appExtraTheme.background,
                            side: BorderSide(
                              color: context.appExtraTheme.background
                                  .withOpacity(.2),
                            ),
                            padding: EdgeInsets.symmetric(vertical: spacing.sm),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                spacing.radiusSm,
                              ),
                            ),
                          ),
                          child: Text(
                            lang.partialReturn,
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: context.appExtraTheme.background,
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
