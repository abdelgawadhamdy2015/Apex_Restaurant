// cart_state.dart

import 'package:apex_restaurant/featchers/cart/data/models/dynamic_discount.dart';
import 'package:apex_restaurant/featchers/cart/data/models/invoice_request_model.dart';
import 'package:apex_restaurant/featchers/cart/data/models/pos_client_model.dart';
import 'package:apex_restaurant/featchers/cart/data/models/waiter_model.dart';
import 'package:apex_restaurant/featchers/pos/data/models/delivery_company.dart';
import 'package:apex_restaurant/featchers/pos/domain/entities/menu_item.dart';
import 'package:apex_restaurant/featchers/tables/domain/entities/table_entity.dart';
import 'package:equatable/equatable.dart';

enum OrderType { takeaway, dineIn, delivery, deliveryCompany }

enum DiscountType { coupon, direct }

enum CartStatus { initial, loading, success, failure }

class CartState extends Equatable {
  final OrderType selectedOrderType;
  final CartStatus status;
  final DiscountType selectedDiscountType;
  final ClientAddressModel? selectedAddress;
  final TableEntity? selectedTable;
  final DateTime? takeawayDateTime;
  final List<OrderItem> items;
  final List<DynamicDiscountModel> discounts;
  final SaveDiscountModel? saveDiscountModel;
  final double? couponDiscountvalue;
  final bool dynamicDiscountIsActive;
  final DynamicDiscountModel? activeDiscountModel;
  final List<WaiterModel> waiters;
  final List<WaiterModel> deliveryAgents;
  final List<PosClientModel> persons;
  final PosClientModel? selectedPerson;
  final List<DeliveryCompanyModel> deliveryCompanies;
  final DeliveryCompanyModel? selectedDeliveryCompany;
  final WaiterModel? selectedWaiter;
  final WaiterModel? selectedDeliveryMan;
  final double discountAmount;
  final double deliveryFee;
  final double vatPercentage;
  final bool isLoading;
  final bool isSubmitting;
  final String? errorMessage;
  final String? successMessage;

  const CartState({
    this.selectedOrderType = OrderType.dineIn,
    this.selectedDiscountType = DiscountType.coupon,
    this.status = CartStatus.initial,
    this.items = const [],
    this.couponDiscountvalue,
    this.takeawayDateTime,
    this.waiters = const [],
    this.deliveryAgents = const [],
    this.persons = const [],
    this.deliveryCompanies = const [],
    this.selectedDeliveryCompany,
    this.selectedWaiter,
    this.selectedDeliveryMan,
    this.discountAmount = 0.0,
    this.deliveryFee = 6.00,
    this.vatPercentage = 0.15,
    this.isLoading = false,
    this.isSubmitting = false,
    this.errorMessage,
    this.successMessage,
    this.selectedAddress,
    this.selectedPerson,
    this.discounts = const [],
    this.dynamicDiscountIsActive = false,
    this.activeDiscountModel,
    this.saveDiscountModel,
    this.selectedTable,
  });

