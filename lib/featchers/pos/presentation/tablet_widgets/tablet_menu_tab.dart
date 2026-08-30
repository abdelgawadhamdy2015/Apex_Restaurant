import 'package:apex_restaurant/featchers/cart/data/models/get_client_request.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/helpers/helper_methods.dart';
import '../../../../core/helpers/transactionid_generator.dart';
import '../../../cart/presentation/bloc/cart_bloc.dart';
import '../../../cart/presentation/bloc/cart_event.dart';
import '../../../cart/presentation/bloc/cart_state.dart';
import '../../../cart/presentation/ui/layouts/cart_tablet_screen.dart';
import '../../data/models/category_model.dart';
import '../../data/models/restaurant_item.dart';
import '../../domain/entities/menu_item.dart';
import '../bloc/pos_bloc.dart';
import '../bloc/pos_event.dart';
import '../bloc/pos_state.dart';
import '../widgets/pos_categories_bar.dart';
import '../widgets/pos_menu_item_card.dart';
import 'tablet_item_customization.dart';

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

    return Row(
      children: [
        // Left Column: Category Bar, Filters Bar, and Grid
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
                      context.read<PosBloc>().add(SelectCategoryEvent(cat));
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
          color: theme.dividerColor.withOpacity(0.1),
        ),

        // Right Column: Cart Panel Summary
        Expanded(flex: 3, child: const TabletCartPanel()),
      ],
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
              final matchedCategory = posState.categories.where(
                (cat) => cat.id == item.categoryId,
              );
              final List<AdditiveModel> itemCatAdditives =
                  matchedCategory.isNotEmpty
                  ? matchedCategory.first.additives ?? []
                  : [];

              return PosMenuItemCard(
                item: item,
                onAddPressed: () =>
                    _onAddPressed(context, item, itemCatAdditives, cartState),
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

  void _onAddPressed(
    BuildContext context,
    RestaurantItem item,
    List<AdditiveModel> additives,
    CartState cartState,
  ) {
    if (cartState.selectedPerson == null) {
      HelperMethods.openPicker(context, cartState.persons);
      return;
    }

    final needsCustomization = item.sizes.length > 1 || additives.isNotEmpty;

    if (!needsCustomization) {
      final orderItem = OrderItem(
        transactionId: TransactionIdGenerator.nextId.toString(),
        menuItem: item,
        selectedSize: item.sizes.isNotEmpty ? item.sizes.first : null,
        quantity: 1,
      );
      context.read<CartBloc>().add(AddOrderItemToCartEvent(orderItem));
      return;
    }

    final posBloc = context.read<PosBloc>();

    TabletItemCustomizationDialog.show(context, item, posBloc, (
      customItem,
      returnedAdditives, {
      required selectedSize,
      required selectedAddons,
      required discount,
      required isPercentageDiscount,
      required notes,
      required quantity,
    }) {
      final orderItem = OrderItem(
        transactionId: TransactionIdGenerator.nextId.toString(),
        menuItem: customItem,
        selectedSize: selectedSize,
        addons: selectedAddons,
        quantity: quantity,
        notes: notes,
        discount: discount,
        isPercentageDiscount: isPercentageDiscount,
      );

      context.read<CartBloc>().add(AddOrderItemToCartEvent(orderItem));
    });
  }
}
