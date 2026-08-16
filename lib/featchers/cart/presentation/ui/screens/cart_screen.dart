import '../../../../../core/helpers/extensions.dart';
import '../../../../../core/helpers/helper_methods.dart';
import '../../../../../core/helpers/restaurant_constants.dart';
import '../../../data/enums/cart_enum.dart';
import '../../../data/models/cart_screen_args.dart';
import '../../../data/models/get_client_request.dart';
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

class CartScreen extends StatefulWidget {
  const CartScreen({super.key, this.args});
  final CartScreenArgs? args;

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool get canEdit => widget.args?.canEdite ?? true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cartBloc = context.read<CartBloc>();

      if (widget.args?.isRestored == true) {
        cartBloc.add(const AcknowledgeCartRestoredEvent());
      } else {
        cartBloc.add(LoadCartDataEvent());
      }

      cartBloc.add(LoadDynamicDiscountsEvent());
      cartBloc.add(
        LoadPersonsData(request: GetClientsRequest(isSupplier: false)),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: CartTopBar(
        // Disable clear all button in top bar if editing is locked
        onClearAll: canEdit
            ? () => context.read<CartBloc>().add(ClearCartEvent())
            : null,
      ),
      backgroundColor: theme.colorScheme.surface,
      body: BlocConsumer<CartBloc, CartState>(
        listener: _onCartStateChanged,
        builder: (context, state) {
          if (state.status == CartStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          return IgnorePointer(
            ignoring:
                !canEdit, // Locks tap gestures on interactive inputs if read-only
            child: _CartContent(state: state, canEdit: canEdit),
          );
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
  const _CartContent({required this.state, required this.canEdit});

  final CartState state;
  final bool canEdit;

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
            // Re-enabled touch events for BottomActionBar if you need actions like print/exit
            // while passing down `canEdit` to disable save/submit buttons internally.
            IgnorePointer(
              ignoring: false,
              child: BottomActionBar(canEdit: canEdit),
            ),
          ],
        );
      },
    );
  }
}
