// ignore_for_file: deprecated_member_use

import 'package:apex_restaurant/core/helpers/extensions.dart';
import 'package:apex_restaurant/core/router/routes.dart';
import 'package:apex_restaurant/core/themes/app_colors.dart';
import 'package:apex_restaurant/featchers/cart/presentation/bloc/cart_bloc.dart';
import 'package:apex_restaurant/featchers/cart/presentation/bloc/cart_event.dart';
import 'package:apex_restaurant/featchers/cart/presentation/bloc/cart_state.dart';
import 'package:apex_restaurant/featchers/cart/presentation/ui/widgets/cart_top_bar.dart';
import 'package:apex_restaurant/featchers/pos/domain/entities/menu_item.dart';
import 'package:apex_restaurant/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: BlocConsumer<CartBloc, CartState>(
        listener: (context, state) {
          if (state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
                backgroundColor: theme.colorScheme.error,
              ),
            );
          }
          if (state.successMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.successMessage!),
                backgroundColor: theme.colorScheme.primary,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 700;
              final contentWidth = isWide ? 700.0 : constraints.maxWidth;

              return Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.all(spacing.md),
                      child: Center(
                        child: SizedBox(
                          width: contentWidth,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const CartTopBar(),
                              const _HeaderInfoCard(),
                              SizedBox(height: spacing.sm),
                              const _OrderTypeSelector(),
                              SizedBox(height: spacing.sm),
                              const _CustomerInfoCard(),
                              SizedBox(height: spacing.sm),
                              _buildDynamicTypeSelection(state),
                              SizedBox(height: spacing.md),
                              ...state.items.asMap().entries.map((entry) {
                                return _CartItemTile(
                                  index: entry.key,
                                  item: entry.value,
                                );
                              }),
                              SizedBox(height: spacing.md),
                              const _DiscountSection(),
                              SizedBox(height: spacing.md),
                              const _OrderSummaryCard(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const _BottomActionBar(),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildDynamicTypeSelection(CartState state) {
    switch (state.selectedOrderType) {
      case OrderType.dineIn:
        return const _DineInSelector();
      case OrderType.delivery:
        return const _DeliveryAgentSelector();
      case OrderType.deliveryCompany:
        return const _DeliveryCompanySelector();
      case OrderType.takeaway:
        return const SizedBox.shrink();
    }
  }
}

// -----------------------------------------------------------------------------
// Sub-Widgets
// -----------------------------------------------------------------------------

class _HeaderInfoCard extends StatelessWidget {
  const _HeaderInfoCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;
    final lang = S.of(context);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: spacing.md,
        vertical: spacing.sm,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.4),
        borderRadius: BorderRadius.circular(spacing.radiusLg),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _HeaderInfoItem(title: lang.orderNumber, value: '#12345'),
          _HeaderInfoItem(
            title: lang.invoiceNumber,
            value: 'INV-9876',
            isValueBlue: true,
          ),
          _HeaderInfoItem(title: lang.date, value: '10/07/2026'),
        ],
      ),
    );
  }
}

class _HeaderInfoItem extends StatelessWidget {
  final String title;
  final String value;
  final bool isValueBlue;

  const _HeaderInfoItem({
    required this.title,
    required this.value,
    this.isValueBlue = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Text(
          title,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        SizedBox(height: context.spacing.xxs),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: isValueBlue
                ? theme.colorScheme.primary
                : theme.colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}

class _OrderTypeSelector extends StatelessWidget {
  const _OrderTypeSelector();

  @override
  Widget build(BuildContext context) {
    context.select((CartBloc b) => b.state.selectedOrderType);
    final spacing = context.spacing;
    final lang = S.of(context);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildChip(
            context,
            OrderType.takeaway,
            lang.takeaway,
            Icons.shopping_bag_outlined,
          ),
          SizedBox(width: spacing.xs),
          _buildChip(context, OrderType.dineIn, lang.dineIn, Icons.restaurant),
          SizedBox(width: spacing.xs),
          _buildChip(
            context,
            OrderType.delivery,
            lang.delivery,
            Icons.two_wheeler,
          ),
          SizedBox(width: spacing.xs),
          _buildChip(
            context,
            OrderType.deliveryCompany,
            lang.deliveryCompanies,
            Icons.storefront,
          ),
        ],
      ),
    );
  }

