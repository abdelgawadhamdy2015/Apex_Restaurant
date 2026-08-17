import 'package:apex_restaurant/core/helpers/extensions.dart';
import 'package:apex_restaurant/core/shared/widgets/settings_screen.dart';
import 'package:apex_restaurant/core/themes/app_colors.dart';
import 'package:apex_restaurant/featchers/home/presentation/bloc/home_bloc.dart';
import 'package:apex_restaurant/featchers/orders/presentation/pages/tablet_orders_screen.dart';
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
  int _selectedNavIndex = 0;

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
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final homeState = context.read<HomeBloc>().state;
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: TabletPosTopHeader(
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
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Row(
          children: [
            Expanded(flex: 1, child: _buildSideNavigationRail(theme, isDark)),
            VerticalDivider(
              width: 1,
              thickness: 1,
              color: theme.dividerColor.withOpacity(0.1),
            ),
            Expanded(
              flex: 9,
              child: IndexedStack(
                index: _selectedNavIndex,
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
      ),
    );
  }

  Widget _buildSideNavigationRail(ThemeData theme, bool isDark) {
    return Container(
      color: theme.colorScheme.surface,
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          const SizedBox(height: 20),
          _buildRailItem(0, Icons.restaurant_menu, 'القائمة', theme),
          _buildRailItem(1, Icons.receipt_long, 'الطلبات', theme),
          _buildRailItem(2, Icons.people, 'العملاء', theme),
          _buildRailItem(3, Icons.table_bar, 'الطاولات', theme),
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
      borderRadius: BorderRadius.circular(12),
      onTap: () => setState(() => _selectedNavIndex = index),
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
