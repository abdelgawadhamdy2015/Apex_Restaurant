import '../../../../core/helpers/helper_methods.dart';
import '../../../../core/helpers/transactionid_generator.dart';
import '../../../cart/data/models/get_client_request.dart';
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
import '../widgets/item_customization_sheet.dart';
import '../widgets/pos_categories_bar.dart';
import '../widgets/pos_filters_bar.dart';
import '../widgets/pos_menu_item_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PosTabletMenuScreen extends StatefulWidget {
  const PosTabletMenuScreen({super.key});

  @override
  State<PosTabletMenuScreen> createState() => _PosTabletMenuScreenState();
}

class _PosTabletMenuScreenState extends State<PosTabletMenuScreen> {
  int _selectedFilterIndex = 0;
  int _selectedNavIndex = 0;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // PosTabletMenuScreen is rendered directly by PosPage (not nested under
    // PosMenuScreen/MenuScreen like the mobile flow), so it needs to kick
    // off the same cart bootstrap data itself.
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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(title: _buildTabletHeader(theme)),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Row(
          children: [
            _buildSideNavigationRail(theme, isDark),

            Expanded(
              flex: 3,
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
                      PosFiltersBar(
                        selectedIndex: _selectedFilterIndex,
                        onSelected: (index) {
                          setState(() {
                            _selectedFilterIndex = index;
                          });
                        },
                      ),
                      const SizedBox(height: 12),
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

            Expanded(flex: 3, child: _buildCartSummaryPane(theme)),
          ],
        ),
      ),
    );
  }

  Widget _buildSideNavigationRail(ThemeData theme, bool isDark) {
    return Container(
      width: 80,
      color: theme.colorScheme.surface,
      child: Column(
        children: [
          const SizedBox(height: 20),
          _buildRailItem(0, Icons.restaurant_menu, 'القائمة', theme),
          _buildRailItem(1, Icons.receipt_long, 'الطلبات', theme),
          _buildRailItem(2, Icons.people, 'العملاء', theme),
          _buildRailItem(3, Icons.table_bar, 'الطاولات', theme),
          const Spacer(),
          _buildRailItem(4, Icons.more_horiz, 'المزيد', theme),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildRailItem(
    int index,
    IconData icon,
    String label,
    ThemeData theme,
  ) {
    final isSelected = _selectedNavIndex == index;
    return InkWell(
      onTap: () => setState(() => _selectedNavIndex = index),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? theme.colorScheme.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected
                  ? theme.colorScheme.onPrimary
                  : theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: theme.textTheme.labelSmall?.copyWith(
                color: isSelected
                    ? theme.colorScheme.onPrimary
                    : theme.colorScheme.onSurfaceVariant,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabletHeader(ThemeData theme) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      color: theme.colorScheme.surface,
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
            child: Icon(Icons.person, color: theme.colorScheme.primary),
          ),
          const SizedBox(width: 12),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'مدير المطعم',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'الفرع الرئيسي',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const Spacer(),
          Expanded(
            flex: 2,
            child: TextField(
              decoration: InputDecoration(
                hintText: 'بحث عن منتج...',
                prefixIcon: const Icon(Icons.search),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                fillColor: theme.colorScheme.surface,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Real menu grid backed by [PosBloc], with the same pagination behavior
  /// as the mobile screen (infinite scroll via [_scrollController]).
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
        transactionId: TransactionIdGenerator.nextId,
        menuItem: item,
        selectedSize: item.sizes.isNotEmpty ? item.sizes.first : null,
        quantity: 1,
      );
      context.read<CartBloc>().add(AddOrderItemToCartEvent(orderItem));
      return;
    }

    final posBloc = context.read<PosBloc>();

    ItemCustomizationSheet.show(context, item, posBloc, (
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

      context.read<CartBloc>().add(AddOrderItemToCartEvent(orderItem));
    });
  }

  Widget _buildCartSummaryPane(ThemeData theme) {
    return PosTabletCartPanel();
  }
}
