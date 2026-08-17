import 'package:flutter/material.dart';

import '../../../../core/helpers/extensions.dart';
import '../../../../generated/l10n.dart';

class TabletReturnsScreen extends StatefulWidget {
  const TabletReturnsScreen({super.key});

  @override
  State<TabletReturnsScreen> createState() => _TabletReturnsScreenState();
}

class _TabletReturnsScreenState extends State<TabletReturnsScreen> {
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

    return Padding(
      padding: EdgeInsets.all(spacing.lg),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left Side: Invoices List
          Expanded(
            flex: 3,
            child: Container(
              padding: EdgeInsets.all(spacing.md),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(spacing.radiusLg),
                border: Border.all(color: colorScheme.outlineVariant),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: spacing.sm),
                      child: Text(
                        lang.invoices,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ),
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
            ),
          ),
          SizedBox(width: spacing.lg),

          // Right Side: Search Filter Card
          Expanded(flex: 2, child: _buildSearchCard(context)),
        ],
      ),
    );
  }

  Widget _buildSearchCard(BuildContext context) {
    final lang = S.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final spacing = context.spacing;

    return Container(
      padding: EdgeInsets.all(spacing.lg),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(spacing.radiusLg),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            lang.invoiceNumber,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: spacing.xs),
          TextField(
            controller: _invoiceController,
            decoration: InputDecoration(
              hintText: lang.invoiceNumberExample,
              hintStyle: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.outline,
              ),
              filled: true,
              fillColor: colorScheme.surfaceContainerHighest.withOpacity(0.3),
              contentPadding: EdgeInsets.symmetric(
                horizontal: spacing.md,
                vertical: spacing.sm,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(spacing.radiusMd),
                borderSide: BorderSide(color: colorScheme.outlineVariant),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(spacing.radiusMd),
                borderSide: BorderSide(color: colorScheme.outlineVariant),
              ),
            ),
          ),
          SizedBox(height: spacing.md),
          Text(
            lang.date,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: spacing.xs),
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
              hintStyle: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.outline,
              ),
              filled: true,
              fillColor: colorScheme.surfaceContainerHighest.withOpacity(0.3),
              suffixIcon: Icon(
                Icons.calendar_today_outlined,
                size: context.iconSizes.sm,
                color: colorScheme.onSurfaceVariant,
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: spacing.md,
                vertical: spacing.sm,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(spacing.radiusMd),
                borderSide: BorderSide(color: colorScheme.outlineVariant),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(spacing.radiusMd),
                borderSide: BorderSide(color: colorScheme.outlineVariant),
              ),
            ),
          ),
          SizedBox(height: spacing.xl),
          SizedBox(
            height: 48,
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: Icon(Icons.search, size: context.iconSizes.sm),
              label: Text(
                lang.search,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onPrimary,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(spacing.radiusMd),
                ),
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
        border: Border.all(color: colorScheme.outlineVariant),
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
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: spacing.xl),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        invoiceNumber,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      SizedBox(height: spacing.xxs),
                      Row(
                        mainAxisSize: MainAxisSize.min,
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
                            size: context.iconSizes.xs,
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
                        color: colorScheme.outline,
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
                                  color: colorScheme.onSurface,
                                ),
                              ),
                              Row(
                                children: [
                                  Text(
                                    item.quantity,
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: colorScheme.onSurface,
                                    ),
                                  ),
                                  SizedBox(width: spacing.xs),
                                  Text(
                                    item.name,
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: colorScheme.onSurface,
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
                        child: OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            backgroundColor: colorScheme.primaryContainer
                                .withOpacity(0.3),
                            foregroundColor: colorScheme.primary,
                            side: BorderSide(
                              color: colorScheme.primaryContainer,
                            ),
                            padding: EdgeInsets.symmetric(vertical: spacing.sm),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                spacing.radiusSm,
                              ),
                            ),
                          ),
                          child: Text(
                            lang.partialReturn,
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.primary,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: spacing.sm),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            backgroundColor: colorScheme.tertiaryContainer
                                .withOpacity(0.3),
                            foregroundColor: colorScheme.tertiary,
                            side: BorderSide(
                              color: colorScheme.tertiaryContainer,
                            ),
                            padding: EdgeInsets.symmetric(vertical: spacing.sm),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                spacing.radiusSm,
                              ),
                            ),
                          ),
                          child: Text(
                            lang.fullReturn,
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.tertiary,
                            ),
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
