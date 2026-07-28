import 'package:apex_restaurant/core/di/debandancy_injection.dart';
import 'package:apex_restaurant/core/router/routes.dart';
import 'package:apex_restaurant/featchers/home/presentation/widgets/side_nav.dart';
import 'package:apex_restaurant/featchers/orders/presentation/bloc/orders_bloc.dart';
import 'package:apex_restaurant/featchers/orders/presentation/pages/orders_screen.dart';
import 'package:apex_restaurant/featchers/pos/presentation/bloc/pos_bloc.dart';
import 'package:apex_restaurant/featchers/pos/presentation/bloc/pos_event.dart';
import 'package:apex_restaurant/featchers/pos/presentation/screens/menu_screen.dart';
import 'package:apex_restaurant/featchers/pos/presentation/widgets/more_options.dart';
import 'package:apex_restaurant/featchers/pos/presentation/widgets/pos_bottom_nav_bar.dart';
import 'package:apex_restaurant/featchers/pos/presentation/widgets/select_customer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PosMenuScreen extends StatefulWidget {
  const PosMenuScreen({super.key, required this.changeLanguage});
  final Function(Locale) changeLanguage;

  @override
  State<PosMenuScreen> createState() => _PosMenuScreenState();
}

class _PosMenuScreenState extends State<PosMenuScreen> {
  int _selectedNavIndex = 2;

  @override
  void initState() {
    super.initState();
    context.read<PosBloc>().add(const LoadCategoriesEvent());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      drawer: SideNav(
        changeLanguage: widget.changeLanguage,
        currentRoute: Routes.posScreen,
      ),
      body: _getWidget(),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Builder(
            builder: (bottomNavContext) => PosBottomNavBar(
              currentIndex: _selectedNavIndex,
              onTap: (m) {
                setState(() {
                  _selectedNavIndex = m;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _getWidget() {
    switch (_selectedNavIndex) {
      case 0:
        return MoreOptions();
      case 1:
        return SelectCustomerWidget();
      case 2:
        return BlocProvider(
          child: OrdersScreen(),
          create: (context) => getIt<OrdersBloc>(),
        );

      case 3:
        return MenuScreen();
      default:
        return MenuScreen();
    }
  }
}
