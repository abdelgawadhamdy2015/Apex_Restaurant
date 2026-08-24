import 'dart:async';

import 'package:apex_restaurant/core/helpers/extensions.dart';
import 'package:apex_restaurant/core/shared/widgets/settings_screen.dart';
import 'package:apex_restaurant/core/themes/app_colors.dart';
import 'package:apex_restaurant/featchers/home/presentation/bloc/home_bloc.dart';
import 'package:apex_restaurant/featchers/orders/presentation/pages/tablet_orders_screen.dart';
import 'package:apex_restaurant/featchers/pos/domain/entities/get_items_request_model.dart';
import 'package:apex_restaurant/featchers/pos/presentation/bloc/pos_bloc.dart';
import 'package:apex_restaurant/featchers/pos/presentation/bloc/pos_event.dart';
import 'package:apex_restaurant/featchers/pos/presentation/bloc/pos_state.dart';
import 'package:apex_restaurant/featchers/pos/presentation/screens/customers_tablet_screen.dart';
import 'package:apex_restaurant/featchers/pos/presentation/tablet_widgets/tablet_menu_tab.dart';
import 'package:apex_restaurant/featchers/pos/presentation/tablet_widgets/tablet_more_option.dart';
import 'package:apex_restaurant/featchers/pos/presentation/tablet_widgets/tablet_top_header.dart';
import 'package:apex_restaurant/featchers/tables/presentation/pages/tablet_tables_screen.dart';
import 'package:flutter/material.dart';

// Ensure your import paths are aligned
import '../../../cart/data/models/get_client_request.dart';
import '../../../cart/presentation/bloc/cart_bloc.dart';
import '../../../cart/presentation/bloc/cart_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PosTabletMenuScreen extends StatefulWidget {
  const PosTabletMenuScreen({super.key});
  @override
  State<PosTabletMenuScreen> createState() => _PosTabletMenuScreenState();
}

class _PosTabletMenuScreenState extends State<PosTabletMenuScreen> {
  static const int _pageSize = 100;
  static const Duration _searchDebounceDuration = Duration(milliseconds: 400);
  static const Duration _loadMoreThrottleDuration = Duration(milliseconds: 600);

  Timer? _searchDebounce;

  /// The search key currently applied to the item list. Kept here (rather
  /// than only inside the TextField) so pagination requests triggered while
  /// a filter is active keep reusing the same key instead of silently
  /// dropping back to an unfiltered list.
  String _currentSearchKey = '';
  int _currentPage = 1;

  /// Simple timestamp-based throttle guard so rapid-fire "load more"
  /// triggers (e.g. multiple scroll events near the bottom of the grid)
  /// don't fan out into duplicate in-flight requests.
  DateTime? _lastLoadMoreAt;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CartBloc>().add(LoadDynamicDiscountsEvent());
      context.read<CartBloc>().add(
        LoadPersonsData(request: GetClientsRequest(isSupplier: false)),
      );
      context.read<CartBloc>().add(LoadCartDataEvent());
    });
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    super.dispose();
  }

  /// Debounced search handler. Waits for the user to stop typing before
  /// firing a request, and always resets pagination back to page 1 since a
  /// new search key means a brand-new result set.
  void _onSearchChanged(String value) {
    final trimmed = value.trim();

    _searchDebounce?.cancel();
    _searchDebounce = Timer(_searchDebounceDuration, () {
      if (!mounted) return;
      // Skip re-fetching if the debounced value didn't actually change
      // (e.g. user typed then quickly deleted back to the same text).
      if (trimmed == _currentSearchKey && _currentPage == 1) return;

      _currentSearchKey = trimmed;
      _currentPage = 1;
      _fetchItems(page: 1, searchKey: _currentSearchKey);
    });
  }

  /// Loads the next page for whatever search key is currently active.
  /// Throttled so it can be safely called from a scroll listener without
  /// worrying about duplicate calls near the end of the list.
  void loadNextPage() {
    final now = DateTime.now();
    if (_lastLoadMoreAt != null &&
        now.difference(_lastLoadMoreAt!) < _loadMoreThrottleDuration) {
      return;
    }
    _lastLoadMoreAt = now;

    _currentPage += 1;
    _fetchItems(page: _currentPage, searchKey: _currentSearchKey);
  }

  void _fetchItems({required int page, required String searchKey}) {
    context.read<PosBloc>().add(
      LoadItemsEvent(
        GetItemsRequest(
          pageNumber: page,
          pageSize: _pageSize,
          searchKey: searchKey.isEmpty ? null : searchKey,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final homeState = context.read<HomeBloc>().state;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: TabletPosTopHeader(
          onSearchChanged: _onSearchChanged,
          branchName: homeState.selectedEmployeeBranch?.arabicName ?? "",
          userRole: homeState.userDataModel?.employees?.arabicName ?? "",
          onSettingsPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return SettingsScreen();
              },
            );
          },
        ),
      ),
      body: BlocBuilder<PosBloc, PosState>(
        builder: (context, state) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: _buildSideNavigationRail(theme, isDark, state),
                ),
                VerticalDivider(
                  width: 1,
                  thickness: 1,
                  color: theme.dividerColor.withOpacity(0.1),
                ),
                Expanded(
                  flex: 9,
                  child: IndexedStack(
                    index: state.selectedNavIndex,
                    children: [
                      PosTabletMenuTab(),
                      OrdersTabletScreen(),
                      CustomersTabletView(),
                      TablesTabletScreen(
                        inCartScreen: false,
                        personList: context.read<CartBloc>().state.persons,
                        branchId: context
                            .read<HomeBloc>()
                            .state
                            .selectedEmployeeBranch!
                            .branchId,
                      ),
                      TabletMoreOptions(),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSideNavigationRail(
    ThemeData theme,
    bool isDark,
    PosState posState,
  ) {
    return Container(
      color: theme.colorScheme.surface,
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          const SizedBox(height: 20),
          _buildRailItem(0, Icons.restaurant_menu, 'القائمة', theme, posState),
          _buildRailItem(1, Icons.receipt_long, 'الطلبات', theme, posState),
          _buildRailItem(2, Icons.people, 'العملاء', theme, posState),
          _buildRailItem(3, Icons.table_bar, 'الطاولات', theme, posState),
          _buildRailItem(4, Icons.more_horiz, 'المزيد', theme, posState),
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
    PosState posState,
  ) {
    final isSelected = posState.selectedNavIndex == index;
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => context.read<PosBloc>().add(
        SelectedNavIndexEvent(selectedNavIndex: index),
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.amber : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected
                  ? AppColors.white
                  : theme.colorScheme.onSecondary,
            ),
            SizedBox(height: context.spacing.sm),
            Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isSelected
                    ? AppColors.white
                    : theme.colorScheme.onSecondary,
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
}
