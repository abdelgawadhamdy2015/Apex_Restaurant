import 'package:apex_restaurant/featchers/tables/presentation/widgets/reservations_tab_view.dart';
import 'package:apex_restaurant/featchers/tables/presentation/widgets/tables_tab_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/helpers/extensions.dart';
import '../../../../core/helpers/helper_methods.dart';
import '../../../../core/shared/widgets/custom_app_bar.dart';
import '../../../cart/data/models/pos_client_model.dart';
import '../../data/models/get_floor_request.dart';
import '../bloc/tables_bloc.dart';
import '../bloc/tables_event.dart';
import '../bloc/tables_state.dart';
import '../widgets/main_segmented_tab.dart';
import '../../../../generated/l10n.dart';

class TablesScreen extends StatefulWidget {
  const TablesScreen({
    super.key,
    required this.branchId,
    required this.personList,
    required this.inCartScreen,
  });
  final int branchId;
  final List<PosClientModel> personList;
  final bool inCartScreen;

  @override
  State<TablesScreen> createState() => _TablesScreenState();
}

class _TablesScreenState extends State<TablesScreen> {
  @override
  void initState() {
    super.initState();
    final bloc = context.read<TablesBloc>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      bloc.add(
        FetchFloorsEvent(
          GetFloorsRequest(
            branchId: widget.branchId,
            pageNumber: 1,
            pageSize: 100,
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;
    final l10n = S.of(context);

    return BlocConsumer<TablesBloc, TablesState>(
      listenWhen: (previous, current) =>
          previous.status != current.status ||
          previous.errorMessage != current.errorMessage,
      listener: (context, state) {
        if (state.status == TablesStatus.failure &&
            state.errorMessage != null &&
            state.errorMessage!.isNotEmpty) {
          HelperMethods.showSnackBar(
            context: context,
            message: state.errorMessage!,
            isError: true,
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: theme.colorScheme.surface,
          appBar: CustomAppBar(
            title: state.activeTab == 0 ? l10n.tables : l10n.reservations,
            onBackPressed: () => Navigator.of(context).maybePop(),
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(spacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                MainSegmentedTab(
                  activeTab: state.activeTab,
                  onTabChanged: (tab) =>
                      context.read<TablesBloc>().add(SwitchMainTabEvent(tab)),
                ),
                SizedBox(height: spacing.xxs),
                if (state.activeTab == 0)
                  TablesTabView(inCartScreen: widget.inCartScreen)
                else
                  ReservationsTabView(personList: widget.personList),
              ],
            ),
          ),
        );
      },
    );
  }
}
