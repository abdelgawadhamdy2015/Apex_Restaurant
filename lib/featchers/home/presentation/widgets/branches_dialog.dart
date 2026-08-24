// ignore_for_file: deprecated_member_use

import 'package:apex_restaurant/core/helpers/extensions.dart';
import 'package:apex_restaurant/featchers/home/data/models/employee_branch.dart';
import 'package:apex_restaurant/generated/l10n.dart';
import 'package:flutter/material.dart';

class BranchesDialog extends StatelessWidget {
  final List<EmployeeBranch> branches;
  final EmployeeBranch currentBranch;
  final Function(EmployeeBranch) onBranchSelected;

  const BranchesDialog({
    super.key,
    required this.branches,
    required this.currentBranch,
    required this.onBranchSelected,
  });

  @override
  Widget build(BuildContext context) {
    final lang = S.of(context);
    final theme = Theme.of(context);
    final spacing = context.spacing;
    final iconSizes = context.iconSizes;

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(spacing.radiusLg),
      ),
      // Was AppColors.surface — now the theme surface, so this dialog
      // gets the dark card color in dark mode like every other surface.
      backgroundColor: theme.colorScheme.surface,
      title: Text(lang.selectBranch, style: theme.textTheme.titleMedium),
      contentPadding: EdgeInsets.symmetric(vertical: spacing.sm),
      content: SizedBox(
        width: MediaQuery.sizeOf(context).width * 0.8,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400, maxHeight: 350),
          child: ListView.separated(
            shrinkWrap: true,
            itemCount: branches.length,
            separatorBuilder: (_, __) => Divider(
              height: 1,
              // Was AppColors.border.
              color: theme.colorScheme.outlineVariant,
            ),
            itemBuilder: (context, index) {
              final branch = branches[index];
              final isSelected = branch.branchId == currentBranch.branchId;
              return ListTile(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: spacing.lg,
                  vertical: spacing.xs / 2,
                ),
                title: Text(
                  branch.arabicName,
                  style: theme.textTheme.titleMedium?.copyWith(
                    // Was AppColors.textPrimary.
                    color: theme.colorScheme.onSurface,
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
                trailing: isSelected
                    ? Icon(
                        Icons.check_circle_rounded,
                        color: theme.colorScheme.primary,
                        size: iconSizes.md,
                      )
                    : null,
                tileColor: isSelected
                    ? theme.colorScheme.primary.withOpacity(0.08)
                    : null,
                onTap: () {
                  onBranchSelected(branch);
                  Navigator.of(context).pop();
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
