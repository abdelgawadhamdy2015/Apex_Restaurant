import '../../../../core/helpers/extensions.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/shared/widgets/custom_app_bar.dart';
import '../../../cart/data/models/cart_screen_args.dart';
import '../../../cart/presentation/bloc/cart_bloc.dart';
import '../../../cart/presentation/bloc/cart_event.dart';
import '../../data/model/get_previous_invoice_request.dart';
import '../../data/model/order_model.dart';
import '../../domain/mapper/restored_invoice_mapper.dart';
import '../bloc/orders_bloc.dart';
import '../bloc/orders_event.dart';
import '../bloc/orders_state.dart';
import '../widgets/held_order_expandable_card.dart';
import '../widgets/held_orders_summary_card.dart';
import '../widgets/orders_search_filter_card.dart';
import '../widgets/orders_segmented_tab.dart';
import '../widgets/previous_order_card.dart';
import '../../../../generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

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
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    // Initial load for the default (previous orders) tab.
    context.read<OrdersBloc>().add(
      const FetchPreviousInvoicesEvent(
        request: GetPreviousInvoiceRequest(
          pageNumber: 1,
          pageSize: kOrdersPageSize,
        ),
      ),
    );
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    // Trigger a bit before the actual bottom for a smoother feel.
    if (position.pixels < position.maxScrollExtent - 200) return;

    final state = context.read<OrdersBloc>().state;
    if (state.activeTab == OrderTab.previous) {
      if (!state.isLoadingMorePrevious && state.previousOrdersHasMore) {
        context.read<OrdersBloc>().add(const LoadMorePreviousInvoicesEvent());
      }
    } else {
      if (!state.isLoadingMorePinding && state.pindingInvoicesHasMore) {
        context.read<OrdersBloc>().add(const LoadMorePindingInvoicesEvent());
      }
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _invoiceController.dispose();
    _customerController.dispose();
    _fromDateController.dispose();
    _toDateController.dispose();
    super.dispose();
  }

  void _onOrdersStateChanged(BuildContext context, OrdersState state) {
    final restored = state.restoredInvoice;
    if (restored == null) return;

    final cartData = restored.toRestoredCartData(context);

    context.read<CartBloc>().add(SyncRestoredInvoiceEvent(cartData));
    context.read<OrdersBloc>().add(const ClearRestoredInvoiceEvent());
    context.pushNamed(
      Routes.cartScreen,
      extra: CartScreenArgs(isRestored: true, canEdite: state.canEdite),
    );
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
      body: BlocConsumer<OrdersBloc, OrdersState>(
        listenWhen: (prev, curr) =>
            curr.restoredInvoice != null &&
            curr.restoredInvoice != prev.restoredInvoice,
        listener: _onOrdersStateChanged,
        builder: (context, state) {
          return SafeArea(
            child: SingleChildScrollView(
              controller: _scrollController,
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
                    if (state.isLoadingMorePrevious)
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: spacing.md),
                        child: const Center(child: CircularProgressIndicator()),
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
                    if (state.isLoadingMorePinding)
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: spacing.md),
                        child: const Center(child: CircularProgressIndicator()),
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
