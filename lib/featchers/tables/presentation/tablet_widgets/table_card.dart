// ignore_for_file: deprecated_member_use

import 'dart:developer';

import 'package:apex_restaurant/core/helpers/size_helper.dart';
import 'package:apex_restaurant/core/router/routes.dart';
import 'package:apex_restaurant/featchers/cart/data/enums/cart_enum.dart';
import 'package:apex_restaurant/featchers/orders/domain/mapper/restored_invoice_mapper.dart';
import 'package:apex_restaurant/featchers/pos/presentation/bloc/pos_bloc.dart';
import 'package:apex_restaurant/featchers/pos/presentation/bloc/pos_event.dart';
import 'package:apex_restaurant/featchers/pos/presentation/pages/pos_page.dart';
import 'package:apex_restaurant/featchers/tables/presentation/bloc/tables_bloc.dart';
import 'package:apex_restaurant/featchers/tables/presentation/bloc/tables_event.dart';
import 'package:apex_restaurant/featchers/tables/presentation/bloc/tables_state.dart';
import 'package:apex_restaurant/featchers/tables/presentation/tablet_widgets/tablet_add_customer_sheet.dart';

import '../../../../core/helpers/extensions.dart';
import '../../../cart/presentation/bloc/cart_bloc.dart';
import '../../../cart/presentation/bloc/cart_event.dart';
import '../../../pos/data/enums/table_status.dart';
import '../../domain/entities/table_entity.dart';
import '../widgets/add_reservation_bottom_sheet.dart';
import '../../../../generated/l10n.dart';
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

  OverlayEntry _createOverlayEntry() {
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

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
                    BlocBuilder<TablesBloc, TablesState>(
                      builder: (context, state) {
                        return TextButton(
                          onPressed: () {
                            _closeMenu();
                            SizeHelper.isMobile
                                ? AddReservationBottomSheet.show(
                                    parentContext,
                                    state.tables,
                                    context.read<CartBloc>().state.persons,
                                  )
                                : TabletAddReservationBottomSheet.show(
                                    parentContext,
                                    state.tables,
                                    context.read<CartBloc>().state.persons,
                                    widget.table,
                                  );
                          },
                          child: Text(S.of(parentContext).addNewReservation),
                        );
                      },
                    ),

                    if (widget.table.bookingTableInvoiceId != null)
                      TextButton(
                        onPressed: () {
                          _closeMenu();
                          context.read<CartBloc>().add(
                            SelectCartTableEvent(table: widget.table),
                          );
                          context.read<TablesBloc>().add(
                            RestoreOrderEvent(
                              invoiceId: widget.table.bookingTableInvoiceId!,
                              canEdite: widget.table.canEdit ?? true,
                            ),
                          );
                          context.read<CartBloc>().add(
                            ChangeOrderTypeEvent(CartOrderType.DINE_IN),
                          );
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

  void _onTableStateChanged(BuildContext context, TablesState state) {
    if (state.status == TablesStatus.success) {
      final restored = state.restoredInvoiceModel;
      log("$restored");
      if (restored == null) return;

      final cartData = restored.toRestoredCartData(context);

      context.read<CartBloc>().add(
        SyncRestoredInvoiceEvent(
          cartData,
          canEdit: state.restoredInvoiceModel?.invoice?.canEdit ?? true,
          isPending: true,
        ),
      );
      context.read<TablesBloc>().add(const ClearRestoredInvoiceEvent());
      if (SizeHelper.isMobile) {
        context.pushNamed(Routes.posScreen);
      } else {
        context.read<PosBloc>().add(
          SelectedNavIndexEvent(selectedNavIndex: PosBottomNavEnm.menu),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;
    final iconSizes = context.iconSizes;
    final lang = S.of(context);
    final isAvailable = widget.table.status == TableStatus.available;

    return BlocListener<TablesBloc, TablesState>(
      listener: (context, state) {
        if (state.status == TablesStatus.success) {
          _onTableStateChanged(context, state);
        }
      },
      child: GestureDetector(
        onTap: widget.table.status == TableStatus.available
            ? () {
                if (widget.inCartScreen) {
                  context.read<CartBloc>().add(
                    SelectCartTableEvent(table: widget.table),
                  );
                  context.pop();
                } else {
                  _isOpen ? _closeMenu() : _openMenu(context);
                }
              }
            : null,
        child: Container(
          padding: EdgeInsets.all(spacing.xxs),
          decoration: BoxDecoration(
            color: theme.colorScheme.onSurface,
            borderRadius: BorderRadius.circular(spacing.radiusSm),
            border: Border.all(color: theme.colorScheme.outlineVariant),
          ),
          child: Stack(
            children: [
              Align(
                alignment: AlignmentGeometry.topLeft,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: widget.table.status == TableStatus.available
                        ? Colors.green
                        : Colors.red,
                  ),
                ),
              ),
              Column(
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
                    '${lang.table} ${widget.table.arabicName}',
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
                        '${widget.table.seatNumbers} ${lang.seats}',
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
                          ? context.appExtraTheme.greenBackground.withOpacity(
                              .1,
                            )
                          : theme.colorScheme.error.withOpacity(.1),
                      borderRadius: BorderRadius.circular(spacing.radiusLg),
                    ),
                    child: Text(
                      isAvailable ? lang.available : lang.reserved,
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
            ],
          ),
        ),
      ),
    );
  }
}
