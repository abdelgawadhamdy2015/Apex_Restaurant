import 'package:apex_restaurant/core/helpers/size_helper.dart';
import 'package:apex_restaurant/core/themes/app_colors.dart';
import 'package:apex_restaurant/featchers/home/presentation/bloc/home_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/helpers/extensions.dart';
import '../../../../core/router/routes.dart';
import '../../../../generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Screens narrower than this render a single-page mobile layout.
/// Anything at or above it renders the two-pane / tabbed layout.
const double kResponsibilityWideBreakpoint = 800;

enum ResponsibilityTab { log, custody }

/// The page-level tab bar shown only on wide layouts, letting the user
/// jump between the transactions log and the add/withdraw form without
/// growing the navigation stack. On mobile there is no tab bar — moving
/// between the two screens happens through explicit buttons instead
/// (see the "view full log" button and the log screen's forward action).
class ResponsibilityPageTabs extends StatelessWidget {
  final ResponsibilityTab active;
  final ValueChanged<ResponsibilityTab>? onTabChanged;
  const ResponsibilityPageTabs({
    super.key,
    required this.active,
    this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    final lang = S.of(context);
    final spacing = context.spacing;

    return Row(
      children: [
        Expanded(
          child: _tab(
            context,
            label: lang.cashierCustody,
            selected: active == ResponsibilityTab.custody,
            onTap: () {
              if (active != ResponsibilityTab.custody && SizeHelper.isMobile) {
                context.pushReplacementNamed(
                  Routes.cashierCustodyScreen,
                  extra:
                      context
                          .read<HomeBloc>()
                          .state
                          .userDataModel
                          ?.employeesId ??
                      0,
                );
              } else {
                onTabChanged?.call(ResponsibilityTab.custody);
              }
            },
          ),
        ),
        SizedBox(width: spacing.sm),

        Expanded(
          child: _tab(
            context,
            label: lang.custodyLogTitle,
            selected: active == ResponsibilityTab.log,
            onTap: () {
              if (active != ResponsibilityTab.log) {
                if (SizeHelper.isMobile) {
                  context.pushReplacementNamed(Routes.custodyLogScreen);
                } else {
                  onTabChanged?.call(ResponsibilityTab.log);
                }
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _tab(
    BuildContext context, {
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final spacing = context.spacing;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: spacing.sm),
        decoration: BoxDecoration(
          color: selected
              ? colorScheme.primary
              : colorScheme.primary.withOpacity(0.08),
          borderRadius: BorderRadius.circular(spacing.radiusSm),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: selected ? AppColors.white : colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

enum CustodyFilter { all, additions, withdrawals }

/// The "سحوبات / إضافات / الكل" pill row. Shared between the mobile card
/// list and the tablet table so filtering logic and styling live once.
class ResponsibilityFilterChips extends StatelessWidget {
  final CustodyFilter selected;
  final ValueChanged<CustodyFilter> onChanged;

  const ResponsibilityFilterChips({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final lang = S.of(context);
    return Card(
      color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            child: _chip(
              context,
              label: lang.allFilter,
              value: CustodyFilter.all,
            ),
          ),
          Expanded(
            child: _chip(
              context,
              label: lang.withdrawalsFilter,
              value: CustodyFilter.withdrawals,
            ),
          ),
          Expanded(
            child: _chip(
              context,
              label: lang.additionsFilter,
              value: CustodyFilter.additions,
            ),
          ),
        ],
      ),
    );
  }

  Widget _chip(
    BuildContext context, {
    required String label,
    required CustodyFilter value,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final spacing = context.spacing;
    final isSelected = selected == value;

    return GestureDetector(
      onTap: () => onChanged(value),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: spacing.md,
          vertical: spacing.sm,
        ),
        decoration: BoxDecoration(
          color: isSelected ? colorScheme.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(spacing.radiusSm),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: isSelected ? AppColors.white : colorScheme.onSecondary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

/// list and the tablet table.
class CustodyTypeBadge extends StatelessWidget {
  final bool isAddition;
  const CustodyTypeBadge({super.key, required this.isAddition});

  @override
  Widget build(BuildContext context) {
    final lang = S.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final spacing = context.spacing;
    final color = isAddition ? AppColors.success : colorScheme.error;
    final bg = isAddition
        ? AppColors.successLightTranslucent
        : colorScheme.error.withOpacity(0.08);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: spacing.sm,
        vertical: spacing.xxs,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(spacing.radiusSm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isAddition ? Icons.arrow_upward : Icons.arrow_downward,
            size: 12,
            color: color,
          ),
          SizedBox(width: spacing.xxs),
          Text(
            isAddition ? lang.addCustody : lang.withdrawCustody,
            style: theme.textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
