import 'package:apex_restaurant/core/di/debandancy_injection.dart';
import 'package:apex_restaurant/core/router/routes.dart';
import 'package:apex_restaurant/featchers/home/presentation/widgets/side_nav.dart';
import 'package:apex_restaurant/featchers/orders/presentation/bloc/orders_bloc.dart';
import 'package:apex_restaurant/featchers/orders/presentation/pages/orders_screen.dart';
import 'package:apex_restaurant/featchers/pos/presentation/bloc/pos_bloc.dart';
import 'package:apex_restaurant/featchers/pos/presentation/bloc/pos_event.dart';
import 'package:apex_restaurant/featchers/pos/presentation/bloc/pos_state.dart';
import 'package:apex_restaurant/featchers/pos/presentation/pages/pos_page.dart';
import 'package:apex_restaurant/featchers/pos/presentation/screens/menu_screen.dart';
import 'package:apex_restaurant/featchers/pos/presentation/widgets/more_options.dart';
import 'package:apex_restaurant/featchers/pos/presentation/widgets/pos_bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PosMenuScreen extends StatefulWidget {
  const PosMenuScreen({super.key, required this.changeLanguage});

  final Function(Locale) changeLanguage;

  @override
  State<PosMenuScreen> createState() => _PosMenuScreenState();
}

class _PosMenuScreenState extends State<PosMenuScreen> {
  @override
  void initState() {
    super.initState();

    context.read<PosBloc>().add(const LoadCategoriesEvent());
  }

  List<PosBottomNavEnm> _getNavItems(BuildContext context) {
    return const [
      PosBottomNavEnm.menu,
      PosBottomNavEnm.orders,
      PosBottomNavEnm.more,
    ];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<PosBloc, PosState>(
      builder: (context, state) {
        final navItems = _getNavItems(context);

        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,

          drawer: SideNav(
            changeLanguage: widget.changeLanguage,
            currentRoute: Routes.posScreen,
          ),

          body: _getWidget(state),

          bottomNavigationBar: PosBottomNavBar(
            currentIndex: state.selectedNavIndex,
            items: navItems,
            onTap: (item) {
              context.read<PosBloc>().add(
                SelectedNavIndexEvent(selectedNavIndex: item),
              );
            },
          ),
        );
      },
    );
  }

  Widget _getWidget(PosState state) {
    switch (state.selectedNavIndex) {
      case PosBottomNavEnm.menu:
        return MenuScreen();

      case PosBottomNavEnm.orders:
        return BlocProvider(
          create: (context) => getIt<OrdersBloc>(),
          child: OrdersScreen(),
        );

      case PosBottomNavEnm.customers:
        // Tablet only
        return const SizedBox();

      case PosBottomNavEnm.tables:
        // Tablet only
        return const SizedBox();

      case PosBottomNavEnm.more:
        return MoreOptions();
    }
  }
}
