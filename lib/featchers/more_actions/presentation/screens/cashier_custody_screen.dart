import 'package:apex_restaurant/core/helpers/helper_methods.dart';
import 'package:apex_restaurant/core/themes/app_extra_theme.dart';
import 'package:apex_restaurant/featchers/more_actions/data/model/add_cash_transaction_request.dart';
import 'package:apex_restaurant/featchers/more_actions/presentation/widgets/custody_log_tablet_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/helpers/extensions.dart';
import '../../../../core/helpers/size_helper.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/shared/widgets/custom_app_bar.dart';
import '../../../../core/themes/app_colors.dart';
import '../../../../generated/l10n.dart';
import '../bloc/more_actions_bloc.dart';
import '../bloc/more_actions_event.dart';
import '../bloc/more_actions_state.dart';
import 'responsibility_shared_widgets.dart';

class CashierCustodyScreen extends StatefulWidget {
  final int employeeId;

  const CashierCustodyScreen({super.key, required this.employeeId});

  @override
  State<CashierCustodyScreen> createState() => _CashierCustodyScreenState();
}

class _CashierCustodyScreenState extends State<CashierCustodyScreen> {
  int _selectedTypeIndex = 0; // 0: Add Custody, 1: Withdraw Custody
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _onConfirm() {
    final amountText = _amountController.text.trim();
    final notesText = _notesController.text.trim();

    if (amountText.isEmpty || double.tryParse(amountText) == null) {
      HelperMethods.showSnackBar(
        context: context,
        message: S.of(context).invalidAmount,
        isError: true,
      );
      return;
    }

    final amount = double.parse(amountText);
    final isAdd = _selectedTypeIndex == 0;

    context.read<MoreActionsBloc>().add(
      AddCashTransactionForSessionEvent(
        cashTransaction: AddCashTransactionRequest(
          employeesId: widget.employeeId,
          cashAmount: amount,
          notes: notesText,
          signal: isAdd ? -1 : 1, // -1 for Add, 1 for Withdraw
        ),
      ),
    );
  }

