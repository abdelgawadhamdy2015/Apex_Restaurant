// ignore_for_file: must_be_immutable

import 'dart:developer';

import 'package:apex_restaurant/core/shared/widgets/app_text_button.dart';
import 'package:apex_restaurant/core/theme/app_theme.dart';
import 'package:apex_restaurant/featchers/pos/data/enums/pos_order_type.dart';
import 'package:apex_restaurant/featchers/pos/data/models/food_additive_model.dart';
import 'package:apex_restaurant/featchers/pos/domain/entities/menu_item.dart';
import 'package:apex_restaurant/featchers/pos/presentation/bloc/pos_bloc.dart';
import 'package:apex_restaurant/featchers/pos/presentation/bloc/pos_event.dart';
import 'package:apex_restaurant/featchers/pos/presentation/bloc/pos_state.dart';
import 'package:apex_restaurant/featchers/pos/presentation/widgets/additives_selection_dialog.dart';
import 'package:apex_restaurant/featchers/pos/presentation/widgets/order_type_dialog.dart';
import 'package:apex_restaurant/featchers/pos/presentation/widgets/table_selection_dialog.dart';
import 'package:apex_restaurant/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
          _OrderHeader(),
          Flexible(child: _OrderItemsList()),
          _OrderSummary(),
          _OrderActions(),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  late final S lang;

  String orderTitle(PosOrderType type, S lang) {
    switch (type) {
      case PosOrderType.dineIn:
        return lang.dineInOrder;
      case PosOrderType.takeaway:
        return lang.takeawayOrder;
      case PosOrderType.delivery:
        return lang.deliveryOrder;
    }
  }

  @override
  Widget build(BuildContext context) {
    lang = S.of(context);
    return Container(
      padding: AppPadding.allSm,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: BlocBuilder<PosBloc, PosState>(
                  builder: (context, state) {
                    return AppButtonText(
                      verticalPadding: 0,
                      backGroundColor: AppColors.primary,
                      buttonHeight: AppSizes.buttonHeightSm,
                      butonText: orderTitle(state.orderType, lang),
                      textStyle: AppFonts.bodyMedium
                          .colored(AppColors.white)
                          .semiBold(),
                      onPressed: () async {
                        final type = await showDialog(
                          context: context,
                          builder: (_) => const OrderTypeDialog(),
                        );
                        log(type.toString());
                        if (type != null) {
                          // ignore: use_build_context_synchronously
                          context.read<PosBloc>().add(
                            ChangeOrderTypeEvent(type),
                          );
                        }
                        if (type == PosOrderType.dineIn) {
                          await showDialog(
                            // ignore: use_build_context_synchronously
                            context: context,
                            builder: (_) => BlocProvider.value(
                              value: context.read<PosBloc>(),
                              child: const TableSelectionDialog(),
                            ),
                          );
                        }
                      },
                    );
                  },
                ),
              ),

              AppSizes.gapW12,

              Expanded(
                child: BlocBuilder<PosBloc, PosState>(
                  builder: (context, state) {
                    return AppButtonText(
                      verticalPadding: AppPadding.xs,
                      backGroundColor: AppColors.primary,
                      buttonHeight: AppSizes.buttonHeightSm,
                      butonText: lang.table,
                      textStyle: AppFonts.bodyMedium
                          .colored(AppColors.white)
                          .semiBold(),
                      onPressed: state.orderType == PosOrderType.dineIn
                          ? () async {
                              await showDialog(
                                context: context,
                                builder: (_) => BlocProvider.value(
                                  value: context.read<PosBloc>(),
                                  child: const TableSelectionDialog(),
                                ),
                              );
                            }
                          : null,
                    );
                  },
                ),
              ),
            ],
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

class _OrderHeader extends StatelessWidget {
  const _OrderHeader();

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
              return (state.orderType == PosOrderType.dineIn &&
                      state.selectedTable != null)
                  ? Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppPadding.md,
                        vertical: AppPadding.xs,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(AppRadius.full),
                      ),
                      child: Text(
                        '${S.of(context).table} ${state.selectedTable?.arabicName ?? ''}',
                        style: AppFonts.bodySmall
                            .colored(AppColors.white)
                            .bold(),
                      ),
                    )
                  : const SizedBox.shrink();
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
                Text(lang.noDateFound, style: AppFonts.bodySmall),
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
          itemBuilder: (context, index) {
            return _OrderItemRow(orderItem: state.currentOrder.items[index]);
          },
        );
      },
    );
  }
}

class _OrderItemRow extends StatelessWidget {
  final OrderItem orderItem;
  _OrderItemRow({required this.orderItem});
  late S lang = S();

  List<FoodAdditiveModel> _getInitSelection(List<FoodAdditiveModel> allAdons) {
    return allAdons.where((a) => orderItem.addons.contains(a)).toList();
  }

  Future<List<FoodAdditiveModel>?> showAdditivesDialog({
    required BuildContext context,
    required List<FoodAdditiveModel> additives,
    List<FoodAdditiveModel> initialSelection = const [],
  }) {
    return showModalBottomSheet<List<FoodAdditiveModel>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AdditivesDialog(
        additives: additives,
        initialSelection: initialSelection,
      ),
    );
  }

  String additivesNames(List<FoodAdditiveModel> adds) {
    log(adds.length.toString());
    return adds.map((a) => a.arabicName).join(',');
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
                  onTap: () async {
                    final additives =
                        await showAdditivesDialog(
                          context: context,
                          additives: state.additives,
                          initialSelection: _getInitSelection(state.additives),
                        ) ??
                        [];

                    if (additives.isNotEmpty) {
                      // ignore: use_build_context_synchronously
                      context.read<PosBloc>().add(
                        UpdateItemAddonsEvent(
                          addons: additives,
                          item: orderItem,
                        ),
                      );
                    }
                  },
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
                      BlocBuilder<PosBloc, PosState>(
                        builder: (context, state) {
                          final currentItem = state.currentOrder.items
                              .firstWhere(
                                (i) => i.menuItem.id == orderItem.menuItem.id,
                                orElse: () => orderItem,
                              );
                          return Text(
                            currentItem.addons.isNotEmpty
                                ? additivesNames(currentItem.addons)
                                : lang.noAddons,
                            textAlign: TextAlign.center,
                            style: AppFonts.bodySmall.colored(
                              AppColors.textMuted,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Spacer(),
              Row(
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
                    width: AppSizes.w12,
                    child: Text(
                      '${orderItem.quantity}',
                      textAlign: TextAlign.center,
                      style: AppFonts.bodyLarge
                          .colored(AppColors.textPrimary)
                          .bold(),
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
              ),
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
        width: AppSizes.w16,
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
