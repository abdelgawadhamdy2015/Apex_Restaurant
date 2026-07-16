// ignore_for_file: deprecated_member_use

import 'package:apex_restaurant/featchers/pos/data/models/restaurant_item_response.dart';
import 'package:apex_restaurant/featchers/pos/domain/entities/get_items_request_model.dart';
import 'package:apex_restaurant/featchers/pos/domain/entities/menu_item.dart';
import 'package:apex_restaurant/featchers/pos/presentation/widgets/item_customization_sheet.dart';
import 'package:apex_restaurant/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:apex_restaurant/featchers/pos/presentation/bloc/pos_bloc.dart';
import 'package:apex_restaurant/featchers/pos/presentation/bloc/pos_event.dart';
import 'package:apex_restaurant/featchers/pos/presentation/bloc/pos_state.dart';

class MobilePosLayout extends StatefulWidget {
  const MobilePosLayout({super.key});

  @override
  State<MobilePosLayout> createState() => _MobilePosLayoutState();
}

class _MobilePosLayoutState extends State<MobilePosLayout> {
  int _currentNavIndex = 0; // 0: Menu, 1: Orders, 2: Cart, 3: Settings

  @override
  void initState() {
    super.initState();
    context.read<PosBloc>().add(const LoadCategoriesEvent());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  _buildHeader(theme, textTheme),
                  _buildCategoriesRow(theme),
                  _buildChipsFilters(theme),
                  Expanded(child: _buildItemsGrid(theme, textTheme)),
                  const SizedBox(
                    height: 100,
                  ), // Bottom offsets for Floating Bar & Nav Bar
                ],
              ),
              // Floating Basket Actions
              Positioned(
                bottom: 5,
                left: 16,
                right: 16,
                child: _buildFloatingBasketBar(theme, textTheme),
              ),
            ],
          ),
        ),
        bottomNavigationBar: _buildBottomNavigationBar(theme, textTheme),
      ),
    );
  }

  // Header Component (Restaurant Manager & Search Icon)
  Widget _buildHeader(ThemeData theme, TextTheme textTheme) {
    return Container(
      color: theme.colorScheme.surface,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: theme.colorScheme.primary.withOpacity(0.15),
                child: Icon(
                  Icons.person,
                  color: theme.colorScheme.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'مدير المطعم',
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
          IconButton(
            icon: Icon(
              Icons.search,
              color: theme.hintColor.withOpacity(0.8),
              size: 28,
            ),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  // Horizontal Category Row
  Widget _buildCategoriesRow(ThemeData theme) {
    return BlocBuilder<PosBloc, PosState>(
      builder: (context, state) {
        final categories = state.categories;
        return Container(
          height: 110,
          color: theme.colorScheme.surface,

          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              final isSelected = state.selectedCategory?.id == category.id;

              return GestureDetector(
                onTap: () {
                  context.read<PosBloc>().add(SelectCategoryEvent(category));
                  context.read<PosBloc>().add(
                    LoadItemsEvent(
                      GetItemsRequestModel(
                        categoryId: state.selectedCategory?.id,
                      ),
                    ),
                  );
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 72,
                  margin: const EdgeInsets.symmetric(horizontal: 6),

                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 72,
                        height: 60,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? theme.colorScheme.primary.withOpacity(0.1)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected
                                ? theme.colorScheme.primary
                                : theme.dividerColor.withOpacity(0.1),
                            width: 2,
                          ),
                        ),

                        child: Icon(
                          _getCategoryIcon(category.arabicName),
                          color: isSelected
                              ? theme.colorScheme.primary
                              : theme.hintColor,
                          size: 24,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        category.arabicName,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: isSelected
                              ? theme.colorScheme.primary
                              : theme.hintColor,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  // Tags/Chips Filters (الأكثر مبيعاً، المفضلة، جديد، إلخ)
  Widget _buildChipsFilters(ThemeData theme) {
    final filters = [
      {'label': '🔥 الأكثر مبيعاً', 'color': theme.colorScheme.secondary},
      {'label': '⭐ المفضلة', 'color': theme.hintColor},
      {'label': '🆕 جديد', 'color': const Color(0xFF17BDAA)},
      {'label': '🎁 عروض اليوم', 'color': const Color(0xFFA91CFF)},
    ];

    return Container(
      height: 48,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: filters.length,
        itemBuilder: (context, index) {
          final filter = filters[index];
          final color = filter['color'] as Color;
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.08),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: color.withOpacity(0.3), width: 1),
            ),
            child: Center(
              child: Text(
                filter['label'] as String,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // Menu Grid Area
  Widget _buildItemsGrid(ThemeData theme, TextTheme textTheme) {
    return BlocBuilder<PosBloc, PosState>(
      builder: (context, state) {
        if (state.status == PosStatus.loading) {
          return Center(
            child: CircularProgressIndicator(color: theme.colorScheme.primary),
          );
        }

        final items = state.currentMenuItems;
        if (items.isEmpty) {
          return Center(
            child: Text('لا توجد عناصر متاحة', style: textTheme.bodyLarge),
          );
        }

        return GridView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.72,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
          ),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return _buildItemCard(context, item, theme, textTheme);
          },
        );
      },
    );
  }

  // Individual Product Card
  Widget _buildItemCard(
    BuildContext context,
    RestaurantItemResponse item,
    ThemeData theme,
    TextTheme textTheme,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.brightness == Brightness.light
                ? const Color(0xC1C6D533).withOpacity(0.12)
                : Colors.black.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                item.imagePath != null
                    ? Container(
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(16),
                          ),
                          image: DecorationImage(
                            image: NetworkImage(item.imagePath!),
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                    : Assets.images.images.image(width: double.infinity),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.itemNameAr,
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  item.itemNameEn,
                  style: textTheme.bodySmall?.copyWith(
                    color: theme.brightness == Brightness.light
                        ? const Color(0xFF717784)
                        : Colors.white60,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${item.sizes.first.price} ر.س',
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // If the menu item has multiple units or sizes, prompt choices sheet
                        if (item.sizes.length > 1) {
                          ItemCustomizationSheet.show(context, item, (
                            customItem, {
                            required selectedSize,
                            required selectedAddons,
                            required discount,
                            required isPercentageDiscount,
                            required notes,
                            required quantity,
                          }) {
                            final orderItem = OrderItem(
                              menuItem: item,
                              quantity: quantity,
                            );
                            context.read<PosBloc>().add(
                              UpdateItemAddonsEvent(
                                item: orderItem,
                                addons: selectedAddons,
                              ),
                            );
                            // Trigger your custom add BLoC event passing the user's customizations
                            // context.read<PosBloc>().add(AddItemToOrderEvent(customItem, quantity: quantity, ...));
                          });
                        } else {
                          // Add immediately if it's a simple, single-size item
                          context.read<PosBloc>().add(
                            AddItemToOrderEvent(item),
                          );
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.add,
                          color: theme.colorScheme.onPrimary,
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Floating Bottom Cart Bar
  Widget _buildFloatingBasketBar(ThemeData theme, TextTheme textTheme) {
    return BlocBuilder<PosBloc, PosState>(
      builder: (context, state) {
        final totalQuantity = state.currentOrder.items.fold<int>(
          0,
          (sum, item) => sum + item.quantity,
        );
        final totalPrice = state.currentOrder.items.fold<double>(
          0.0,
          (sum, item) =>
              sum + ((item.menuItem.sizes.first.price) * item.quantity),
        );

        if (totalQuantity == 0) return const SizedBox.shrink();

        return Container(
          height: 64,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.primary.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Basket icon & badge
              Row(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.onPrimary.withOpacity(0.15),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.shopping_basket_outlined,
                          color: theme.colorScheme.onPrimary,
                        ),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.secondary,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '$totalQuantity',
                            style: textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.onSecondary,
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$totalQuantity أصناف',
                        style: textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onPrimary.withOpacity(0.7),
                        ),
                      ),
                      Text(
                        '${totalPrice.toStringAsFixed(2)} ر.س',
                        style: textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.onPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              // Action Button (عرض السلة)
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.onPrimary,
                  foregroundColor: theme.colorScheme.primary,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                ),
                onPressed: () {
                  // Navigate to cart/basket logic
                },
                child: Row(
                  children: [
                    Text(
                      'عرض السلة',
                      style: textTheme.labelLarge?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      Icons.arrow_back,
                      size: 16,
                      color: theme.colorScheme.primary,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Active-tab custom bottom nav bar
  Widget _buildBottomNavigationBar(ThemeData theme, TextTheme textTheme) {
    return Container(
      height: 75,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(0, Icons.restaurant_menu, 'القائمة', theme, textTheme),
          _buildNavItem(1, Icons.receipt_long, 'الطلبات', theme, textTheme),
          _buildNavItem(
            2,
            Icons.shopping_cart_outlined,
            'السلة',
            theme,
            textTheme,
            hasBadge: true,
          ),
          _buildNavItem(3, Icons.settings, 'الإعدادات', theme, textTheme),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    int index,
    IconData icon,
    String label,
    ThemeData theme,
    TextTheme textTheme, {
    bool hasBadge = false,
  }) {
    final isSelected = _currentNavIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _currentNavIndex = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: isSelected
            ? BoxDecoration(
                color: theme.colorScheme.secondary,
                borderRadius: BorderRadius.circular(20),
              )
            : null,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(
                  icon,
                  color: isSelected
                      ? theme.colorScheme.onSecondary
                      : theme.hintColor,
                  size: 24,
                ),
                if (hasBadge && !isSelected)
                  Positioned(
                    top: -2,
                    right: -2,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.error,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: textTheme.labelSmall?.copyWith(
                color: isSelected
                    ? theme.colorScheme.onSecondary
                    : theme.hintColor,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String name) {
    if (name.contains('كل') || name.toLowerCase().contains('all')) {
      return Icons.select_all;
    }
    if (name.contains('بحري') || name.contains('سمك')) {
      return Icons.set_meal_outlined;
    }
    if (name.contains('بيتزا')) return Icons.local_pizza_outlined;
    if (name.contains('برجر')) return Icons.lunch_dining_outlined;
    return Icons.restaurant;
  }
}
