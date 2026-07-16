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

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: theme.colorScheme.surface,
      title: Text(lang.selectBranch, style: theme.textTheme.titleMedium),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView.separated(
          shrinkWrap: true,
          itemCount: branches.length,
          separatorBuilder: (_, __) =>
              Divider(height: 1, color: theme.dividerColor),
          itemBuilder: (context, index) {
            final branch = branches[index];
            final isSelected = branch.branchId == currentBranch.branchId;
            return ListTile(
              title: Text(
                branch.arabicName,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
              trailing: isSelected
                  ? Icon(
                      Icons.check_circle_rounded,
                      // TODO: swap for a themed "success" color/role if one
                      // gets added to the app's ColorScheme/theme extensions.
                      color: Colors.green,
                      size: 24,
                    )
                  : null,
              tileColor: isSelected
                  ? theme.colorScheme.primary.withValues(alpha: .08)
                  : null,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              onTap: () {
                onBranchSelected(branch);
                Navigator.of(context).pop();
              },
            );
          },
        ),
      ),
    );
  }
}
