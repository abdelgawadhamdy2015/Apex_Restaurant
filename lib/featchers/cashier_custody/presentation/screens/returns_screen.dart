import '../../../../core/helpers/extensions.dart';
import '../../../../core/shared/widgets/custom_app_bar.dart';
import '../../../../generated/l10n.dart';
import 'package:flutter/material.dart';

class ReturnsScreen extends StatefulWidget {
  const ReturnsScreen({super.key});

  @override
  State<ReturnsScreen> createState() => _ReturnsScreenState();
}

class _ReturnsScreenState extends State<ReturnsScreen> {
  final TextEditingController _invoiceController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  int? _expandedIndex = 2;

  @override
  void dispose() {
    _invoiceController.dispose();
    _dateController.dispose();
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
        title: lang.returns,
        showBackButton: true,
        onBackPressed: () => Navigator.of(context).pop(),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(spacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Search Filter Card
            _buildSearchCard(context),
            SizedBox(height: spacing.md),

            // 2. Invoice Result Cards
            _InvoiceCard(
              invoiceNumber: "INV-2012",
              time: "09:30 ص",
              itemsCountText: lang.itemsCount(5),
              totalAmount: "240.50 ${lang.currencySar}",
              isExpanded: _expandedIndex == 0,
              onTap: () => setState(() {
                _expandedIndex = _expandedIndex == 0 ? null : 0;
              }),
            ),
            SizedBox(height: spacing.sm),

            _InvoiceCard(
              invoiceNumber: "INV-2030",
              time: "10:15 ص",
              itemsCountText: lang.itemCountSingle(1),
              totalAmount: "25.00 ${lang.currencySar}",
              isExpanded: _expandedIndex == 1,
              onTap: () => setState(() {
                _expandedIndex = _expandedIndex == 1 ? null : 1;
              }),
            ),
            SizedBox(height: spacing.sm),

            _InvoiceCard(
              invoiceNumber: "INV-2039",
              time: "11:45 ص",
              itemsCountText: lang.itemsCount(3),
              totalAmount: "132.00 ${lang.currencySar}",
              isExpanded: _expandedIndex == 2,
              onTap: () => setState(() {
                _expandedIndex = _expandedIndex == 2 ? null : 2;
              }),
              items: [
                _OrderSubItem(
                  name: "برجر لحم كلاسيك",
                  quantity: "1x",
                  price: "45.00 ${lang.currencySar}",
                ),
                _OrderSubItem(
                  name: "بطاطس مقلية (وسط)",
                  quantity: "2x",
                  price: "30.00 ${lang.currencySar}",
                ),
                _OrderSubItem(
                  name: "مشروب غازي",
                  quantity: "3x",
                  price: "57.00 ${lang.currencySar}",
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchCard(BuildContext context) {
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
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            lang.invoiceNumber,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: spacing.xxs),
          TextField(
            controller: _invoiceController,
            decoration: InputDecoration(
              hintText: lang.invoiceNumberExample,
              hintStyle: TextStyle(color: Colors.grey.shade400),
              filled: true,
              fillColor: colorScheme.outlineVariant.withOpacity(0.3),
              contentPadding: EdgeInsets.symmetric(
                horizontal: spacing.sm,
                vertical: spacing.xs,
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
          SizedBox(height: spacing.sm),

          Text(
            lang.date,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: spacing.xxs),
          TextField(
            controller: _dateController,
            readOnly: true,
            onTap: () async {
              await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2020),
                lastDate: DateTime(2030),
              );
            },
            decoration: InputDecoration(
              hintText: lang.dateFormatHint,
              hintStyle: TextStyle(color: Colors.grey.shade400),
              filled: true,
              fillColor: colorScheme.outlineVariant.withOpacity(0.3),
              suffixIcon: const Icon(Icons.calendar_today_outlined, size: 20),
              contentPadding: EdgeInsets.symmetric(
                horizontal: spacing.sm,
                vertical: spacing.xs,
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

          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.search, size: 20),
            label: Text(
              lang.search,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
              padding: EdgeInsets.symmetric(vertical: spacing.sm),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(spacing.radiusSm),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InvoiceCard extends StatelessWidget {
  final String invoiceNumber;
  final String time;
  final String itemsCountText;
  final String totalAmount;
  final bool isExpanded;
  final VoidCallback onTap;
  final List<_OrderSubItem>? items;

  const _InvoiceCard({
    required this.invoiceNumber,
    required this.time,
    required this.itemsCountText,
    required this.totalAmount,
    required this.isExpanded,
    required this.onTap,
    this.items,
  });

  @override
  Widget build(BuildContext context) {
    final lang = S.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final spacing = context.spacing;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(spacing.radiusMd),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(spacing.radiusMd),
            child: Padding(
              padding: EdgeInsets.all(spacing.md),
              child: Row(
                children: [
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  const Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        itemsCountText,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      SizedBox(height: spacing.xxs),
                      Text(
                        totalAmount,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: spacing.lg),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        invoiceNumber,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: spacing.xxs),
                      Row(
                        children: [
                          Text(
                            time,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                          SizedBox(width: spacing.xxs),
                          Icon(
                            Icons.access_time,
                            size: 14,
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

          if (isExpanded && items != null) ...[
            Divider(height: 1, color: colorScheme.outlineVariant),
            Padding(
              padding: EdgeInsets.all(spacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      lang.orderDetails,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                  SizedBox(height: spacing.sm),

                  ...items!.map(
                    (item) => Padding(
                      padding: EdgeInsets.only(bottom: spacing.xs),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                item.price,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Row(
                                children: [
                                  Text(
                                    item.name,
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(width: spacing.xs),
                                  Text(
                                    item.quantity,
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: spacing.xs),
                          Divider(
                            height: 1,
                            color: colorScheme.outlineVariant.withOpacity(0.5),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: spacing.md),

                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFE8F5E9),
                            foregroundColor: const Color(0xFF2E7D32),
                            elevation: 0,
                            padding: EdgeInsets.symmetric(vertical: spacing.sm),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                spacing.radiusSm,
                              ),
                              side: const BorderSide(color: Color(0xFFA5D6A7)),
                            ),
                          ),
                          child: Text(
                            lang.fullReturn,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      SizedBox(width: spacing.sm),

                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFE3F2FD),
                            foregroundColor: colorScheme.primary,
                            elevation: 0,
                            padding: EdgeInsets.symmetric(vertical: spacing.sm),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                spacing.radiusSm,
                              ),
                              side: BorderSide(
                                color: colorScheme.primary.withOpacity(0.3),
                              ),
                            ),
                          ),
                          child: Text(
                            lang.partialReturn,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _OrderSubItem {
  final String name;
  final String quantity;
  final String price;

  const _OrderSubItem({
    required this.name,
    required this.quantity,
    required this.price,
  });
}
