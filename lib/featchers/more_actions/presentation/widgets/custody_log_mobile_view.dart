import 'package:apex_restaurant/core/helpers/restaurant_constants.dart';
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

class CustodyLogMobileView extends StatefulWidget {
  final int employeeId;

  const CustodyLogMobileView({super.key, required this.employeeId});

  @override
  State<CustodyLogMobileView> createState() => _CustodyLogMobileViewState();
}

class _CustodyLogMobileViewState extends State<CustodyLogMobileView> {
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

  @override
  Widget build(BuildContext context) {
    final lang = S.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final spacing = context.spacing;

    return BlocBuilder<MoreActionsBloc, MoreActionsState>(
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

        final res = state.transactionsResponse;
        final allItems = res?.items ?? [];
        final filteredList = _getFilteredItems(allItems);

        final totalAdditions =
            res?.totalAdds ??
            allItems
                .where((e) => (e.signal ?? 0) >= 0)
                .fold(0.0, (sum, e) => sum ?? 0 + (e.amount ?? 0.0));

        final totalWithdrawals =
            res?.totalRemoves ??
            allItems
                .where((e) => (e.signal ?? 0) < 0)
                .fold(0.0, (sum, e) => sum ?? 0 + (e.amount ?? 0.0));

        final currentBalance =
            res?.fund ?? (totalAdditions ?? 0 - (totalWithdrawals ?? 0.0));

        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(spacing.sm),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _BalanceSummaryCard(
                  balance: currentBalance,
                  totalAdditions: totalAdditions ?? 0.0,
                  totalWithdrawals: totalWithdrawals ?? 0.0,
                ),
                SizedBox(height: spacing.xxs),
                ResponsibilityFilterChips(
                  selected: _filter,
                  onChanged: (f) => setState(() => _filter = f),
                ),
                SizedBox(height: spacing.xxs),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _exportCsv,
                        icon: Icon(
                          Icons.download,
                          size: context.iconSizes.sm,
                          color: colorScheme.primary,
                        ),
                        label: Text(
                          lang.exportCsv,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colorScheme.onSurface,
                          side: BorderSide(
                            color: context.appExtraTheme.cancelPorder,
                          ),
                          padding: EdgeInsets.symmetric(
                            vertical: spacing.xxs,
                            horizontal: spacing.md,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              spacing.radiusSm,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: spacing.sm),

                    Expanded(
                      child: ElevatedButton.icon(
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
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colorScheme.onSurface,
                          side: BorderSide(
                            color: context.appExtraTheme.cancelPorder,
                          ),
                          padding: EdgeInsets.symmetric(
                            vertical: spacing.xxs,
                            horizontal: spacing.md,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              spacing.radiusSm,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: spacing.md),
                Text(
                  lang.viewFullCustodyLog,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: spacing.sm),
                if (filteredList.isEmpty)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: spacing.xl),
                    child: Center(
                      child: Text(
                        'لا توجد معاملات مسجلة',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSecondary,
                        ),
                      ),
                    ),
                  )
                else
                  Column(
                    children: filteredList
                        .map(
                          (item) => Padding(
                            padding: EdgeInsets.only(bottom: spacing.sm),
                            child: _TransactionEntryCard(item: item),
                          ),
                        )
                        .toList(),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _BalanceSummaryCard extends StatelessWidget {
  final double balance;
  final double totalAdditions;
  final double totalWithdrawals;

  const _BalanceSummaryCard({
    required this.balance,
    required this.totalAdditions,
    required this.totalWithdrawals,
  });

  @override
  Widget build(BuildContext context) {
    final lang = S.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final spacing = context.spacing;

    return Container(
      padding: EdgeInsets.all(spacing.md),
      decoration: BoxDecoration(
        color: colorScheme.primary.withOpacity(0.2),
        borderRadius: BorderRadius.circular(spacing.radiusMd),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  borderRadius: BorderRadius.circular(spacing.radiusSm),
                ),
                child: Icon(
                  Icons.credit_card,
                  color: AppColors.white,
                  size: context.iconSizes.sm,
                ),
              ),
              SizedBox(width: spacing.sm),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    lang.currentBalance,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSecondary,
                    ),
                  ),
                  Text(
                    "${balance.toStringAsFixed(2)} ${lang.currencySarShort}",
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const Spacer(),
            ],
          ),
          Divider(height: spacing.lg, color: colorScheme.outlineVariant),
          Row(
            children: [
              Expanded(
                child: _MiniStat(
                  icon: Icons.remove_circle_outline,
                  label: lang.totalWithdrawals,
                  value: totalWithdrawals,
                  color: colorScheme.error,
                ),
              ),
              Expanded(
                child: _MiniStat(
                  icon: Icons.add_circle_outline,
                  label: lang.totalAdditions,
                  value: totalAdditions,
                  color:
                      theme.extension<AppExtraTheme>()?.greenBackground ??
                      AppColors.success,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final IconData icon;
  final String label;
  final double value;
  final Color color;

  const _MiniStat({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final lang = S.of(context);
    final theme = Theme.of(context);
    final spacing = context.spacing;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: color),
            SizedBox(width: spacing.xxs),
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSecondary,
              ),
            ),
          ],
        ),
        Text(
          "${value.toStringAsFixed(2)} ${lang.currencySarShort}",
          style: theme.textTheme.titleMedium?.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class _TransactionEntryCard extends StatelessWidget {
  final TransactionItem item;
  const _TransactionEntryCard({required this.item});

  String _formatDate(DateTime? date) {
    if (date == null) return '--';
    return RestaurantConstants.dateTimeFormat.format(date);
    // String two(int n) => n.toString().padLeft(2, '0');
    // return "${two(date.hour)}:${two(date.minute)} ${date.year}-${two(date.month)}-${two(date.day)}";
  }

  @override
  Widget build(BuildContext context) {
    final lang = S.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final extra = theme.extension<AppExtraTheme>();
    final spacing = context.spacing;

    final isAddition = (item.signal ?? 0) == -1;
    final amount = item.amount ?? 0.0;
    final accent = isAddition
        ? (extra?.greenBackground ?? AppColors.success)
        : colorScheme.error;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.onSurface,
        borderRadius: BorderRadius.circular(spacing.radiusMd),
        border: Border(right: BorderSide(color: accent, width: 4)),
      ),
      padding: EdgeInsets.all(spacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              SizedBox(height: spacing.xs),
              Text(
                item.typeAr ?? item.typeEn ?? '--',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),

              CustodyTypeBadge(isAddition: isAddition),
              const Spacer(),

              Text(
                "${isAddition ? '+' : '-'}${amount.toStringAsFixed(2)} ${lang.currencySarShort}",
                style: theme.textTheme.titleMedium?.copyWith(
                  color: accent,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: spacing.sm),
            ],
          ),
          SizedBox(height: spacing.xs),
          Text(
            _formatDate(item.date),
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSecondary,
            ),
          ),

          if (item.notes != null && item.notes!.isNotEmpty) ...[
            SizedBox(height: spacing.xxs),
            Text(
              item.notes!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSecondary,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
          SizedBox(height: spacing.xs),
          Row(
            children: [
              Icon(
                Icons.person_outline,
                size: 14,
                color: colorScheme.onSecondary,
              ),
              SizedBox(width: spacing.xxs),
              Text(
                item.userAr ?? item.userEn ?? '--',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
