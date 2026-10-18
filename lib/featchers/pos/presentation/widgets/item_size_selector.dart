import 'package:apex_restaurant/featchers/cart/presentation/bloc/cart_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/helpers/extensions.dart';
import '../../data/models/restaurant_item.dart';
import '../../../../generated/l10n.dart';
import 'package:material_ui/material_ui.dart';

class ItemSizeSelector extends StatelessWidget {
  const ItemSizeSelector({
    super.key,
    required this.sizes,
    required this.selectedIndex,
    required this.onSelected,
  });

  final List<ItemSize> sizes;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final spacing = context.spacing;
    final iconSizes = context.iconSizes;
    final lang = S.of(context);
    final cartState = context.select((CartBloc b) => b.state);
    return Row(
      children: List.generate(sizes.length, (index) {
        final size = sizes[index];
        final isSelected = selectedIndex == index;
        return Expanded(
          child: GestureDetector(
            onTap: () => cartState.isReturn ? null : onSelected(index),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: spacing.xxs),
              padding: EdgeInsets.all(spacing.sm),
              decoration: BoxDecoration(
                color: isSelected
                    ? theme.colorScheme.primary.withValues(alpha: 0.04)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(spacing.radiusLg),
                border: Border.all(
                  color: isSelected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.outlineVariant,
                  width: 2,
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        size.sizeNameAr ?? "",
                        style: textTheme.bodyLarge?.copyWith(
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                      Icon(
                        isSelected
                            ? Icons.radio_button_checked
                            : Icons.radio_button_off,
                        color: isSelected
                            ? theme.colorScheme.primary
                            : theme.colorScheme.onPrimary,
                        size: iconSizes.md,
                      ),
                    ],
                  ),
                  SizedBox(height: spacing.xs),
                  Text(
                    lang.priceWithCurrency(size.price?.toStringAsFixed(2) ?? 0),
                    style: textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isSelected
                          ? theme.colorScheme.primary
                          : theme.colorScheme.onSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
