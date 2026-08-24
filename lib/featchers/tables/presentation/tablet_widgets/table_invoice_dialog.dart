import 'package:apex_restaurant/core/helpers/extensions.dart';
import 'package:apex_restaurant/featchers/tables/presentation/tablet_widgets/table_order_entity.dart';
import 'package:apex_restaurant/generated/l10n.dart';
import 'package:flutter/material.dart';

import 'order_item_row.dart';

/// Shows a table's current invoice (existing order) or, when [order] is
/// empty, acts as the start of a brand-new invoice for that table.
class TableInvoiceDialog extends StatefulWidget {
  const TableInvoiceDialog({
    super.key,
    required this.tableName,
    required this.seatsCount,
    required this.order,
    this.onApplyCoupon,
    this.onQuantityChanged,
    this.onDeleteItem,
    this.onClearAll,
    this.onAddItem,
    this.onCancelOrder,
    this.onPrintReceipt,
  });

  final String tableName;
  final int seatsCount;
  final TableOrderEntity order;

  final ValueChanged<String>? onApplyCoupon;
  final void Function(String itemId, int newQuantity)? onQuantityChanged;
  final ValueChanged<String>? onDeleteItem;
  final VoidCallback? onClearAll;
  final VoidCallback? onAddItem;
  final VoidCallback? onCancelOrder;
  final VoidCallback? onPrintReceipt;

  /// Convenience helper: `TableInvoiceDialog.show(context, ...)`.
  static Future<void> show(
    BuildContext context, {
    required String tableName,
    required int seatsCount,
    required TableOrderEntity order,
    ValueChanged<String>? onApplyCoupon,
    void Function(String itemId, int newQuantity)? onQuantityChanged,
    ValueChanged<String>? onDeleteItem,
    VoidCallback? onClearAll,
    VoidCallback? onAddItem,
    VoidCallback? onCancelOrder,
    VoidCallback? onPrintReceipt,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => TableInvoiceDialog(
        tableName: tableName,
        seatsCount: seatsCount,
        order: order,
        onApplyCoupon: onApplyCoupon,
        onQuantityChanged: onQuantityChanged,
        onDeleteItem: onDeleteItem,
        onClearAll: onClearAll,
        onAddItem: onAddItem,
        onCancelOrder: onCancelOrder,
        onPrintReceipt: onPrintReceipt,
      ),
    );
  }

  @override
  State<TableInvoiceDialog> createState() => _TableInvoiceDialogState();
}

class _TableInvoiceDialogState extends State<TableInvoiceDialog> {
  final _couponController = TextEditingController();
  bool _isCouponMode = true;

  @override
  void initState() {
    super.initState();
    _couponController.text = widget.order.couponCode ?? '';
  }

  @override
  void dispose() {
    _couponController.dispose();
    super.dispose();
  }

  String _fmt(double v) => v.toStringAsFixed(2);

  String _fmtDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;
    final l10n = S.of(context);
    final order = widget.order;
    final size = MediaQuery.of(context).size;
    final isNewInvoice = order.invoiceNumber.isEmpty;

