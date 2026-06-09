// ignore_for_file: use_build_context_synchronously, must_be_immutable

import 'package:apex_restaurant/core/shared/widgets/app_text_button.dart';
import 'package:apex_restaurant/core/theme/app_theme.dart';
import 'package:apex_restaurant/featchers/pos/data/enums/pos_order_type.dart';
import 'package:apex_restaurant/featchers/pos/data/models/food_additive_model.dart';
import 'package:apex_restaurant/featchers/pos/domain/entities/menu_item.dart';
import 'package:apex_restaurant/featchers/pos/presentation/bloc/pos_bloc.dart';
import 'package:apex_restaurant/featchers/pos/presentation/bloc/pos_event.dart';
import 'package:apex_restaurant/featchers/pos/presentation/bloc/pos_state.dart';
import 'package:apex_restaurant/featchers/pos/presentation/widgets/additives_selection_dialog.dart';
import 'package:apex_restaurant/featchers/pos/presentation/widgets/delivery_company_selection_dialpg.dart';
import 'package:apex_restaurant/featchers/pos/presentation/widgets/order_type_dialog.dart';
import 'package:apex_restaurant/featchers/pos/presentation/widgets/table_selection_dialog.dart';
import 'package:apex_restaurant/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ── Shared dialog helpers ──────────────────────────────────────────────────────

Future<void> _showTableDialog(BuildContext context) => showDialog(
  context: context,
  builder: (_) => BlocProvider.value(
    value: context.read<PosBloc>(),
    child: const TableSelectionDialog(),
  ),
);

Future<void> _showDeliveryDialog(BuildContext context) => showDialog(
  context: context,
  builder: (_) => BlocProvider.value(
    value: context.read<PosBloc>()..add(LoadDeliveryCompaniesEvent()),
    child: DeliveryCompanySelectionDialog(),
  ),
);

Future<void> _showDialogForType(PosOrderType type, BuildContext context) {
  if (type == PosOrderType.dineIn) return _showTableDialog(context);
  if (type == PosOrderType.delivery) return _showDeliveryDialog(context);
  return Future.value();
}

// ── OrderPanel ─────────────────────────────────────────────────────────────────

class OrderPanel extends StatelessWidget {
  const OrderPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSizes.wFraction(0.35),
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(right: BorderSide(color: AppColors.border, width: 1)),
      ),
      child: Column(
        children: [
          _Header(),
          const _OrderHeader(),
          Flexible(child: _OrderItemsList()),
          _OrderSummary(),
          _OrderActions(),
        ],
      ),
    );
  }
}

// ── _Header ────────────────────────────────────────────────────────────────────

class _Header extends StatelessWidget {
  late final S lang;

  String _orderTitle(PosOrderType type) {
    switch (type) {
      case PosOrderType.dineIn:
        return lang.dineInOrder;
      case PosOrderType.takeaway:
        return lang.takeawayOrder;
      case PosOrderType.delivery:
        return lang.deliveryOrder;
    }
  }

  String _secondButtonTitle(PosOrderType type) {
    if (type == PosOrderType.delivery) return lang.deliveryCompany;
    return lang.table;
  }

  VoidCallback? _secondButtonTap(PosOrderType type, BuildContext context) {
    if (type == PosOrderType.dineIn) return () => _showTableDialog(context);
    if (type == PosOrderType.delivery)
      return () => _showDeliveryDialog(context);
    return null;
  }

