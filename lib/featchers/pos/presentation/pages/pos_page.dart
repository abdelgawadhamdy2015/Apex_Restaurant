import 'package:apex_restaurant/core/di/debandancy_injection.dart';
import 'package:apex_restaurant/featchers/home/presentation/widgets/side_nav.dart';
import 'package:apex_restaurant/featchers/pos/presentation/bloc/pos_bloc.dart';
import 'package:apex_restaurant/featchers/pos/presentation/bloc/pos_event.dart';
import 'package:apex_restaurant/featchers/pos/presentation/widgets/category_sidebar.dart';
import 'package:apex_restaurant/featchers/pos/presentation/widgets/menu_grid.dart';
import 'package:apex_restaurant/featchers/pos/presentation/widgets/order_panel.dart';
import 'package:apex_restaurant/featchers/pos/presentation/widgets/pos_toast.dart';
import 'package:apex_restaurant/featchers/pos/presentation/widgets/pos_top_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PosPage extends StatelessWidget {
  const PosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<PosBloc>()..add(const LoadMenuEvent()),
      child: const _PosPageView(),
    );
  }
}

class _PosPageView extends StatelessWidget {
  const _PosPageView();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        drawer: Directionality.of(context) == TextDirection.ltr
            ? SideNav()
            : null,

        endDrawer: Directionality.of(context) == TextDirection.rtl
            ? SideNav()
            : null,
        appBar: const PosTopBar(),
        body: SafeArea(
          child: Stack(
            children: [
              Row(
                children: [
                  // Right: Category sidebar
                  const CategorySidebar(),

                  // Center: Menu grid
                  const Expanded(child: MenuGrid()),

                  // Left: Order panel
                  const OrderPanel(),
                ],
              ),

              // Toast overlay
              const PosToast(),
            ],
          ),
        ),
      ),
    );
  }
}
