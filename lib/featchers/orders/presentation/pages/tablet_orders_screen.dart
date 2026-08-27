import 'package:apex_restaurant/featchers/orders/presentation/widgets/tablet_previous_orders.dart';
import 'package:apex_restaurant/featchers/pos/presentation/bloc/pos_bloc.dart';
import 'package:apex_restaurant/featchers/pos/presentation/bloc/pos_event.dart';
import 'package:apex_restaurant/featchers/pos/presentation/pages/pos_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/helpers/extensions.dart';
import '../../../../generated/l10n.dart';
import '../../../cart/presentation/bloc/cart_bloc.dart';
import '../../../cart/presentation/bloc/cart_event.dart';
import '../../data/model/get_previous_invoice_request.dart';
import '../../data/model/order_model.dart';
import '../../domain/mapper/restored_invoice_mapper.dart';
import '../bloc/orders_bloc.dart';
import '../bloc/orders_event.dart';
import '../bloc/orders_state.dart';
import '../widgets/held_order_expandable_card.dart';
import '../widgets/orders_segmented_tab.dart';

class OrdersTabletScreen extends StatefulWidget {
  const OrdersTabletScreen({super.key});

  @override
  State<OrdersTabletScreen> createState() => _OrdersTabletScreenState();
}

class _OrdersTabletScreenState extends State<OrdersTabletScreen> {
  final TextEditingController _invoiceController = TextEditingController();
  final TextEditingController _customerController = TextEditingController();
  final TextEditingController _fromDateController = TextEditingController();
  final TextEditingController _toDateController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);

    // Fetch initial page for previous orders on screen mount
    context.read<OrdersBloc>().add(
      FetchPreviousInvoicesEvent(
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
    if (position.pixels < position.maxScrollExtent - 200) return;

    final state = context.read<OrdersBloc>().state;
    if (state.activeTab == OrderTab.previous) {
      if (!state.isLoadingMorePrevious && state.previousOrdersHasMore) {
        context.read<OrdersBloc>().add(LoadMorePreviousInvoicesEvent());
      }
    } else {
      if (!state.isLoadingMorePinding && state.pindingInvoicesHasMore) {
        context.read<OrdersBloc>().add(LoadMorePindingInvoicesEvent());
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
    context.read<PosBloc>().add(
      SelectedNavIndexEvent(selectedNavIndex: PosBottomNavEnm.menu),
    );
    context.read<CartBloc>().add(
      SyncRestoredInvoiceEvent(
        cartData,
        canEdit: state.restoredInvoice?.invoice?.canEdit ?? true,
        isPending: state.isPending,
      ),
    );
    context.read<OrdersBloc>().add(ClearRestoredInvoiceEvent());
  }

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;
    final lang = S.of(context);

    return BlocConsumer<OrdersBloc, OrdersState>(
      listenWhen: (prev, curr) =>
          curr.restoredInvoice != null &&
          curr.restoredInvoice != prev.restoredInvoice,
      listener: _onOrdersStateChanged,
      builder: (context, state) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.all(spacing.md),
            child: Column(
              children: [
                // Top Tab Navigation Bar
                SizedBox(
                  height: 52,
                  child: OrdersSegmentedTab(state: state, l10n: lang),
                ),
                SizedBox(height: spacing.md),

                // Main Content Scrollable View
                Expanded(
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    child: Column(
                      children: [
                        if (state.activeTab == OrderTab.previous) ...[
                          LayoutBuilder(
                            builder: (context, constraints) {
                              return PreviousOrdersTabletView();
                            },
                          ),
                          if (state.isLoadingMorePrevious)
                            Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: spacing.md,
                              ),
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                        ] else ...[
                          // 2-Column Responsive Grid View for Pending/Held Orders
                          LayoutBuilder(
                            builder: (context, constraints) {
                              final crossAxisCount = constraints.maxWidth > 900
                                  ? 3
                                  : 2;
                              return GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: crossAxisCount,
                                      crossAxisSpacing: spacing.md,
                                      mainAxisSpacing: spacing.md,
                                      mainAxisExtent: 310,
                                    ),
                                itemCount: state.pindingInvoices.length,
                                itemBuilder: (context, index) {
                                  final order = state.pindingInvoices[index];
                                  return HeldOrderExpandableCard(
                                    order: order,
                                    l10n: lang,
                                  );
                                },
                              );
                            },
                          ),
                          if (state.isLoadingMorePinding)
                            Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: spacing.md,
                              ),
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