  void _openFullLog() {
    if (SizeHelper.isMobile) {
      context.pushNamed(Routes.custodyLogScreen, extra: widget.employeeId);
    } else {
      context.read<MoreActionsBloc>().add(
        const ChangeActiveTabEvent(activeTab: ResponsibilityTab.log),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final lang = S.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    return BlocBuilder<MoreActionsBloc, MoreActionsState>(
      builder: (context, state) {
        return !SizeHelper.isMobile
            ? _buildWideLayout(context, state)
            : Scaffold(
                backgroundColor: colorScheme.surface,
                appBar: CustomAppBar(
                  title: lang.cashierCustody,
                  showBackButton: true,
                  onBackPressed: () => Navigator.of(context).pop(),
                ),
                body: _buildMobileLayout(context),
              );
      },
    );
  }

  // ---------------------------------------------------------------------
  // Mobile Layout
  // ---------------------------------------------------------------------
  Widget _buildMobileLayout(BuildContext context) {
    final spacing = context.spacing;
    final lang = S.of(context);
    return SingleChildScrollView(
      padding: EdgeInsets.all(spacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _RecentTransactionsCard(onViewFullLog: _openFullLog),
          SizedBox(height: spacing.lg),
          _CustodyTypeToggle(
            selectedIndex: _selectedTypeIndex,
            onChanged: (i) => setState(() => _selectedTypeIndex = i),
          ),
          SizedBox(height: spacing.lg),
          _buildFormFields(context),
          SizedBox(height: spacing.lg),
          BlocConsumer<MoreActionsBloc, MoreActionsState>(
            listener: (context, state) {
              if (state.status == MoreActionsStatus.failure) {
                HelperMethods.showSnackBar(
                  context: context,
                  message: state.errorMessage ?? 'Unknown error',
                  isError: true,
                );
              }

              if (state.status == MoreActionsStatus.success) {
                _amountController.clear();
                _notesController.clear();

                HelperMethods.showSnackBar(
                  context: context,
                  message: lang.transactionAddedSuccessfully,
                  isError: false,
                );
              }
            },
            builder: (context, state) {
              if (state.status == MoreActionsStatus.loading) {
                return Center(
                  child: CircularProgressIndicator(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                );
              }

              return _ActionButtons(
                onConfirm: _onConfirm,
                onCancel: () => Navigator.of(context).pop(),
              );
            },
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------
  // Tablet/Wide Layout
  // ---------------------------------------------------------------------
  Widget _buildWideLayout(BuildContext context, MoreActionsState state) {
    final spacing = context.spacing;
    final activeTab = state.activeTab ?? ResponsibilityTab.custody;

    return Padding(
      padding: EdgeInsets.all(spacing.lg),
      child: Column(
        children: [
          if (activeTab == ResponsibilityTab.custody) ...[
            ResponsibilityPageTabs(
              active: activeTab,
              onTabChanged: (tab) {
                context.read<MoreActionsBloc>().add(
                  ChangeActiveTabEvent(activeTab: tab),
                );
              },
            ),
            SizedBox(height: spacing.lg),
            Expanded(
              child: SingleChildScrollView(
                child: _buildCashierCustodyFormTablet(context),
              ),
            ),
          ] else ...[
            Expanded(
              child: CustodyLogTabletView(employeeId: widget.employeeId),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCashierCustodyFormTablet(BuildContext context) {
    final spacing = context.spacing;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _CustodyTypeToggle(
                selectedIndex: _selectedTypeIndex,
                onChanged: (i) => setState(() => _selectedTypeIndex = i),
              ),
              SizedBox(height: spacing.lg),
              _buildFormFields(context),
              SizedBox(height: spacing.lg),
              _ActionButtons(
                onConfirm: _onConfirm,
                onCancel: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        ),
        SizedBox(width: spacing.lg),
        Expanded(
          flex: 2,
          child: _RecentTransactionsCard(onViewFullLog: _openFullLog),
        ),
      ],
    );
  }

  Widget _buildFormFields(BuildContext context) {
    final lang = S.of(context);
    final spacing = context.spacing;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SectionTitle(lang.amount),
        SizedBox(height: spacing.xs),
        _AmountField(controller: _amountController),
        SizedBox(height: spacing.md),
        _SectionTitle(lang.additionalNotes),
        SizedBox(height: spacing.xs),
        _NotesField(controller: _notesController),
      ],
    );
  }
}

// ===========================================================================
// Tablet Custody Log Table Component (Matches screenshot layout & themes)
// ===========================================================================

class _CustodyLogTableTablet extends StatelessWidget {
  const _CustodyLogTableTablet();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final extraTheme = theme.extension<AppExtraTheme>();
    final spacing = context.spacing;

    return Column(
      children: [
        // Top Bar: Export CSV, Print, and Filter Chips
        Row(
          children: [
            ElevatedButton.icon(
              onPressed: () {},
              icon: Icon(Icons.download, size: context.iconSizes.sm),
              label: const Text('تصدير CSV'),
              style: ElevatedButton.styleFrom(
                backgroundColor: extraTheme?.greenBackground ?? AppColors.green,
                foregroundColor: AppColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(spacing.radiusSm),
                ),
              ),
            ),
            SizedBox(width: spacing.sm),
            OutlinedButton.icon(
              onPressed: () {},
              icon: Icon(Icons.print, size: context.iconSizes.sm),
              label: const Text('طباعة'),
              style: OutlinedButton.styleFrom(
                foregroundColor: colorScheme.primary,
                side: BorderSide(color: colorScheme.primary),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(spacing.radiusSm),
                ),
              ),
            ),
            const Spacer(),
            // Segmented Filter Chips (الكل, إضافات, سحوبات)
            Container(
              padding: EdgeInsets.all(spacing.xxs),
              decoration: BoxDecoration(
                color: colorScheme.onSurface.withOpacity(0.05),
                borderRadius: BorderRadius.circular(spacing.radiusPill),
              ),
              child: Row(
                children: [
                  _FilterChip(title: 'الكل', isSelected: true, onTap: () {}),
                  _FilterChip(title: 'إضافات', isSelected: false, onTap: () {}),
                  _FilterChip(title: 'سحوبات', isSelected: false, onTap: () {}),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: spacing.md),

        // Transactions Table Container
        Container(
          decoration: BoxDecoration(
            color: colorScheme.onSurface,
            borderRadius: BorderRadius.circular(spacing.radiusMd),
            border: Border.all(color: colorScheme.outlineVariant),
          ),
          child: Column(
            children: [
              // Table Header
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: spacing.md,
                  vertical: spacing.sm,
                ),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: colorScheme.outlineVariant),
                  ),
                ),
                child: Row(
                  children: const [
                    Expanded(flex: 2, child: _TableHeaderCell('التاريخ')),
                    Expanded(
                      flex: 1,
                      child: _TableHeaderCell('النوع', align: TextAlign.center),
                    ),
                    Expanded(
                      flex: 1,
                      child: _TableHeaderCell(
                        'المبلغ',
                        align: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: _TableHeaderCell('السبب', align: TextAlign.center),
                    ),
                    Expanded(
                      flex: 2,
                      child: _TableHeaderCell(
                        'ملاحظات',
                        align: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: _TableHeaderCell(
                        'المرفق',
                        align: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: _TableHeaderCell(
                        'المستخدم',
                        align: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),

              // Mocked Table Rows matching the image
              const _TableDataRow(
                date: '14:30 2026-06-23',
                typeLabel: 'إضافة',
                isAdd: true,
                amount: '1000.00',
                reason: 'عهدة افتتاحية',
                notes: 'بداية الوردية الصباحية',
                attachment: '--',
                user: 'أحمد علي',
              ),
              const _TableDataRow(
                date: '21:44 2026-06-22',
                typeLabel: 'سحب',
                isAdd: false,
                amount: '120.00',
                reason: 'مصروفات نثرية',
                notes: 'شراء أكياس تغليف',
                attachment: 'receipt-120.jpg',
                user: 'أحمد علي',
              ),
              const _TableDataRow(
                date: '10:56 2026-06-21',
                typeLabel: 'إضافة',
                isAdd: true,
                amount: '500.00',
                reason: 'تحويل من الإدارة',
                notes: 'دعم سيولة',
                attachment: '--',
                user: 'سارة محمد',
              ),
              const _TableDataRow(
                date: '09:11 2026-06-21',
                typeLabel: 'سحب',
                isAdd: false,
                amount: '75.00',
                reason: 'دفع مورد',
                notes: 'ثلج',
                attachment: 'ice-invoice.jpg',
                user: 'أحمد علي',
                isLast: true,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TableHeaderCell extends StatelessWidget {
  final String title;
  final TextAlign align;

  const _TableHeaderCell(this.title, {this.align = TextAlign.start});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      textAlign: align,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.onSecondary,
      ),
    );
  }
}

class _TableDataRow extends StatelessWidget {
  final String date;
  final String typeLabel;
  final bool isAdd;
  final String amount;
  final String reason;
  final String notes;
  final String attachment;
  final String user;
  final bool isLast;

  const _TableDataRow({
    required this.date,
    required this.typeLabel,
    required this.isAdd,
    required this.amount,
    required this.reason,
    required this.notes,
    required this.attachment,
    required this.user,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final extraTheme = theme.extension<AppExtraTheme>();
    final spacing = context.spacing;

    final badgeColor = isAdd
        ? (extraTheme?.greenBackground ?? AppColors.green)
        : colorScheme.error;
    final badgeBg = isAdd
        ? AppColors.successLightTranslucent
        : colorScheme.error.withOpacity(0.12);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: spacing.md,
        vertical: spacing.sm,
      ),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : Border(bottom: BorderSide(color: colorScheme.outlineVariant)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(date, style: theme.textTheme.bodySmall),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: spacing.xs,
                  vertical: spacing.xxs,
                ),
                decoration: BoxDecoration(
                  color: badgeBg,
                  borderRadius: BorderRadius.circular(spacing.radiusSm),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isAdd ? Icons.north_west : Icons.south_east,
                      size: context.iconSizes.xs,
                      color: badgeColor,
                    ),
                    SizedBox(width: spacing.xxs),
                    Text(
                      typeLabel,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: badgeColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              amount,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: badgeColor,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              reason,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              notes,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall,
            ),
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: attachment == '--'
                  ? Text('--', style: theme.textTheme.bodySmall)
                  : InkWell(
                      onTap: () {},
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.attach_file,
                            size: context.iconSizes.xs,
                            color: colorScheme.primary,
                          ),
                          SizedBox(width: spacing.xxs),
                          Flexible(
                            child: Text(
                              attachment,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colorScheme.primary,
                                textBaseline: TextBaseline.alphabetic,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              user,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final spacing = context.spacing;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: spacing.md,
          vertical: spacing.xs,
        ),
        decoration: BoxDecoration(
          color: isSelected ? colorScheme.onSurface : Colors.transparent,
          borderRadius: BorderRadius.circular(spacing.radiusPill),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? colorScheme.surface : colorScheme.onSecondary,
          ),
        ),
      ),
    );
  }
}

// ===========================================================================
// Shared building blocks — used by both the mobile and wide layouts.
// ===========================================================================

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(
        context,
      ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
    );
  }
}

class _CustodyTypeToggle extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  const _CustodyTypeToggle({
    required this.selectedIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final lang = S.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final spacing = context.spacing;

    return Container(
      padding: EdgeInsets.all(spacing.xs),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(spacing.radiusMd),
      ),
      child: Row(
        children: [
          Expanded(
            child: _SegmentTab(
              title: lang.addCustody,
              icon: Icons.add_circle_outline,
              isSelected: selectedIndex == 0,
              onTap: () => onChanged(0),
            ),
          ),
          SizedBox(width: spacing.xs),
          Expanded(
            child: _SegmentTab(
              title: lang.withdrawCustody,
              icon: Icons.remove_circle_outline,
              isSelected: selectedIndex == 1,
              onTap: () => onChanged(1),
            ),
          ),
        ],
      ),
    );
  }
}

class _SegmentTab extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _SegmentTab({
    required this.title,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final spacing = context.spacing;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: spacing.sm),
        decoration: BoxDecoration(
          color: isSelected
              ? colorScheme.primary
              : colorScheme.onSurface.withOpacity(0.05),
          borderRadius: BorderRadius.circular(spacing.radiusSm),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: context.iconSizes.sm,
              color: isSelected ? AppColors.white : colorScheme.onSecondary,
            ),
            SizedBox(width: spacing.xs),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isSelected ? AppColors.white : colorScheme.onSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AmountField extends StatelessWidget {
  final TextEditingController controller;
  const _AmountField({required this.controller});

  @override
  Widget build(BuildContext context) {
    final lang = S.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final spacing = context.spacing;

    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        hintText: "0.00",
        prefixIcon: Container(
          margin: EdgeInsets.all(spacing.xs),
          padding: EdgeInsets.symmetric(
            horizontal: spacing.sm,
            vertical: spacing.xs,
          ),
          decoration: BoxDecoration(
            color: colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(spacing.radiusSm),
          ),
          child: Text(
            lang.currencySarShort,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
      ),
    );
  }
}

class _NotesField extends StatelessWidget {
  final TextEditingController controller;
  const _NotesField({required this.controller});

  @override
  Widget build(BuildContext context) {
    final lang = S.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return TextField(
      controller: controller,
      maxLines: 3,
      decoration: InputDecoration(
        hintText: lang.writeOperationDetailsHint,
        hintStyle: theme.textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSecondary,
        ),
      ),
    );
  }
}

class _ActionButtons extends StatelessWidget {
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const _ActionButtons({required this.onConfirm, required this.onCancel});

  @override
  Widget build(BuildContext context) {
    final lang = S.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final spacing = context.spacing;

    return Row(
      children: [
        Expanded(
          flex: 2,
          child: ElevatedButton.icon(
            onPressed: onConfirm,
            icon: Icon(Icons.check_circle_outline, color: AppColors.white),
            label: Text(
              lang.confirmTransaction,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.white,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.primary,
              padding: EdgeInsets.symmetric(vertical: spacing.md),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(spacing.radiusSm),
              ),
            ),
          ),
        ),
        SizedBox(width: spacing.md),
        Expanded(
          flex: 1,
          child: OutlinedButton(
            onPressed: onCancel,
            style: OutlinedButton.styleFrom(
              backgroundColor: AppColors.onSurface,
              foregroundColor: AppColors.white,
              padding: EdgeInsets.symmetric(vertical: spacing.md),
              side: BorderSide(color: colorScheme.outlineVariant),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(spacing.radiusSm),
              ),
            ),
            child: Text(
              lang.cancel,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _RecentTransactionsCard extends StatelessWidget {
  final VoidCallback onViewFullLog;
  const _RecentTransactionsCard({required this.onViewFullLog});

  @override
  Widget build(BuildContext context) {
    final lang = S.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final extra = theme.extension<AppExtraTheme>();
    final spacing = context.spacing;

    return Container(
      padding: EdgeInsets.all(spacing.md),
      decoration: BoxDecoration(
        color: colorScheme.onSurface,
        borderRadius: BorderRadius.circular(spacing.radiusMd),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            lang.recentTransactionsSummary,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSecondary,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: spacing.md),
          _TransactionTile(
            title: lang.addBalance,
            subtitle: lang.minutesAgo(15),
            amount: "+500",
            isPositive: true,
            accentColor: extra?.greenBackground ?? AppColors.success,
            accentBg: AppColors.successLightTranslucent,
            icon: Icons.check,
          ),
          Divider(height: spacing.lg, color: colorScheme.outlineVariant),
          _TransactionTile(
            title: lang.withdrawExpenses,
            subtitle: lang.hoursAgo(2),
            amount: "-120",
            isPositive: false,
            accentColor: colorScheme.error,
            accentBg: colorScheme.error.withOpacity(0.08),
            icon: Icons.north_east,
          ),
          SizedBox(height: spacing.md),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: onViewFullLog,
              style: TextButton.styleFrom(
                backgroundColor: colorScheme.primary.withOpacity(0.08),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(spacing.radiusSm),
                ),
              ),
              child: Text(
                lang.viewFullCustodyLog,
                style: TextStyle(
                  color: colorScheme.primary,
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

class _TransactionTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final String amount;
  final bool isPositive;
  final Color accentColor;
  final Color accentBg;
  final IconData icon;

  const _TransactionTile({
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.isPositive,
    required this.accentColor,
    required this.accentBg,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final spacing = context.spacing;

    return Row(
      children: [
        Text(
          amount,
          style: theme.textTheme.titleMedium?.copyWith(
            color: accentColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Spacer(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              title,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              subtitle,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSecondary,
              ),
            ),
          ],
        ),
        SizedBox(width: spacing.sm),
        Container(
          padding: EdgeInsets.all(spacing.xs),
          decoration: BoxDecoration(
            color: accentBg,
            borderRadius: BorderRadius.circular(spacing.radiusSm),
          ),
          child: Icon(icon, color: accentColor, size: context.iconSizes.sm),
        ),
      ],
    );
  }
}
