import 'package:apex_restaurant/featchers/more_actions/presentation/screens/responsibility_shared_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/helpers/extensions.dart';
import '../../../../core/themes/app_colors.dart';
import '../../../../core/themes/app_extra_theme.dart';
import '../../../../generated/l10n.dart';
import '../../data/model/transactions_response.dart';
import '../bloc/more_actions_bloc.dart';
import '../bloc/more_actions_event.dart';
import '../bloc/more_actions_state.dart';

class CustodyLogTabletView extends StatefulWidget {
  final int employeeId;

  const CustodyLogTabletView({super.key, required this.employeeId});

  @override
  State<CustodyLogTabletView> createState() => _CustodyLogTabletViewState();
}

class _CustodyLogTabletViewState extends State<CustodyLogTabletView> {
  CustodyFilter _filter = CustodyFilter.all;

  @override
  void initState() {
    super.initState();
    _fetchTransactions();
  }

  void _fetchTransactions() {
    context.read<MoreActionsBloc>().add(
      FetchCashTransactionForSessionEvent(employeeId: widget.employeeId),
    );
  }

  List<TransactionItem> _getFilteredItems(List<TransactionItem> items) {
    switch (_filter) {
      case CustodyFilter.additions:
        return items.where((e) => (e.signal ?? 0) >= 0).toList();
      case CustodyFilter.withdrawals:
        return items.where((e) => (e.signal ?? 0) < 0).toList();
      case CustodyFilter.all:
        return items;
    }
  }

  void _exportCsv() {
    // TODO: Connect CSV export service
  }

  void _print() {
    // TODO: Connect Print service
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '--';
    String two(int n) => n.toString().padLeft(2, '0');
    return "${two(date.hour)}:${two(date.minute)} ${date.year}-${two(date.month)}-${two(date.day)}";
  }

  @override
  Widget build(BuildContext context) {
    final lang = S.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final extraTheme = theme.extension<AppExtraTheme>();
    final spacing = context.spacing;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ResponsibilityPageTabs(
          active: ResponsibilityTab.log,
          onTabChanged: (tab) {
            context.read<MoreActionsBloc>().add(
              ChangeActiveTabEvent(activeTab: tab),
            );
          },
        ),
        SizedBox(height: spacing.lg),
        Row(
          children: [
            ElevatedButton.icon(
              onPressed: _exportCsv,
              icon: Icon(
                Icons.download,
                size: context.iconSizes.sm,
                color: AppColors.white,
              ),
              label: Text(
                lang.exportCsv,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    extraTheme?.greenBackground ?? AppColors.success,
                padding: EdgeInsets.symmetric(
                  vertical: spacing.sm,
                  horizontal: spacing.md,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(spacing.radiusSm),
                ),
              ),
            ),
            SizedBox(width: spacing.sm),
            OutlinedButton.icon(
              onPressed: _print,
              icon: Icon(
                Icons.print_outlined,
                size: context.iconSizes.sm,
                color: colorScheme.primary,
              ),
              label: Text(
                lang.print,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.primary,
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: colorScheme.primary),
                padding: EdgeInsets.symmetric(
                  vertical: spacing.sm,
                  horizontal: spacing.md,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(spacing.radiusSm),
                ),
              ),
            ),
            const Spacer(),
            ResponsibilityFilterChips(
              selected: _filter,
              onChanged: (f) => setState(() => _filter = f),
            ),
          ],
        ),
        SizedBox(height: spacing.lg),
        Expanded(
          child: BlocBuilder<MoreActionsBloc, MoreActionsState>(
            builder: (context, state) {
              if (state.status == MoreActionsStatus.loading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state.status == MoreActionsStatus.failure) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        state.errorMessage ?? 'حدث خطأ أثناء جلب البيانات',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.error,
                        ),
                      ),
                      SizedBox(height: spacing.md),
                      ElevatedButton(
                        onPressed: _fetchTransactions,
                        child: const Text('إعادة المحاولة'),
                      ),
                    ],
                  ),
                );
              }

              final allItems = state.transactionsResponse?.items ?? [];
              final filteredList = _getFilteredItems(allItems);

              if (filteredList.isEmpty) {
                return Center(
                  child: Text(
                    'لا توجد معاملات مسجلة',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSecondary,
                    ),
                  ),
                );
              }

              return Container(
                decoration: BoxDecoration(
                  color: colorScheme.onSurface,
                  borderRadius: BorderRadius.circular(spacing.radiusMd),
                  border: Border.all(color: colorScheme.outlineVariant),
                ),
                clipBehavior: Clip.antiAlias,
                child: SingleChildScrollView(
                  child: Table(
                    columnWidths: const {
                      0: FlexColumnWidth(1.3),
                      1: FlexColumnWidth(1.0),
                      2: FlexColumnWidth(1.0),
                      3: FlexColumnWidth(2.0),
                      4: FlexColumnWidth(1.2),
                    },
                    children: [
                      TableRow(
                        decoration: BoxDecoration(color: colorScheme.surface),
                        children: [
                          _buildHeaderCell(context, lang.date),
                          _buildHeaderCell(context, lang.type),
                          _buildHeaderCell(context, lang.amount),
                          _buildHeaderCell(context, lang.additionalNotes),
                          _buildHeaderCell(context, lang.user),
                        ],
                      ),
                      for (final entry in filteredList)
                        TableRow(
                          decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(
                                color: colorScheme.outlineVariant,
                              ),
                            ),
                          ),
                          children: [
                            _buildDataCell(context, _formatDate(entry.date)),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: spacing.sm,
                                horizontal: spacing.sm,
                              ),
                              child: CustodyTypeBadge(
                                isAddition: (entry.signal ?? 0) >= 0,
                              ),
                            ),
                            _buildDataCell(
                              context,
                              (entry.amount ?? 0.0).toStringAsFixed(2),
                              color: (entry.signal ?? 0) >= 0
                                  ? (extraTheme?.greenBackground ??
                                        AppColors.success)
                                  : colorScheme.error,
                              bold: true,
                            ),
                            _buildDataCell(context, entry.notes ?? '--'),
                            _buildDataCell(
                              context,
                              entry.userAr ?? entry.userEn ?? '--',
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHeaderCell(BuildContext context, String label) {
    final theme = Theme.of(context);
    final spacing = context.spacing;
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: spacing.sm,
        horizontal: spacing.sm,
      ),
      child: Text(
        label,
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSecondary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildDataCell(
    BuildContext context,
    String text, {
    Color? color,
    bool bold = false,
  }) {
    final theme = Theme.of(context);
    final spacing = context.spacing;
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: spacing.sm,
        horizontal: spacing.sm,
      ),
      child: Text(
        text,
        style: theme.textTheme.bodySmall?.copyWith(
          color: color ?? theme.colorScheme.onSecondary,
          fontWeight: bold ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}
