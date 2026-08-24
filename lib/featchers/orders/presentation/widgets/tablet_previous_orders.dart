import 'package:apex_restaurant/core/themes/app_spacing_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/helpers/extensions.dart';
import '../../../../core/helpers/restaurant_constants.dart';
import '../../../../core/shared/widgets/date_text_field.dart';
import '../../../../generated/l10n.dart';
import '../../data/model/get_previous_invoice_request.dart';
import '../../data/model/previous_invoice_model.dart';
import '../bloc/orders_bloc.dart';
import '../bloc/orders_event.dart';
import '../bloc/orders_state.dart';

class PreviousOrdersTabletView extends StatefulWidget {
  const PreviousOrdersTabletView({super.key});

  @override
  State<PreviousOrdersTabletView> createState() =>
      _PreviousOrdersTabletViewState();
}

class _PreviousOrdersTabletViewState extends State<PreviousOrdersTabletView> {
  late final TextEditingController _invoiceController;
  late final TextEditingController _customerController;
  late final TextEditingController _fromDateController;
  late final TextEditingController _toDateController;

  @override
  void initState() {
    super.initState();
    _invoiceController = TextEditingController();
    _customerController = TextEditingController();
    _fromDateController = TextEditingController();
    _toDateController = TextEditingController();
  }

