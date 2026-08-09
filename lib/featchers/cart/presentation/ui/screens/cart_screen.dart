import 'package:apex_restaurant/core/helpers/extensions.dart';
import 'package:apex_restaurant/core/helpers/helper_methods.dart';
import 'package:apex_restaurant/core/helpers/restaurant_constants.dart';
import 'package:apex_restaurant/featchers/cart/data/enums/cart_enum.dart';
import 'package:apex_restaurant/featchers/cart/data/models/get_client_request.dart';
import 'package:apex_restaurant/featchers/cart/presentation/bloc/cart_bloc.dart';
import 'package:apex_restaurant/featchers/cart/presentation/bloc/cart_event.dart';
import 'package:apex_restaurant/featchers/cart/presentation/bloc/cart_state.dart';
import 'package:apex_restaurant/featchers/cart/presentation/ui/widgets/address_card.dart';
import 'package:apex_restaurant/featchers/cart/presentation/ui/widgets/bottom_action_bar.dart';
import 'package:apex_restaurant/featchers/cart/presentation/ui/widgets/cart_item_tile.dart';
import 'package:apex_restaurant/featchers/cart/presentation/ui/widgets/cart_top_bar.dart';
import 'package:apex_restaurant/featchers/cart/presentation/ui/widgets/customer_info_card.dart';
import 'package:apex_restaurant/featchers/cart/presentation/ui/widgets/delivery_agent_selector.dart';
import 'package:apex_restaurant/featchers/cart/presentation/ui/widgets/delivery_company_selector.dart';
import 'package:apex_restaurant/featchers/cart/presentation/ui/widgets/dine_in_selector.dart';
import 'package:apex_restaurant/featchers/cart/presentation/ui/widgets/discount_section.dart';
import 'package:apex_restaurant/featchers/cart/presentation/ui/widgets/header_info_card.dart';
import 'package:apex_restaurant/featchers/cart/presentation/ui/widgets/order_summary_card.dart';
import 'package:apex_restaurant/featchers/cart/presentation/ui/widgets/order_type_selector.dart';
import 'package:apex_restaurant/featchers/cart/presentation/ui/widgets/takeaway_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CartBloc>().add(LoadCartDataEvent());
      context.read<CartBloc>().add(LoadDynamicDiscountsEvent());
      context.read<CartBloc>().add(
        LoadPersonsData(request: GetClientsRequest(isSupplier: false)),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: CartTopBar(
        onClearAll: () => context.read<CartBloc>().add(ClearCartEvent()),
      ),
      backgroundColor: theme.colorScheme.surface,
      body: BlocConsumer<CartBloc, CartState>(
        listener: _onCartStateChanged,
        builder: (context, state) {
          if (state.status == CartStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          return _CartContent(state: state);
        },
      ),
    );
  }

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
}

/// The scrollable body of the cart screen plus the fixed bottom action bar.
class _CartContent extends StatelessWidget {
  const _CartContent({required this.state});

  final CartState state;

  Widget _orderTypeSpecificSection(CartState state) {
    switch (state.selectedOrderType) {
      case CartOrderType.TAKEAWAY:
        return SizedBox.shrink();
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
        return DeliveryCompanySelector(
          deliveryCompanies: state.deliveryCompanies,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 700;
        final contentWidth = isWide ? 700.0 : constraints.maxWidth;
        final showAddressCard =
            state.selectedOrderType == CartOrderType.DELIVERY;
        final selectedPerson =
            state.selectedPerson ??
            (state.persons.isNotEmpty ? state.persons.first : null);

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
                            addresses:
                                state.selectedPerson?.personAddress ?? const [],
                          ),
                        ],
                        SizedBox(height: spacing.sm),
                        _orderTypeSpecificSection(state),
                        SizedBox(height: spacing.md),
                        ...state.items.asMap().entries.map(
                          (entry) =>
                              CartItemTile(index: entry.key, item: entry.value),
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
              ),
            ),
            const BottomActionBar(),
          ],
        );
      },
    );
  }
}
