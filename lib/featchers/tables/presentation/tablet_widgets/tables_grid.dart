import 'package:apex_restaurant/core/helpers/size_helper.dart';

import '../../../../core/helpers/extensions.dart';
import '../../domain/entities/table_entity.dart';
import '../../../../generated/l10n.dart';
import 'package:flutter/material.dart';

import 'table_card.dart';

class TablesGrid extends StatelessWidget {
  const TablesGrid({
    super.key,
    required this.tables,
    required this.inCartScreen,
  });

  final List<TableEntity> tables;
  final bool inCartScreen;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;
    final l10n = S.of(context);

    if (tables.isEmpty) {
      return Padding(
        padding: EdgeInsets.all(spacing.lg),
        child: Center(
          child: Text(
            l10n.noTablesAvailable,
            style: theme.textTheme.bodyMedium,
          ),
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: tables.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: SizeHelper.isMobile ? 2 : 3,
        crossAxisSpacing: spacing.md,
        mainAxisSpacing: spacing.md,
        childAspectRatio: SizeHelper.isMobile ? 1.1 : 1.8,
      ),
      itemBuilder: (context, index) =>
          TableCard(table: tables[index], inCartScreen: inCartScreen),
    );
  }
}
