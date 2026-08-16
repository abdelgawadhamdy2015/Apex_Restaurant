import '../../../../core/helpers/extensions.dart';
import '../../../../core/helpers/helper_methods.dart';
import '../../../../core/helpers/transactionid_generator.dart';
import '../../../../core/router/routes.dart';
import '../../../cart/data/models/get_client_request.dart';
import '../../../cart/presentation/bloc/cart_bloc.dart';
import '../../../cart/presentation/bloc/cart_event.dart';
import '../../../cart/presentation/bloc/cart_state.dart';
import '../../data/models/category_model.dart';
import '../../data/models/restaurant_item.dart';
import '../../domain/entities/menu_item.dart';
import '../bloc/pos_bloc.dart';
import '../bloc/pos_event.dart';
import '../bloc/pos_state.dart';
import '../widgets/cart_floating_summary_bar.dart';
import '../widgets/item_customization_sheet.dart';
import '../widgets/pos_categories_bar.dart';
import '../widgets/pos_menu_item_card.dart';
import '../widgets/pos_top_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CartBloc>().add(LoadDynamicDiscountsEvent());
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
    final spacing = context.spacing;

    return Scaffold(
      appBar: const PosTopAppBar(),
      bottomNavigationBar: BlocBuilder<CartBloc, CartState>(
        builder: (context, cartState) {
          if (cartState.items.isEmpty) return const SizedBox.shrink();

          final totalItems = cartState.items.fold<int>(
            0,
            (sum, item) => sum + item.quantity,
          );

          return CartFloatingSummaryBar(
            itemCount: totalItems,
            totalAmount: cartState.subtotal,
            onViewCartPressed: () => context.pushNamed(Routes.cartScreen),
          );
        },
      ),
      body: BlocConsumer<PosBloc, PosState>(
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
        builder: (context, state) {
          final cartState = context.watch<CartBloc>().state;
          return Column(
            children: [
              Divider(),
              PosCategoriesBar(
                categories: state.categories,
                selectedCategoryId: state.selectedCategory?.id,
                onCategorySelected: (cat) {
                  if (_scrollController.hasClients) {
                    _scrollController.jumpTo(0);
                  }
                  context.read<PosBloc>().add(SelectCategoryEvent(cat));
                },
              ),
              SizedBox(height: spacing.sm),
              Divider(),
              SizedBox(height: spacing.sm),

              Expanded(
                child:
                    state.status == PosStatus.loading &&
                        state.currentMenuItems.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : _buildItemsGrid(
                        context,
                        state.selectedCategory?.id,
                        state.currentMenuItems,
                        state.selectedCategory?.additives ?? [],
                        cartState,
                        state.isLoadingMoreItems,
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildItemsGrid(
    BuildContext parentContext,
    dynamic categoryId,
    List<RestaurantItem> items,
    List<AdditiveModel> additives,
    CartState cartState,
    bool isLoadingMore,
  ) {
    final spacing = context.spacing;

    if (items.isEmpty) {
      return const Center(child: Text("No items found"));
    }

    return CustomScrollView(
      key: ValueKey(categoryId),
      controller: _scrollController,
      slivers: [
        SliverPadding(
          padding: EdgeInsets.symmetric(
            horizontal: spacing.md,
            vertical: spacing.xs,
          ),
          sliver: SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.72,
              crossAxisSpacing: spacing.sm,
              mainAxisSpacing: spacing.sm,
            ),
            delegate: SliverChildBuilderDelegate((context, index) {
              final item = items[index];
              final matchedCategory = context
                  .read<PosBloc>()
                  .state
                  .categories
                  .where((cat) => cat.id == item.categoryId);
              final List<AdditiveModel> itemCatAdditives =
                  matchedCategory.isNotEmpty
                  ? matchedCategory.first.additives ?? []
                  : [];

              return PosMenuItemCard(
                item: item,
                onAddPressed: () => _onAddPressed(
                  parentContext,
                  item,
                  itemCatAdditives,
                  cartState,
                ),
              );
            }, childCount: items.length),
          ),
        ),
        if (isLoadingMore)
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: spacing.md),
              child: const Center(child: CircularProgressIndicator()),
            ),
          ),
      ],
    );
  }

  void _onAddPressed(
    BuildContext parentContext,
    RestaurantItem item,
    List<AdditiveModel> additives,
    CartState cartState,
  ) {
    if (cartState.selectedPerson == null) {
      HelperMethods.openPicker(parentContext, cartState.persons);
      return;
    }

    final needsCustomization = item.sizes.length > 1 || additives.isNotEmpty;

    if (!needsCustomization) {
      final orderItem = OrderItem(
        transactionId: TransactionIdGenerator.nextId,
        menuItem: item,
        selectedSize: item.sizes.isNotEmpty ? item.sizes.first : null,
        quantity: 1,
      );
      parentContext.read<CartBloc>().add(AddOrderItemToCartEvent(orderItem));
      return;
    }

    final posBloc = parentContext.read<PosBloc>();

    ItemCustomizationSheet.show(parentContext, item, posBloc, (
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
        transactionId: TransactionIdGenerator.nextId,
        menuItem: customItem,
        selectedSize: selectedSize,
        addons: selectedAddons,
        quantity: quantity,
        notes: notes,
        discount: discount,
        isPercentageDiscount: isPercentageDiscount,
      );

      parentContext.read<CartBloc>().add(AddOrderItemToCartEvent(orderItem));
    });
  }
}
