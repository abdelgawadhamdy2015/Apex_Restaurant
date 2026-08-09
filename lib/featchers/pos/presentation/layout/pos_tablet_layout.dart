import 'package:apex_restaurant/core/helpers/extensions.dart';
import 'package:apex_restaurant/core/helpers/helper_methods.dart';
import 'package:apex_restaurant/core/router/routes.dart';
import 'package:apex_restaurant/featchers/cart/data/models/get_client_request.dart';
import 'package:apex_restaurant/featchers/cart/presentation/bloc/cart_bloc.dart';
import 'package:apex_restaurant/featchers/cart/presentation/bloc/cart_event.dart';
import 'package:apex_restaurant/featchers/cart/presentation/bloc/cart_state.dart';
import 'package:apex_restaurant/featchers/cart/presentation/ui/widgets/order_type_selector.dart';
import 'package:apex_restaurant/featchers/payment/presentation/screens/tablet_payment_dialog.dart';
import 'package:apex_restaurant/featchers/pos/data/models/category_model.dart';
import 'package:apex_restaurant/featchers/pos/presentation/bloc/pos_state.dart';
import 'package:apex_restaurant/featchers/pos/data/models/restaurant_item.dart';
import 'package:apex_restaurant/featchers/pos/domain/entities/menu_item.dart';
import 'package:apex_restaurant/featchers/pos/presentation/bloc/pos_bloc.dart';
import 'package:apex_restaurant/featchers/pos/presentation/bloc/pos_event.dart';
import 'package:apex_restaurant/featchers/pos/presentation/widgets/item_customization_sheet.dart';
import 'package:apex_restaurant/featchers/pos/presentation/widgets/pos_categories_bar.dart';
import 'package:apex_restaurant/featchers/pos/presentation/widgets/pos_menu_item_card.dart';
import 'package:apex_restaurant/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class PosTabletScreen extends StatefulWidget {
  const PosTabletScreen({super.key});

  @override
  State<PosTabletScreen> createState() => _PosTabletScreenState();
}