  Widget _buildChip(
    BuildContext context,
    OrderType type,
    String label,
    IconData icon,
  ) {
    final theme = Theme.of(context);
    final isSelected = context.select(
      (CartBloc b) => b.state.selectedOrderType == type,
    );
    final spacing = context.spacing;
    final icons = context.iconSizes;

    final activeColor = theme.colorScheme.primary;
    final inactiveColor = theme.colorScheme.surfaceContainerHighest;
    final activeTextColor = theme.colorScheme.onPrimary;
    final inactiveTextColor = theme.colorScheme.onSurfaceVariant;

    return InkWell(
      onTap: () => context.read<CartBloc>().add(ChangeOrderTypeEvent(type)),
      borderRadius: BorderRadius.circular(spacing.radiusPill),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          horizontal: spacing.md,
          vertical: spacing.xs,
        ),
        decoration: BoxDecoration(
          color: isSelected ? activeColor : inactiveColor,
          borderRadius: BorderRadius.circular(spacing.radiusPill),
          border: Border.all(
            color: isSelected ? activeColor : theme.colorScheme.outlineVariant,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: icons.sm,
              color: isSelected ? activeTextColor : inactiveTextColor,
            ),
            SizedBox(width: spacing.xxs + spacing.xxs / 2),
            Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: isSelected ? activeTextColor : inactiveTextColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CustomerInfoCard extends StatelessWidget {
  const _CustomerInfoCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;
    final icons = context.iconSizes;
    final lang = S.of(context);

    return Container(
      padding: EdgeInsets.all(spacing.sm),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
        borderRadius: BorderRadius.circular(spacing.radiusLg),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: theme.colorScheme.primaryContainer,
            radius: icons.lg - icons.sm / 2,
            child: Icon(
              Icons.person,
              color: theme.colorScheme.onPrimaryContainer,
              size: icons.md,
            ),
          ),
          SizedBox(width: spacing.sm),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'أحمد محمود',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              Text(
                lang.registeredCustomer,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const Spacer(),
          TextButton.icon(
            onPressed: () {},
            icon: Icon(
              Icons.person_add_outlined,
              size: icons.sm,
              color: theme.colorScheme.primary,
            ),
            label: Text(
              lang.addCustomer,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DineInSelector extends StatelessWidget {
  const _DineInSelector();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;
    final icons = context.iconSizes;
    final lang = S.of(context);

    return Container(
      padding: EdgeInsets.all(spacing.sm),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
        borderRadius: BorderRadius.circular(spacing.radiusLg),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Column(
        children: [
          DropdownButtonFormField<String>(
            decoration: InputDecoration(
              hintText: lang.selectWaiter,
              contentPadding: EdgeInsets.symmetric(
                horizontal: spacing.sm,
                vertical: spacing.xs,
              ),
            ),
            items: const [],
            onChanged: (val) {},
          ),
          SizedBox(height: spacing.xs + spacing.xxs / 2),
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              minimumSize: Size.fromHeight(icons.xl + spacing.md),
              side: BorderSide(color: theme.colorScheme.tertiary),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(spacing.radiusMd),
              ),
            ),
            onPressed: () {},
            icon: Icon(
              Icons.table_restaurant,
              color: theme.colorScheme.tertiary,
              size: icons.md,
            ),
            label: Text(
              lang.selectTable,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.tertiary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DeliveryAgentSelector extends StatelessWidget {
  const _DeliveryAgentSelector();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;
    final lang = S.of(context);

    return Container(
      padding: EdgeInsets.all(spacing.sm),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
        borderRadius: BorderRadius.circular(spacing.radiusLg),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          hintText: lang.selectDeliveryAgent,
          prefixIcon: Icon(
            Icons.two_wheeler,
            color: theme.colorScheme.primary,
            size: context.iconSizes.md,
          ),
        ),
        items: const [],
        onChanged: (val) {},
      ),
    );
  }
}

class _DeliveryCompanySelector extends StatelessWidget {
  const _DeliveryCompanySelector();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;
    final lang = S.of(context);

    return Container(
      padding: EdgeInsets.all(spacing.sm),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
        borderRadius: BorderRadius.circular(spacing.radiusLg),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          hintText: lang.deliveryCompanyDetails,
          prefixIcon: Icon(
            Icons.storefront,
            color: theme.colorScheme.primary,
            size: context.iconSizes.md,
          ),
        ),
        items: const [],
        onChanged: (val) {},
      ),
    );
  }
}

class _CartItemTile extends StatelessWidget {
  final int index;
  final OrderItem item;

  const _CartItemTile({required this.index, required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;
    final icons = context.iconSizes;
    final lang = S.of(context);

    final sizeName = item.selectedSize?.sizeNameAr ?? '';
    final addonsText = item.addons.map((a) => a.arabicName).join(', ');

    return Container(
      margin: EdgeInsets.only(bottom: spacing.sm),
      padding: EdgeInsets.all(spacing.sm),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
        borderRadius: BorderRadius.circular(spacing.radiusLg),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(spacing.radiusMd),
            child: Container(
              width: icons.xl * 2.2,
              height: icons.xl * 2.2,
              color: theme.colorScheme.surfaceContainerHighest,
              child: item.menuItem.imagePath != null
                  ? Image.network(item.menuItem.imagePath!, fit: BoxFit.cover)
                  : Icon(
                      Icons.fastfood,
                      color: theme.colorScheme.onSurfaceVariant,
                      size: icons.lg,
                    ),
            ),
          ),
          SizedBox(width: spacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        item.menuItem.itemNameAr,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                    ),
                    Text(
                      '${item.totalPrice.toStringAsFixed(2)} ${lang.currencySar}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
                if (sizeName.isNotEmpty) ...[
                  SizedBox(height: spacing.xxs),
                  Text(
                    lang.sizeWithVal(sizeName),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
                if (addonsText.isNotEmpty) ...[
                  SizedBox(height: spacing.xxs),
                  Text(
                    lang.addonsWithVal(addonsText),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.tertiary,
                    ),
                  ),
                ],
                if (item.notes != null && item.notes!.isNotEmpty) ...[
                  SizedBox(height: spacing.xxs),
                  Text(
                    lang.notesWithVal(item.notes!),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
                SizedBox(height: spacing.xs),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.delete_sharp,
                        color: theme.colorScheme.error,
                        size: icons.lg,
                      ),
                      onPressed: () =>
                          context.read<CartBloc>().add(RemoveItemEvent(index)),
                    ),
                    const Spacer(),
                    Container(
                      height: spacing.xxl,
                      decoration: BoxDecoration(
                        color: AppColors.border,
                        borderRadius: BorderRadius.circular(spacing.radiusSm),
                        border: Border.all(
                          color: theme.colorScheme.outlineVariant,
                        ),
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.remove, size: icons.sm),
                            color: theme.colorScheme.onSurface,
                            onPressed: () => context.read<CartBloc>().add(
                              UpdateItemQuantityEvent(index, -1),
                            ),
                          ),
                          Text(
                            '${item.quantity}',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.add, size: icons.sm),
                            color: theme.colorScheme.onSurface,
                            onPressed: () => context.read<CartBloc>().add(
                              UpdateItemQuantityEvent(index, 1),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DiscountSection extends StatelessWidget {
  const _DiscountSection();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final discountType = context.select(
      (CartBloc b) => b.state.selectedDiscountType,
    );
    final spacing = context.spacing;
    final icons = context.iconSizes;
    final lang = S.of(context);

    return Container(
      padding: EdgeInsets.all(spacing.sm),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
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
                activeColor: theme.colorScheme.primary,
                onChanged: (val) {
                  if (val != null) {
                    context.read<CartBloc>().add(ChangeDiscountTypeEvent(val));
                  }
                },
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
                activeColor: theme.colorScheme.primary,
                onChanged: (val) {
                  if (val != null) {
                    context.read<CartBloc>().add(ChangeDiscountTypeEvent(val));
                  }
                },
              ),
              Text(
                lang.directDiscount,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: spacing.xs),
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: lang.enterDiscountCode,
                    prefixIcon: Icon(
                      Icons.local_offer_outlined,
                      color: theme.colorScheme.tertiary,
                      size: icons.sm,
                    ),
                  ),
                ),
              ),
              SizedBox(width: spacing.xs),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primaryContainer
                      .withOpacity(.1),
                  foregroundColor: theme.colorScheme.onPrimaryContainer,
                  elevation: 0,
                  padding: EdgeInsets.symmetric(
                    horizontal: spacing.lg,
                    vertical: spacing.sm + spacing.xxs / 2,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(spacing.radiusMd),
                  ),
                ),
                onPressed: () {},
                child: Text(
                  lang.apply,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
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

class _OrderSummaryCard extends StatelessWidget {
  const _OrderSummaryCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = context.watch<CartBloc>().state;
    final spacing = context.spacing;
    final lang = S.of(context);

    return Container(
      padding: EdgeInsets.all(spacing.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
        borderRadius: BorderRadius.circular(spacing.radiusLg),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Column(
        children: [
          _summaryRow(
            context,
            lang.subtotal,
            '${state.subtotal.toStringAsFixed(2)} ${lang.currencySar}',
          ),
          SizedBox(height: spacing.xs),
          _summaryRow(
            context,
            lang.discountCoupon,
            '-${state.discountAmount.toStringAsFixed(2)} ${lang.currencySar}',
            isSuccess: true,
          ),
          if (state.selectedOrderType == OrderType.delivery ||
              state.selectedOrderType == OrderType.deliveryCompany) ...[
            SizedBox(height: spacing.xs),
            _summaryRow(
              context,
              lang.deliveryFee,
              '${state.deliveryFee.toStringAsFixed(2)} ${lang.currencySar}',
            ),
          ],
          SizedBox(height: spacing.xs),
          _summaryRow(
            context,
            lang.vat15,
            '${state.vatAmount.toStringAsFixed(2)} ${lang.currencySar}',
          ),
          Divider(height: spacing.xl, color: theme.colorScheme.outlineVariant),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                lang.grandTotal,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${state.grandTotal.toStringAsFixed(2)} ${lang.currencySar}',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(
    BuildContext context,
    String title,
    String value, {
    bool isSuccess = false,
  }) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: theme.textTheme.bodySmall?.copyWith(
            color: isSuccess
                ? AppColors.green
                : theme.colorScheme.onSurfaceVariant,
          ),
        ),
        Text(
          value,
          style: theme.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: isSuccess ? AppColors.green : theme.colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}

class _BottomActionBar extends StatelessWidget {
  const _BottomActionBar();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;
    final icons = context.iconSizes;
    final lang = S.of(context);

    return Container(
      padding: EdgeInsets.all(spacing.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          top: BorderSide(color: theme.colorScheme.outlineVariant),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: spacing.sm - spacing.xxs / 2,
            offset: Offset(0, -spacing.xxs),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
                padding: EdgeInsets.symmetric(
                  vertical: spacing.sm + spacing.xxs / 2,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(spacing.radiusMd),
                ),
              ),
              onPressed: () => context.pushNamed(Routes.paymentScreen),
              icon: Icon(Icons.payments_outlined, size: icons.md),
              label: Text(
                lang.checkout,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(width: spacing.sm),
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(
                horizontal: spacing.md,
                vertical: spacing.sm + spacing.xxs / 2,
              ),
              side: BorderSide(color: theme.colorScheme.outline),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(spacing.radiusMd),
              ),
            ),
            onPressed: () =>
                context.read<CartBloc>().add(HoldOrderSubmittedEvent()),
            icon: Icon(
              Icons.pause_circle_outline,
              color: theme.colorScheme.onSurface,
              size: icons.md,
            ),
            label: Text(
              lang.holdOrder,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
