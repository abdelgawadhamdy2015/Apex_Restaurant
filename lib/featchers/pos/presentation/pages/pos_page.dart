import 'package:apex_restaurant/core/di/debandancy_injection.dart';
import 'package:apex_restaurant/core/shared/widgets/auth_listener.dart';
import 'package:apex_restaurant/featchers/pos/presentation/bloc/pos_bloc.dart';
import 'package:apex_restaurant/featchers/pos/presentation/bloc/pos_event.dart';
import 'package:apex_restaurant/featchers/pos/presentation/bloc/pos_state.dart';
import 'package:apex_restaurant/featchers/pos/presentation/layout/pos_menu_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PosPage extends StatelessWidget {
  const PosPage({super.key, required this.changeLanguage});

  final Function(Locale) changeLanguage;

  @override
  Widget build(BuildContext context) {
    //  final isMobile = context.size!.width < 400;
    return BlocProvider(
      create: (_) => getIt<PosBloc>()
        ..add(const LoadCategoriesEvent())
        ..add(const LoadFoodAdditivesEvent()),
      child: BlocErrorListener<PosBloc, PosState>(
        child: PosMenuScreen(changeLanguage: changeLanguage),
        // : TabletPosLayout(changeLanguage: changeLanguage, managerName: ""),
      ),
    );
  }
}
