import 'package:apex_restaurant/core/helpers/extensions.dart';
import 'package:apex_restaurant/core/router/routes.dart';
import 'package:apex_restaurant/featchers/cart/data/models/pos_client_model.dart';
import 'package:apex_restaurant/featchers/cart/data/models/waiter_model.dart';
import 'package:apex_restaurant/featchers/cart/presentation/bloc/cart_bloc.dart';
import 'package:apex_restaurant/featchers/cart/presentation/bloc/cart_event.dart';
import 'package:apex_restaurant/featchers/home/presentation/bloc/home_bloc.dart';
import 'package:apex_restaurant/featchers/home/presentation/bloc/home_state.dart';
import 'package:apex_restaurant/featchers/tables/data/models/tables_screen_arg.dart';
import 'package:apex_restaurant/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// Dine-in controls: waiter selection, the currently selected table
/// and a shortcut to open the table picker.
class DineInSelector extends StatelessWidget {
  const DineInSelector({
    super.key,
    required this.persons,
    required this.waiters,
  });

  final List<PosClientModel> persons;
  final List<WaiterModel> waiters;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;
    final icons = context.iconSizes;
    final lang = S.of(context);
    final selectedTable = context.select((CartBloc b) => b.state.selectedTable);

    return Container(
      padding: EdgeInsets.all(spacing.sm),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
        borderRadius: BorderRadius.circular(spacing.radiusLg),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Column(
        children: [
          DropdownButtonFormField<int>(
            decoration: InputDecoration(
              hintText: lang.selectWaiter,
              contentPadding: EdgeInsets.symmetric(
                horizontal: spacing.sm,
                vertical: spacing.xs,
              ),
            ),
            initialValue: context.read<CartBloc>().state.selectedWaiter?.id,
            items: waiters
                .map(
                  (waiter) => DropdownMenuItem<int>(
                    value: waiter.id,
                    child: Text(waiter.arabicName ?? ''),
                  ),
                )
                .toList(),
            onChanged: (waiterId) {
              final waiter = waiters.cast<WaiterModel?>().firstWhere(
                (waiter) => waiter?.id == waiterId,
                orElse: () => null,
              );

              context.read<CartBloc>().add(SelectWaiterEvent(waiter));
            },
          ),
          SizedBox(height: spacing.xs + spacing.xxs / 2),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                '${lang.selectedTable} : ',
                style: theme.textTheme.bodyLarge?.copyWith(),
              ),
              Text(
                selectedTable?.arabicName ?? '',
                style: theme.textTheme.bodyLarge?.copyWith(),
              ),
            ],
          ),
          BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) => OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                minimumSize: Size.fromHeight(icons.xl + spacing.md),
                side: BorderSide(color: theme.colorScheme.tertiary),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(spacing.radiusMd),
                ),
              ),
              onPressed: () => context.pushNamed(
                Routes.tableScreen,
                extra: TablesScreenArgs(
                  branchId: state.selectedEmployeeBranch?.branchId ?? 0,
                  personList: persons,
                  inCartScreen: true,
                ),
              ),
              icon: Icon(
                Icons.table_restaurant,
                color: theme.colorScheme.tertiary,
                size: icons.md,
              ),
              label: Text(
                lang.selectTable,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.tertiary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
