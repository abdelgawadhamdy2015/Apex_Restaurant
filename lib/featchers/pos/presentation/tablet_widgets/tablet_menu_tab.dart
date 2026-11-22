import 'package:apex_restaurant/featchers/cart/data/models/get_client_request.dart';
import 'package:apex_restaurant/featchers/pos/presentation/widgets/pos_add_item_handler.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/helpers/helper_methods.dart';
import '../../../cart/presentation/bloc/cart_bloc.dart';
import '../../../cart/presentation/bloc/cart_event.dart';
import '../../../cart/presentation/bloc/cart_state.dart';
import '../../../cart/presentation/ui/layouts/cart_tablet_screen.dart';
import '../bloc/pos_bloc.dart';
import '../bloc/pos_event.dart';
import '../bloc/pos_state.dart';
import '../widgets/pos_categories_bar.dart';
import '../widgets/pos_menu_item_card.dart';

class PosTabletMenuTab extends StatefulWidget {
  const PosTabletMenuTab({super.key});

  @override
  State<PosTabletMenuTab> createState() => _PosTabletMenuTabState();
}

class _PosTabletMenuTabState extends State<PosTabletMenuTab> {
  // int _selectedFilterIndex = 0;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CartBloc>().add(
        LoadPersonsData(request: GetClientsRequest(isSupplier: false)),
      );
    });

    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final nearBottom =
        _scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 300;
    if (!nearBottom) return;

    final posState = context.read<PosBloc>().state;
    if (posState.hasMoreItems &&
        !posState.isLoadingMoreItems &&
        posState.status != PosStatus.loading) {
      context.read<PosBloc>().add(const LoadMoreItemsEvent());
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return PosMenuCompanySync(
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: BlocConsumer<PosBloc, PosState>(
              listener: (context, state) {
                if (state.toastMessage != null) {
                  HelperMethods.showSnackBar(
                    context: context,
                    message: state.toastMessage!,
                    isError: false,
                  );
                  context.read<PosBloc>().add(const DismissToastEvent());
                }
              },
              builder: (context, posState) {
                final cartState = context.watch<CartBloc>().state;
                return Column(
                  children: [
                    const SizedBox(height: 12),
                    PosCategoriesBar(
                      categories: posState.categories,
                      selectedCategoryId: posState.selectedCategory?.id,
                      onCategorySelected: (cat) {
                        if (_scrollController.hasClients) {
                          _scrollController.jumpTo(0);
                        }
                        context.read<PosBloc>().add(
                          SelectCategoryEvent(
                            category: cat,
                            deliveryCompanyId: cartState.menuCompanyId,
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    // PosFiltersBar(
                    //   selectedIndex: _selectedFilterIndex,
                    //   onSelected: (index) {
                    //     setState(() {
                    //       _selectedFilterIndex = index;
                    //     });
                    //   },
                    // ),
                    // const SizedBox(height: 12),
                    Expanded(
                      child:
                          posState.status == PosStatus.loading &&
                              posState.currentMenuItems.isEmpty
                          ? const Center(child: CircularProgressIndicator())
                          : _buildProductGrid(posState, cartState, theme),
                    ),
                  ],
                );
              },
            ),
          ),

          VerticalDivider(
            width: 1,
            thickness: 1,
            color: theme.dividerColor.withValues(alpha: 0.1),
          ),

          // Right Column: Cart Panel Summary
          Expanded(flex: 3, child: const TabletCartPanel()),
        ],
      ),
    );
  }

  Widget _buildProductGrid(
    PosState posState,
    CartState cartState,
    ThemeData theme,
  ) {
    final items = posState.currentMenuItems;

    if (items.isEmpty) {
      return const Center(child: Text("No items found"));
    }

    return CustomScrollView(
      key: ValueKey(posState.selectedCategory?.id),
      controller: _scrollController,
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 0.78,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            delegate: SliverChildBuilderDelegate((context, index) {
              final item = items[index];
              return PosMenuItemCard(
                item: item,
                onAddPressed: () =>
                    PosAddItemHandler.onAddPressed(context, item),
              );
            }, childCount: items.length),
          ),
        ),
        if (posState.isLoadingMoreItems)
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Center(child: CircularProgressIndicator()),
            ),
          ),
      ],
    );
  }
}