  @override
  Widget build(BuildContext context) {
    lang = S.of(context);
    return Container(
      padding: AppPadding.allSm,
      child: Column(
        children: [
          BlocBuilder<PosBloc, PosState>(
            builder: (context, state) {
              return Row(
                children: [
                  Expanded(
                    child: AppButtonText(
                      verticalPadding: 0,
                      backGroundColor: AppColors.primary,
                      buttonHeight: AppSizes.buttonHeightSm,
                      butonText: _orderTitle(state.orderType),
                      textStyle: AppFonts.bodyMedium
                          .colored(AppColors.white)
                          .semiBold(),
                      onPressed: () async {
                        final type = await showDialog<PosOrderType>(
                          context: context,
                          builder: (_) => OrderTypeDialog(),
                        );
                        if (type == null) return;
                        context.read<PosBloc>().add(ChangeOrderTypeEvent(type));
                        await _showDialogForType(type, context);
                      },
                    ),
                  ),
                  AppSizes.gapW12,
                  Expanded(
                    child: AppButtonText(
                      verticalPadding: AppPadding.xs,
                      backGroundColor: AppColors.primary,
                      buttonHeight: AppSizes.buttonHeightSm,
                      butonText: _secondButtonTitle(state.orderType),
                      textStyle: AppFonts.bodyMedium
                          .colored(AppColors.white)
                          .semiBold(),
                      onPressed: _secondButtonTap(state.orderType, context),
                    ),
                  ),
                ],
              );
            },
          ),
          AppSizes.gapH12,
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Icon(
                Icons.shopping_cart_outlined,
                size: AppSizes.iconMd,
                color: AppColors.textSecondary,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── _OrderHeader ───────────────────────────────────────────────────────────────

class _OrderHeader extends StatelessWidget {
  const _OrderHeader();

  String _badgeText(PosState state, BuildContext context) {
    final lang = S.of(context);
    switch (state.orderType) {
      case PosOrderType.dineIn:
        return '${lang.table} ${state.selectedTable?.arabicName ?? ''}';
      case PosOrderType.delivery:
        return state.selectedDeliveryCompany?.arabicName ?? '';
      default:
        return '';
    }
  }

  bool _showBadge(PosState state) {
    return (state.orderType == PosOrderType.dineIn &&
            state.selectedTable != null) ||
        (state.orderType == PosOrderType.delivery &&
            state.selectedDeliveryCompany != null);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppPadding.xs,
        vertical: AppPadding.md,
      ),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: Row(
        children: [
          BlocBuilder<PosBloc, PosState>(
            builder: (context, state) {
              if (!_showBadge(state)) return const SizedBox.shrink();
              return Expanded(
                flex: 10,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppPadding.xs,
                    vertical: AppPadding.xs,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(AppRadius.full),
                  ),
                  child: Text(
                    _badgeText(state, context),
                    overflow: TextOverflow.ellipsis,
                    style: AppFonts.bodySmall.colored(AppColors.white).bold(),
                  ),
                ),
              );
            },
          ),
          const Spacer(),
          Text(S.of(context).currentOrder, style: AppFonts.titleMedium),
          AppSizes.gapW8,
          Icon(
            Icons.receipt_long_outlined,
            size: AppSizes.iconMd,
            color: AppColors.textSecondary,
          ),
        ],
      ),
    );
  }
}

// ── _OrderItemsList ────────────────────────────────────────────────────────────

class _OrderItemsList extends StatelessWidget {
  _OrderItemsList();
  late S lang = S();

  @override
  Widget build(BuildContext context) {
    lang = S.of(context);
    return BlocBuilder<PosBloc, PosState>(
      builder: (context, state) {
        if (state.currentOrder.items.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.shopping_bag_outlined,
                  size: AppSizes.w40,
                  color: AppColors.textMuted.withOpacity(0.5),
                ),
                AppSizes.gapH12,
                Text(lang.noDataFound, style: AppFonts.bodySmall),
                AppSizes.gapH8,
                Text(
                  lang.tapAnyItemToAdd,
                  style: AppFonts.bodySmall.colored(
                    AppColors.textMuted.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          );
        }
        return ListView.separated(
          padding: AppPadding.verticalSm,
          itemCount: state.currentOrder.items.length,
          separatorBuilder: (_, __) => Divider(
            height: 1,
            indent: AppPadding.lg,
            endIndent: AppPadding.lg,
          ),
          itemBuilder: (_, index) =>
              _OrderItemRow(orderItem: state.currentOrder.items[index]),
        );
      },
    );
  }
}

// ── _OrderItemRow ──────────────────────────────────────────────────────────────

class _OrderItemRow extends StatelessWidget {
  final OrderItem orderItem;
  _OrderItemRow({required this.orderItem});
  late S lang = S();

  String _additivesText(PosState state) {
    final current = state.currentOrder.items.firstWhere(
      (i) => i.menuItem.id == orderItem.menuItem.id,
      orElse: () => orderItem,
    );
    if (current.addons.isEmpty) return lang.noAddons;
    return current.addons.map((a) => a.arabicName).join(', ');
  }

  List<FoodAdditiveModel> _initialSelection(List<FoodAdditiveModel> all) =>
      all.where((a) => orderItem.addons.contains(a)).toList();

  Future<void> _openAdditivesDialog(
    BuildContext context,
    PosState state,
  ) async {
    final result = await showModalBottomSheet<List<FoodAdditiveModel>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AdditivesDialog(
        additives: state.additives,
        initialSelection: _initialSelection(state.additives),
      ),
    );
    if (result != null && result.isNotEmpty) {
      context.read<PosBloc>().add(
        UpdateItemAddonsEvent(addons: result, item: orderItem),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    lang = S.of(context);
    return BlocBuilder<PosBloc, PosState>(
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppPadding.xs,
            vertical: AppPadding.md,
          ),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: InkWell(
                  onTap: () => _openAdditivesDialog(context, state),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        orderItem.menuItem.arabicName ?? "",
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppFonts.bodySmall
                            .colored(AppColors.textPrimary)
                            .semiBold(),
                      ),
                      Text(
                        _additivesText(state),
                        textAlign: TextAlign.center,
                        style: AppFonts.bodySmall.colored(AppColors.textMuted),
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              _QtyControls(orderItem: orderItem),
              AppSizes.gapW12,
              Text(
                orderItem.totalPrice.toStringAsFixed(2),
                style: AppFonts.bodyMedium
                    .colored(AppColors.textPrimary)
                    .bold(),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ── _QtyControls ───────────────────────────────────────────────────────────────

class _QtyControls extends StatelessWidget {
  final OrderItem orderItem;
  const _QtyControls({required this.orderItem});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _QtyButton(
          icon: Icons.remove,
          color: AppColors.textSecondary,
          bgColor: AppColors.background,
          onTap: () => context.read<PosBloc>().add(
            DecrementItemEvent(orderItem.menuItem.id!),
          ),
        ),
        SizedBox(
          width: AppSizes.w24,
          child: Text(
            '${orderItem.quantity}',
            textAlign: TextAlign.center,
            style: AppFonts.bodyLarge.colored(AppColors.textPrimary).bold(),
          ),
        ),
        _QtyButton(
          icon: Icons.add,
          color: AppColors.white,
          bgColor: AppColors.primary,
          onTap: () => context.read<PosBloc>().add(
            IncrementItemEvent(orderItem.menuItem.id!),
          ),
        ),
      ],
    );
  }
}

// ── _QtyButton ─────────────────────────────────────────────────────────────────

class _QtyButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final Color bgColor;
  final VoidCallback onTap;

  const _QtyButton({
    required this.icon,
    required this.color,
    required this.bgColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: AppSizes.w20,
        height: AppSizes.h24,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(AppRadius.sm),
          border: bgColor == AppColors.background
              ? Border.all(color: AppColors.border)
              : null,
        ),
        child: Icon(icon, size: AppSizes.iconSm, color: color),
      ),
    );
  }
}

// ── _OrderSummary ──────────────────────────────────────────────────────────────

class _OrderSummary extends StatelessWidget {
  _OrderSummary();
  late S lang = S();

