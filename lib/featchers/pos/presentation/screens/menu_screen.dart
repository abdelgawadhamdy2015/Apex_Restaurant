import 'package:apex_restaurant/core/helpers/extensions.dart';
import 'package:apex_restaurant/core/helpers/helper_methods.dart';
import 'package:apex_restaurant/core/router/routes.dart';
import 'package:apex_restaurant/featchers/cart/data/models/get_client_request.dart';
import 'package:apex_restaurant/featchers/cart/presentation/bloc/cart_bloc.dart';
import 'package:apex_restaurant/featchers/cart/presentation/bloc/cart_event.dart';
import 'package:apex_restaurant/featchers/cart/presentation/bloc/cart_state.dart';
import 'package:apex_restaurant/featchers/pos/data/models/category_model.dart';
import 'package:apex_restaurant/featchers/pos/data/models/restaurant_item.dart';
import 'package:apex_restaurant/featchers/pos/domain/entities/menu_item.dart';
import 'package:apex_restaurant/featchers/pos/presentation/bloc/pos_bloc.dart';
import 'package:apex_restaurant/featchers/pos/presentation/bloc/pos_event.dart';
import 'package:apex_restaurant/featchers/pos/presentation/bloc/pos_state.dart';
import 'package:apex_restaurant/featchers/pos/presentation/widgets/cart_floating_summary_bar.dart';
import 'package:apex_restaurant/featchers/pos/presentation/widgets/item_customization_sheet.dart';
import 'package:apex_restaurant/featchers/pos/presentation/widgets/pos_categories_bar.dart';
import 'package:apex_restaurant/featchers/pos/presentation/widgets/pos_menu_item_card.dart';
import 'package:apex_restaurant/featchers/pos/presentation/widgets/pos_top_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  // int _selectedFilterIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CartBloc>().add(LoadDynamicDiscountsEvent());
      context.read<CartBloc>().add(
        LoadPersonsData(
          request: GetClientsRequest(
            pageNumber: 1,
            pageSize: 20,
            isSupplier: false,
          ),
        ),
      );
    });
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
                onCategorySelected: (cat) =>
                    context.read<PosBloc>().add(SelectCategoryEvent(cat)),
              ),
              SizedBox(height: spacing.sm),
              Divider(),
              // PosFiltersBar(
              //   selectedIndex: _selectedFilterIndex,
              //   onSelected: (index) =>
              //       setState(() => _selectedFilterIndex = index),
              // ),
              SizedBox(height: spacing.sm),

              Expanded(
                child:
                    state.status == PosStatus.loading &&
                        state.currentMenuItems.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : _buildItemsGrid(
                        context,
                        state.selectedCategory?.id, // Pass key identifier
                        state.currentMenuItems,
                        state.selectedCategory?.additives ?? [],
                        cartState,
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
  ) {
    final spacing = context.spacing;

    if (items.isEmpty) {
      return const Center(child: Text("No items found"));
    }

    return GridView.builder(
      key: ValueKey(categoryId),
      padding: EdgeInsets.symmetric(
        horizontal: spacing.md,
        vertical: spacing.xs,
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.72,
        crossAxisSpacing: spacing.sm,
        mainAxisSpacing: spacing.sm,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return PosMenuItemCard(
          item: item,
          onAddPressed: () =>
              _onAddPressed(parentContext, item, additives, cartState),
        );
      },
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
