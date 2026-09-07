import 'package:apex_restaurant/featchers/cart/data/models/get_client_request.dart';

import '../../../cart/presentation/bloc/cart_bloc.dart';
import '../../../cart/presentation/bloc/cart_event.dart';
import '../bloc/pos_bloc.dart';
import '../bloc/pos_event.dart';
import '../bloc/pos_state.dart';
import '../layout/pos_menu_screen.dart';
import '../layout/pos_tablet_menu_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum PosBottomNavEnm { menu, orders, customers, tables, more }

class PosPage extends StatefulWidget {
  const PosPage({super.key, required this.changeLanguage});

  final Function(Locale) changeLanguage;

  @override
  State<PosPage> createState() => _PosPageState();
}

class _PosPageState extends State<PosPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  void _loadData() {
    context.read<PosBloc>()
      ..add(LoadSettingsEvent())
      ..add(const LoadCategoriesEvent())
      ..add(const LoadFoodAdditivesEvent());

    context.read<CartBloc>()
      ..add(LoadDynamicDiscountsEvent())
      ..add(LoadPersonsData(request: GetClientsRequest(isSupplier: false)));
  }

  Future<void> _onRefresh() async {
    _loadData();
    context.read<CartBloc>().add(ClearCartEvent());
    // Small delay so RefreshIndicator remains visible.
    // Better to replace this with waiting for Bloc success state
    // if you have a loading/status field.
    await Future.delayed(const Duration(milliseconds: 600));
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final isMobile = size.width < 600;

    return BlocListener<PosBloc, PosState>(
      listenWhen: (previous, current) => previous.settings != current.settings,
      listener: (context, state) {
        if (state.settings != null) {
          context.read<CartBloc>().add(UpdateSettingsEvent(state.settings));
        }
      },
      child: RefreshIndicator(
        onRefresh: _onRefresh,
        child: isMobile
            ? PosMenuScreen(changeLanguage: widget.changeLanguage)
            : const PosTabletMenuScreen(),
      ),
    );
  }
}
