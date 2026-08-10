import 'package:apex_restaurant/core/helpers/extensions.dart';
import 'package:apex_restaurant/core/shared/widgets/custom_app_bar.dart';
import 'package:apex_restaurant/featchers/orders/data/model/order_model.dart';
import 'package:apex_restaurant/featchers/orders/presentation/bloc/orders_bloc.dart';
import 'package:apex_restaurant/featchers/orders/presentation/bloc/orders_state.dart';
import 'package:apex_restaurant/featchers/orders/presentation/widgets/held_order_expandable_card.dart';
import 'package:apex_restaurant/featchers/orders/presentation/widgets/held_orders_summary_card.dart';
import 'package:apex_restaurant/featchers/orders/presentation/widgets/orders_search_filter_card.dart';
import 'package:apex_restaurant/featchers/orders/presentation/widgets/orders_segmented_tab.dart';
import 'package:apex_restaurant/featchers/orders/presentation/widgets/previous_order_card.dart';
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
      appBar: CustomAppBar(
        title: lang.orders,
        centerTitle: true,
        showBackButton: false,
      ),
      backgroundColor: theme.colorScheme.surface,
      body: BlocBuilder<OrdersBloc, OrdersState>(
        builder: (context, state) {
          return SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(spacing.md),
              child: Column(
                children: [
                  OrdersSegmentedTab(state: state, l10n: lang),
                  SizedBox(height: spacing.md),

                  if (state.activeTab == OrderTab.previous) ...[
                    // Search Filter Box
                    OrdersSearchFilterCard(
                      invoiceController: _invoiceController,
                      customerController: _customerController,
                      fromDateController: _fromDateController,
                      toDateController: _toDateController,
                      l10n: lang,
                    ),
                    SizedBox(height: spacing.md),
                    // Previous Orders List
                    ...state.previousOrders.map(
                      (order) => PreviousOrderCard(order: order, l10n: lang),
                    ),
                  ] else ...[
                    // Total Held Orders Header Widget
                    HeldOrdersSummaryCard(
                      totalCount: state.pindingInvoices.length,
                      l10n: lang,
                    ),
                    SizedBox(height: spacing.md),
                    // Held Orders List
                    ...state.pindingInvoices.map(
                      (order) =>
                          HeldOrderExpandableCard(order: order, l10n: lang),
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
}
