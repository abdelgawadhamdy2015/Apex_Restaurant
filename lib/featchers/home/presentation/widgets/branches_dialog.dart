// ignore_for_file: deprecated_member_use

import 'package:apex_restaurant/core/helpers/extensions.dart';
import 'package:apex_restaurant/core/themes/app_colors.dart';
import 'package:apex_restaurant/featchers/home/data/models/employee_branch.dart';
import 'package:apex_restaurant/featchers/home/presentation/bloc/home_bloc.dart';
import 'package:apex_restaurant/featchers/home/presentation/bloc/home_event.dart';
import 'package:apex_restaurant/featchers/home/presentation/bloc/home_state.dart';
import 'package:apex_restaurant/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class BranchesDialog extends StatefulWidget {
  final List<EmployeeBranch> branches;
  final EmployeeBranch currentBranch;

  const BranchesDialog({
    super.key,
    required this.branches,
    required this.currentBranch,
  });

  static Future<void> show({
    required BuildContext context,
    required List<EmployeeBranch> branches,
    required EmployeeBranch currentBranch,
  }) async {
    if (branches.isEmpty) {
      return;
    }

    await showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (_) =>
          BranchesDialog(branches: branches, currentBranch: currentBranch),
    );
  }

  @override
  State<BranchesDialog> createState() => _BranchesDialogState();
}

class _BranchesDialogState extends State<BranchesDialog> {
  late EmployeeBranch selectedBranch;
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    selectedBranch = widget.currentBranch;
  }

  void _saveSelection() {
    if (selectedBranch.branchId == widget.currentBranch.branchId) {
      Navigator.of(context).pop();
      return;
    }

    context.read<HomeBloc>().add(SelectBranchEvent(selectedBranch));
  }

  @override
  Widget build(BuildContext context) {
    final lang = S.of(context);
    final theme = Theme.of(context);
    final spacing = context.spacing;
    final iconSizes = context.iconSizes;

    return BlocListener<HomeBloc, HomeState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (!mounted) return;

        switch (state.status) {
          case HomeStatus.branchSelected:
            context.canPop() ? context.pop() : null;
            break;

          case HomeStatus.error:
            setState(() {
              isSaving = false;
            });
            break;

          default:
            break;
        }
      },
      child: AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(spacing.radiusLg),
        ),
        backgroundColor: theme.colorScheme.surface,
        title: Text(
          lang.selectBranch,
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: spacing.sm),
        content: SizedBox(
          width: MediaQuery.sizeOf(context).width * 0.8,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400, maxHeight: 350),
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: widget.branches.length,
              separatorBuilder: (_, __) =>
                  Divider(height: 1, color: theme.colorScheme.outlineVariant),
              itemBuilder: (context, index) {
                final branch = widget.branches[index];

                final isSelected = branch.branchId == selectedBranch.branchId;

                return Card(
                  margin: EdgeInsets.symmetric(
                    horizontal: spacing.xs,
                    vertical: spacing.xs / 2,
                  ),
                  color: isSelected
                      ? theme.colorScheme.primary.withOpacity(0.12)
                      : theme.colorScheme.surfaceContainerHighest,
                  child: RadioListTile<int>(
                    value: branch.branchId,
                    groupValue: selectedBranch.branchId,
                    activeColor: theme.colorScheme.primary,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: spacing.md,
                    ),
                    title: Text(
                      branch.arabicName,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                    subtitle: branch.latinName.isNotEmpty
                        ? Text(
                            branch.latinName,
                            style: theme.textTheme.bodySmall,
                          )
                        : null,
                    secondary: Icon(
                      isSelected
                          ? Icons.business_rounded
                          : Icons.business_outlined,
                      color: isSelected
                          ? theme.colorScheme.primary
                          : theme.colorScheme.onSurfaceVariant,
                      size: iconSizes.md,
                    ),
                    onChanged: isSaving
                        ? null
                        : (_) {
                            setState(() {
                              selectedBranch = branch;
                            });
                          },
                  ),
                );
              },
            ),
          ),
        ),
        actionsPadding: EdgeInsets.fromLTRB(
          spacing.md,
          0,
          spacing.md,
          spacing.md,
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: BlocBuilder<HomeBloc, HomeState>(
              buildWhen: (previous, current) =>
                  previous.status != current.status,
              builder: (context, state) {
                final saving = state.status == HomeStatus.branchUpdating;

                return FilledButton.icon(
                  onPressed: saving ? null : _saveSelection,
                  icon: saving
                      ? SizedBox(
                          width: iconSizes.sm,
                          height: iconSizes.sm,
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                      : const Icon(Icons.check_rounded, color: AppColors.white),
                  label: Text(
                    saving ? 'جاري الحفظ...' : lang.saveChanges,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: saving
                          ? theme.colorScheme.onPrimary
                          : AppColors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
