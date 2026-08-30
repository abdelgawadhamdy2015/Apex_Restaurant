import 'package:apex_restaurant/core/helpers/size_helper.dart';
import 'package:apex_restaurant/core/shared/widgets/custom_app_bar.dart';

import '../../../../core/helpers/extensions.dart';
import '../../../../core/themes/app_colors.dart';
import '../../../../generated/l10n.dart';
import 'package:flutter/material.dart';

/// Breakpoint above which we switch to the two-panel tablet/desktop layout.
const double _kTabletBreakpoint = 700;

class DailyCloseScreen extends StatefulWidget {
  const DailyCloseScreen({super.key});

  @override
  State<DailyCloseScreen> createState() => _DailyCloseScreenState();
}

class _DailyCloseScreenState extends State<DailyCloseScreen> {
  bool _printWithApproval = true;
  bool _approveDeficitVoucher = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;
    final lang = S.of(context);
    final isTablet = SizeHelper.isTablet;
    return isTablet
        ? _buildTabletLayout(context, theme, spacing, lang)
        : _buildMobileLayout(context, theme, spacing, lang);
  }

  // ---------------------------------------------------------------------
  // MOBILE LAYOUT (unchanged single-column design)
  // ---------------------------------------------------------------------
  Widget _buildMobileLayout(
    BuildContext context,
    ThemeData theme,
    dynamic spacing,
    S lang,
  ) {
    return Scaffold(
      appBar: CustomAppBar(title: lang.closeCustody),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(spacing.md),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(spacing.radiusLg),
            border: Border.all(color: theme.colorScheme.outlineVariant),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Text(
                  lang.dailyClose,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onPrimary,
                  ),
                ),
              ),
              SizedBox(height: spacing.md),
              const _MetricsSummaryCard(),
              SizedBox(height: spacing.md),
              const _ExpectedCashCard(),
              SizedBox(height: spacing.md),
              _AmountInputField(
                label: lang.actualCashInDrawer,
                initialValue: '4,135.00',
                valueColor: theme.colorScheme.onPrimary,
                onChanged: (val) {},
              ),
              SizedBox(height: spacing.sm),
              _AmountInputField(
                label: lang.deficit,
                initialValue: '65.00',
                valueColor: theme.colorScheme.error,
                readOnly: true,
              ),
              SizedBox(height: spacing.md),
              _buildSwitches(theme, lang),
              SizedBox(height: spacing.lg),
              _buildApproveButton(theme, spacing, lang),
              SizedBox(height: spacing.sm),
              Row(
                children: [
                  Expanded(child: _buildPrintButton(theme, spacing, lang)),
                  SizedBox(width: spacing.sm),
                  Expanded(
                    child: _buildCancelButton(context, theme, spacing, lang),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------
  // TABLET / DESKTOP LAYOUT (two panels, matches reference design)
  // ---------------------------------------------------------------------
  Widget _buildTabletLayout(
    BuildContext context,
    ThemeData theme,
    dynamic spacing,
    S lang,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Align(
          alignment: AlignmentDirectional.center,
          child: Text(
            lang.dailyClose,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onPrimary,
            ),
          ),
        ),
        SizedBox(height: spacing.md),
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Left wide panel: expected cash, inputs, switches, actions.
              Expanded(
                child: _TabletPanel(
                  theme: theme,
                  spacing: spacing,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const _ExpectedCashCard(),
                      SizedBox(height: spacing.md),
                      _AmountInputField(
                        label: lang.actualCashInDrawer,
                        initialValue: '4,135.00',
                        valueColor: theme.colorScheme.onPrimary,
                        onChanged: (val) {},
                      ),
                      SizedBox(height: spacing.sm),
                      _AmountInputField(
                        label: lang.deficit,
                        initialValue: '65.00',
                        valueColor: theme.colorScheme.error,
                        readOnly: true,
                      ),
                      SizedBox(height: spacing.md),
                      _buildSwitches(theme, lang),
                      SizedBox(height: spacing.lg),
                      Row(
                        children: [
                          // "اعتماد" is the primary action, placed first so
                          // it lands at the reading-start side (right, RTL).
                          Expanded(
                            flex: 2,
                            child: _buildApproveButton(theme, spacing, lang),
                          ),
                          SizedBox(width: spacing.sm),
                          Expanded(
                            child: _buildPrintButton(theme, spacing, lang),
                          ),
                          SizedBox(width: spacing.sm),
                          Expanded(
                            child: _buildCancelButton(
                              context,
                              theme,
                              spacing,
                              lang,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              // Right narrow panel: metrics summary only.
              SizedBox(
                width: 320,
                child: _TabletPanel(
                  theme: theme,
                  spacing: spacing,
                  child: const _MetricsSummaryCard(bordered: false),
                ),
              ),
              SizedBox(width: spacing.md),
            ],
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------
  // Shared pieces (switches + buttons) reused by both layouts
  // ---------------------------------------------------------------------
  Widget _buildSwitches(ThemeData theme, S lang) {
    return Column(
      children: [
        SwitchListTile(
          value: _printWithApproval,
          onChanged: (val) => setState(() => _printWithApproval = val),
          title: Text(
            lang.printWithApproval,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSecondary,
            ),
          ),
          activeColor: AppColors.green,
          contentPadding: EdgeInsets.zero,
        ),
        SwitchListTile(
          value: _approveDeficitVoucher,
          onChanged: (val) => setState(() => _approveDeficitVoucher = val),
          title: Text(
            lang.approveDeficitVoucher,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSecondary,
            ),
          ),
          activeColor: AppColors.green,
          contentPadding: EdgeInsets.zero,
        ),
      ],
    );
  }

  Widget _buildApproveButton(ThemeData theme, dynamic spacing, S lang) {
    return ElevatedButton.icon(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        padding: EdgeInsets.symmetric(vertical: spacing.md),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(spacing.radiusMd),
        ),
      ),
      icon: const Icon(Icons.check_circle_outline),
      label: Text(
        lang.approve,
        style: theme.textTheme.titleMedium?.copyWith(
          color: theme.colorScheme.onPrimary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildPrintButton(ThemeData theme, dynamic spacing, S lang) {
    return OutlinedButton.icon(
      onPressed: () {},
      style: OutlinedButton.styleFrom(
        foregroundColor: theme.colorScheme.primary,
        side: BorderSide(color: theme.colorScheme.primary),
        padding: EdgeInsets.symmetric(vertical: spacing.md),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(spacing.radiusMd),
        ),
      ),
      icon: const Icon(Icons.print_outlined),
      label: Text(lang.printReceipt),
    );
  }

  Widget _buildCancelButton(
    BuildContext context,
    ThemeData theme,
    dynamic spacing,
    S lang,
  ) {
    return ElevatedButton(
      onPressed: () => Navigator.of(context).pop(),
      style: ElevatedButton.styleFrom(
        foregroundColor: theme.colorScheme.onSecondary,
        side: BorderSide(color: theme.colorScheme.outline),
        padding: EdgeInsets.symmetric(vertical: spacing.md),
        shape: RoundedRectangleBorder(
          side: BorderSide(color: context.appExtraTheme.cancelPorder),
          borderRadius: BorderRadius.circular(spacing.radiusMd),
        ),
      ),
      child: Text(lang.cancel),
    );
  }
}

/// Simple white, rounded, bordered panel used to build the two-column
/// tablet/desktop layout.
class _TabletPanel extends StatelessWidget {
  const _TabletPanel({
    required this.theme,
    required this.spacing,
    required this.child,
  });

  final ThemeData theme;
  final dynamic spacing;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(spacing.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(spacing.radiusLg),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: child,
    );
  }
}

class _MetricsSummaryCard extends StatelessWidget {
  /// When embedded inside a [_TabletPanel] the outer card chrome is not
  /// needed (the panel already provides it), so it can be turned off.
  const _MetricsSummaryCard({this.bordered = true});

  final bool bordered;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;
    final lang = S.of(context);

    final content = Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _MetricTile(
                title: lang.totalInvoices,
                amount: '13,270.00',
                icon: Icons.receipt_long_outlined,
                color: theme.colorScheme.primary,
              ),
            ),
            Container(
              height: 40,
              width: 1,
              color: theme.colorScheme.outlineVariant,
            ),
            Expanded(
              child: _MetricTile(
                title: lang.cardNetwork,
                amount: '8,750.00',
                icon: Icons.credit_card,
                color: theme.colorScheme.tertiary,
              ),
            ),
          ],
        ),
        Divider(color: theme.colorScheme.outlineVariant, height: spacing.lg),
        Row(
          children: [
            Expanded(
              child: _MetricTile(
                title: lang.cash,
                amount: '4,520.00',
                icon: Icons.payments_outlined,
                color: AppColors.green,
              ),
            ),
            Container(
              height: 40,
              width: 1,
              color: theme.colorScheme.outlineVariant,
            ),
            Expanded(
              child: _MetricTile(
                title: lang.returns,
                amount: '320.00',
                icon: Icons.assignment_return_outlined,
                color: AppColors.error,
              ),
            ),
          ],
        ),
      ],
    );

    if (!bordered) return content;

    return Container(
      padding: EdgeInsets.all(spacing.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant.withOpacity(0.2),
        borderRadius: BorderRadius.circular(spacing.radiusMd),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: content,
    );
  }
}

