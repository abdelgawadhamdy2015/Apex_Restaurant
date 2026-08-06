import 'package:apex_restaurant/core/helpers/extensions.dart';
import 'package:apex_restaurant/featchers/tables/domain/entities/floor_entity.dart';
import 'package:flutter/material.dart';

class FloorSelector extends StatelessWidget {
  const FloorSelector({
    super.key,
    required this.floors,
    required this.selectedIndex,
    required this.onFloorSelected,
  });

  final List<FloorEntity> floors;
  final int selectedIndex;
  final ValueChanged<int> onFloorSelected;

  @override
  Widget build(BuildContext context) {
    if (floors.isEmpty) return const SizedBox.shrink();

    final spacing = context.spacing;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(floors.length, (index) {
          return Padding(
            padding: EdgeInsets.only(left: spacing.xs),
            child: _FloorChip(
              label: floors[index].arabicName,
              isSelected: selectedIndex == index,
              onSelected: () => onFloorSelected(index),
            ),
          );
        }),
      ),
    );
  }
}

class _FloorChip extends StatelessWidget {
  const _FloorChip({
    required this.label,
    required this.isSelected,
    required this.onSelected,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;

    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) onSelected();
      },
      selectedColor: theme.colorScheme.onSecondary,
      backgroundColor: theme.colorScheme.surface,
      labelStyle: theme.textTheme.bodySmall?.copyWith(
        color: isSelected
            ? theme.colorScheme.onPrimary
            : theme.colorScheme.onSecondary,
        fontWeight: FontWeight.bold,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(spacing.radiusLg),
      ),
      side: BorderSide.none,
    );
  }
}
