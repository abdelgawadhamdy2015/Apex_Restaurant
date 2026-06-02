import 'package:apex_restaurant/core/theme/app_theme.dart';
import 'package:apex_restaurant/core/theme/text_styles.dart';
import 'package:apex_restaurant/featchers/home/data/models/employee_branch.dart';
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
    return AlertDialog(
      title: const Text('اختر الفرع'),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: branches.length,
          itemBuilder: (context, index) {
            final branch = branches[index];
            return ListTile(
              title: Text(
                branch.arabicName,
                style: TextStyles.blackBoldStyle(
                  fontSize: AppTheme.theme.textTheme.bodyMedium!.fontSize!,
                ),
              ),
              trailing: branch.branchId == currentBranch.branchId
                  ? const Icon(Icons.check, color: Colors.green)
                  : null,
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
