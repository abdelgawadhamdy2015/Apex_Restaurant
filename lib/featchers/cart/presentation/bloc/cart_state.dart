import 'package:apex_restaurant/core/helpers/extensions.dart';
import 'package:apex_restaurant/featchers/cart/data/models/check_voucher_response.dart';
import 'package:apex_restaurant/featchers/pos/data/models/category_model.dart';

import '../../../../core/calculation/restaurant_invoice_calculator.dart';
import '../../../../core/shared/model/settings_model.dart';
import '../../data/enums/cart_enum.dart';
import '../../data/models/dynamic_discount.dart';
import '../../data/models/invoice_request.dart';
import '../../data/models/pos_client_model.dart';
import '../../data/models/waiter_model.dart';
import '../../../pos/data/models/delivery_company.dart';
import '../../../pos/data/models/restaurant_item.dart';
import '../../../pos/domain/entities/menu_item.dart';
import '../../../tables/domain/entities/table_entity.dart';
import 'package:equatable/equatable.dart';

part 'cart_invoice_mode.dart';
part '../../domain/extensions/cart_state_discounts.dart';
part '../../domain/extensions/cart_state_calculation.dart';
part '../../domain/extensions/cart_state_request.dart';

enum DiscountTypeEnum { coupon, direct }

enum CartStatus {
  initial,
  loading,
  pindingLoading,
  success,
  pindingSuccess,
  failure,
  pindingFailure,
  itemsUpdateing,
  itemsUpdated,
}

enum DiscountSource { none, dynamic, customer, size, manualInvoice, manualItem }

class CartState extends Equatable {
  final SettingsModel? settingsModel;
  final CartOrderType selectedOrderType;
  final bool justRestored;
  final bool isPreviousInvoice;

  final CartStatus status;
  final DiscountTypeEnum selectedDiscountType;
  final ClientAddressModel? selectedAddress;
  final TableEntity? selectedTable;
  final DateTime? fromBranchDateTime;
  final List<OrderItem> items;
  final List<DynamicDiscountModel> activeDiscounts;
  final RestaurantPosDiscountRequest? restaurantPosDiscountRequest;
  final DynamicDiscountModel? activeDiscountModel;
  final RestaurantPosDiscountRequest? customerDiscount;
  final CheckVoucherResponse? voucherData;
  final List<WaiterModel> waiters;
  final List<WaiterModel> deliveryAgents;
  final List<DeliveryCompanyModel> companiesList;

  final List<PosClientModel> persons;
  final PosClientModel? selectedPerson;
  final DeliveryCompanyModel? selectedDeliveryCompany;
  final WaiterModel? selectedWaiter;
  final WaiterModel? selectedDeliveryMan;
  final double discountAmount;
  final bool canEdit;
  final bool isLoading;
  final bool isSubmitting;
  final String? errorMessage;
  final String? successMessage;
  final int? invoiceId;
  final bool isPending;
  final int? orderNumber;
  final String? invoiceCode;
  final String? voucherId;
  final DateTime? restoredInvoiceDate;
  final bool? isReturnInvoice;
  final bool priceIncludeVat;

  const CartState({
    this.selectedOrderType = CartOrderType.TAKEAWAY,
    this.selectedDiscountType = DiscountTypeEnum.coupon,
    this.justRestored = false,
    this.isPreviousInvoice = false,
    this.status = CartStatus.initial,
    this.items = const [],
    this.fromBranchDateTime,
    this.waiters = const [],
    this.deliveryAgents = const [],
    this.persons = const [],
    this.selectedDeliveryCompany,
    this.selectedWaiter,
    this.selectedDeliveryMan,
    this.discountAmount = 0.0,
    this.isLoading = false,
    this.isSubmitting = false,
    this.errorMessage,
    this.successMessage,
    this.selectedAddress,
    this.selectedPerson,
    this.activeDiscounts = const [],
    this.activeDiscountModel,
    this.restaurantPosDiscountRequest,
    this.customerDiscount,
    this.selectedTable,
    this.settingsModel,
    this.canEdit = true,
    this.companiesList = const [],
    this.invoiceId,
    this.isPending = false,
    this.orderNumber,
    this.invoiceCode,
    this.voucherId,
    this.restoredInvoiceDate,
    this.voucherData,
    this.isReturnInvoice,
    this.priceIncludeVat = false,
  });

  // ---------------------------------------------------------------------------
  // Invoice mode (the ONLY place that decides "return" vs "normal")
  // ---------------------------------------------------------------------------

  CartInvoiceMode get mode => isReturnInvoice == true
      ? const ReturnInvoiceMode()
      : const StandardInvoiceMode();

  bool get isReturn => mode.isReturn;
  bool get canEditInvoice =>
      canEdit && mode.allowsEditing && !isPreviousInvoice;
  bool get canRemoveInvoice => canEdit && !isPreviousInvoice;

  // ---------------------------------------------------------------------------
  // Small shared getters
  // ---------------------------------------------------------------------------

  bool get isDeliveryOrder =>
      selectedOrderType == CartOrderType.DELIVERY ||
      selectedOrderType == CartOrderType.DELIVERY_COMPANY;

  bool get hasTobaccoItems => items.any((i) => i.menuItem.isTobaccoTax == true);

  DateTime get invoiceDate =>
      (settingsModel?.posRestaurant?.editingOnDate ?? false)
      ? fromBranchDateTime ?? DateTime.now().add(const Duration(minutes: 1))
      : DateTime.now();

  // ---------------------------------------------------------------------------
  // copyWith / props
  // ---------------------------------------------------------------------------

