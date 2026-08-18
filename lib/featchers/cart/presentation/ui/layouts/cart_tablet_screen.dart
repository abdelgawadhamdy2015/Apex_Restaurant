import '../../../../../core/helpers/extensions.dart';
import '../../../../../core/helpers/helper_methods.dart';
import '../../../../../core/helpers/restaurant_constants.dart';
import '../../../data/enums/cart_enum.dart';
import '../../bloc/cart_bloc.dart';
import '../../bloc/cart_event.dart';
import '../../bloc/cart_state.dart';
import '../widgets/address_card.dart';
import '../widgets/bottom_action_bar.dart';
import '../widgets/cart_item_tile.dart';
import '../widgets/cart_top_bar.dart';
import '../widgets/customer_info_card.dart';
import '../widgets/delivery_agent_selector.dart';
import '../widgets/delivery_company_selector.dart';
import '../widgets/dine_in_selector.dart';
import '../widgets/discount_section.dart';
import '../widgets/header_info_card.dart';
import '../widgets/order_summary_card.dart';
import '../widgets/order_type_selector.dart';
import '../widgets/takeaway_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PosTabletCartPanel extends StatelessWidget {
  const PosTabletCartPanel({super.key});

  void _onCartStateChanged(BuildContext context, CartState state) {
    if (state.errorMessage != null) {
      HelperMethods.showSnackBar(
        context: context,
        message: state.errorMessage ?? 'An error occurred',
        isError: true,
      );
    }
    if (state.successMessage != null) {
      HelperMethods.showSnackBar(
        context: context,
        message: state.successMessage ?? 'Saved successfully',
        isError: false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          right: BorderSide(color: theme.colorScheme.outlineVariant, width: 1),
        ),
      ),
      child: Column(
        children: [
          CartTopBar(
            isTablet: true,
            onClearAll: () => context.read<CartBloc>().add(ClearCartEvent()),
          ),
          Expanded(
            child: BlocConsumer<CartBloc, CartState>(
              listener: _onCartStateChanged,
              builder: (context, state) {
                if (state.status == CartStatus.loading) {
                  return const Center(child: CircularProgressIndicator());
                }
                return _PosTabletCartContent(state: state);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _PosTabletCartContent extends StatelessWidget {
  const _PosTabletCartContent({required this.state});

  final CartState state;

  Widget _orderTypeSpecificSection(CartState state) {
    switch (state.selectedOrderType) {
      case CartOrderType.TAKEAWAY:
        return const SizedBox.shrink();
      case CartOrderType.DELIVERY:
        return DeliveryAgentSelector(deliveryMens: state.deliveryAgents);
      case CartOrderType.DINE_IN:
        return DineInSelector(persons: state.persons, waiters: state.waiters);
      case CartOrderType.FROMBRANCH:
        return TakeawaySection(
          controller: TextEditingController(
            text: state.fromBranchDateTime != null
                ? RestaurantConstants.dateTimeFormat.format(
                    state.fromBranchDateTime!,
                  )
                : '',
          ),
        );
      case CartOrderType.DELIVERY_COMPANY:
        return DeliveryCompanySelector(deliveryCompanies: state.companiesList);
    }
  }

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;
    final showAddressCard = state.selectedOrderType == CartOrderType.DELIVERY;
    final selectedPerson =
        state.selectedPerson ??
        (state.persons.isNotEmpty ? state.persons.first : null);

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(spacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const HeaderInfoCard(),
                SizedBox(height: spacing.sm),
                const OrderTypeSelector(),
                SizedBox(height: spacing.sm),
                CustomerInfoCard(
                  persons: state.persons,
                  selectedPerson: selectedPerson,
                ),
                if (showAddressCard) ...[
                  SizedBox(height: spacing.sm),
                  AddressCard(
                    selectedAddress: state.selectedAddress,
                    addresses: state.selectedPerson?.personAddress ?? const [],
                  ),
                ],
                SizedBox(height: spacing.sm),
                _orderTypeSpecificSection(state),
                SizedBox(height: spacing.md),
                ...state.items.asMap().entries.map(
                  (entry) => CartItemTile(index: entry.key, item: entry.value),
                ),
                SizedBox(height: spacing.md),
                DiscountSection(
                  selectedPerson: state.selectedPerson,
                  dynamicIsActive: state.dynamicDiscountIsActive,
                  dynamicDiscountModel: state.activeDiscountModel,
                ),
                SizedBox(height: spacing.md),
                const OrderSummaryCard(),
              ],
            ),
          ),
        ),
        if (state.canEdit) const BottomActionBar(canEdit: false),
      ],
    );
  }
}
