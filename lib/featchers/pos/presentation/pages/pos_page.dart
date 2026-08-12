import 'package:apex_restaurant/featchers/cart/presentation/bloc/cart_bloc.dart';
import 'package:apex_restaurant/featchers/cart/presentation/bloc/cart_event.dart';
import 'package:apex_restaurant/featchers/pos/presentation/bloc/pos_bloc.dart';
import 'package:apex_restaurant/featchers/pos/presentation/bloc/pos_event.dart';
import 'package:apex_restaurant/featchers/pos/presentation/bloc/pos_state.dart';
import 'package:apex_restaurant/featchers/pos/presentation/layout/pos_menu_screen.dart';
import 'package:apex_restaurant/featchers/pos/presentation/layout/pos_tablet_menu_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
      final posBloc = context.read<PosBloc>()
        ..add(LoadSettingsEvent())
        ..add(const LoadCategoriesEvent())
        ..add(const LoadFoodAdditivesEvent());
      posBloc;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 600;

    return BlocListener<PosBloc, PosState>(
      listenWhen: (prev, curr) => curr != prev,
      listener: (context, state) {
        if (state.settings != null) {
          context.read<CartBloc>().add(UpdateSettingsEvent(state.settings));
        }
      },
      child: isMobile
          ? PosMenuScreen(changeLanguage: widget.changeLanguage)
          : PosTabletMenuScreen(),
    );
  }
}
