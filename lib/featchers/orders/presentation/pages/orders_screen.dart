import 'package:apex_restaurant/core/helpers/extensions.dart';
import 'package:apex_restaurant/featchers/orders/data/model/order_model.dart';
import 'package:apex_restaurant/featchers/orders/presentation/bloc/orders_bloc.dart';
import 'package:apex_restaurant/featchers/orders/presentation/bloc/orders_event.dart';
import 'package:apex_restaurant/featchers/orders/presentation/bloc/orders_state.dart';
import 'package:apex_restaurant/featchers/pos/presentation/widgets/custom_pos_app_bar.dart';
import 'package:apex_restaurant/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  final TextEditingController _invoiceController = TextEditingController();
  final TextEditingController _customerController = TextEditingController();
  final TextEditingController _fromDateController = TextEditingController();
  final TextEditingController _toDateController = TextEditingController();

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
    final lang = S.of(context);

    return Scaffold(
      appBar: CustomPosAppBar(
        title: S.of(context).orders,
        onMenuPressed: () {
          // Handle menu tap
        },
        onSearchPressed: () {
          // Handle search tap
        },
        onNotificationPressed: () {
          // Handle notifications tap
        },
      ),

      backgroundColor: theme.colorScheme.surfaceContainerLowest,
      body: BlocBuilder<OrdersBloc, OrdersState>(
        builder: (context, state) {
          return SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(spacing.md),
              child: Column(
                children: [
                  _buildSegmentedTab(context, state, lang),
                  SizedBox(height: spacing.md),

                  if (state.activeTab == OrderTab.previous) ...[
                    // Search Filter Box
                    _buildSearchFilterCard(context, theme, spacing, lang),
                    SizedBox(height: spacing.md),
                    // Previous Orders List
                    ...state.previousOrders.map(
                      (order) => _buildPreviousOrderCard(
                        context,
                        theme,
                        spacing,
                        lang,
                        order,
                      ),
                    ),
                  ] else ...[
                    // Total Held Orders Header Widget
                    _buildHeldOrdersSummaryCard(
                      context,
                      theme,
                      spacing,
                      lang,
                      state.heldOrders.length,
                    ),
                    SizedBox(height: spacing.md),
                    // Held Orders List
                    ...state.heldOrders.map(
                      (order) => _HeldOrderExpandableCard(
                        order: order,
                        theme: theme,
                        spacing: spacing,
                        l10n: lang,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSegmentedTab(BuildContext context, OrdersState state, S l10n) {
    final theme = Theme.of(context);
    final spacing = context.spacing;

    return Container(
      padding: EdgeInsets.all(spacing.xxs),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withOpacity(0.3),
        borderRadius: BorderRadius.circular(spacing.radiusLg),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () =>
                  context.read<OrdersBloc>().add(SwitchTabEvent(OrderTab.held)),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: spacing.sm),
                decoration: BoxDecoration(
                  color: state.activeTab == OrderTab.held
                      ? theme.colorScheme.primary
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(spacing.radiusLg),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.secondary,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '3',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSecondary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(width: spacing.xs),
                    Text(
                      l10n.heldOrders,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: state.activeTab == OrderTab.held
                            ? theme.colorScheme.onPrimary
                            : theme.colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => context.read<OrdersBloc>().add(
                SwitchTabEvent(OrderTab.previous),
              ),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: spacing.sm),
                decoration: BoxDecoration(
                  color: state.activeTab == OrderTab.previous
                      ? theme.colorScheme.primary
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(spacing.radiusLg),
                ),
                child: Text(
                  l10n.previousOrders,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: state.activeTab == OrderTab.previous
                        ? theme.colorScheme.onPrimary
                        : theme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchFilterCard(
    BuildContext context,
    ThemeData theme,
    dynamic spacing,
    S l10n,
  ) {
    final iconSizes = context.iconSizes;

    return Container(
      padding: EdgeInsets.all(spacing.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
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
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    SizedBox(height: spacing.xxs),
                    TextField(
                      controller: _invoiceController,
                      decoration: InputDecoration(
                        hintText: l10n.invoiceNumberHint,
                        fillColor: theme.colorScheme.surfaceContainerHighest,
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
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    SizedBox(height: spacing.xxs),
                    TextField(
                      controller: _customerController,
                      decoration: InputDecoration(
                        hintText: l10n.customerNameHint,
                        fillColor: theme.colorScheme.surfaceContainerHighest,
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
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    SizedBox(height: spacing.xxs),
                    TextField(
                      controller: _fromDateController,
                      readOnly: true,
                      decoration: InputDecoration(
                        hintText: l10n.datePlaceholder,
                        prefixIcon: Icon(
                          Icons.calendar_today_outlined,
                          size: iconSizes.sm,
                        ),
                        fillColor: theme.colorScheme.surfaceContainerHighest,
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
                      l10n.toDate,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    SizedBox(height: spacing.xxs),
                    TextField(
                      controller: _toDateController,
                      readOnly: true,
                      decoration: InputDecoration(
                        hintText: l10n.datePlaceholder,
                        prefixIcon: Icon(
                          Icons.calendar_today_outlined,
                          size: iconSizes.sm,
                        ),
                        fillColor: theme.colorScheme.surfaceContainerHighest,
                      ),
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
                    invoiceNumber: _invoiceController.text,
                    customerName: _customerController.text,
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
                Icon(
                  Icons.search,
                  color: theme.colorScheme.onPrimary,
                  size: iconSizes.md,
                ),
                SizedBox(width: spacing.xs),
                Text(
                  l10n.search,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.onPrimary,
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

  Widget _buildPreviousOrderCard(
    BuildContext context,
    ThemeData theme,
    dynamic spacing,
    S l10n,
    OrderModel order,
  ) {
    final iconSizes = context.iconSizes;

    return Container(
      margin: EdgeInsets.only(bottom: spacing.md),
      padding: EdgeInsets.all(spacing.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(spacing.radiusLg),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                order.invoiceNumber,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: iconSizes.sm,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  SizedBox(width: spacing.xxs),
                  Text(
                    '${order.dateTime.year}-${order.dateTime.month.toString().padLeft(2, '0')}-${order.dateTime.day.toString().padLeft(2, '0')} |${order.dateTime.hour}:${order.dateTime.minute.toString().padLeft(2, '0')}  ',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Divider(height: spacing.lg, color: theme.colorScheme.outlineVariant),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.customer,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  Text(
                    order.customerName ?? '',
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
                    l10n.total,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  Text(
                    l10n.priceWithCurrency(
                      order.totalAmount.toStringAsFixed(2),
                    ),
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
                  onPressed: () {},
                  icon: Icon(
                    Icons.visibility_outlined,
                    color: theme.colorScheme.primary,
                    size: iconSizes.sm,
                  ),
                  label: Text(
                    l10n.preview,
                    style: TextStyle(color: theme.colorScheme.primary),
                  ),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primaryContainer
                        .withOpacity(0.2),
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
                  onPressed: () {},
                  icon: Icon(
                    Icons.print_outlined,
                    color: theme.colorScheme.secondary,
                    size: iconSizes.sm,
                  ),
                  label: Text(
                    l10n.print,
                    style: TextStyle(color: theme.colorScheme.secondary),
                  ),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: theme.colorScheme.secondary.withOpacity(
                      0.12,
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
    );
  }

  Widget _buildHeldOrdersSummaryCard(
    BuildContext context,
    ThemeData theme,
    dynamic spacing,
    S l10n,
    int totalCount,
  ) {
    final iconSizes = context.iconSizes;

    return Container(
      padding: EdgeInsets.all(spacing.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(spacing.radiusLg),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.totalHeldOrders,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              Text(
                l10n.ordersCount(totalCount),
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.all(spacing.md),
            decoration: BoxDecoration(
              color: theme.colorScheme.secondary.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.hourglass_empty_rounded,
              color: theme.colorScheme.secondary,
              size: iconSizes.lg,
            ),
          ),
        ],
      ),
    );
  }
}

class _HeldOrderExpandableCard extends StatefulWidget {
  final OrderModel order;
  final ThemeData theme;
  final dynamic spacing;
  final S l10n;

  const _HeldOrderExpandableCard({
    required this.order,
    required this.theme,
    required this.spacing,
    required this.l10n,
  });

  @override
  State<_HeldOrderExpandableCard> createState() =>
      _HeldOrderExpandableCardState();
}

class _HeldOrderExpandableCardState extends State<_HeldOrderExpandableCard> {
  bool _isExpanded = true;

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme;
    final spacing = widget.spacing;
    final l10n = widget.l10n;
    final order = widget.order;
    final iconSizes = context.iconSizes;

    return Container(
      margin: EdgeInsets.only(bottom: spacing.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(spacing.radiusLg),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Column(
        children: [
          // Collapsible Header
          InkWell(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            child: Padding(
              padding: EdgeInsets.all(spacing.md),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: spacing.sm,
                      vertical: spacing.xs,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer.withOpacity(
                        0.5,
                      ),
                      borderRadius: BorderRadius.circular(spacing.radiusLg),
                    ),
                    child: Text(
                      order.orderQueueNumber ?? '',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.inverseSurface,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(width: spacing.lg),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        order.invoiceNumber,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            ' ${order.dateTime.hour}:${order.dateTime.minute.toString().padLeft(2, '0')}  ص',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          SizedBox(width: spacing.xxs),
                          Icon(
                            Icons.access_time,
                            size: iconSizes.sm,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(width: spacing.sm),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        order.itemsCount == 1
                            ? l10n.singleItemCount
                            : l10n.itemsCount(order.itemsCount),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      Text(
                        l10n.priceWithCurrency(
                          order.totalAmount.toStringAsFixed(2),
                        ),
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: spacing.sm),

                  Icon(
                    _isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: theme.colorScheme.onSurfaceVariant,
                    size: iconSizes.md,
                  ),
                ],
              ),
            ),
          ),

          // Expanded Content Body
          if (_isExpanded) ...[
            Divider(height: 1, color: theme.colorScheme.outlineVariant),
            Padding(
              padding: EdgeInsets.all(spacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      l10n.orderDetails,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                  SizedBox(height: spacing.sm),
                  ...order.items.map(
                    (item) => Padding(
                      padding: EdgeInsets.only(bottom: spacing.xs),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                '${item.quantity}x',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: spacing.xs),
                              Text(
                                item.name,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            l10n.priceWithCurrency(
                              item.price.toStringAsFixed(2),
                            ),
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: spacing.md),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            context.read<OrdersBloc>().add(
                              RestoreOrderEvent(order.id),
                            );
                          },
                          icon: Icon(
                            Icons.history,
                            color: theme.colorScheme.onPrimary,
                            size: iconSizes.sm,
                          ),
                          label: Text(
                            l10n.restoreOrder,
                            style: TextStyle(
                              color: theme.colorScheme.onPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.colorScheme.primary,
                            padding: EdgeInsets.symmetric(vertical: spacing.md),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                spacing.radiusMd,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: spacing.sm),

                      Expanded(
                        child: TextButton.icon(
                          onPressed: () {
                            context.read<OrdersBloc>().add(
                              DeleteOrderEvent(order.id),
                            );
                          },
                          icon: Icon(
                            Icons.delete,
                            color: theme.colorScheme.errorContainer,
                            size: iconSizes.sm,
                          ),
                          label: Text(
                            l10n.deleteOrder,
                            style: TextStyle(
                              color: theme.colorScheme.errorContainer,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: TextButton.styleFrom(
                            backgroundColor: theme.colorScheme.errorContainer
                                .withOpacity(0.12),
                            padding: EdgeInsets.symmetric(vertical: spacing.md),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                spacing.radiusMd,
                              ),
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
