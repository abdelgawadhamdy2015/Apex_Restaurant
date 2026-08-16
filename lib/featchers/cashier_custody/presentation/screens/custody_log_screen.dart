import '../../../../core/helpers/extensions.dart';
import '../../../../core/shared/widgets/custom_app_bar.dart';
import '../../../../generated/l10n.dart';
import 'package:flutter/material.dart';

class CustodyLogScreen extends StatefulWidget {
  const CustodyLogScreen({super.key});

  @override
  State<CustodyLogScreen> createState() => _CustodyLogScreenState();
}

class _CustodyLogScreenState extends State<CustodyLogScreen> {
  int _selectedFilterIndex = 0;

  @override
  Widget build(BuildContext context) {
    final lang = S.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final spacing = context.spacing;

    return Scaffold(
      backgroundColor: colorScheme.outlineVariant,
      appBar: CustomAppBar(
        title: lang.custodyLog,
        showBackButton: true,
        onBackPressed: () => Navigator.of(context).pop(),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(spacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Balance Summary Card
            const _BalanceSummaryCard(),
            SizedBox(height: spacing.md),

            // 2. Filter Tabs
            _buildFilterTabs(context),
            SizedBox(height: spacing.md),

            // 3. Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.download_rounded, size: 18),
                    label: Text(lang.exportCsv),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: colorScheme.surface,
                      padding: EdgeInsets.symmetric(vertical: spacing.sm),
                      side: BorderSide(color: colorScheme.outlineVariant),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(spacing.radiusSm),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: spacing.sm),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.print_outlined, size: 18),
                    label: Text(lang.print),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: colorScheme.surface,
                      padding: EdgeInsets.symmetric(vertical: spacing.sm),
                      side: BorderSide(color: colorScheme.outlineVariant),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(spacing.radiusSm),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: spacing.lg),

            // 4. Section Title
            Text(
              lang.transactionLog,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: spacing.sm),

            // 5. Transaction History List
            TransactionCard(
              title: lang.openingCustodyTitle,
              typeTag: lang.additionTag,
              dateTime: "2026-06-22 • 08:00 ص",
              description: "بداية الوردية الصباحية",
              userName: "أحمد علي",
              amount: "+1000.00 ${lang.currencySar}",
              isAddition: true,
            ),
            SizedBox(height: spacing.sm),
            TransactionCard(
              title: lang.pettyExpenses,
              typeTag: lang.withdrawalTag,
              dateTime: "2026-06-22 • 10:15 ص",
              description: "شراء أكياس تغليف",
              userName: "أحمد علي",
              amount: "-120.00 ${lang.currencySar}",
              isAddition: false,
              attachmentName: "receipt-120.jpg",
            ),
            SizedBox(height: spacing.sm),
            TransactionCard(
              title: lang.transferFromManagement,
              typeTag: lang.additionTag,
              dateTime: "2026-06-22 • 12:30 م",
              description: "دعم سيولة",
              userName: "سارة محمد",
              amount: "+500.00 ${lang.currencySar}",
              isAddition: true,
            ),
            SizedBox(height: spacing.sm),
            TransactionCard(
              title: lang.supplierPayment,
              typeTag: lang.withdrawalTag,
              dateTime: "2026-06-22 • 01:45 م",
              description: "ثلج",
              userName: "سارة محمد",
              amount: "-75.00 ${lang.currencySar}",
              isAddition: false,
              attachmentName: "ice-invoice.pdf",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterTabs(BuildContext context) {
    final lang = S.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final spacing = context.spacing;

    final filters = [lang.all, lang.additions, lang.withdrawals];

    return Container(
      padding: EdgeInsets.all(spacing.xs),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(spacing.radiusMd),
      ),
      child: Row(
        children: List.generate(
          filters.length,
          (index) => Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedFilterIndex = index),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: spacing.sm),
                decoration: BoxDecoration(
                  color: _selectedFilterIndex == index
                      ? colorScheme.primary
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(spacing.radiusSm),
                ),
                child: Center(
                  child: Text(
                    filters[index],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: _selectedFilterIndex == index
                          ? colorScheme.onPrimary
                          : colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BalanceSummaryCard extends StatelessWidget {
  const _BalanceSummaryCard();

  @override
  Widget build(BuildContext context) {
    final lang = S.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final spacing = context.spacing;

    return Container(
      padding: EdgeInsets.all(spacing.md),
      decoration: BoxDecoration(
        color: const Color(0xFFEEF4FF),
        borderRadius: BorderRadius.circular(spacing.radiusLg),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(spacing.sm),
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  borderRadius: BorderRadius.circular(spacing.radiusSm),
                ),
                child: Icon(
                  Icons.account_balance_wallet_outlined,
                  color: colorScheme.onPrimary,
                  size: 24,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    lang.currentAvailableBalance,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  SizedBox(height: spacing.xxs),
                  Text(
                    "1305.00 ${lang.currencySar}",
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Divider(height: spacing.lg, color: colorScheme.outlineVariant),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.remove_circle_outline,
                        color: Colors.red,
                        size: 16,
                      ),
                      SizedBox(width: spacing.xxs),
                      Text(
                        lang.totalWithdrawals,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: spacing.xxs),
                  Text(
                    "195.00 ${lang.currencySar}",
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Text(
                        lang.totalAdditions,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      SizedBox(width: spacing.xxs),
                      const Icon(
                        Icons.add_circle_outline,
                        color: Colors.green,
                        size: 16,
                      ),
                    ],
                  ),
                  SizedBox(height: spacing.xxs),
                  Text(
                    "1500.00 ${lang.currencySar}",
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class TransactionCard extends StatelessWidget {
  final String title;
  final String typeTag;
  final String dateTime;
  final String description;
  final String userName;
  final String amount;
  final bool isAddition;
  final String? attachmentName;

  const TransactionCard({
    super.key,
    required this.title,
    required this.typeTag,
    required this.dateTime,
    required this.description,
    required this.userName,
    required this.amount,
    required this.isAddition,
    this.attachmentName,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final spacing = context.spacing;

    final accentColor = isAddition ? Colors.green : Colors.red;
    final tagBgColor = isAddition ? Colors.green.shade50 : Colors.red.shade50;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(spacing.radiusSm),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(spacing.radiusSm),
        child: Container(
          decoration: BoxDecoration(
            border: Border(right: BorderSide(color: accentColor, width: 4)),
          ),
          padding: EdgeInsets.all(spacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    amount,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: accentColor,
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: spacing.xs,
                          vertical: spacing.xxs,
                        ),
                        decoration: BoxDecoration(
                          color: tagBgColor,
                          borderRadius: BorderRadius.circular(spacing.radiusSm),
                        ),
                        child: Text(
                          typeTag,
                          style: TextStyle(
                            color: accentColor,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(width: spacing.xs),
                      Text(
                        title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: spacing.xxs),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  dateTime,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              SizedBox(height: spacing.xs),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  description,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              SizedBox(height: spacing.sm),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (attachmentName != null)
                    InkWell(
                      onTap: () {},
                      child: Row(
                        children: [
                          Icon(
                            Icons.link,
                            size: 16,
                            color: colorScheme.primary,
                          ),
                          SizedBox(width: spacing.xxs),
                          Text(
                            attachmentName!,
                            style: TextStyle(
                              color: colorScheme.primary,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    const SizedBox.shrink(),
                  Row(
                    children: [
                      Text(
                        userName,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      SizedBox(width: spacing.xxs),
                      Icon(
                        Icons.person_outline,
                        size: 16,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ],
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
