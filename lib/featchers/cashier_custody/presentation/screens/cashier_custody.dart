import 'package:apex_restaurant/core/helpers/extensions.dart';
import 'package:apex_restaurant/core/router/routes.dart';
import 'package:apex_restaurant/core/shared/widgets/custom_app_bar.dart';
import 'package:apex_restaurant/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CashierCustodyScreen extends StatefulWidget {
  const CashierCustodyScreen({super.key});

  @override
  State<CashierCustodyScreen> createState() => _CashierCustodyScreenState();
}

class _CashierCustodyScreenState extends State<CashierCustodyScreen> {
  int _selectedTypeIndex = 0; // 0: Add Custody, 1: Withdraw Custody
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  String? _selectedReason;

  @override
  void dispose() {
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lang = S.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final spacing = context.spacing;

    return Scaffold(
      backgroundColor: colorScheme.outlineVariant,
      appBar: CustomAppBar(
        title: lang.cashierCustody,
        showBackButton: true,
        onBackPressed: () => Navigator.of(context).pop(),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(spacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Recent Transactions Card
            const _RecentTransactionsCard(),
            SizedBox(height: spacing.lg),

            // 2. Tab Segment Switcher
            _buildTypeSegmentedControl(context),
            SizedBox(height: spacing.lg),

            // 3. Amount Input
            _buildSectionTitle(context, lang.amount),
            SizedBox(height: spacing.xs),
            TextField(
              controller: _amountController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              textAlign: TextAlign.start,
              decoration: InputDecoration(
                hintText: "0.00",
                filled: true,
                fillColor: colorScheme.surface,
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
                    lang.currencySar,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                prefixIconConstraints: const BoxConstraints(
                  minWidth: 0,
                  minHeight: 0,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(spacing.radiusSm),
                  borderSide: BorderSide(color: colorScheme.outlineVariant),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(spacing.radiusSm),
                  borderSide: BorderSide(color: colorScheme.outlineVariant),
                ),
              ),
            ),
            SizedBox(height: spacing.md),

            // 4. Operation Reason Dropdown
            _buildSectionTitle(context, lang.operationReason),
            SizedBox(height: spacing.xs),
            DropdownButtonFormField<String>(
              value: _selectedReason,
              hint: Text(
                lang.selectReason,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              decoration: InputDecoration(
                filled: true,
                fillColor: colorScheme.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(spacing.radiusSm),
                  borderSide: BorderSide(color: colorScheme.outlineVariant),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(spacing.radiusSm),
                  borderSide: BorderSide(color: colorScheme.outlineVariant),
                ),
              ),
              items: [
                DropdownMenuItem(value: "1", child: Text(lang.openingCustody)),
                DropdownMenuItem(
                  value: "2",
                  child: Text(lang.expenseReimbursement),
                ),
                DropdownMenuItem(value: "3", child: Text(lang.other)),
              ],
              onChanged: (val) => setState(() => _selectedReason = val),
            ),
            SizedBox(height: spacing.md),

            // 5. Additional Notes
            _buildSectionTitle(context, lang.additionalNotes),
            SizedBox(height: spacing.xs),
            TextField(
              controller: _notesController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: lang.writeOperationDetailsHint,
                hintStyle: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                filled: true,
                fillColor: colorScheme.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(spacing.radiusSm),
                  borderSide: BorderSide(color: colorScheme.outlineVariant),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(spacing.radiusSm),
                  borderSide: BorderSide(color: colorScheme.outlineVariant),
                ),
              ),
            ),
            SizedBox(height: spacing.lg),

            // 6. Attachment Container
            const _FileUploadCard(),
            SizedBox(height: spacing.xl),

            // 7. Action Buttons
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.check_circle_outline),
                    label: Text(lang.confirmTransaction),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
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
                    onPressed: () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: spacing.md),
                      side: BorderSide(color: colorScheme.outlineVariant),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(spacing.radiusSm),
                      ),
                    ),
                    child: Text(
                      lang.cancel,
                      style: TextStyle(color: colorScheme.onSurfaceVariant),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(
        context,
      ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
    );
  }

  Widget _buildTypeSegmentedControl(BuildContext context) {
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
              isSelected: _selectedTypeIndex == 0,
              onTap: () => setState(() => _selectedTypeIndex = 0),
            ),
          ),
          Expanded(
            child: _SegmentTab(
              title: lang.withdrawCustody,
              icon: Icons.remove_circle_outline,
              isSelected: _selectedTypeIndex == 1,
              onTap: () => setState(() => _selectedTypeIndex = 1),
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
          color: isSelected ? colorScheme.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(spacing.radiusSm),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected
                  ? colorScheme.onPrimary
                  : colorScheme.onSurfaceVariant,
            ),
            SizedBox(width: spacing.xs),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isSelected
                    ? colorScheme.onPrimary
                    : colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RecentTransactionsCard extends StatelessWidget {
  const _RecentTransactionsCard();

  @override
  Widget build(BuildContext context) {
    final lang = S.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final spacing = context.spacing;

    return Container(
      padding: EdgeInsets.all(spacing.md),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(spacing.radiusMd),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            lang.recentTransactionsSummary,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: spacing.md),
          _buildTransactionRow(
            context,
            title: lang.addBalance,
            subtitle: lang.minutesAgo(15),
            amount: "+500",
            amountColor: Colors.green,
            icon: Icons.check,
            iconBg: Colors.green.shade50,
            iconColor: Colors.green,
          ),
          Divider(height: spacing.lg, color: colorScheme.outlineVariant),
          _buildTransactionRow(
            context,
            title: lang.withdrawExpenses,
            subtitle: lang.hoursAgo(2),
            amount: "-120",
            amountColor: Colors.red,
            icon: Icons.north_east,
            iconBg: Colors.red.shade50,
            iconColor: Colors.red,
          ),
          SizedBox(height: spacing.md),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () {
                context.pushNamed(Routes.custodyLogScreen);
              },
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

  Widget _buildTransactionRow(
    BuildContext context, {
    required String title,
    required String subtitle,
    required String amount,
    required Color amountColor,
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
  }) {
    final theme = Theme.of(context);
    final spacing = context.spacing;

    return Row(
      children: [
        Text(
          amount,
          style: theme.textTheme.titleMedium?.copyWith(
            color: amountColor,
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
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        SizedBox(width: spacing.sm),
        Container(
          padding: EdgeInsets.all(spacing.xs),
          decoration: BoxDecoration(
            color: iconBg,
            borderRadius: BorderRadius.circular(spacing.radiusSm),
          ),
          child: Icon(icon, color: iconColor, size: 20),
        ),
      ],
    );
  }
}

class _FileUploadCard extends StatelessWidget {
  const _FileUploadCard();

  @override
  Widget build(BuildContext context) {
    final lang = S.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final spacing = context.spacing;

    return Container(
      padding: EdgeInsets.all(spacing.md),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(spacing.radiusMd),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            lang.attachReceiptOrInvoice,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: spacing.sm),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(spacing.lg),
            decoration: BoxDecoration(
              border: Border.all(
                color: colorScheme.outlineVariant,
                style: BorderStyle.solid,
              ),
              borderRadius: BorderRadius.circular(spacing.radiusSm),
            ),
            child: Column(
              children: [
                CircleAvatar(
                  radius: spacing.radiusLg,
                  backgroundColor: colorScheme.primary.withOpacity(0.1),
                  child: Icon(
                    Icons.cloud_upload_outlined,
                    color: colorScheme.primary,
                    size: context.iconSizes.md,
                  ),
                ),
                SizedBox(height: spacing.xs),
                Text(
                  lang.clickToUploadFile,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: spacing.xxs),
                Text(
                  lang.maxFileSizeHint,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
