import 'package:apex_restaurant/core/helpers/extensions.dart';
import 'package:apex_restaurant/featchers/cart/data/models/dynamic_discount.dart';
import 'package:apex_restaurant/featchers/cart/data/models/invoice_request_model.dart';
import 'package:apex_restaurant/featchers/cart/data/models/pos_client_model.dart';
import 'package:apex_restaurant/featchers/cart/presentation/bloc/cart_bloc.dart';
import 'package:apex_restaurant/featchers/cart/presentation/bloc/cart_event.dart';
import 'package:apex_restaurant/featchers/cart/presentation/bloc/cart_state.dart';
import 'package:apex_restaurant/featchers/pos/presentation/widgets/discount_type_toggle.dart';
import 'package:apex_restaurant/generated/l10n.dart';
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
        const ChangeDiscountTypeEvent(DiscountType.direct),
      );
      _discountCodeController.text = person.discountRatio?.toString() ?? "";
    }
  }

  void _applyDiscount(CartState state) {
    if (widget.dynamicIsActive) return;

    final textValue = _discountCodeController.text.trim();
    if (textValue.isEmpty) return;

    if (state.selectedDiscountType == DiscountType.direct) {
      final discountValue = double.tryParse(textValue) ?? 0.0;
      context.read<CartBloc>().add(
        ApplyDiscountEvent(
          saveDiscountModel: SaveDiscountModel(
            type: _isPercentageDiscount ? 1 : 2, // 1 for %, 2 for fixed SAR
            value: discountValue,
          ),
        ),
      );
    } else {
      context.read<CartBloc>().add(ApplyCouponDiscountEvent(code: textValue));
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

    void Function(DiscountType?)? onTypeChanged() {
      if (widget.dynamicIsActive) return null;
      return (val) {
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
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Radio<DiscountType>(
                value: DiscountType.coupon,
                groupValue: discountType,
                activeColor: theme.colorScheme.onPrimary,
                backgroundColor: WidgetStateProperty.all(
                  theme.colorScheme.onSecondary,
                ),
                onChanged: onTypeChanged(),
              ),
              Text(
                lang.coupon,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(width: spacing.md),
              Radio<DiscountType>(
                value: DiscountType.direct,
                groupValue: discountType,
                activeColor: theme.colorScheme.onPrimary,
                backgroundColor: WidgetStateProperty.all(
                  theme.colorScheme.onSecondary,
                ),
                onChanged: onTypeChanged(),
              ),
              Text(
                lang.directDiscount,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          if (state.selectedDiscountType == DiscountType.direct)
            DiscountTypeToggle(
              enabled: !widget.dynamicIsActive,
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

                  //  enabled: !widget.dynamicIsActive,
                  decoration: InputDecoration(
                    hintText: state.selectedDiscountType == DiscountType.direct
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
                  color: buttonTheme.background,
                  borderRadius: BorderRadius.circular(spacing.radiusMd),
                ),

                child: TextButton(
                  onPressed: widget.dynamicIsActive
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
        ],
      ),
    );
  }
}