  CartState copyWith({
    int? invoiceId,
    SettingsModel? settingsModel,
    CartOrderType? selectedOrderType,
    DiscountTypeEnum? selectedDiscountType,
    bool? justRestored,
    bool? canEdit,
    ClientAddressModel? selectedAddress,
    RestaurantPosDiscountRequest? restaurantPosDiscountRequest,
    RestaurantPosDiscountRequest? customerDiscount,
    double? couponDiscountvalue,
    CartStatus? status,
    List<OrderItem>? items,
    List<DynamicDiscountModel>? activeDiscounts,
    DynamicDiscountModel? activeDiscountModel,
    List<WaiterModel>? waiters,
    List<WaiterModel>? deliveryAgents,
    List<DeliveryCompanyModel>? companiesList,
    CheckVoucherResponse? voucherData,
    List<PosClientModel>? persons,
    PosClientModel? selectedPerson,
    DeliveryCompanyModel? selectedDeliveryCompany,
    WaiterModel? selectedWaiter,
    WaiterModel? selectedDeliveryMan,
    double? discountAmount,
    bool? isLoading,
    bool? isSubmitting,
    String? errorMessage,
    String? successMessage,
    TableEntity? selectedTable,
    DateTime? fromBranchDateTime,
    bool? isPending,
    int? orderNumber,
    String? invoiceCode,
    String? voucherId,
    DateTime? restoredInvoiceDate,
    bool? isPreviousInvoice,
    // Flags to force an explicit null
    bool clearActiveDiscountModel = false,
    bool clearRestaurantPosDiscountRequest = false,
    bool clearCustomerDiscount = false,
    bool clearVoucherDiscountValue = false,
    bool clearAddress = false,
    bool clearInvoiceId = false,
    bool clearCart = false,
    bool? isReturnInvoice,
    bool? priceIncludeVat,
  }) {
    return CartState(
      settingsModel: settingsModel ?? this.settingsModel,
      selectedOrderType: selectedOrderType ?? this.selectedOrderType,
      selectedDiscountType: selectedDiscountType ?? this.selectedDiscountType,
      selectedAddress: clearAddress
          ? null
          : selectedAddress ?? this.selectedAddress,
      status: status ?? this.status,
      items: items ?? this.items,
      activeDiscounts: activeDiscounts ?? this.activeDiscounts,
      justRestored: justRestored ?? this.justRestored,
      canEdit: canEdit ?? this.canEdit,
      activeDiscountModel: clearActiveDiscountModel
          ? null
          : (activeDiscountModel ?? this.activeDiscountModel),
      waiters: waiters ?? this.waiters,
      persons: persons ?? this.persons,
      selectedPerson: selectedPerson ?? this.selectedPerson,
      deliveryAgents: deliveryAgents ?? this.deliveryAgents,
      selectedDeliveryCompany:
          selectedDeliveryCompany ?? this.selectedDeliveryCompany,
      selectedWaiter: clearCart ? null : selectedWaiter ?? this.selectedWaiter,
      selectedDeliveryMan: clearCart
          ? null
          : selectedDeliveryMan ?? this.selectedDeliveryMan,
      discountAmount: discountAmount ?? this.discountAmount,
      voucherData: clearVoucherDiscountValue
          ? null
          : voucherData ?? this.voucherData,
      isLoading: isLoading ?? this.isLoading,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: errorMessage,
      successMessage: successMessage,
      restaurantPosDiscountRequest: clearRestaurantPosDiscountRequest
          ? null
          : (restaurantPosDiscountRequest ?? this.restaurantPosDiscountRequest),
      customerDiscount: clearCustomerDiscount
          ? null
          : (customerDiscount ?? this.customerDiscount),
      selectedTable: clearCart ? null : selectedTable ?? this.selectedTable,
      fromBranchDateTime: clearCart
          ? null
          : fromBranchDateTime ?? this.fromBranchDateTime,
      companiesList: companiesList ?? this.companiesList,
      invoiceId: clearInvoiceId ? null : invoiceId ?? this.invoiceId,
      isPending: isPending ?? this.isPending,
      voucherId: clearInvoiceId ? null : voucherId ?? this.voucherId,
      orderNumber: clearInvoiceId ? null : orderNumber ?? this.orderNumber,
      invoiceCode: clearInvoiceId ? null : invoiceCode ?? this.invoiceCode,
      restoredInvoiceDate: clearInvoiceId
          ? null
          : restoredInvoiceDate ?? this.restoredInvoiceDate,
      isPreviousInvoice: isPreviousInvoice ?? this.isPreviousInvoice,
      isReturnInvoice: isReturnInvoice ?? this.isReturnInvoice,
      priceIncludeVat: priceIncludeVat ?? this.priceIncludeVat,
    );
  }

  @override
  List<Object?> get props => [
    settingsModel,
    selectedOrderType,
    selectedDiscountType,
    justRestored,
    selectedAddress,
    status,
    items,
    activeDiscounts,
    restaurantPosDiscountRequest,
    customerDiscount,
    activeDiscountModel,
    waiters,
    deliveryAgents,
    persons,
    selectedPerson,
    companiesList,
    selectedDeliveryCompany,
    selectedWaiter,
    selectedDeliveryMan,
    fromBranchDateTime,
    discountAmount,
    isLoading,
    isSubmitting,
    errorMessage,
    successMessage,
    isPending,
    canEdit,
    selectedTable,
    voucherId,
    invoiceCode,
    orderNumber,
    restoredInvoiceDate,
    voucherData,
    isPreviousInvoice,
    isReturnInvoice,
    priceIncludeVat,
  ];
}
