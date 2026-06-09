import 'package:apex_restaurant/core/theme/app_theme.dart';
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
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      backgroundColor: AppColors.white,
      title: Text(lang.selectBranch, style: AppFonts.titleMedium),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView.separated(
          shrinkWrap: true,
          itemCount: branches.length,
          separatorBuilder: (_, __) =>
              const Divider(height: 1, color: AppColors.divider),
          itemBuilder: (context, index) {
            final branch = branches[index];
            final isSelected = branch.branchId == currentBranch.branchId;
            return ListTile(
              title: Text(
                branch.arabicName,
                style: AppFonts.titleLarge
                    .colored(AppColors.textPrimary)
                    .semiBold(),
              ),
              trailing: isSelected
                  ? Icon(
                      Icons.check_circle_rounded,
                      color: AppColors.success,
                      size: AppSizes.iconLg,
                    )
                  : null,
              tileColor: isSelected ? AppColors.sidebarActive : null,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.md),
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