  @override
  Widget build(BuildContext context) {
    lang = S.of(context);
    return BlocBuilder<PosBloc, PosState>(
      builder: (context, state) {
        final order = state.currentOrder;
        return Container(
          padding: AppPadding.allLg,
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(color: AppColors.divider),
              bottom: BorderSide(color: AppColors.divider),
            ),
          ),
          child: Column(
            children: [
              _SummaryRow(
                label: lang.subtotal,
                value: 'SAR ${order.subtotal.toStringAsFixed(2)}',
                isBold: false,
              ),
              AppSizes.gapH8,
              _SummaryRow(
                label: '${lang.tax} (15%)',
                value: 'SAR ${order.tax.toStringAsFixed(2)}',
                isBold: false,
              ),
              AppSizes.gapH12,
              _SummaryRow(
                label: lang.total,
                value: 'SAR ${order.total.toStringAsFixed(2)}',
                isBold: true,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;

  const _SummaryRow({
    required this.label,
    required this.value,
    required this.isBold,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          value,
          style: isBold
              ? AppFonts.titleLarge.colored(AppColors.primary)
              : AppFonts.bodySmall.colored(AppColors.textSecondary),
        ),
        const Spacer(),
        Text(
          label,
          style: isBold
              ? AppFonts.titleMedium.colored(AppColors.textPrimary)
              : AppFonts.bodySmall.colored(AppColors.textSecondary),
        ),
      ],
    );
  }
}

// ── _OrderActions ──────────────────────────────────────────────────────────────

class _OrderActions extends StatelessWidget {
  _OrderActions();
  late S lang;

  @override
  Widget build(BuildContext context) {
    lang = S.of(context);
    return BlocBuilder<PosBloc, PosState>(
      builder: (context, state) {
        final isSubmitting = state.status == PosStatus.submitting;
        return Padding(
          padding: AppPadding.allMd,
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: _ActionButton(
                      label: lang.toRestaurant,
                      icon: Icons.send_outlined,
                      bgColor: AppColors.primary,
                      textColor: AppColors.white,
                      isLoading: isSubmitting,
                      onTap: () => context.read<PosBloc>().add(
                        const SendToKitchenEvent(),
                      ),
                    ),
                  ),
                  AppSizes.gapW8,
                  Expanded(
                    child: _ActionButton(
                      label: lang.pay,
                      icon: Icons.payment_outlined,
                      bgColor: AppColors.accent,
                      textColor: AppColors.white,
                      isLoading: isSubmitting,
                      onTap: () =>
                          context.read<PosBloc>().add(const PayOrderEvent()),
                    ),
                  ),
                ],
              ),
              AppSizes.gapH8,
              Row(
                children: [
                  Expanded(
                    child: _ActionButton(
                      label: lang.cancel,
                      icon: Icons.close,
                      bgColor: AppColors.errorLight,
                      textColor: AppColors.error,
                      borderColor: AppColors.error,
                      onTap: () =>
                          context.read<PosBloc>().add(const CancelOrderEvent()),
                    ),
                  ),
                  AppSizes.gapW8,
                  Expanded(
                    child: _ActionButton(
                      label: lang.tables,
                      icon: Icons.table_restaurant_outlined,
                      bgColor: AppColors.background,
                      textColor: AppColors.textPrimary,
                      borderColor: AppColors.border,
                      onTap: () {},
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color bgColor;
  final Color textColor;
  final Color? borderColor;
  final bool isLoading;
  final VoidCallback onTap;

  const _ActionButton({
    required this.label,
    required this.icon,
    required this.bgColor,
    required this.textColor,
    this.borderColor,
    this.isLoading = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        height: AppSizes.buttonHeightSm,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: borderColor != null
              ? Border.all(color: borderColor!, width: 1.5)
              : null,
        ),
        child: isLoading
            ? Center(
                child: SizedBox(
                  width: AppSizes.w16,
                  height: AppSizes.h16,
                  child: const CircularProgressIndicator(strokeWidth: 2),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, size: AppSizes.iconSm, color: textColor),
                  AppSizes.gapW8,
                  Text(
                    label,
                    style: AppFonts.bodyMedium.colored(textColor).semiBold(),
                  ),
                ],
              ),
      ),
    );
  }
}
