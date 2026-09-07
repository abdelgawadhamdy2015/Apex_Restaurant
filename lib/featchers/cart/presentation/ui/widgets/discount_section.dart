import 'package:apex_restaurant/featchers/cart/data/enums/cart_enum.dart';
import 'package:apex_restaurant/featchers/cart/data/models/check_voucher_request.dart';

import '../../../../../core/helpers/extensions.dart';
import '../../../../../core/helpers/helper_methods.dart';
import '../../../../../core/shared/widgets/app_radio_group.dart';
import '../../../data/models/dynamic_discount.dart';
import '../../../data/models/invoice_request.dart';
import '../../../data/models/pos_client_model.dart';
import '../../bloc/cart_bloc.dart';
import '../../bloc/cart_event.dart';
import '../../bloc/cart_state.dart';
import '../../../../pos/presentation/widgets/discount_type_toggle.dart';
import '../../../../../generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DiscountSection extends StatefulWidget {
  const DiscountSection({
    super.key,
    required this.dynamicIsActive,
    this.dynamicDiscountModel,
    this.selectedPerson,
  });

  final bool dynamicIsActive;

  final DynamicDiscountModel? dynamicDiscountModel;
  final PosClientModel? selectedPerson;

  @override
  State<DiscountSection> createState() => _DiscountSectionState();
}

class _DiscountSectionState extends State<DiscountSection> {
  final _discountCodeController = TextEditingController(text: '');
  bool _isPercentageDiscount = true;

  @override
  void initState() {
    super.initState();
    _syncCustomerDiscount();
  }

  @override
  void didUpdateWidget(covariant DiscountSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedPerson != widget.selectedPerson ||
        oldWidget.dynamicIsActive != widget.dynamicIsActive) {
      _syncCustomerDiscount();
    }
  }

  @override
  void dispose() {
    _discountCodeController.dispose();
    super.dispose();
  }

  void _syncCustomerDiscount() {
    final person = widget.selectedPerson;
    if (widget.dynamicIsActive && person != null && person.discountRatio != 0) {
      context.read<CartBloc>().add(
        const ChangeDiscountTypeEvent(DiscountTypeEnum.direct),
      );
      _discountCodeController.text = person.discountRatio?.toString() ?? "";
    }
  }

  void _applyDiscount(CartState state) {
    if (widget.dynamicIsActive) return;

    final textValue = _discountCodeController.text.trim();
    if (textValue.isEmpty) return;

    if (state.selectedDiscountType == DiscountTypeEnum.direct) {
      final discountValue = double.tryParse(textValue) ?? 0.0;
      context.read<CartBloc>().add(
        ApplyDiscountEvent(
          restaurantPosDiscountRequest: RestaurantPosDiscountRequest(
            type: _isPercentageDiscount ? 1 : 2, // 1 for %, 2 for fixed SAR
            value: discountValue,
          ),
        ),
      );
    } else {
      context.read<CartBloc>().add(
        ApplyVoucherDiscountEvent(
          request: CheckVoucherRequest(
            code: _discountCodeController.text,
            posType: state.selectedOrderType.apiValue,
            customerId: state.selectedPerson?.id,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = context.watch<CartBloc>().state;
    final discountType = context.select(
      (CartBloc b) => b.state.selectedDiscountType,
    );
    final spacing = context.spacing;
    final icons = context.iconSizes;
    final buttonTheme = context.appExtraTheme;

    final lang = S.of(context);
    final discountEnabled =
        (!widget.dynamicIsActive &&
            !HelperMethods.anyItemHasDiscount(state.items)) &&
        state.canEdit;
    ValueChanged<DiscountTypeEnum?> onTypeChanged() {
      return (val) {
        if (widget.dynamicIsActive) return;

        if (val != null) {
          context.read<CartBloc>().add(ChangeDiscountTypeEvent(val));
        }
      };
    }

    return Container(
      padding: EdgeInsets.all(spacing.sm),
      decoration: BoxDecoration(
        color: theme.colorScheme.onSurface,
        borderRadius: BorderRadius.circular(spacing.radiusLg),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Column(
        children: [
          Wrap(
            children: [
              AppRadioGroup<DiscountTypeEnum>(
                value: DiscountTypeEnum.coupon,
                groupValue: discountType,
                enabled: true,
                label: Text(
                  lang.coupon,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                selectedColor: theme.colorScheme.primary,
                unselectedColor: theme.colorScheme.onSecondary,
                onChanged: onTypeChanged(),
              ),
              SizedBox(width: spacing.md),

              AppRadioGroup<DiscountTypeEnum>(
                value: DiscountTypeEnum.direct,
                groupValue: discountType,
                enabled: discountEnabled,

                label: Text(
                  lang.directDiscount,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                selectedColor: theme.colorScheme.primary,
                unselectedColor: theme.colorScheme.onSecondary,
                onChanged: onTypeChanged(),
              ),
            ],
          ),
          if (state.selectedDiscountType == DiscountTypeEnum.direct)
            DiscountTypeToggle(
              enabled: discountEnabled,
              isPercentage: _isPercentageDiscount,
              onChanged: (value) =>
                  setState(() => _isPercentageDiscount = value),
            ),
          SizedBox(height: spacing.sm),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _discountCodeController,

                  //   enabled: discountEnabled,
                  decoration: InputDecoration(
                    hintText:
                        state.selectedDiscountType == DiscountTypeEnum.direct
                        ? lang.enterDiscountValue
                        : lang.enterDiscountCode,
                    prefixIcon: Icon(
                      Icons.local_offer_outlined,
                      color: theme.colorScheme.tertiary,
                      size: icons.sm,
                    ),
                  ),
                ),
              ),
              SizedBox(width: spacing.xs),
              Container(
                padding: EdgeInsets.symmetric(horizontal: spacing.sm),
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: buttonTheme.background.withOpacity(.1),
                  borderRadius: BorderRadius.circular(spacing.radiusMd),
                ),

                child: TextButton(
                  onPressed: widget.dynamicIsActive || !state.canEdit
                      ? null
                      : () => _applyDiscount(state),
                  child: Text(
                    lang.apply,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: buttonTheme.subtitleColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: spacing.xs),

          if (state.voucherData != null &&
              state.selectedDiscountType == DiscountTypeEnum.coupon)
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: spacing.md,
                vertical: spacing.xxs,
              ),
              decoration: BoxDecoration(
                color: context.appExtraTheme.greenBackground.withOpacity(.3),
                border: BoxBorder.all(
                  color: context.appExtraTheme.greenBackground,
                ),
                borderRadius: BorderRadius.circular(spacing.radiusLg),
              ),
              child: Row(
                children: [
                  Text(
                    lang.voucherApplied(state.voucherData?.discountValue ?? 0),
                  ),
                  Spacer(),
                  InkWell(
                    onTap: () {
                      context.read<CartBloc>().add(ClearVoucherDiscountEvent());
                      _discountCodeController.clear();
                    },
                    child: Icon(
                      Icons.close,
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ],
              ),
            ),
          SizedBox(height: spacing.md),
          if (state.isManualItemDiscountApplied)
            Container(
              padding: EdgeInsets.all(spacing.sm),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(spacing.radiusMd),
              ),
              child: Text(
                lang.invoiceDiscountNotAllowed,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.error,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
