import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/helpers/helper_methods.dart';
import '../../../../core/helpers/size_helper.dart';
import '../../../../generated/l10n.dart';
import '../../../cart/data/enums/cart_enum.dart';
import '../../../cart/presentation/bloc/cart_bloc.dart';
import '../../../cart/presentation/bloc/cart_event.dart';
import '../../../cart/presentation/bloc/cart_state.dart';
import '../../data/models/category_model.dart';
import '../../data/models/restaurant_item.dart';
import '../../domain/entities/order_item.dart';
import '../bloc/pos_bloc.dart';
import '../bloc/pos_event.dart';
import '../tablet_widgets/tablet_item_customization.dart';
import 'item_customization_sheet.dart';

/// Company id used to price the menu. Only meaningful for delivery-company orders.
extension PosMenuCartX on CartState {
  int? get menuCompanyId => selectedOrderType == CartOrderType.DELIVERY_COMPANY
      ? selectedDeliveryCompany?.id
      : null;
}

/// Single entry point for "add item" on both mobile and tablet.
class PosAddItemHandler {
  const PosAddItemHandler._();

  static void onAddPressed(BuildContext context, RestaurantItem item) {
    final cartBloc = context.read<CartBloc>();
    final posBloc = context.read<PosBloc>();
    final cartState = cartBloc.state;

    // Return / previous invoices can't receive new items.
    if (!cartState.canEditInvoice) return;

    if (cartState.selectedPerson == null) {
      HelperMethods.openPicker(context, cartState.persons);
      return;
    }

    if (item.sizes.isEmpty) {
      HelperMethods.showSnackBar(
        context: context,
        message: S.of(context).thisItemHasNoValidSize,
        isError: true,
      );
      return;
    }

    final additives = _additivesFor(posBloc, item);
    final needsCustomization = item.sizes.length > 1 || additives.isNotEmpty;

    // Tablet keeps quick-add for simple items; mobile always opens the sheet
    // (notes / discount live there).
    final quickAdd = !SizeHelper.isMobile && !needsCustomization;
    if (quickAdd) {
      cartBloc.add(
        AddOrderItemToCartEvent(
          OrderItem(
            transactionId: "",
            menuItem: item,
            selectedSize: item.sizes.first,
            quantity: 1,
          ),
        ),
      );
      return;
    }

    void onConfirm(
      RestaurantItem customItem,
      List<AdditiveModel> _, {
      required dynamic selectedSize,
      required List<AdditiveModel> selectedAddons,
      required double discount,
      required bool isPercentageDiscount,
      required String notes,
      required int quantity,
    }) {
      cartBloc.add(
        AddOrderItemToCartEvent(
          OrderItem(
            transactionId: "",
            menuItem: customItem,
            selectedSize: selectedSize as ItemSize,
            addons: selectedAddons,
            quantity: quantity,
            notes: notes,
            discount: discount,
            isPercentageDiscount: isPercentageDiscount,
          ),
        ),
      );
    }

    if (SizeHelper.isMobile) {
      ItemCustomizationSheet.show(context, item, posBloc, onConfirm);
    } else {
      TabletItemCustomizationDialog.show(context, item, posBloc, onConfirm);
    }
  }

  static List<AdditiveModel> _additivesFor(PosBloc bloc, RestaurantItem item) {
    final match = bloc.state.categories.where((c) => c.id == item.categoryId);
    return match.isNotEmpty ? (match.first.additives ?? const []) : const [];
  }
}

/// Reloads the menu (with the right prices) when the delivery-company
/// pricing context changes. Wrap the menu body with it.
class PosMenuCompanySync extends StatelessWidget {
  const PosMenuCompanySync({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocListener<CartBloc, CartState>(
      listenWhen: (p, c) => p.menuCompanyId != c.menuCompanyId,
      listener: (context, cart) {
        final pos = context.read<PosBloc>();
        final category = pos.state.selectedCategory;
        if (category == null) return;
        pos.add(
          SelectCategoryEvent(
            category: category,
            deliveryCompanyId: cart.menuCompanyId,
          ),
        );
      },
      child: child,
    );
  }
}
