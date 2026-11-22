import 'dart:developer';

import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

class CartScreen extends StatefulWidget {
  const CartScreen({super.key, this.args});

  final CartScreenArgs? args;

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      final cartBloc = context.read<CartBloc>();

      if (widget.args?.isRestored == true) {
        cartBloc.add(const AcknowledgeCartRestoredEvent());
      }

      cartBloc
        ..add(LoadCartDataEvent())
        ..add(LoadDynamicDiscountsEvent())
        ..add(LoadPersonsData(request: GetClientsRequest(isSupplier: false)));
    });
  }

  bool _shouldClearCartOnExit(CartState state) {
    return (state.isPreviousInvoice && !state.canEdit) || state.isReturn;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocConsumer<CartBloc, CartState>(
      listener: _onCartStateChanged,
      builder: (context, state) {
        log(
          'CartScreen build: canEdit=${state.canEdit}, '
          'isPreviousInvoice=${state.isPreviousInvoice}',
        );

        if (state.status == CartStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        return SafeArea(
          top: false,
          child: PopScope(
            canPop: true,
            onPopInvokedWithResult: (didPop, result) {
              if (didPop && _shouldClearCartOnExit(state)) {
                context.read<CartBloc>().add(ClearCartEvent());
              }
            },
            child: Scaffold(
              appBar: CartTopBar(
                onClearAll: state.canEdit
                    ? () => context.read<CartBloc>().add(ClearCartEvent())
                    : null,
                onBack: () => context.pop(),
              ),
              backgroundColor: theme.colorScheme.surface,
              body: _CartContent(state: state),
            ),
          ),
        );
      },
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

/// Scrollable cart content with a fixed bottom action bar.
class _CartContent extends StatefulWidget {
  const _CartContent({required this.state});

  final CartState state;

  @override
  State<_CartContent> createState() => _CartContentState();
}

class _CartContentState extends State<_CartContent> {
  late final TextEditingController _fromBranchController;

  String _formattedFromBranchDate(DateTime? dateTime) {
    return dateTime == null
        ? ''
        : RestaurantConstants.dateTimeFormat.format(dateTime);
  }

  @override
  void initState() {
    super.initState();
    _fromBranchController = TextEditingController(
      text: _formattedFromBranchDate(widget.state.fromBranchDateTime),
    );
  }

  @override
  void didUpdateWidget(covariant _CartContent oldWidget) {
    super.didUpdateWidget(oldWidget);

    final oldValue = _formattedFromBranchDate(
      oldWidget.state.fromBranchDateTime,
    );
    final newValue = _formattedFromBranchDate(widget.state.fromBranchDateTime);

    if (oldValue != newValue && _fromBranchController.text != newValue) {
      _fromBranchController.text = newValue;
    }
  }

  @override
  void dispose() {
    _fromBranchController.dispose();
    super.dispose();
  }

  Widget _orderTypeSpecificSection(CartState state) {
    switch (state.selectedOrderType) {
      case CartOrderType.TAKEAWAY:
        return const SizedBox.shrink();
      case CartOrderType.DELIVERY:
        return DeliveryAgentSelector(deliveryMens: state.deliveryAgents);
      case CartOrderType.DINE_IN:
        return DineInSelector(persons: state.persons, waiters: state.waiters);
      case CartOrderType.FROMBRANCH:
        return TakeawaySection(controller: _fromBranchController);
      case CartOrderType.DELIVERY_COMPANY:
        return DeliveryCompanySelector();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    final spacing = context.spacing;
    final canEdit = state.canEdit;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 700;
        final contentWidth = isWide ? 700.0 : constraints.maxWidth;
        final showAddressCard =
            state.selectedOrderType == CartOrderType.DELIVERY;

        final selectedPerson =
            state.selectedPerson ??
            (state.persons.isNotEmpty ? state.persons.first : null);

        final saveButtonDisabled =
            !canEdit ||
            state.status == CartStatus.saveDineInInvoiceSuccess ||
            state.items.isEmpty;

        final showBottomActionBar = canEdit || state.isReturn;

        return Column(
          children: [
            if (state.isCalculating)
              const LinearProgressIndicator(minHeight: 2),

            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.all(spacing.md),
                      child: IgnorePointer(
                        ignoring: !canEdit,
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
                                        state.selectedPerson?.personAddress ??
                                        const [],
                                  ),
                                ],
                                SizedBox(height: spacing.sm),
                                _orderTypeSpecificSection(state),
                                SizedBox(height: spacing.md),
                                for (
                                  var index = 0;
                                  index < state.items.length;
                                  index++
                                )
                                  CartItemTile(
                                    index: index,
                                    item: state.items[index],
                                  ),
                                // BlocBuilder<CartBloc, CartState>(
                                //   builder: (context, cartState) {
                                //     if (cartState.status ==
                                //         CartStatus.itemsUpdateing) {
                                //       return const Center(
                                //         child: CircularProgressIndicator(),
                                //       );
                                //     }

                                //     return Column(
                                //       children: [
                                //         for (
                                //           int index = 0;
                                //           index < cartState.items.length;
                                //           index++
                                //         )
                                //           CartItemTile(
                                //             index: index,
                                //             item: cartState.items[index],
                                //           ),
                                //       ],
                                //     );
                                //   },
                                // ),
                                SizedBox(height: spacing.md),
                                if (state.manualDiscountSettingOn)
                                  DiscountSection(
                                    selectedPerson: state.selectedPerson,
                                    dynamicIsActive:
                                        state.dynamicDiscountIsActive,
                                    dynamicDiscountModel:
                                        state.activeDiscountModel,
                                  ),
                                SizedBox(height: spacing.xxs),
                                const OrderSummaryCard(),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (!saveButtonDisabled)
                    Positioned(
                      left: spacing.md,
                      bottom: spacing.md,
                      child: FloatingActionButton(
                        onPressed: () {
                          context.read<CartBloc>().add(
                            SaveTableOrderEvent(
                              request: state.toSaveRestaurantPosInvoiceRequest,
                            ),
                          );
                        },
                        child: const Icon(Icons.save, color: Colors.white),
                      ),
                    ),
                ],
              ),
            ),
            if (showBottomActionBar) BottomActionBar(),
          ],
        );
      },
    );
  }
}
