import 'package:apex_restaurant/core/helpers/extensions.dart';
import 'package:apex_restaurant/core/router/routes.dart';
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
import 'package:apex_restaurant/featchers/pos/presentation/widgets/pos_filters_bar.dart';
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
  int _selectedFilterIndex = 0;

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;

    return Scaffold(
      appBar: const PosTopAppBar(),
      bottomNavigationBar: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state.items.isEmpty) return const SizedBox.shrink();

          final totalItems = state.items.fold<int>(
            0,
            (sum, item) => sum + item.quantity,
          );

          return CartFloatingSummaryBar(
            itemCount: totalItems,
            totalAmount: state.subtotal,
            onViewCartPressed: () => context.pushNamed(Routes.cartScreen),
          );
        },
      ),
      body: BlocConsumer<PosBloc, PosState>(
        listener: (context, state) {
          if (state.toastMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.toastMessage!),
                duration: const Duration(seconds: 2),
              ),
            );
            context.read<PosBloc>().add(const DismissToastEvent());
          }
        },
        builder: (context, state) {
          return Column(
            children: [
              PosCategoriesBar(
                categories: state.categories,
                selectedCategoryId: state.selectedCategory?.id,
                onCategorySelected: (cat) =>
                    context.read<PosBloc>().add(SelectCategoryEvent(cat)),
              ),
              SizedBox(height: spacing.sm),

              PosFiltersBar(
                selectedIndex: _selectedFilterIndex,
                onSelected: (index) =>
                    setState(() => _selectedFilterIndex = index),
              ),
              SizedBox(height: spacing.sm),

              Expanded(
                child:
                    state.status == PosStatus.loading &&
                        state.currentMenuItems.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : _buildItemsGrid(
                        state.currentMenuItems,
                        state.selectedCategory?.additives ?? [],
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildItemsGrid(
    List<RestaurantItem> items,
    List<AdditiveModel> additives,
  ) {
    final spacing = context.spacing;

    return GridView.builder(
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
          onAddPressed: () {
            if (item.sizes.length > 1 || additives.isNotEmpty) {
              ItemCustomizationSheet.show(context, item, additives, (
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

                context.read<CartBloc>().add(
                  AddOrderItemToCartEvent(orderItem),
                );
              });
            } else {
              final orderItem = OrderItem(
                menuItem: item,
                selectedSize: item.sizes.isNotEmpty ? item.sizes.first : null,
                quantity: 1,
              );

              context.read<CartBloc>().add(AddOrderItemToCartEvent(orderItem));
            }
          },
        );
      },
    );
  }
}
