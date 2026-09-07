// ignore_for_file: deprecated_member_use

import 'package:apex_restaurant/core/helpers/helper_methods.dart';
import 'package:apex_restaurant/core/helpers/restaurant_constants.dart';
import 'package:apex_restaurant/core/helpers/size_helper.dart';
import 'package:apex_restaurant/core/router/routes.dart';
import 'package:apex_restaurant/core/shared/widgets/date_text_field.dart';
import 'package:apex_restaurant/core/themes/app_colors.dart';
import 'package:apex_restaurant/featchers/cart/presentation/bloc/cart_bloc.dart';
import 'package:apex_restaurant/featchers/cart/presentation/bloc/cart_event.dart';
import 'package:apex_restaurant/featchers/cart/presentation/ui/layouts/cart_tablet_screen.dart';
import 'package:apex_restaurant/featchers/more_actions/data/model/add_pos_total_return_invoice_request.dart';
import 'package:apex_restaurant/featchers/more_actions/data/model/get_all_pos_invoice_request.dart';
import 'package:apex_restaurant/featchers/more_actions/presentation/bloc/more_actions_bloc.dart';
import 'package:apex_restaurant/featchers/more_actions/presentation/bloc/more_actions_event.dart';
import 'package:apex_restaurant/featchers/more_actions/presentation/bloc/more_actions_state.dart';
import 'package:apex_restaurant/featchers/orders/domain/mapper/restored_invoice_mapper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
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

  int? _expandedIndex = -1;
  DateTime? selectedInvoiceDate;

  @override
  void dispose() {
    _invoiceController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _pickInvoiceDateTime(BuildContext context) async {
    final dateTime = await DateTextField.pickDateTime(
      context,
      type: DateTextFieldType.date,
    );
    if (!mounted || dateTime == null) return;
    selectedInvoiceDate = dateTime;
    _dateController.text = RestaurantConstants.dateFormat.format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    final lang = S.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final isTablet = SizeHelper.isTablet;

    return BlocConsumer<MoreActionsBloc, MoreActionsState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (BuildContext context, MoreActionsState state) {
        if (state.status == MoreActionsStatus.success) {
          if (state.returnedInvoice != null) {
            final restoresd = state.returnedInvoice?.toRestoredCartData(
              context,
            );
            if (restoresd == null) return;
            if (state.isFullReturn == false) {
              context.read<CartBloc>().add(SyncRestoredInvoiceEvent(restoresd));
              SizeHelper.isTablet
                  ? showBottomSheet(
                      context: context,
                      builder: (context) {
                        return TabletCartPanel();
                      },
                    )
                  : context.pushReplacementNamed(Routes.cartScreen);
            } else {
              HelperMethods.showSnackBar(
                context: context,
                message: lang.invoiceReturnedSuccessfully,
                isError: false,
              );
            }
          } else if (state.invoiceReturnResponse != null) {
            HelperMethods.showSnackBar(
              context: context,
              message: lang.invoiceReturnedSuccessfully,
              isError: false,
            );
          }
        } else if (state.status == MoreActionsStatus.failure) {
          HelperMethods.showSnackBar(
            context: context,
            message: state.errorMessage ?? lang.somethingWentWrong,
            isError: true,
          );
        }
      },
      builder: (context, state) {
        return isTablet
            ? _buildTabletLayout(context, state)
            : _buildMobileLayout(context, state, lang, colorScheme);
      },
    );
  }

  // ---------------------------------------------------------------------
  // MOBILE LAYOUT (search card on top, invoices stacked below)
  // ---------------------------------------------------------------------
  Widget _buildMobileLayout(
    BuildContext context,
    MoreActionsState state,
    S lang,
    ColorScheme colorScheme,
  ) {
    final spacing = context.spacing;

    return Scaffold(
      appBar: CustomAppBar(
        title: lang.returns,
        showBackButton: true,
        onBackPressed: () => Navigator.of(context).pop(),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildSearchCard(context),
            SizedBox(height: spacing.md),
            _buildInvoiceList(context, state),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------
  // TABLET / DESKTOP LAYOUT (two panels, matches reference design)
  // ---------------------------------------------------------------------
  Widget _buildTabletLayout(BuildContext context, MoreActionsState state) {
    final spacing = context.spacing;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left narrow panel: search filters.
          SizedBox(width: 340, child: _buildSearchCard(context)),
          SizedBox(width: spacing.md),

          //Right  wide panel: invoices list.
          Expanded(child: _buildInvoicesPanel(context, state)),
        ],
      ),
    );
  }

  Widget _buildInvoicesPanel(BuildContext context, MoreActionsState state) {
    final lang = S.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final spacing = context.spacing;

    return Container(
      padding: EdgeInsets.all(spacing.md),
      decoration: BoxDecoration(
        color: colorScheme.onSurface,
        borderRadius: BorderRadius.circular(spacing.radiusMd),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                lang.invoices,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: spacing.sm),
            _buildInvoiceList(context, state),
          ],
        ),
      ),
    );
  }

  Widget _buildInvoiceList(BuildContext context, MoreActionsState state) {
    final lang = S.of(context);
    final spacing = context.spacing;
    final invoices = state.invoices;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < invoices.length; i++) ...[
          if (i > 0) SizedBox(height: spacing.sm),
          _InvoiceCard(
            invoiceId: invoices[i].invoiceId,
            invoiceNumber: invoices[i].invoiceType,
            time: RestaurantConstants.hoursFormat.format(
              invoices[i].invoiceDate,
            ),
            itemsCountText: lang.itemsCount(5),
            totalAmount: "${invoices[i].totalPrice} ${lang.currencySarShort}",
            isExpanded: _expandedIndex == i,

            // items: _expandedIndex == i ? _sampleItems : const [],
            onTap: () => setState(() {
              _expandedIndex = _expandedIndex == i ? null : i;
            }),
          ),
        ],
      ],
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
      color: colorScheme.onSecondary,
    );
    final fieldBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(spacing.radiusSm),
      borderSide: BorderSide(color: colorScheme.outlineVariant),
    );

    return Container(
      padding: EdgeInsets.all(spacing.md),
      decoration: BoxDecoration(
        color: colorScheme.onSurface,
        borderRadius: BorderRadius.circular(spacing.radiusMd),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            lang.invoiceNumber,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSecondary,
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
              color: colorScheme.onSecondary,
            ),
          ),
          SizedBox(height: spacing.xxs),
          DateTextField(
            controller: _dateController,
            onTap: () {
              _pickInvoiceDateTime(context);
            },
          ),
          SizedBox(height: spacing.md),

          ElevatedButton(
            onPressed: () {
              context.read<MoreActionsBloc>().add(
                FetchAllInvoicesEvent(
                  request: GetAllPosInvoiceRequest(
                    pageNumber: 1,
                    pageSize: 20,
                    invoiceTypeId: 11,
                    financialYearId: 1,
                    invoiceDate: selectedInvoiceDate,
                    invoiceType: moreActionState.invoiceType,
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
              padding: EdgeInsets.symmetric(vertical: spacing.sm),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(spacing.radiusSm),
              ),
            ),

            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.search, size: iconSizes.sm, color: AppColors.white),
                SizedBox(width: spacing.md),
                Text(
                  lang.search,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
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

class _InvoiceCard extends StatelessWidget {
  final String invoiceNumber;
  final String time;
  final String itemsCountText;
  final String totalAmount;
  final bool isExpanded;
  final VoidCallback onTap;
  final int invoiceId;
  const _InvoiceCard({
    required this.invoiceNumber,
    required this.time,
    required this.itemsCountText,
    required this.totalAmount,
    required this.isExpanded,
    required this.onTap,
    required this.invoiceId,
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
        color: colorScheme.onSurface,
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
                    crossAxisAlignment: CrossAxisAlignment.start,
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

                  SizedBox(width: spacing.lg),

                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    size: iconSizes.sm,
                    color: colorScheme.onPrimary,
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

                  // ...items.map(
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
                  //             Text(
                  //               '${item.price} ${lang.currencySarShortShort}',
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
                        child: ElevatedButton(
                          onPressed: () {
                            context.read<MoreActionsBloc>().add(
                              AddPOSTotalReturnEvent(
                                request: AddPOSTotalReturnInvoiceRequest(
                                  id: invoiceId,
                                ),
                              ),
                            );
                          },
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
                          onPressed: () {
                            context.read<MoreActionsBloc>().add(
                              FetchInvoiceByIdEvent(invoiceId: invoiceId),
                            );
                          },
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