  @override
  void dispose() {
    _invoiceController.dispose();
    _customerController.dispose();
    _fromDateController.dispose();
    _toDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;
    final l10n = S.of(context);

    return BlocBuilder<OrdersBloc, OrdersState>(
      builder: (context, state) {
        return Column(
          children: [
            // Top Inline Filter Bar
            _buildSearchFilterBar(context, theme, spacing, l10n),
            SizedBox(height: spacing.md),

            // Data Table & Pagination Container
            Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(spacing.radiusLg),
                border: Border.all(color: theme.colorScheme.outlineVariant),
              ),
              child: Column(
                children: [
                  _buildTableHeader(theme, spacing, l10n),
                  const Divider(height: 1),
                  if (state.previousOrders.isEmpty)
                    Padding(
                      padding: EdgeInsets.all(spacing.lg),
                      child: Center(
                        child: Text(
                          l10n.noDataFound,
                          style: theme.textTheme.bodyMedium,
                        ),
                      ),
                    )
                  else
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: state.previousOrders.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        return _buildTableRow(
                          context,
                          theme,
                          spacing,
                          l10n,
                          state.previousOrders[index],
                        );
                      },
                    ),
                  const Divider(height: 1),
                  _buildPaginationFooter(theme, spacing, state),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  // Horizontal Filter Bar matching tablet mockup
  Widget _buildSearchFilterBar(
    BuildContext context,
    ThemeData theme,
    AppSpacing spacing,
    S l10n,
  ) {
    return Container(
      padding: EdgeInsets.all(spacing.sm),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(spacing.radiusLg),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Row(
        children: [
          // Search Button
          SizedBox(
            height: 44,
            child: ElevatedButton.icon(
              onPressed: () => _triggerSearch(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(spacing.radiusMd),
                ),
              ),
              icon: const Icon(Icons.search, color: Colors.white, size: 18),
              label: Text(
                l10n.search,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
          SizedBox(width: spacing.sm),

          // To Date
          Expanded(
            child: DateTextField(
              controller: _toDateController,
              type: DateTextFieldType.date,
              onTap: () async {
                final date = await DateTextField.pickDateTime(
                  context,
                  type: DateTextFieldType.date,
                );
                if (date != null) {
                  _toDateController.text = RestaurantConstants.dateTimeFormat
                      .format(date);
                }
              },
            ),
          ),
          SizedBox(width: spacing.sm),

          // From Date
          Expanded(
            child: DateTextField(
              controller: _fromDateController,
              type: DateTextFieldType.date,
              onTap: () async {
                final date = await DateTextField.pickDateTime(
                  context,
                  type: DateTextFieldType.date,
                );
                if (date != null) {
                  _fromDateController.text = RestaurantConstants.dateTimeFormat
                      .format(date);
                }
              },
            ),
          ),
          SizedBox(width: spacing.sm),

          // Customer Name
          Expanded(
            child: TextField(
              controller: _customerController,
              decoration: InputDecoration(
                hintText: l10n.customerNameHint,
                fillColor: theme.colorScheme.surface,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
              ),
            ),
          ),
          SizedBox(width: spacing.sm),

          // Invoice Number
          Expanded(
            child: TextField(
              controller: _invoiceController,
              decoration: InputDecoration(
                hintText: l10n.invoiceNumberHint,
                fillColor: theme.colorScheme.surface,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Table Headers
  Widget _buildTableHeader(ThemeData theme, AppSpacing spacing, S l10n) {
    return Container(
      color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
      padding: EdgeInsets.symmetric(
        horizontal: spacing.md,
        vertical: spacing.sm,
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              l10n.invoiceNumberLabel,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              l10n.fromDate,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              l10n.customer,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              l10n.total,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            width: 110,
            child: Center(
              child: Text(
                l10n.orderDetails,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Individual Table Row
  Widget _buildTableRow(
    BuildContext context,
    ThemeData theme,
    AppSpacing spacing,
    S l10n,
    PreviousInvoiceModel order,
  ) {
    final invoiceCode = order.invoiceCode ?? '';
    final invoiceDate = order.invoiceDate;
    final personName = order.personNameAr ?? '';
    final totalAmount = order.totalAmount ?? 0.0;

    final formattedDate = invoiceDate != null
        ? '${invoiceDate.hour}:${invoiceDate.minute.toString().padLeft(2, '0')} ${invoiceDate.year}-${invoiceDate.month.toString().padLeft(2, '0')}-${invoiceDate.day.toString().padLeft(2, '0')}'
        : '';

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: spacing.md,
        vertical: spacing.xs,
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              invoiceCode,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(formattedDate, style: theme.textTheme.bodyMedium),
          ),
          Expanded(
            flex: 2,
            child: Text(personName, style: theme.textTheme.bodyMedium),
          ),
          Expanded(
            flex: 2,
            child: Text(
              l10n.priceWithCurrency(totalAmount.toStringAsFixed(2)),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // Action Buttons: Preview & Print
          SizedBox(
            width: 110,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildIconButton(
                  icon: Icons.visibility_outlined,
                  color: theme.colorScheme.primary,
                  backgroundColor: theme.colorScheme.primary.withOpacity(0.12),
                  onPressed: () {
                    context.read<OrdersBloc>().add(
                      RestoreOrderEvent(
                        invoiceId: order.invoiceId ?? 0,
                        canEdite: false,
                      ),
                    );
                  },
                ),
                SizedBox(width: spacing.xs),
                _buildIconButton(
                  icon: Icons.print_outlined,
                  color: const Color(0xFFD97706),
                  backgroundColor: const Color(0xFFFEF3C7),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required Color color,
    required Color backgroundColor,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 18, color: color),
      ),
    );
  }

  // Footer Pagination Control
  Widget _buildPaginationFooter(
    ThemeData theme,
    AppSpacing spacing,
    OrdersState state,
  ) {
    return Padding(
      padding: EdgeInsets.all(spacing.sm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              _buildPageButton('<', enabled: false, onPressed: () {}),
              _buildPageButton('...', enabled: false, onPressed: () {}),
              _buildPageButton('3', enabled: false, onPressed: () {}),
              _buildPageButton('2', enabled: false, onPressed: () {}),
              _buildPageButton('1', selected: true, onPressed: () {}),
              _buildPageButton('>', enabled: false, onPressed: () {}),
            ],
          ),
          Text(
            'عرض 1 إلى ${state.previousOrders.length} نتيجة',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPageButton(
    String text, {
    bool selected = false,
    bool enabled = true,
    required VoidCallback onPressed,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: selected ? const Color(0xFF005DB9) : Colors.transparent,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: selected ? const Color(0xFF005DB9) : Colors.grey.shade300,
        ),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: selected ? Colors.white : Colors.black87,
            fontWeight: selected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  void _triggerSearch(BuildContext context) {
    context.read<OrdersBloc>().add(
      FetchPreviousInvoicesEvent(
        request: GetPreviousInvoiceRequest(
          pageNumber: 1,
          pageSize: kOrdersPageSize,
          invoiceCode: _invoiceController.text.trim().isEmpty
              ? null
              : _invoiceController.text.trim(),
          personName: _customerController.text.trim().isEmpty
              ? null
              : _customerController.text.trim(),
          fromDate: _fromDateController.text.trim().isEmpty
              ? null
              : RestaurantConstants.dateTimeFormat.parse(
                  _fromDateController.text.trim(),
                ),
          toDate: _toDateController.text.trim().isEmpty
              ? null
              : RestaurantConstants.dateTimeFormat.parse(
                  _toDateController.text.trim(),
                ),
        ),
      ),
    );
  }
}
