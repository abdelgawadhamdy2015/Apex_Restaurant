import 'package:apex_restaurant/core/helpers/extensions.dart';
import 'package:apex_restaurant/featchers/cart/presentation/bloc/cart_bloc.dart';
import 'package:apex_restaurant/featchers/cart/presentation/bloc/cart_event.dart';
import 'package:apex_restaurant/featchers/pos/data/enums/table_status.dart';
import 'package:apex_restaurant/featchers/tables/domain/entities/table_entity.dart';
import 'package:apex_restaurant/featchers/tables/presentation/tablet_widgets/table_invoice_dialog.dart';
import 'package:apex_restaurant/featchers/tables/presentation/tablet_widgets/table_order_entity.dart';
import 'package:apex_restaurant/featchers/tables/presentation/widgets/add_reservation_bottom_sheet.dart';
import 'package:apex_restaurant/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class TableCard extends StatefulWidget {
  const TableCard({super.key, required this.table, required this.inCartScreen});
  final TableEntity table;
  final bool inCartScreen;
  @override
  State<TableCard> createState() => _TableCardState();
}

class _TableCardState extends State<TableCard> {
  OverlayEntry? _overlayEntry;

  bool _isOpen = false;

  void _openMenu(BuildContext context) {
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
    setState(() => _isOpen = true);
  }

  void _closeMenu() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    if (mounted) setState(() => _isOpen = false);
  }

  /// Opens the invoice dialog. If the table already has an open order
  /// (reserved/occupied) this should show that order — wire [order] up to
  /// a real fetch (e.g. a `GetTableOrderUseCase` via `TablesBloc`) once the
  /// backend endpoint for it is available. If the table is free, it opens
  /// as a blank invoice ready for items to be added.
  void _openInvoice(BuildContext context) {
    final isExistingOrder = widget.table.status != TableStatus.available;

    // TODO: replace with the real order fetched for widget.table.id.
    final order = isExistingOrder
        ? TableOrderEntity(
            orderNumber: '12345',
            invoiceNumber: 'INV-9876',
            date: DateTime.now(),
          )
        : TableOrderEntity.empty();

    TableInvoiceDialog.show(
      context,
      tableName: widget.table.arabicName ?? '',
      seatsCount: widget.table.seatNumbers ?? 0,
      order: order,
      onApplyCoupon: (code) {
        // TODO: dispatch coupon application to the order/cart bloc.
      },
      onQuantityChanged: (itemId, quantity) {
        // TODO: dispatch quantity update to the order/cart bloc.
      },
      onDeleteItem: (itemId) {
        // TODO: dispatch item removal to the order/cart bloc.
      },
      onClearAll: () {
        // TODO: dispatch clear-cart to the order/cart bloc.
      },
      onAddItem: () {
        // TODO: navigate to the menu/item picker for this table.
      },
      onCancelOrder: () {
        // TODO: dispatch order cancellation, then close the dialog.
        Navigator.of(context).pop();
      },
      onPrintReceipt: () {
        // TODO: trigger receipt printing for this order.
      },
    );
  }

  OverlayEntry _createOverlayEntry() {
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    // Store the outer parent context that has access to the BLoC tree
    final parentContext = context;

    return OverlayEntry(
      builder: (overlayContext) {
        return Stack(
          children: [
            GestureDetector(
              onTap: _closeMenu,
              behavior: HitTestBehavior.translucent,
              child: const SizedBox.expand(),
            ),
            Positioned(
              left: offset.dx,
              top: offset.dy + size.height / 2,
              width: size.width,
              child: Material(
                elevation: 8,
                borderRadius: BorderRadius.circular(8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextButton(
                      onPressed: () {
                        _closeMenu();
                        AddReservationBottomSheet.show(parentContext, [], []);
                      },
                      child: Text(S.of(parentContext).addNewReservation),
                    ),
                    TextButton(
                      onPressed: () {
                        _closeMenu();
                        _openInvoice(parentContext);
                      },
                      child: Text(S.of(parentContext).openInvoice),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;
    final iconSizes = context.iconSizes;
    final l10n = S.of(context);
    final isAvailable = widget.table.status == TableStatus.available;

    return InkWell(
      onTap: () {
        if (widget.inCartScreen) {
          context.read<CartBloc>().add(
            SelectCartTableEvent(table: widget.table),
          );
          context.pop();
        } else {
          _isOpen ? _closeMenu() : _openMenu(context);
        }
      },
      child: Container(
        padding: EdgeInsets.all(spacing.sm),
        decoration: BoxDecoration(
          color: theme.colorScheme.onSurface,
          borderRadius: BorderRadius.circular(spacing.radiusLg),
          border: Border.all(color: theme.colorScheme.outlineVariant),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              height: 60,
              width: 90,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(spacing.radiusSm),
                border: Border.all(
                  color: isAvailable
                      ? Colors.blue.shade300
                      : Colors.purple.shade200,
                  width: 2,
                ),
              ),
            ),
            Text(
              '${l10n.table} ${widget.table.arabicName}',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.people_outline,
                  size: iconSizes.xs,
                  color: theme.colorScheme.onPrimary,
                ),
                SizedBox(width: spacing.xxs),
                Text(
                  '${widget.table.seatNumbers} ${l10n.seats}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onPrimary,
                  ),
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: spacing.sm,
                vertical: spacing.xxs,
              ),
              decoration: BoxDecoration(
                color: isAvailable
                    ? context.appExtraTheme.greenBackground.withOpacity(.1)
                    : theme.colorScheme.error.withOpacity(.1),
                borderRadius: BorderRadius.circular(spacing.radiusLg),
              ),
              child: Text(
                isAvailable ? l10n.available : l10n.reserved,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: isAvailable
                      ? context.appExtraTheme.greenBackground
                      : theme.colorScheme.error,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