class _PosTabletScreenState extends State<PosTabletScreen> {
  int _selectedNavIndex = 0;
  int _selectedFilterIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CartBloc>().add(LoadCartDataEvent());
      context.read<CartBloc>().add(LoadDynamicDiscountsEvent());
      context.read<CartBloc>().add(
        LoadPersonsData(
          request: GetClientsRequest(
            pageNumber: 1,
            pageSize: 50,
            isSupplier: false,
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: SafeArea(
        child: Row(
          children: [
            // Left Side - Cart Section (340px)
            const VerticalDivider(width: 1, thickness: 1),

            // Right Side - Navigation Rail
            _TabletNavRail(
              selectedIndex: _selectedNavIndex,
              onDestinationSelected: (index) {
                setState(() => _selectedNavIndex = index);
                if (index == 1) context.pushNamed(Routes.ordersScreen);
                if (index == 3) context.pushNamed(Routes.tableScreen);
              },
            ),
            // Middle Section - Menu & Categories
            Expanded(
              child: Column(
                children: [
                  const _TabletTopHeader(),
                  const Divider(height: 1),

                  // Categories Bar
                  BlocBuilder<PosBloc, PosState>(
                    builder: (context, state) {
                      return PosCategoriesBar(
                        categories: state.categories,
                        selectedCategoryId: state.selectedCategory?.id,
                        onCategorySelected: (cat) => context
                            .read<PosBloc>()
                            .add(SelectCategoryEvent(cat)),
                      );
                    },
                  ),

                  // Filter Chips
                  _TabletFilterBar(
                    selectedIndex: _selectedFilterIndex,
                    onSelected: (idx) =>
                        setState(() => _selectedFilterIndex = idx),
                  ),

                  // Menu Grid
                  Expanded(
                    child: BlocConsumer<PosBloc, PosState>(
                      listener: (context, state) {
                        if (state.toastMessage != null) {
                          HelperMethods.showSnackBar(
                            context: context,
                            message: state.toastMessage!,
                            isError: false,
                          );
                          context.read<PosBloc>().add(
                            const DismissToastEvent(),
                          );
                        }
                      },
                      builder: (context, state) {
                        final cartState = context.watch<CartBloc>().state;
                        if (state.status == PosStatus.loading &&
                            state.currentMenuItems.isEmpty) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        return _buildItemsGrid(
                          context,
                          state.selectedCategory?.id,
                          state.currentMenuItems,
                          state.selectedCategory?.additives ?? [],
                          cartState,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            const VerticalDivider(width: 1, thickness: 1),

            SizedBox(width: 360, child: const _TabletCartPanel()),
          ],
        ),
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
      padding: EdgeInsets.all(spacing.sm),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4, // 4 items per row in tablet mode
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

// -----------------------------------------------------------------------------
// Top Search Header
// -----------------------------------------------------------------------------
class _TabletTopHeader extends StatelessWidget {
  const _TabletTopHeader();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;

    return Padding(
      padding: EdgeInsets.all(spacing.sm),
      child: Row(
        children: [
          Expanded(
            child: SearchBar(
              hintText: S.of(context).search,
              leading: const Icon(Icons.search),
              elevation: const MaterialStatePropertyAll(0),
              backgroundColor: MaterialStatePropertyAll(
                theme.colorScheme.surfaceVariant.withOpacity(0.3),
              ),
            ),
          ),
          SizedBox(width: spacing.sm),
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// Tablet Filters Bar
// -----------------------------------------------------------------------------
class _TabletFilterBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  const _TabletFilterBar({
    required this.selectedIndex,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final lang = S.of(context);
    final spacing = context.spacing;
    final filters = [
      lang.bestSellers,
      lang.todayOffers,
      lang.newItems,
      lang.favorites,
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(
        horizontal: spacing.sm,
        vertical: spacing.xs,
      ),
      child: Row(
        children: List.generate(filters.length, (index) {
          final isSelected = selectedIndex == index;
          return Padding(
            padding: EdgeInsets.only(left: spacing.xs),
            child: ChoiceChip(
              label: Text(filters[index]),
              selected: isSelected,
              onSelected: (_) => onSelected(index),
            ),
          );
        }),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// Tablet Cart Side Panel
// -----------------------------------------------------------------------------
class _TabletCartPanel extends StatelessWidget {
  const _TabletCartPanel();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;
    final lang = S.of(context);

    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        final selectedPerson =
            state.selectedPerson ??
            (state.persons.isNotEmpty ? state.persons.first : null);

        return Column(
          children: [
            // Header Row
            Padding(
              padding: EdgeInsets.all(spacing.sm),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    lang.shoppingCart,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () =>
                        context.read<CartBloc>().add(ClearCartEvent()),
                    child: Text(
                      lang.clearAll,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
            ),

            // Order Header Specs (Order # & Date)
            Container(
              color: theme.colorScheme.surfaceVariant.withOpacity(0.2),
              padding: EdgeInsets.symmetric(
                horizontal: spacing.md,
                vertical: spacing.xs,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Text('رقم الطلب', style: theme.textTheme.bodySmall),
                      Text(
                        '#12345',
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text('رقم الفاتورة', style: theme.textTheme.bodySmall),
                      Text(
                        'INV-9876',
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text('التاريخ', style: theme.textTheme.bodySmall),
                      const Text(
                        '10/07/2026',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: spacing.xs),

            // Order Type Selector
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: OrderTypeSelector(),
            ),
            SizedBox(height: spacing.xs),

            // Customer Selector Card
            ListTile(
              dense: true,
              leading: const CircleAvatar(child: Icon(Icons.person, size: 18)),
              title: Text(selectedPerson?.arabicName ?? 'أحمد محمود'),
              subtitle: const Text('عميل مسجل'),
              trailing: TextButton(
                onPressed: () => context.pushNamed(Routes.addCustomerScreen),
                child: Text(lang.addCustomer),
              ),
            ),
            const Divider(),

            // Items List
            Expanded(
              child: state.items.isEmpty
                  ? const Center(child: Text('السلة فارغة'))
                  : ListView.separated(
                      padding: EdgeInsets.symmetric(horizontal: spacing.sm),
                      itemCount: state.items.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final item = state.items[index];
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Image.network(
                            item.menuItem.imagePath ?? '',
                            width: 48,
                            height: 48,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              width: 48,
                              height: 48,
                              color: Colors.grey.shade200,
                              child: const Icon(Icons.fastfood, size: 20),
                            ),
                          ),
                          title: Text(
                            item.menuItem.itemNameAr,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            '${item.selectedSize?.sizeNameAr ?? ''} | ${item.notes ?? ''}',
                            style: theme.textTheme.bodySmall,
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '${item.totalPrice.toStringAsFixed(2)} ر.س',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete_outline,
                                  size: 18,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  context.read<CartBloc>().add(
                                    RemoveItemEvent(index),
                                  );
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),

            // Footer / Checkout Action
            Container(
              padding: EdgeInsets.all(spacing.sm),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                border: Border(
                  top: BorderSide(color: theme.colorScheme.outlineVariant),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.pause_circle_outline),
                          label: Text(lang.holdOrder),
                        ),
                      ),
                      SizedBox(width: spacing.sm),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton.icon(
                          onPressed: () => TabletPaymentDialog.show(
                            context,
                            totalAmount: state.grandTotal,
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.colorScheme.primary,
                            foregroundColor: theme.colorScheme.onPrimary,
                          ),
                          icon: const Icon(Icons.payment),
                          label: Text(lang.checkout),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

// -----------------------------------------------------------------------------
// Tablet Vertical Side Nav Rail
// -----------------------------------------------------------------------------
class _TabletNavRail extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  const _TabletNavRail({
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final lang = S.of(context);

    return NavigationRail(
      selectedIndex: selectedIndex,
      onDestinationSelected: onDestinationSelected,
      labelType: NavigationRailLabelType.all,
      selectedIconTheme: IconThemeData(color: theme.colorScheme.primary),
      selectedLabelTextStyle: TextStyle(
        color: theme.colorScheme.primary,
        fontWeight: FontWeight.bold,
      ),
      destinations: [
        NavigationRailDestination(
          icon: const Icon(Icons.restaurant_menu),
          label: Text(lang.menu),
        ),
        NavigationRailDestination(
          icon: const Icon(Icons.receipt_long),
          label: Text(lang.orders),
        ),
        NavigationRailDestination(
          icon: const Icon(Icons.people_outline),
          label: Text(lang.customers),
        ),
        NavigationRailDestination(
          icon: const Icon(Icons.table_restaurant),
          label: Text(lang.tables),
        ),
        NavigationRailDestination(
          icon: const Icon(Icons.more_horiz),
          label: Text(lang.more),
        ),
      ],
    );
  }
}