    return Dialog(
      backgroundColor: theme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(spacing.radiusLg),
      ),
      insetPadding: EdgeInsets.symmetric(
        horizontal: size.width > 900 ? size.width * 0.1 : spacing.md,
        vertical: spacing.lg,
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 960, maxHeight: 720),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _Header(
              tableName: widget.tableName,
              seatsCount: widget.seatsCount,
              onClose: () => Navigator.of(context).pop(),
            ),
            Divider(height: 1, color: theme.colorScheme.outlineVariant),
            Flexible(
              child: Padding(
                padding: EdgeInsets.all(spacing.md),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final isNarrow = constraints.maxWidth < 700;
                    final left = _buildSummaryColumn(
                      theme,
                      spacing,
                      l10n,
                      order,
                      isNewInvoice,
                    );
                    final right = _buildCartColumn(theme, spacing, l10n, order);

                    if (isNarrow) {
                      return SingleChildScrollView(
                        child: Column(
                          children: [
                            right,
                            SizedBox(height: spacing.md),
                            left,
                          ],
                        ),
                      );
                    }

                    return SingleChildScrollView(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: left),
                          SizedBox(width: spacing.md),
                          Expanded(flex: 2, child: right),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
            Divider(height: 1, color: theme.colorScheme.outlineVariant),
            Padding(
              padding: EdgeInsets.all(spacing.md),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: isNewInvoice ? null : widget.onCancelOrder,
                      icon: Icon(Icons.close, color: theme.colorScheme.error),
                      label: Text(
                        l10n.cancelOrder,
                        style: TextStyle(color: theme.colorScheme.error),
                      ),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 48),
                        side: BorderSide(color: theme.colorScheme.error),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(spacing.radiusLg),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: spacing.sm),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: order.items.isEmpty
                          ? null
                          : widget.onPrintReceipt,
                      icon: Icon(
                        Icons.print,
                        color: theme.colorScheme.onPrimary,
                      ),
                      label: Text(
                        l10n.printReceipt,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.onPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 48),
                        backgroundColor: theme.colorScheme.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(spacing.radiusLg),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryColumn(
    ThemeData theme,
    dynamic spacing,
    S l10n,
    TableOrderEntity order,
    bool isNewInvoice,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: EdgeInsets.all(spacing.sm),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(spacing.radiusMd),
          ),
          child: Row(
            children: [
              Expanded(
                child: _InfoBlock(
                  label: l10n.date,
                  value: _fmtDate(order.date),
                ),
              ),
              Expanded(
                child: _InfoBlock(
                  label: l10n.invoiceNumber,
                  value: isNewInvoice ? '—' : order.invoiceNumber,
                  valueColor: theme.colorScheme.primary,
                ),
              ),
              Expanded(
                child: _InfoBlock(
                  label: l10n.orderNumber,
                  value: isNewInvoice ? '—' : '#${order.orderNumber}',
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: spacing.md),
        Container(
          padding: EdgeInsets.all(spacing.md),
          decoration: BoxDecoration(
            border: Border.all(color: theme.colorScheme.outlineVariant),
            borderRadius: BorderRadius.circular(spacing.radiusMd),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Radio<bool>(
                        value: false,
                        groupValue: _isCouponMode,
                        onChanged: (v) => setState(() => _isCouponMode = v!),
                      ),
                      Text(l10n.directDiscount),
                    ],
                  ),
                  Row(
                    children: [
                      Text(l10n.coupon),
                      Radio<bool>(
                        value: true,
                        groupValue: _isCouponMode,
                        onChanged: (v) => setState(() => _isCouponMode = v!),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: spacing.xs),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _couponController,
                      decoration: InputDecoration(
                        hintText: l10n.enterDiscountCode,
                        prefixIcon: const Icon(Icons.sell_outlined),
                        fillColor: theme.colorScheme.surfaceContainerHighest,
                      ),
                    ),
                  ),
                  SizedBox(width: spacing.xs),
                  ElevatedButton(
                    onPressed: () {
                      final code = _couponController.text.trim();
                      if (code.isNotEmpty) widget.onApplyCoupon?.call(code);
                    },
                    child: Text(l10n.apply),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: spacing.md),
        _SummaryRow(label: l10n.subtotal, value: _fmt(order.subtotal)),
        if (order.discountAmount > 0)
          _SummaryRow(
            label: l10n.couponDiscount,
            value: '-${_fmt(order.discountAmount)}',
            valueColor: Colors.green,
          ),
        _SummaryRow(
          label: '${l10n.vat} (${order.vatPercentage.toStringAsFixed(0)}%)',
          value: _fmt(order.vatAmount),
        ),
        Divider(color: theme.colorScheme.outlineVariant),
        _SummaryRow(
          label: l10n.grandTotal,
          value: _fmt(order.total),
          isBold: true,
          valueColor: theme.colorScheme.primary,
        ),
      ],
    );
  }

  Widget _buildCartColumn(
    ThemeData theme,
    dynamic spacing,
    S l10n,
    TableOrderEntity order,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              l10n.cart,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            if (order.items.isNotEmpty)
              TextButton(
                onPressed: widget.onClearAll,
                child: Text(
                  l10n.clearAll,
                  style: TextStyle(color: theme.colorScheme.error),
                ),
              ),
          ],
        ),
        OutlinedButton.icon(
          onPressed: widget.onAddItem,
          icon: Icon(Icons.add, color: theme.colorScheme.primary),
          label: Text(l10n.addNewItem),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(double.infinity, 44),
            side: BorderSide(color: theme.colorScheme.primary),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(spacing.radiusMd),
            ),
          ),
        ),
        SizedBox(height: spacing.sm),
        if (order.items.isEmpty)
          Padding(
            padding: EdgeInsets.symmetric(vertical: spacing.lg),
            child: Center(
              child: Text(l10n.cartEmpty, style: theme.textTheme.bodyMedium),
            ),
          )
        else
          ...order.items.map(
            (item) => OrderItemRow(
              item: item,
              onIncrement: () =>
                  widget.onQuantityChanged?.call(item.id, item.quantity + 1),
              onDecrement: () => widget.onQuantityChanged?.call(
                item.id,
                (item.quantity - 1).clamp(0, 999),
              ),
              onDelete: () => widget.onDeleteItem?.call(item.id),
            ),
          ),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.tableName,
    required this.seatsCount,
    required this.onClose,
  });

  final String tableName;
  final int seatsCount;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;
    final l10n = S.of(context);

    return Padding(
      padding: EdgeInsets.all(spacing.md),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(icon: const Icon(Icons.close), onPressed: onClose),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${l10n.table} $tableName',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  Text(
                    '$seatsCount ${l10n.seats}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  SizedBox(width: spacing.xxs),
                  Icon(
                    Icons.people_outline,
                    size: 16,
                    color: theme.colorScheme.onSurfaceVariant,
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

class _InfoBlock extends StatelessWidget {
  const _InfoBlock({required this.label, required this.value, this.valueColor});

  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    this.isBold = false,
    this.valueColor,
  });

  final String label;
  final String value;
  final bool isBold;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: spacing.xxs),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: isBold
                ? theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  )
                : theme.textTheme.bodyMedium,
          ),
          Text(
            value,
            style:
                (isBold
                        ? theme.textTheme.titleMedium
                        : theme.textTheme.bodyMedium)
                    ?.copyWith(fontWeight: FontWeight.bold, color: valueColor),
          ),
        ],
      ),
    );
  }
}
