import 'package:apex_restaurant/featchers/pos/presentation/bloc/pos_state.dart';

import '../../../../core/di/debandancy_injection.dart';
import '../../../../core/router/routes.dart';
import '../../../home/presentation/widgets/side_nav.dart';
import '../../../orders/presentation/bloc/orders_bloc.dart';
import '../../../orders/presentation/pages/orders_screen.dart';
import '../bloc/pos_bloc.dart';
import '../bloc/pos_event.dart';
import '../screens/menu_screen.dart';
import '../widgets/more_options.dart';
import '../widgets/pos_bottom_nav_bar.dart';
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocBuilder<PosBloc, PosState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          drawer: SideNav(
            changeLanguage: widget.changeLanguage,
            currentRoute: Routes.posScreen,
          ),
          body: _getWidget(state),
          bottomNavigationBar: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Builder(
                builder: (bottomNavContext) => PosBottomNavBar(
                  currentIndex: state.selectedNavIndex,
                  onTap: (m) {
                    context.read<PosBloc>().add(
                      SelectedNavIndexEvent(selectedNavIndex: m),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _getWidget(PosState state) {
    switch (state.selectedNavIndex) {
      case 0:
        return MenuScreen();

      case 1:
        return BlocProvider(
          child: OrdersScreen(),
          create: (context) => getIt<OrdersBloc>(),
        );

      case 2:
        return MoreOptions();
      default:
        return MenuScreen();
    }
  }
}
