import 'dart:developer';

import 'package:apex_restaurant/core/shared/widgets/app_text_button.dart';
import 'package:apex_restaurant/core/theme/app_theme.dart';
import 'package:apex_restaurant/core/theme/size_config.dart';
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
import 'package:google_fonts/google_fonts.dart';

class OrderPanel extends StatelessWidget {
  const OrderPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.screenWidth! * .35,
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(right: BorderSide(color: AppColors.border, width: 1)),
      ),
      child: Column(
        children: [
          _Header(),
          _OrderHeader(),
          const Expanded(child: _OrderItemsList()),
          const _OrderSummary(),
          const _OrderActions(),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  late final S lang;
  String orderTitle(PosOrderType type) {
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
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: BlocBuilder<PosBloc, PosState>(
                  builder: (context, state) {
                    return AppButtonText(
                      verticalPadding: AppSpacing.xs,
                      backGroundColor: AppColors.primary,
                      buttonHeight: 40,
                      butonText: orderTitle(state.orderType),
                      textStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
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

              const SizedBox(width: AppSpacing.sm),

              Expanded(
                child: BlocBuilder<PosBloc, PosState>(
                  builder: (context, state) {
                    return AppButtonText(
                      verticalPadding: AppSpacing.xs,
                      backGroundColor: AppColors.primary,
                      buttonHeight: SizeConfig.screenHeight! * .03,
                      butonText: lang.table,
                      textStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
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

          const SizedBox(height: AppSpacing.md),

          Row(
            children: [
              const Spacer(),

              Icon(
                Icons.shopping_cart_outlined,
                size: 20,
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
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
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
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.xs,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(AppRadius.full),
                      ),
                      child: Text(
                        'طاولة ${state.selectedTable?.arabicName ?? ''}',
                        style: GoogleFonts.cairo(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.white,
                        ),
                      ),
                    )
                  : const SizedBox.shrink();
            },
          ),

          const Spacer(),
          Text(
            'الطلب الحالي',
            style: GoogleFonts.cairo(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          const Icon(
            Icons.receipt_long_outlined,
            size: 20,
            color: AppColors.textSecondary,
          ),
        ],
      ),
    );
  }
}

class _OrderItemsList extends StatelessWidget {
  const _OrderItemsList();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PosBloc, PosState>(
      builder: (context, state) {
        if (state.currentOrder.items.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.shopping_bag_outlined,
                  size: 40,
                  color: AppColors.textMuted.withOpacity(0.5),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'لا توجد عناصر في الطلب',
                  style: GoogleFonts.cairo(
                    fontSize: 13,
                    color: AppColors.textMuted,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'اضغط على أي صنف لإضافته',
                  style: GoogleFonts.cairo(
                    fontSize: 11,
                    color: AppColors.textMuted.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
          itemCount: state.currentOrder.items.length,
          separatorBuilder: (_, __) => const Divider(
            height: 1,
            indent: AppSpacing.lg,
            endIndent: AppSpacing.lg,
          ),
          itemBuilder: (context, index) {
            final orderItem = state.currentOrder.items[index];
            return _OrderItemRow(orderItem: orderItem);
          },
        );
      },
    );
  }
}

class _OrderItemRow extends StatelessWidget {
  final OrderItem orderItem;
  const _OrderItemRow({required this.orderItem});

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

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PosBloc, PosState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          child: Row(
            children: [
              // Price
              Text(
                orderItem.totalPrice.toStringAsFixed(2),
                style: GoogleFonts.cairo(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const Spacer(),

              // Quantity controls
              Row(
                children: [
                  _QtyButton(
                    icon: Icons.remove,
                    color: AppColors.textSecondary,
                    bgColor: AppColors.background,
                    onTap: () => context.read<PosBloc>().add(
                      DecrementItemEvent(orderItem.menuItem.id.toString()),
                    ),
                  ),
                  Container(
                    width: 36,
                    alignment: Alignment.center,
                    child: Text(
                      '${orderItem.quantity}',
                      style: GoogleFonts.cairo(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  _QtyButton(
                    icon: Icons.add,
                    color: AppColors.white,
                    bgColor: AppColors.primary,
                    onTap: () => context.read<PosBloc>().add(
                      IncrementItemEvent(orderItem.menuItem.id.toString()),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: AppSpacing.md),

              // Item info
              InkWell(
                onTap: () async {
                  context.read<PosBloc>().add(
                    SelectItemEvent(orderItem.menuItem),
                  );
                  List<FoodAdditiveModel> additives =
                      await showAdditivesDialog(
                        context: context,
                        additives: state.additives,
                      ) ??
                      [];

                  log(state.selectedMenuItem?.arabicName ?? "");
                },
                child: Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        orderItem.menuItem.arabicName ?? "",
                        textAlign: TextAlign.right,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.cairo(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      if (orderItem.addons.isNotEmpty ||
                          orderItem.notes != null)
                        Text(
                          orderItem.notes ?? orderItem.addons.join('، '),
                          textAlign: TextAlign.right,
                          style: GoogleFonts.cairo(
                            fontSize: 10,
                            color: AppColors.textMuted,
                          ),
                        )
                      else
                        Text(
                          'بدون إضافات',
                          textAlign: TextAlign.right,
                          style: GoogleFonts.cairo(
                            fontSize: 10,
                            color: AppColors.textMuted,
                          ),
                        ),
                    ],
                  ),
                ),
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
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(AppRadius.sm),
          border: bgColor == AppColors.background
              ? Border.all(color: AppColors.border)
              : null,
        ),
        child: Icon(icon, size: 16, color: color),
      ),
    );
  }
}

class _OrderSummary extends StatelessWidget {
  const _OrderSummary();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PosBloc, PosState>(
      builder: (context, state) {
        final order = state.currentOrder;
        return Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(color: AppColors.divider),
              bottom: BorderSide(color: AppColors.divider),
            ),
          ),
          child: Column(
            children: [
              _SummaryRow(
                label: 'المجموع الفرعي',
                value: 'SAR ${order.subtotal.toStringAsFixed(2)}',
                isLight: true,
              ),
              const SizedBox(height: AppSpacing.sm),
              _SummaryRow(
                label: 'الضريبة (15%)',
                value: 'SAR ${order.tax.toStringAsFixed(2)}',
                isLight: true,
              ),
              const SizedBox(height: AppSpacing.md),
              _SummaryRow(
                label: 'الإجمالي',
                value: 'SAR ${order.total.toStringAsFixed(2)}',
                isLight: false,
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
  final bool isLight;
  final bool isBold;

  const _SummaryRow({
    required this.label,
    required this.value,
    required this.isLight,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          value,
          style: GoogleFonts.cairo(
            fontSize: isBold ? 18 : 13,
            fontWeight: isBold ? FontWeight.w800 : FontWeight.w500,
            color: isBold ? AppColors.primary : AppColors.textSecondary,
          ),
        ),
        const Spacer(),
        Text(
          label,
          style: GoogleFonts.cairo(
            fontSize: isBold ? 16 : 13,
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w400,
            color: isBold ? AppColors.textPrimary : AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

class _OrderActions extends StatelessWidget {
  const _OrderActions();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PosBloc, PosState>(
      builder: (context, state) {
        final isSubmitting = state.status == PosStatus.submitting;
        return Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            children: [
              // Kitchen + Pay buttons
              Row(
                children: [
                  Expanded(
                    child: _ActionButton(
                      label: 'للمطبخ',
                      icon: Icons.send_outlined,
                      bgColor: AppColors.primary,
                      textColor: AppColors.white,
                      isLoading: isSubmitting,
                      onTap: () => context.read<PosBloc>().add(
                        const SendToKitchenEvent(),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: _ActionButton(
                      label: 'دفع',
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
              const SizedBox(height: AppSpacing.sm),
              // Cancel + Tables row
              Row(
                children: [
                  Expanded(
                    child: _ActionButton(
                      label: 'إلغاء',
                      icon: Icons.close,
                      bgColor: AppColors.errorLight,
                      textColor: AppColors.error,
                      borderColor: AppColors.error,
                      onTap: () =>
                          context.read<PosBloc>().add(const CancelOrderEvent()),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: _ActionButton(
                      label: 'طاولات',
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
        height: 48,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: borderColor != null
              ? Border.all(color: borderColor!, width: 1.5)
              : null,
        ),
        child: isLoading
            ? const Center(
                child: SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, size: 18, color: textColor),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    label,
                    style: GoogleFonts.cairo(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
