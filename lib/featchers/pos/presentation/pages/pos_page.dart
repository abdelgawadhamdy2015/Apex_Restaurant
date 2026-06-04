import 'package:apex_restaurant/core/di/debandancy_injection.dart';
import 'package:apex_restaurant/featchers/home/presentation/widgets/side_nav.dart';
import 'package:apex_restaurant/featchers/pos/presentation/bloc/pos_bloc.dart';
import 'package:apex_restaurant/featchers/pos/presentation/bloc/pos_event.dart';
import 'package:apex_restaurant/featchers/pos/presentation/widgets/category_sidebar.dart';
import 'package:apex_restaurant/featchers/pos/presentation/widgets/menu_grid.dart';
import 'package:apex_restaurant/featchers/pos/presentation/widgets/order_panel.dart';
import 'package:apex_restaurant/featchers/pos/presentation/widgets/pos_toast.dart';
import 'package:apex_restaurant/featchers/pos/presentation/widgets/pos_top_bar.dart';
import 'package:apex_restaurant/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PosPage extends StatefulWidget {
  const PosPage({super.key, required this.changeLanguage});
  final Function(Locale) changeLanguage;

  @override
  State<PosPage> createState() => _PosPageState();
}

class _PosPageState extends State<PosPage> {
  _PosPageState();

  late S lang;
  @override
  Widget build(BuildContext context) {
    lang = S.current;
    return BlocProvider(
      create: (_) => getIt<PosBloc>()
        ..add(const LoadCategoriesEvent())
        ..add(const LoadFoodAdditivesEvent()),
      child: Scaffold(
        drawer: SideNav(changeLanguage: widget.changeLanguage),

        body: SafeArea(
          child: Column(
            children: [
              PosTopBar(lang: lang),
              Expanded(
                child: Row(
                  children: [
                    // Right: Category sidebar
                    const CategorySidebar(),

                    // Center: Menu grid
                    const Expanded(child: MenuGrid()),

                    // Left: Order panel
                    const OrderPanel(),
                  ],
                ),
              ),

              // Toast overlay
              PosToast(),
            ],
          ),
        ),
      ),
    );
  }
}
