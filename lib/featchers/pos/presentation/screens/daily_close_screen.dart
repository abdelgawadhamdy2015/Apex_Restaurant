import '../../../../core/helpers/extensions.dart';
import '../../../../core/themes/app_colors.dart';
import '../../../../generated/l10n.dart';
import 'package:flutter/material.dart';

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

    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(spacing.md),
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
                onChanged: (val) =>
                    setState(() => _approveDeficitVoucher = val),
                title: Text(
                  lang.approveDeficitVoucher,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSecondary,
                  ),
                ),
                activeColor: AppColors.green,
                contentPadding: EdgeInsets.zero,
              ),
              SizedBox(height: spacing.lg),
              ElevatedButton.icon(
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
              ),
              SizedBox(height: spacing.sm),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
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
                    ),
                  ),
                  SizedBox(width: spacing.sm),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: theme.colorScheme.onSecondary,
                        side: BorderSide(color: theme.colorScheme.outline),
                        padding: EdgeInsets.symmetric(vertical: spacing.md),
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            color: context.appExtraTheme.cancelPorder,
                          ),
                          borderRadius: BorderRadius.circular(spacing.radiusMd),
                        ),
                      ),
                      child: Text(lang.cancel),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MetricsSummaryCard extends StatelessWidget {
  const _MetricsSummaryCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;
    final lang = S.of(context);

    return Container(
      padding: EdgeInsets.all(spacing.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant.withOpacity(0.2),
        borderRadius: BorderRadius.circular(spacing.radiusMd),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Column(
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
      ),
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
