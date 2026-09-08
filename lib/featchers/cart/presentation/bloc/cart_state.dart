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

enum DiscountTypeEnum { coupon, direct }

enum CartStatus {
  initial,
  loading,
  pindingLoading,
  success,
  pindingSuccess,
  failure,
  pindingFailure,
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
  });

  // الخصومات الديناميكية
  DynamicDiscountModel? get matchedDynamicDiscount {
    if (!dynamicDiscountIsActive) return null;

    final currentPosType = selectedOrderType.apiValue;

    if (activeDiscountModel?.posTypeId == currentPosType) {
      return activeDiscountModel;
    }

    final match = activeDiscounts.where((d) => d.posTypeId == currentPosType);
    return match.isNotEmpty ? match.first : null;
  }

  bool get dynamicDiscountIsActive =>
      activeDiscounts.any((d) => d.posTypeId == selectedOrderType.apiValue);

  int get currentPosTypeId => selectedOrderType.apiValue;

  ItemDiscount? dynamicDiscountForSize(ItemSize? size) {
    final discount = size?.discountForPosType(currentPosTypeId);
    if (discount == null || discount.discountValue <= 0) return null;
    return discount;
  }

  // أولويات الخصومات
  bool get hasSizeDiscount {
    return items.any(
      (item) => dynamicDiscountForSize(item.selectedSize) != null,
    );
  }

  bool get isCustomerDiscountEditable => !dynamicDiscountIsActive;

  bool get isCustomerDiscountApplied =>
      isCustomerDiscountEditable &&
      customerDiscount != null &&
      (customerDiscount!.value) > 0;

  bool get isManualItemDiscountApplied =>
      hasSizeDiscount ? false : items.any((i) => i.discount > 0);

  bool get isManualInvoiceDiscountApplied =>
      selectedDiscountType == DiscountTypeEnum.direct &&
      (restaurantPosDiscountRequest?.value ?? 0) > 0;

  bool get isInvoiceManualDiscountEnabled =>
      !dynamicDiscountIsActive &&
      !isCustomerDiscountApplied &&
      // !hasSizeDiscount &&
      !isManualItemDiscountApplied;

  bool get isItemManualDiscountEnabled =>
      !dynamicDiscountIsActive &&
      !isCustomerDiscountApplied &&
      !hasSizeDiscount &&
      !isManualInvoiceDiscountApplied;

  // تحديد مصدر الخصم المطبق حسب الأولوية
  DiscountSource get activeDiscountSource {
    if (dynamicDiscountIsActive) return DiscountSource.dynamic;
    if (isCustomerDiscountApplied) return DiscountSource.customer;
    if (hasSizeDiscount) return DiscountSource.size;
    if (isManualInvoiceDiscountApplied) return DiscountSource.manualInvoice;
    if (isManualItemDiscountApplied) return DiscountSource.manualItem;
    return DiscountSource.none;
  }

  // احتساب خصم الصنف الفردي
  ({double value, bool isPercentage, int? discountId}) _resolveItemDiscount(
    OrderItem item,
  ) {
    if (dynamicDiscountIsActive || isCustomerDiscountApplied) {
      return (value: 0.0, isPercentage: false, discountId: null);
    }

    final sizeDiscount = _sizeDiscountFor(item);
    if (sizeDiscount != null) return sizeDiscount;

    if (isManualInvoiceDiscountApplied) {
      return (value: 0.0, isPercentage: false, discountId: null);
    }

    if (item.discount > 0) {
      return (
        value: item.discount,
        isPercentage: item.isPercentageDiscount,
        discountId: null,
      );
    }

    return (value: 0.0, isPercentage: false, discountId: null);
  }

  // جلب وتطبيق خصم الحجم
  ({double value, bool isPercentage, int? discountId})? _sizeDiscountFor(
    OrderItem item,
  ) {
    final discount = dynamicDiscountForSize(item.selectedSize);
    if (discount == null) return null;

    final lineTotal = item.totalPriceBeforeDiscount;
    if (discount.minInvoiceNet > 0 && lineTotal < discount.minInvoiceNet) {
      return null;
    }

    final isPercentage = discount.discountNatural == 1;
    final value = discount.discountValue;
    final int? discountId = int.tryParse(discount.id.toString());

    if (isPercentage && discount.maxDiscountValue > 0) {
      final computedAmount = lineTotal * value / 100;
      if (computedAmount > discount.maxDiscountValue) {
        return (
          value: discount.maxDiscountValue,
          isPercentage: false,
          discountId: discountId,
        );
      }
    }

    return (value: value, isPercentage: isPercentage, discountId: discountId);
  }

  // ضريبة التبغ
  bool get hasTobaccoItems => items.any((i) => i.menuItem.isTobaccoTax == true);

  // محرك حساب الفاتورة
  List<InvoiceItemInput> _mapItemsToCalculationInputs() {
    final inputs = <InvoiceItemInput>[];
    int generatedTxCounter = 100000;

    final defaultVatRatio = (settingsModel?.vat?.vatActive ?? false)
        ? (settingsModel?.vat?.vatDefaultValue ?? 0).toDouble()
        : 0.0;

    for (int i = 0; i < items.length; i++) {
      final item = items[i];

      // Use existing transactionId if restored; generate one if it's new
      final parentTxId = (item.transactionId.isNotEmpty)
          ? item.transactionId
          : 'item_${i}_${DateTime.now().millisecondsSinceEpoch}';

      final unitPrice =
          item.selectedSize?.price ??
          (item.menuItem.sizes.isNotEmpty
              ? item.menuItem.sizes.first.price
              : item.menuItem.defaultPrice);

      final resolvedDiscount = _resolveItemDiscount(item);

      // الصنف الرئيسي
      inputs.add(
        InvoiceItemInput(
          transactionId: parentTxId,
          parentTransactionId: null,
          itemId: item.menuItem.itemId,
          sizeId: item.selectedSize?.sizeId,
          quantity: item.quantity.toDouble(),
          unitPrice: unitPrice ?? 0,
          vatRatio: defaultVatRatio,
          discount: resolvedDiscount.value,
          discountType: resolvedDiscount.isPercentage
              ? DiscountNatural.percentage
              : DiscountNatural.fixedAmount,
          itemTypeId: item.menuItem.itemTypeId ?? 0,
          isTobacco: item.menuItem.isTobaccoTax ?? false,
        ),
      );

      // تجميع الإضافات
      final groupedAddons = <String, Map<String, dynamic>>{};
      for (var addon in item.addons) {
        // Group key takes restored transactionId or addon id into account
        final key = addon.id;
        if (!groupedAddons.containsKey(key)) {
          groupedAddons[key] = {'addon': addon, 'count': 0};
        }
        groupedAddons[key]!['count'] =
            (groupedAddons[key]!['count'] as int) + 1;
      }

      // إضافة بند لكل نوع من الإضافات
      for (final entry in groupedAddons.values) {
        final AdditiveModel addon = entry['addon'];
        final countPerItem = entry['count'] as int;

        // Use restored transactionId if available, otherwise generate a unique string ID
        final addonTxId =
            (addon.transactionId != null && addon.transactionId!.isNotEmpty)
            ? addon.transactionId!
            : (generatedTxCounter++).toString();

        final resolvedParentTxId =
            (addon.parentTransactionId != null &&
                addon.parentTransactionId!.isNotEmpty)
            ? addon.parentTransactionId!
            : parentTxId;

        inputs.add(
          InvoiceItemInput(
            transactionId: addonTxId,
            parentTransactionId: resolvedParentTxId,
            itemId: item.menuItem.itemId,
            additiveId: int.tryParse(addon.id),
            quantity: countPerItem.toDouble(),
            unitPrice: addon.price,
            vatRatio: defaultVatRatio,
            itemTypeId: item.menuItem.itemTypeId ?? 0,
          ),
        );
      }
    }

    return inputs;
  }

  // نتائج الحسابات الفعالة
  InvoiceCalculationResult? get calculationResult {
    if (items.isEmpty) return null;

    double discountOnTotal = 0.0;
    DiscountNatural calcDiscountType = DiscountNatural.percentage;

    switch (activeDiscountSource) {
      case DiscountSource.dynamic:
        final matchedDiscount = matchedDynamicDiscount;
        discountOnTotal = matchedDiscount?.discount?.discountValue ?? 0.0;
        calcDiscountType = matchedDiscount?.discount?.discountNatural == 1
            ? DiscountNatural.percentage
            : DiscountNatural.fixedAmount;
        break;
      case DiscountSource.customer:
        discountOnTotal = customerDiscount?.value ?? 0.0;
        calcDiscountType = customerDiscount?.type == 1
            ? DiscountNatural.percentage
            : DiscountNatural.fixedAmount;
        break;
      case DiscountSource.manualInvoice:
        discountOnTotal = restaurantPosDiscountRequest?.value ?? 0.0;
        calcDiscountType = restaurantPosDiscountRequest?.type == 1
            ? DiscountNatural.percentage
            : DiscountNatural.fixedAmount;
        break;
      case DiscountSource.size:
      case DiscountSource.manualItem:
      case DiscountSource.none:
        discountOnTotal = 0.0;
        break;
    }

    // إدخال القسيمة/الكوبون
    VoucherInput? voucherInput;
    if (selectedDiscountType == DiscountTypeEnum.coupon &&
        voucherData != null) {
      voucherInput = VoucherInput(
        code: voucherData!.voucherCode!,
        discountType: voucherData!.discountNatural == 1
            ? DiscountNatural.percentage
            : DiscountNatural.fixedAmount,
        value: voucherData!.discountValue ?? 0,
        minimumCharge: voucherData?.minimumCharge ?? 0,
        maximumDiscount: voucherData?.maximumDiscountValue ?? 0,
      );
    }

    // رسوم التوصيل والخدمة
    double calculatedDeliveryCost = 0.0;
    if (selectedOrderType == CartOrderType.DELIVERY ||
        selectedOrderType == CartOrderType.DELIVERY_COMPANY) {
      calculatedDeliveryCost =
          settingsModel?.posRestaurant?.deliveryCost ?? 0.0;
    }

    double dineInRatio = 0.0;
    if (selectedOrderType == CartOrderType.DINE_IN) {
      dineInRatio = selectedTable?.serviceRatio ?? 0.0;
    }

    final input = InvoiceCalculationInput(
      discountOnTotal: discountOnTotal,
      discountType: calcDiscountType,
      deliveryCost: calculatedDeliveryCost,
      dineInRatio: dineInRatio,
      applyVAT: settingsModel?.vat?.vatActive ?? false,
      priceIncludesVAT: settingsModel?.posRestaurant?.priceIncludeVat ?? false,
      items: _mapItemsToCalculationInputs(),
      voucher: voucherInput,
    );

    const calculator = InvoiceCalculator(
      noteItemTypeId: 99,
      offerItemTypeId: 100,
    );

    final response = calculator.calculate(input);
    return response.data;
  }

  // القيم المحسوبة
  double get subtotal => calculationResult?.totalOfItems ?? 0.0;
  double get totalDiscountAmount =>
      selectedDiscountType == DiscountTypeEnum.direct
      ? calculationResult?.totalDiscount ?? 0.0
      : calculationResult?.voucherDiscount ?? 0;
  double get netSubtotal => calculationResult?.totalWithoutVAT ?? 0.0;
  double get vatAmount => calculationResult?.totalVAT ?? 0.0;
  double get tobaccoTaxAmount => calculationResult?.totalTobaccoTax ?? 0.0;
  double get dineInCost => calculationResult?.dineInCost ?? 0.0;
  double get grandTotal => calculationResult?.netTotal ?? 0.0;
  DateTime get invoiceDate =>
      (settingsModel?.posRestaurant?.editingOnDate ?? false)
            ? fromBranchDateTime ?? DateTime.now().add(Duration(minutes: 1))
            : DateTime.now()
        ..add(Duration(minutes: 1));

  // تحويل البيانات لطلب الحفظ (API)
  SaveRestaurantPosInvoiceRequest get toSaveRestaurantPosInvoiceRequest {
    RestaurantPosDiscountRequest? appliedDiscount;
    int? activeInvoiceDiscountId;
    String? voucherCode;
    int generatedTxCounter = 100000;

    switch (activeDiscountSource) {
      case DiscountSource.dynamic:
        final matchedDiscount = matchedDynamicDiscount;
        activeInvoiceDiscountId = int.tryParse(
          matchedDiscount?.discount?.id ?? "",
        );
        appliedDiscount = RestaurantPosDiscountRequest(
          type: matchedDiscount?.discount?.discountType ?? 0,
          value: matchedDiscount?.discount?.discountValue ?? 0,
        );
        break;
      case DiscountSource.customer:
        appliedDiscount = customerDiscount;
        break;
      case DiscountSource.manualInvoice:
        appliedDiscount = restaurantPosDiscountRequest;
        break;
      case DiscountSource.size:
      case DiscountSource.manualItem:
      case DiscountSource.none:
        appliedDiscount = null;
        break;
    }

    if (appliedDiscount == null &&
        selectedDiscountType == DiscountTypeEnum.coupon &&
        voucherData != null) {
      voucherCode = voucherData?.voucherCode;
      appliedDiscount = RestaurantPosDiscountRequest(
        type: voucherData?.discountNatural ?? 0,
        value: voucherData?.discountValue ?? 0,
      );
    }

    final invoiceItems = <RestaurantPosInvoiceItemRequest>[];

    for (int i = 0; i < items.length; i++) {
      final item = items[i];

      final parentTxId = (item.transactionId.isNotEmpty)
          ? item.transactionId
          : 'item_${i}_${DateTime.now().millisecondsSinceEpoch}';

      final grouped = <String, AdditiveModel>{};
      final quantities = <String, int>{};

      for (final addon in item.addons) {
        final key =
            '${addon.id}_${addon.transactionId}_${addon.parentTransactionId}';
        grouped[key] = addon;
        quantities[key] = (quantities[key] ?? 0) + 1;
      }

      final resolvedDiscount = _resolveItemDiscount(item);

      final additivesList = grouped.entries.map((entry) {
        final addon = entry.value;

        final addonTxId =
            (addon.transactionId != null && addon.transactionId!.isNotEmpty)
            ? addon.transactionId!
            : (generatedTxCounter++).toString();

        final resolvedParentTxId =
            (addon.parentTransactionId != null &&
                addon.parentTransactionId!.isNotEmpty)
            ? addon.parentTransactionId!
            : parentTxId;

        return RestaurantPosItemAdditiveRequest(
          transactionID: addonTxId,
          parentTransactionId: resolvedParentTxId,
          additiveId: int.parse(addon.id),
          quantity: quantities[entry.key]!.toDouble(),
        );
      }).toList();

      invoiceItems.add(
        RestaurantPosInvoiceItemRequest(
          transactionID: parentTxId,
          itemId: item.menuItem.itemId,
          sizeId: item.selectedSize?.sizeId ?? 0,
          quantity: item.quantity.toDouble(),
          price:
              item.selectedSize?.price ??
              (item.menuItem.sizes.isNotEmpty
                  ? item.menuItem.sizes.first.price
                  : item.menuItem.defaultPrice) ??
              0.0,
          notes: item.notes,
          discount: resolvedDiscount.value > 0
              ? RestaurantPosDiscountRequest(
                  type: resolvedDiscount.isPercentage ? 1 : 2,
                  value: resolvedDiscount.value,
                )
              : null,
          itemDiscountId: resolvedDiscount.discountId,
          additives: additivesList,
        ),
      );
    }

    double calculatedDeliveryCost = 0.0;
    if (selectedOrderType == CartOrderType.DELIVERY ||
        selectedOrderType == CartOrderType.DELIVERY_COMPANY) {
      calculatedDeliveryCost =
          calculationResult?.deliveryCost ??
          (settingsModel?.posRestaurant?.deliveryCost ?? 0.0);
    }

    final invoiceModel = RestaurantPosInvoiceInfoRequest(
      invoiceId: isPending ? 0 : invoiceId,
      pendingInvoiceId: invoiceId,
      postype: selectedOrderType.apiValue,
      foodTableId: selectedOrderType == CartOrderType.DINE_IN
          ? int.tryParse(selectedTable?.id ?? '')
          : null,
      waiterId: selectedOrderType == CartOrderType.DINE_IN
          ? int.tryParse(selectedWaiter?.id?.toString() ?? '')
          : null,
      deliveryManId: selectedOrderType == CartOrderType.DELIVERY
          ? int.tryParse(selectedDeliveryMan?.id?.toString() ?? '')
          : null,
      deliveryCompanyId: selectedOrderType == CartOrderType.DELIVERY_COMPANY
          ? selectedDeliveryCompany?.id
          : null,
      voucherCode: selectedDiscountType == DiscountTypeEnum.coupon
          ? voucherCode
          : null,
      clientId: selectedPerson?.id ?? 0,
      personAddressId: selectedOrderType == CartOrderType.DELIVERY
          ? (int.tryParse(selectedAddress?.id.toString() ?? '') ?? 0)
          : 0,
      personPhoneId: selectedOrderType == CartOrderType.DELIVERY
          ? selectedPerson?.personPhones?.first.id ?? 0
          : 0,
      orderReceivedTime: selectedOrderType == CartOrderType.FROMBRANCH
          ? fromBranchDateTime
          : null,
      discount:
          appliedDiscount?.value == 0 ||
              selectedDiscountType != DiscountTypeEnum.direct
          ? null
          : appliedDiscount,
      paidAmount: grandTotal,
      totalInvoicePrice: grandTotal,
      invoiceDiscountId: activeInvoiceDiscountId,
      deliveryCost: calculatedDeliveryCost,
      invoiceDate: invoiceDate,
    );

    return SaveRestaurantPosInvoiceRequest(
      invoice: invoiceModel,
      items: invoiceItems,
      payments: const [],
      gediaKey: '',
    );
  }

  // نسخ ومقارنة الحالة
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
    // Optional flag helpers to force explicit null assignment
    bool clearActiveDiscountModel = false,
    bool clearRestaurantPosDiscountRequest = false,
    bool clearCustomerDiscount = false,
    bool clearVoucherDiscountValue = false,
    bool clearAddress = false,
    bool clearInvoiceId = false,
    bool clearCart = false,
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
          : restoredInvoiceDate ?? restoredInvoiceDate,
      isPreviousInvoice: isPreviousInvoice ?? this.isPreviousInvoice,
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
  ];
}
