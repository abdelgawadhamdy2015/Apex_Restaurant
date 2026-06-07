import 'package:apex_restaurant/core/helpers/restaurant_constants.dart';
import 'package:apex_restaurant/core/theme/app_theme.dart';
import 'package:apex_restaurant/featchers/pos/data/enums/table_status.dart';
import 'package:apex_restaurant/featchers/pos/data/models/floor_model.dart';
import 'package:apex_restaurant/featchers/pos/data/models/table_model.dart';
import 'package:apex_restaurant/featchers/pos/presentation/bloc/pos_bloc.dart';
import 'package:apex_restaurant/featchers/pos/presentation/bloc/pos_event.dart';
import 'package:apex_restaurant/featchers/pos/presentation/bloc/pos_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class TableSelectionDialog extends StatefulWidget {
  const TableSelectionDialog({super.key});

  @override
  State<TableSelectionDialog> createState() => _TableSelectionDialogState();
}

class _TableSelectionDialogState extends State<TableSelectionDialog> {
  FloorModel? selectedFloor;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _getFloors());
  }

  void _getFloors() {
    context.read<PosBloc>().add(
      LoadFloorsEvent(branchId: RestaurantConstants.currentBranch?.branchId),
    );
    if (selectedFloor != null) {
      context.read<PosBloc>().add(
        LoadTablesEvent(floorID: selectedFloor!.id, forPOS: true),
      );
    }
  }

  void _selectFloor(FloorModel floor) {
    setState(() => selectedFloor = floor);
    context.read<PosBloc>().add(
      LoadTablesEvent(floorID: floor.id, forPOS: true),
    );
  }

  IconData _icon(TableStatus status) {
    switch (status) {
      case TableStatus.available:
        return Icons.table_restaurant;
      case TableStatus.occupied:
        return Icons.people;
      case TableStatus.maintenance:
        return Icons.build;
      case TableStatus.reserved:
        return Icons.event_seat;
    }
  }

  Color _tableColor(TableStatus status) {
    switch (status) {
      case TableStatus.available:
        return AppColors.successLight;
      case TableStatus.occupied:
        return AppColors.errorLight;
      case TableStatus.maintenance:
        return AppColors.background;
      case TableStatus.reserved:
        return AppColors.selectedColor;
    }
  }

  Color _tableIconColor(TableStatus status) {
    switch (status) {
      case TableStatus.available:
        return AppColors.success;
      case TableStatus.occupied:
        return AppColors.error;
      case TableStatus.maintenance:
        return AppColors.textMuted;
      case TableStatus.reserved:
        return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: SizedBox(
        width: AppSizes.wFraction(0.75),
        height: AppSizes.hFraction(0.75),
        child: Row(
          children: [
            _FloorSidebar(
              selectedFloor: selectedFloor,
              onFloorSelected: _selectFloor,
              onFloorInit: (floor) => setState(() => selectedFloor = floor),
            ),
            if (selectedFloor != null)
              _TablesGrid(
                iconBuilder: _icon,
                colorBuilder: _tableColor,
                iconColorBuilder: _tableIconColor,
              ),
          ],
        ),
      ),
    );
  }
}

class _FloorSidebar extends StatelessWidget {
  final FloorModel? selectedFloor;
  final ValueChanged<FloorModel> onFloorSelected;
  final ValueChanged<FloorModel> onFloorInit;

  const _FloorSidebar({
    required this.selectedFloor,
    required this.onFloorSelected,
    required this.onFloorInit,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PosBloc, PosState>(
      builder: (context, state) {
        if (selectedFloor == null && state.floors.isNotEmpty) {
          WidgetsBinding.instance.addPostFrameCallback(
            (_) => onFloorInit(state.floors.first),
          );
        }

        return Container(
          width: AppSizes.w100,
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(AppRadius.lg),
              bottomRight: Radius.circular(AppRadius.lg),
            ),
            border: Border(right: BorderSide(color: AppColors.border)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: AppPadding.allLg,
                child: Text('الطوابق', style: AppFonts.titleSmall),
              ),
              const Divider(height: 1),
              Expanded(
                child: ListView(
                  padding: AppPadding.verticalSm,
                  children: state.floors
                      .map(
                        (floor) => _FloorItem(
                          floor: floor,
                          isSelected: selectedFloor == floor,
                          onTap: () => onFloorSelected(floor),
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _FloorItem extends StatelessWidget {
  final FloorModel floor;
  final bool isSelected;
  final VoidCallback onTap;

  const _FloorItem({
    required this.floor,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: AppSizes.h64,
        margin: EdgeInsets.symmetric(
          horizontal: AppPadding.sm,
          vertical: AppPadding.xs,
        ),
        padding: EdgeInsets.symmetric(horizontal: AppPadding.md),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.sidebarActive : Colors.transparent,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: isSelected
              ? Border.all(color: AppColors.accent.withOpacity(0.3))
              : null,
        ),
        alignment: Alignment.center,
        child: Text(
          floor.arabicName ?? "",
          style: AppFonts.bodyMedium.copyWith(
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected ? AppColors.accent : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}

class _TablesGrid extends StatelessWidget {
  final IconData Function(TableStatus) iconBuilder;
  final Color Function(TableStatus) colorBuilder;
  final Color Function(TableStatus) iconColorBuilder;

  const _TablesGrid({
    required this.iconBuilder,
    required this.colorBuilder,
    required this.iconColorBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PosBloc, PosState>(
      builder: (context, state) {
        return Expanded(
          child: GridView.builder(
            padding: AppPadding.allMd,
            itemCount: state.tables.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: AppPadding.sm,
              mainAxisSpacing: AppPadding.sm,
            ),
            itemBuilder: (_, index) {
              final table = state.tables[index];
              return _TableCard(
                table: table,
                icon: iconBuilder(table.status!),
                bgColor: colorBuilder(table.status!),
                iconColor: iconColorBuilder(table.status!),
                onTap: () {
                  context.pop(context);
                  context.read<PosBloc>().add(SelectTableEvent(table: table));
                },
              );
            },
          ),
        );
      },
    );
  }
}

class _TableCard extends StatelessWidget {
  final TableModel table;
  final IconData icon;
  final Color bgColor;
  final Color iconColor;
  final VoidCallback onTap;

  const _TableCard({
    required this.table,
    required this.icon,
    required this.bgColor,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(AppRadius.sm),
          border: Border.all(color: AppColors.border),
        ),
        child: FittedBox(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: AppSizes.w32, color: iconColor),
              AppSizes.gapH8,
              Text(
                table.arabicName ?? "",
                style: AppFonts.titleMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