  SaveInvoiceRequestModel get toSaveInvoiceRequestModel {
    int posTypeInt;
    switch (selectedOrderType) {
      case OrderType.takeaway:
        posTypeInt = 1;
        break;
      case OrderType.dineIn:
        posTypeInt = 2;
        break;
      case OrderType.delivery:
        posTypeInt = 3;
        break;
      case OrderType.deliveryCompany:
        posTypeInt = 4;
        break;
    }

    SaveDiscountModel? appliedDiscount;
    int? activeInvoiceDiscountId;

    if (dynamicDiscountIsActive && activeDiscountModel != null) {
      activeInvoiceDiscountId = activeDiscountModel?.discount?.id;
      appliedDiscount = SaveDiscountModel(
        type: activeDiscountModel?.discount?.discountType,
        value: activeDiscountModel?.discount?.discountValue,
      );
    } else if (selectedDiscountType == DiscountType.direct &&
        saveDiscountModel != null) {
      appliedDiscount = saveDiscountModel;
    } else if (selectedDiscountType == DiscountType.coupon &&
        couponDiscountvalue != null) {
      appliedDiscount = SaveDiscountModel(
        type: 2, // Fixed amount coupon
        value: couponDiscountvalue,
      );
    }

    // 3. Map items to InvoiceItemModel list
    final invoiceItems = items.map((item) {
      return InvoiceItemModel(
        itemId: item.menuItem.itemId,
        sizeId: item.selectedSize?.sizeId,
        quantity: item.quantity.toDouble(),
        price: item.selectedSize?.price ?? item.menuItem.sizes.first.price,
        notes: item.notes,
        discount: item.discount > 0
            ? SaveDiscountModel(
                type: item.isPercentageDiscount ? 1 : 2,
                value: item.discount,
              )
            : null,
        additives: item.addons
            .map(
              (addon) => SaveAdditiveModel(
                additiveId: int.tryParse(addon.id) ?? 0,
                quantity: 1.0,
              ),
            )
            .toList(),
      );
    }).toList();

    // 4. Build SaveInvoiceModel
    final invoiceModel = SaveInvoiceModel(
      postype: posTypeInt,
      foodTableId: int.tryParse(selectedTable?.id ?? ''),
      waiterId: int.tryParse(selectedWaiter?.id?.toString() ?? ''),
      deliveryManId: int.tryParse(selectedDeliveryMan?.id?.toString() ?? ''),
      deliveryCompanyId: selectedDeliveryCompany?.id,
      clientId: selectedPerson?.id,
      takeawayDateTime: takeawayDateTime,
      discount: appliedDiscount,
      paidAmount: grandTotal,
      totalInvoicePrice: grandTotal,
      invoiceDiscountId: activeInvoiceDiscountId,
    );

    // 5. Return model with ONLY invoice & items mapped
    return SaveInvoiceRequestModel(invoice: invoiceModel, items: invoiceItems);
  }

  /// 1. Total raw price of items before discount or tax
  double get subtotal => items.fold(0.0, (sum, item) => sum + item.totalPrice);

  /// 2. Calculates total applied discount amount BEFORE tax
  double get totalDiscountAmount {
    double totalDiscount = 0.0;

    if (dynamicDiscountIsActive && activeDiscountModel != null) {
      // Dynamic Discount Priority
      final double value = activeDiscountModel?.discount?.discountValue ?? 0.0;
      final bool isPercentage =
          activeDiscountModel?.discount?.discountType == 1;

      if (isPercentage) {
        totalDiscount = subtotal * (value / 100);
      } else {
        totalDiscount = value;
      }
    } else {
      // Direct Discount (SaveDiscountModel)
      if (selectedDiscountType == DiscountType.direct &&
          saveDiscountModel != null &&
          saveDiscountModel!.value != null) {
        final double directVal = saveDiscountModel!.value!;
        // type 1 = Percentage, type 2 or 0 = Fixed Amount
        if (saveDiscountModel!.type == 1) {
          totalDiscount += subtotal * (directVal / 100);
        } else {
          totalDiscount += directVal;
        }
      }

      // Coupon Discount
      if (selectedDiscountType == DiscountType.coupon &&
          couponDiscountvalue != null) {
        totalDiscount += couponDiscountvalue!;
      }
    }

    // Discount cannot exceed subtotal
    return totalDiscount > subtotal ? subtotal : totalDiscount;
  }

  /// 3. Subtotal minus Discount (Excludes VAT)
  double get netSubtotal => (subtotal - totalDiscountAmount) > 0.0
      ? (subtotal - totalDiscountAmount)
      : 0.0;

  /// 4. 15% VAT calculated ONLY on the Net Subtotal (After Discount)
  double get vatAmount => netSubtotal * vatPercentage;