class _MetricTile extends StatelessWidget {
  final String title;
  final String amount;
  final IconData icon;
  final Color color;

  const _MetricTile({
    required this.title,
    required this.amount,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;
    final lang = S.of(context);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18, color: color),
            SizedBox(width: spacing.xs),
            Text(
              title,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        SizedBox(height: spacing.xs),
        Text(
          '$amount ${lang.currencySarShort}',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSecondary,
          ),
        ),
      ],
    );
  }
}

class _ExpectedCashCard extends StatelessWidget {
  const _ExpectedCashCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;
    final lang = S.of(context);

    return Container(
      padding: EdgeInsets.all(spacing.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withOpacity(0.2),
        borderRadius: BorderRadius.circular(spacing.radiusMd),
      ),
      child: Column(
        children: [
          Text(
            lang.expectedTotalCash,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onPrimary,
            ),
          ),
          SizedBox(height: spacing.xs),
          Text(
            '4,200.00 ${lang.currencySarShort}',
            style: theme.textTheme.headlineMedium?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _AmountInputField extends StatelessWidget {
  final String label;
  final String initialValue;
  final Color valueColor;
  final bool readOnly;
  final ValueChanged<String>? onChanged;

  const _AmountInputField({
    required this.label,
    required this.initialValue,
    required this.valueColor,
    this.readOnly = false,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;
    final lang = S.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSecondary,
          ),
        ),
        SizedBox(height: spacing.xs),
        TextFormField(
          initialValue: initialValue,
          readOnly: readOnly,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.start,
          style: theme.textTheme.titleLarge?.copyWith(
            color: valueColor,
            fontWeight: FontWeight.bold,
          ),
          decoration: InputDecoration(
            isDense: true,
            filled: true,
            fillColor: theme.colorScheme.surfaceVariant.withOpacity(0.3),
            suffixIcon: Padding(
              padding: EdgeInsets.all(spacing.sm),
              child: Text(
                lang.currencySarShort,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onPrimaryFixed,
                ),
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(spacing.radiusMd),
              borderSide: BorderSide(color: theme.colorScheme.outlineVariant),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(spacing.radiusMd),
              borderSide: BorderSide(color: theme.colorScheme.outlineVariant),
            ),
          ),
          onChanged: onChanged,
        ),
      ],
    );
  }
}
