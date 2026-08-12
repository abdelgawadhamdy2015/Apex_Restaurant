import 'package:apex_restaurant/featchers/cart/presentation/ui/layouts/cart_tablet_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:apex_restaurant/featchers/pos/presentation/bloc/pos_bloc.dart';
import 'package:apex_restaurant/featchers/pos/presentation/bloc/pos_state.dart';
import 'package:apex_restaurant/featchers/pos/presentation/widgets/pos_categories_bar.dart';
import 'package:apex_restaurant/featchers/pos/presentation/widgets/pos_filters_bar.dart';

class PosTabletMenuScreen extends StatefulWidget {
  const PosTabletMenuScreen({super.key});

  @override
  State<PosTabletMenuScreen> createState() => _PosTabletMenuScreenState();
}

class _PosTabletMenuScreenState extends State<PosTabletMenuScreen> {
  int _selectedFilterIndex = 0;
  int? _selectedCategoryId;
  int _selectedNavIndex = 0;

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
            // 1. Right Navigation Rail (In RTL view: far right side)
            _buildSideNavigationRail(theme, isDark),

            // 2. Main Content Area (Categories, Filters & Food Grid)
            Expanded(
              flex: 3,
              child: Column(
                children: [
                  Expanded(
                    child: BlocBuilder<PosBloc, PosState>(
                      builder: (context, posState) {
                        return Column(
                          children: [
                            const SizedBox(height: 12),
                            PosCategoriesBar(
                              categories: posState.categories,
                              selectedCategoryId: _selectedCategoryId,
                              onCategorySelected: (cat) {
                                setState(() {
                                  _selectedCategoryId = cat.id;
                                });
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
                            Expanded(child: _buildProductGrid(posState, theme)),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            // Vertical Divider
            VerticalDivider(
              width: 1,
              thickness: 1,
              color: theme.dividerColor.withOpacity(0.1),
            ),

            // 3. Left Side Cart Summary Pane (In RTL view: far left side)
            Expanded(flex: 3, child: _buildCartSummaryPane(theme)),
          ],
        ),
      ),
    );
  }

  /// Navigation Rail for Tablet
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

  /// Top Search & Admin Header
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
                fillColor: theme.colorScheme.background,
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

  /// Grid view of food items
  Widget _buildProductGrid(PosState posState, ThemeData theme) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, // 3 columns for tablet central pane
        childAspectRatio: 0.78,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: posState.categories
          .expand((element) => element.additives ?? [])
          .length, // Replace with your items list
      itemBuilder: (context, index) {
        // Construct or fetch item
        return Container(
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: theme.dividerColor.withOpacity(0.08)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceVariant,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                  ),
                  child: const Center(child: Icon(Icons.fastfood, size: 40)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'وجبة متكاملة',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '45.00 ر.س',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add_circle),
                          color: theme.colorScheme.primary,
                          onPressed: () {},
                        ),
                      ],
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

  /// Persistent Tablet Order/Cart Sidebar
  Widget _buildCartSummaryPane(ThemeData theme) {
    return PosTabletCartPanel();
  }
}