  /// 5. Grand total = Net Subtotal + VAT + Delivery Fee
  double get grandTotal {
    double total = netSubtotal + vatAmount;
    if (selectedOrderType == OrderType.delivery ||
        selectedOrderType == OrderType.deliveryCompany) {
      total += deliveryFee;
    }
    return total < 0 ? 0.0 : total;
  }

  CartState copyWith({
    OrderType? selectedOrderType,
    DiscountType? selectedDiscountType,
    ClientAddressModel? selectedAddress,
    SaveDiscountModel? saveDiscountModel,
    double? couponDiscountvalue,
    CartStatus? status,
    List<OrderItem>? items,
    List<DynamicDiscountModel>? discounts,
    bool? dynamicDiscountIsActive,
    DynamicDiscountModel? activeDiscountModel,
    List<WaiterModel>? waiters,
    List<WaiterModel>? deliveryAgents,
    List<PosClientModel>? persons,
    PosClientModel? selectedPerson,
    List<DeliveryCompanyModel>? deliveryCompanies,
    DeliveryCompanyModel? selectedDeliveryCompany,
    WaiterModel? selectedWaiter,
    WaiterModel? selectedDeliveryMan,
    double? discountAmount,
    double? deliveryFee,
    double? vatPercentage,
    bool? isLoading,
    bool? isSubmitting,
    String? errorMessage,
    String? successMessage,
    TableEntity? selectedTable,
    DateTime? takeawayDateTime,
  }) {
    return CartState(
      selectedOrderType: selectedOrderType ?? this.selectedOrderType,
      selectedDiscountType: selectedDiscountType ?? this.selectedDiscountType,
      selectedAddress: selectedAddress ?? this.selectedAddress,
      status: status ?? this.status,
      items: items ?? this.items,
      discounts: discounts ?? this.discounts,
      couponDiscountvalue: couponDiscountvalue ?? this.couponDiscountvalue,
      dynamicDiscountIsActive:
          dynamicDiscountIsActive ?? this.dynamicDiscountIsActive,
      activeDiscountModel: activeDiscountModel ?? this.activeDiscountModel,
      waiters: waiters ?? this.waiters,
      persons: persons ?? this.persons,
      selectedPerson: selectedPerson ?? this.selectedPerson,
      deliveryAgents: deliveryAgents ?? this.deliveryAgents,
      deliveryCompanies: deliveryCompanies ?? this.deliveryCompanies,
      selectedDeliveryCompany:
          selectedDeliveryCompany ?? this.selectedDeliveryCompany,
      selectedWaiter: selectedWaiter ?? this.selectedWaiter,
      selectedDeliveryMan: selectedDeliveryMan ?? this.selectedDeliveryMan,
      discountAmount: discountAmount ?? this.discountAmount,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      vatPercentage: vatPercentage ?? this.vatPercentage,
      isLoading: isLoading ?? this.isLoading,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: errorMessage,
      successMessage: successMessage,
      saveDiscountModel: saveDiscountModel ?? this.saveDiscountModel,
      selectedTable: selectedTable ?? this.selectedTable,
      takeawayDateTime: takeawayDateTime ?? this.takeawayDateTime,
    );
  }

  @override
  List<Object?> get props => [
    selectedOrderType,
    selectedDiscountType,
    selectedAddress,
    status,
    items,
    discounts,
    couponDiscountvalue,
    saveDiscountModel,
    dynamicDiscountIsActive,
    activeDiscountModel,
    waiters,
    deliveryAgents,
    persons,
    selectedPerson,
    deliveryCompanies,
    selectedDeliveryCompany,
    selectedWaiter,
    selectedDeliveryMan,
    takeawayDateTime,
    discountAmount,
    deliveryFee,
    vatPercentage,
    isLoading,
    isSubmitting,
    errorMessage,
    successMessage,
    selectedTable,
  ];
}
