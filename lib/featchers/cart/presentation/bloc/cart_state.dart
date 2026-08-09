// import 'package:apex_restaurant/core/shared/model/settings_model.dart';
// import 'package:apex_restaurant/featchers/cart/data/enums/cart_enum.dart';
// import 'package:apex_restaurant/featchers/cart/data/models/dynamic_discount.dart';
// import 'package:apex_restaurant/featchers/cart/data/models/invoice_request_model.dart';
// import 'package:apex_restaurant/featchers/cart/data/models/pos_client_model.dart';
// import 'package:apex_restaurant/featchers/cart/data/models/waiter_model.dart';
// import 'package:apex_restaurant/featchers/pos/data/models/delivery_company.dart';
// import 'package:apex_restaurant/featchers/pos/domain/entities/menu_item.dart';
// import 'package:apex_restaurant/featchers/tables/domain/entities/table_entity.dart';
// import 'package:equatable/equatable.dart';

// enum DiscountType { coupon, direct }

// enum CartStatus { initial, loading, success, failure }

// class CartState extends Equatable {
//   final SettingsModel? settingsModel;
//   final CartOrderType selectedOrderType;
//   final CartStatus status;
//   final DiscountType selectedDiscountType;
//   final ClientAddressModel? selectedAddress;
//   final TableEntity? selectedTable;
//   final DateTime? fromBranchDateTime;
//   final List<OrderItem> items;
//   final List<DynamicDiscountModel> discounts;
//   final SaveDiscountModel? saveDiscountModel;
//   final double? couponDiscountvalue;
//   final bool dynamicDiscountIsActive;
//   final DynamicDiscountModel? activeDiscountModel;
//   final List<WaiterModel> waiters;
//   final List<WaiterModel> deliveryAgents;
//   final List<PosClientModel> persons;
//   final PosClientModel? selectedPerson;
//   final List<DeliveryCompanyModel> deliveryCompanies;
//   final DeliveryCompanyModel? selectedDeliveryCompany;
//   final WaiterModel? selectedWaiter;
//   final WaiterModel? selectedDeliveryMan;
//   final double discountAmount;

//   final bool isLoading;
//   final bool isSubmitting;
//   final String? errorMessage;
//   final String? successMessage;

//   const CartState({
//     this.selectedOrderType = CartOrderType.TAKEAWAY,
//     this.selectedDiscountType = DiscountType.coupon,
//     this.status = CartStatus.initial,
//     this.items = const [],
//     this.couponDiscountvalue,
//     this.fromBranchDateTime,
//     this.waiters = const [],
//     this.deliveryAgents = const [],
//     this.persons = const [],
//     this.deliveryCompanies = const [],
//     this.selectedDeliveryCompany,
//     this.selectedWaiter,
//     this.selectedDeliveryMan,
//     this.discountAmount = 0.0,

//     this.isLoading = false,
//     this.isSubmitting = false,
//     this.errorMessage,
//     this.successMessage,
//     this.selectedAddress,
//     this.selectedPerson,
//     this.discounts = const [],
//     this.dynamicDiscountIsActive = false,
//     this.activeDiscountModel,
//     this.saveDiscountModel,
//     this.selectedTable,
//     this.settingsModel,
//   });

//   SaveInvoiceRequestModel get toSaveInvoiceRequestModel {
//     SaveDiscountModel? appliedDiscount;
//     int? activeInvoiceDiscountId;

//     if (dynamicDiscountIsActive && activeDiscountModel != null) {
//       activeInvoiceDiscountId = activeDiscountModel?.discount?.id;
//       appliedDiscount = SaveDiscountModel(
//         type: activeDiscountModel?.discount?.discountType,
//         value: activeDiscountModel?.discount?.discountValue,
//       );
//     } else if (selectedDiscountType == DiscountType.direct &&
//         saveDiscountModel != null) {
//       appliedDiscount = saveDiscountModel;
//     } else if (selectedDiscountType == DiscountType.coupon &&
//         couponDiscountvalue != null) {
//       appliedDiscount = SaveDiscountModel(
//         type: 2, // Fixed amount coupon
//         value: couponDiscountvalue,
//       );
//     }

//     // 3. Map items to InvoiceItemModel list
//     final invoiceItems = items.map((item) {
//       final grouped = <String, int>{};

//       for (var addon in item.addons) {
//         grouped[addon.id] = (grouped[addon.id] ?? 0) + 1;
//       }
//       return InvoiceItemModel(
//         itemId: item.menuItem.itemId,
//         sizeId: item.selectedSize?.sizeId,
//         quantity: item.quantity.toDouble(),
//         price: item.selectedSize?.price ?? item.menuItem.sizes.first.price,
//         notes: item.notes,
//         discount: item.discount > 0
//             ? SaveDiscountModel(
//                 type: item.isPercentageDiscount ? 1 : 2,
//                 value: item.discount,
//               )
//             : null,

//         additives: grouped.entries
//             .map(
//               (e) => SaveAdditiveModel(
//                 additiveId: int.parse(e.key),
//                 quantity: e.value.toDouble(),
//               ),
//             )
//             .toList(),
//       );
//     }).toList();

//     // 4. Build SaveInvoiceModel
//     final invoiceModel = SaveInvoiceModel(
//       postype: selectedOrderType.apiValue,
//       foodTableId: int.tryParse(selectedTable?.id ?? ''),
//       waiterId: int.tryParse(selectedWaiter?.id?.toString() ?? ''),
//       deliveryManId: int.tryParse(selectedDeliveryMan?.id?.toString() ?? ''),
//       deliveryCompanyId: selectedDeliveryCompany?.id,
//       clientId: selectedPerson?.id,
//       takeawayDateTime: fromBranchDateTime,
//       discount: appliedDiscount,
//       paidAmount: grandTotal,
//       totalInvoicePrice: grandTotal,
//       invoiceDiscountId: activeInvoiceDiscountId,
//     );

//     // 5. Return model with ONLY invoice & items mapped
//     return SaveInvoiceRequestModel(invoice: invoiceModel, items: invoiceItems);
//   }

//   /// 1. Total raw price of items before discount or tax
//   double get subtotal => items.fold(0.0, (sum, item) => sum + item.totalPrice);

//   /// 2. Calculates total applied discount amount BEFORE tax
//   double get totalDiscountAmount {
//     double totalDiscount = 0.0;

//     if (dynamicDiscountIsActive && activeDiscountModel != null) {
//       // Dynamic Discount Priority
//       final double value = activeDiscountModel?.discount?.discountValue ?? 0.0;
//       final bool isPercentage =
//           activeDiscountModel?.discount?.discountType == 1;

//       if (isPercentage) {
//         totalDiscount = subtotal * (value / 100);
//       } else {
//         totalDiscount = value;
//       }
//     } else {
//       // Direct Discount (SaveDiscountModel)
//       if (selectedDiscountType == DiscountType.direct &&
//           saveDiscountModel != null &&
//           saveDiscountModel!.value != null) {
//         final double directVal = saveDiscountModel!.value!;
//         // type 1 = Percentage, type 2 or 0 = Fixed Amount
//         if (saveDiscountModel!.type == 1) {
//           totalDiscount += subtotal * (directVal / 100);
//         } else {
//           totalDiscount += directVal;
//         }
//       }

//       // Coupon Discount
//       if (selectedDiscountType == DiscountType.coupon &&
//           couponDiscountvalue != null) {
//         totalDiscount += couponDiscountvalue!;
//       }
//     }

//     // Discount cannot exceed subtotal
//     return totalDiscount > subtotal ? subtotal : totalDiscount;
//   }

//   /// 3. Subtotal minus Discount (Excludes VAT)
//   double get netSubtotal => (subtotal - totalDiscountAmount) > 0.0
//       ? (subtotal - totalDiscountAmount)
//       : 0.0;

//   /// 4. 15% VAT calculated ONLY on the Net Subtotal (After Discount)
//   double get vatAmount => (settingsModel?.vat?.vatActive ?? false)
//       ? netSubtotal *
//             ((settingsModel?.vat?.vatDefaultValue ?? 0) / 100).toDouble()
//       : 0;

//   /// 5. Grand total = Net Subtotal + VAT + Delivery Fee
//   double get grandTotal {
//     double total = netSubtotal + vatAmount;
//     if (selectedOrderType == CartOrderType.DELIVERY ||
//         selectedOrderType == CartOrderType.DELIVERY_COMPANY) {
//       total += settingsModel?.posRestaurant?.deliveryCost ?? 0;
//     }
//     return total < 0 ? 0.0 : total;
//   }

//   CartState copyWith({
//     SettingsModel? settingsModel,
//     CartOrderType? selectedOrderType,
//     DiscountType? selectedDiscountType,
//     ClientAddressModel? selectedAddress,
//     SaveDiscountModel? saveDiscountModel,
//     double? couponDiscountvalue,
//     CartStatus? status,
//     List<OrderItem>? items,
//     List<DynamicDiscountModel>? discounts,
//     bool? dynamicDiscountIsActive,
//     DynamicDiscountModel? activeDiscountModel,
//     List<WaiterModel>? waiters,
//     List<WaiterModel>? deliveryAgents,
//     List<PosClientModel>? persons,
//     PosClientModel? selectedPerson,
//     List<DeliveryCompanyModel>? deliveryCompanies,
//     DeliveryCompanyModel? selectedDeliveryCompany,
//     WaiterModel? selectedWaiter,
//     WaiterModel? selectedDeliveryMan,
//     double? discountAmount,

//     bool? isLoading,
//     bool? isSubmitting,
//     String? errorMessage,
//     String? successMessage,
//     TableEntity? selectedTable,
//     DateTime? fromBranchDateTime,
//   }) {
//     return CartState(
//       settingsModel: settingsModel ?? this.settingsModel,
//       selectedOrderType: selectedOrderType ?? this.selectedOrderType,
//       selectedDiscountType: selectedDiscountType ?? this.selectedDiscountType,
//       selectedAddress: selectedAddress ?? this.selectedAddress,
//       status: status ?? this.status,
//       items: items ?? this.items,
//       discounts: discounts ?? this.discounts,
//       couponDiscountvalue: couponDiscountvalue ?? this.couponDiscountvalue,
//       dynamicDiscountIsActive:
//           dynamicDiscountIsActive ?? this.dynamicDiscountIsActive,
//       activeDiscountModel: activeDiscountModel ?? this.activeDiscountModel,
//       waiters: waiters ?? this.waiters,
//       persons: persons ?? this.persons,
//       selectedPerson: selectedPerson ?? this.selectedPerson,
//       deliveryAgents: deliveryAgents ?? this.deliveryAgents,
//       deliveryCompanies: deliveryCompanies ?? this.deliveryCompanies,
//       selectedDeliveryCompany:
//           selectedDeliveryCompany ?? this.selectedDeliveryCompany,
//       selectedWaiter: selectedWaiter ?? this.selectedWaiter,
//       selectedDeliveryMan: selectedDeliveryMan ?? this.selectedDeliveryMan,
//       discountAmount: discountAmount ?? this.discountAmount,

//       isLoading: isLoading ?? this.isLoading,
//       isSubmitting: isSubmitting ?? this.isSubmitting,
//       errorMessage: errorMessage,
//       successMessage: successMessage,
//       saveDiscountModel: saveDiscountModel ?? this.saveDiscountModel,
//       selectedTable: selectedTable ?? this.selectedTable,
//       fromBranchDateTime: fromBranchDateTime ?? this.fromBranchDateTime,
//     );
//   }

//   @override
//   List<Object?> get props => [
//     settingsModel,
//     selectedOrderType,
//     selectedDiscountType,
//     selectedAddress,
//     status,
//     items,
//     discounts,
//     couponDiscountvalue,
//     saveDiscountModel,
//     dynamicDiscountIsActive,
//     activeDiscountModel,
//     waiters,
//     deliveryAgents,
//     persons,
//     selectedPerson,
//     deliveryCompanies,
//     selectedDeliveryCompany,
//     selectedWaiter,
//     selectedDeliveryMan,
//     fromBranchDateTime,
//     discountAmount,

//     isLoading,
//     isSubmitting,
//     errorMessage,
//     successMessage,
//     selectedTable,
//   ];
// }

import 'package:apex_restaurant/core/calculation/restaurant_invoice_calculator.dart';
import 'package:apex_restaurant/core/shared/model/settings_model.dart';
import 'package:apex_restaurant/featchers/cart/data/enums/cart_enum.dart';
import 'package:apex_restaurant/featchers/cart/data/models/dynamic_discount.dart';
import 'package:apex_restaurant/featchers/cart/data/models/invoice_request_model.dart';
import 'package:apex_restaurant/featchers/cart/data/models/pos_client_model.dart';
import 'package:apex_restaurant/featchers/cart/data/models/waiter_model.dart';
import 'package:apex_restaurant/featchers/pos/data/models/delivery_company.dart';
import 'package:apex_restaurant/featchers/pos/domain/entities/menu_item.dart';
import 'package:apex_restaurant/featchers/tables/domain/entities/table_entity.dart';
import 'package:equatable/equatable.dart';

enum DiscountTypeEnum { coupon, direct }

enum CartStatus { initial, loading, success, failure }

class CartState extends Equatable {
  final SettingsModel? settingsModel;
  final CartOrderType selectedOrderType;
  final CartStatus status;
  final DiscountTypeEnum selectedDiscountType;
  final ClientAddressModel? selectedAddress;
  final TableEntity? selectedTable;
  final DateTime? fromBranchDateTime;
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

  final bool isLoading;
  final bool isSubmitting;
  final String? errorMessage;
  final String? successMessage;

  const CartState({
    this.selectedOrderType = CartOrderType.TAKEAWAY,
    this.selectedDiscountType = DiscountTypeEnum.coupon,
    this.status = CartStatus.initial,
    this.items = const [],
    this.couponDiscountvalue,
    this.fromBranchDateTime,
    this.waiters = const [],
    this.deliveryAgents = const [],
    this.persons = const [],
    this.deliveryCompanies = const [],
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
    this.discounts = const [],
    this.dynamicDiscountIsActive = false,
    this.activeDiscountModel,
    this.saveDiscountModel,
    this.selectedTable,
    this.settingsModel,
  });

  // =====================================================================
  // INVOICE CALCULATOR ENGINE INTEGRATION
  // =====================================================================

  /// Maps [items] into list of [InvoiceItemInput] expected by the calculator engine.
  List<InvoiceItemInput> _mapItemsToCalculationInputs() {
    final inputs = <InvoiceItemInput>[];
    int additiveCounter = 100000;

    final defaultVatRatio = (settingsModel?.vat?.vatActive ?? false)
        ? (settingsModel?.vat?.vatDefaultValue ?? 0).toDouble()
        : 0.0;

    for (final item in items) {
      final parentTxId = item.transactionId;
      final unitPrice =
          item.selectedSize?.price ??
          (item.menuItem.sizes.isNotEmpty
              ? item.menuItem.sizes.first.price
              : item.menuItem.defaultPrice);

      // 1. إدراج الصنف الرئيسي
      inputs.add(
        InvoiceItemInput(
          transactionId: parentTxId,
          parentTransactionId: null,
          itemId: item.menuItem.itemId,
          sizeId: item.selectedSize?.sizeId,
          quantity: item.quantity.toDouble(),
          unitPrice: unitPrice,
          vatRatio: defaultVatRatio,
          discount: item.discount,
          discountType: item.isPercentageDiscount
              ? DiscountType.percentage
              : DiscountType.fixedAmount,
          itemTypeId: item.menuItem.itemTypeId ?? 0,
          isTobacco: item.menuItem.isTobaccoTax ?? false,
        ),
      );

      // 2. تجميع الإضافات وحساب أسعارها وكمياتها المضروبة بـ item.quantity
      final groupedAddons = <String, Map<String, dynamic>>{};
      for (var addon in item.addons) {
        if (!groupedAddons.containsKey(addon.id)) {
          groupedAddons[addon.id] = {'addon': addon, 'count': 0};
        }
        groupedAddons[addon.id]!['count'] =
            (groupedAddons[addon.id]!['count'] as int) + 1;
      }

      // 3. إدراج الإضافات بسعرها المباشر ونسبة الضريبة
      for (final entry in groupedAddons.values) {
        final addon = entry['addon'];
        final countPerItem = entry['count'] as int;

        // إجمالي كمية الإضافة = عدد الإضافات بالقطعة الواحدة × كمية الصنف الرئيسي
        final totalAdditiveQuantity = (countPerItem * item.quantity).toDouble();

        inputs.add(
          InvoiceItemInput(
            transactionId: additiveCounter++,
            parentTransactionId: parentTxId,
            itemId: item.menuItem.itemId,
            additiveId: int.tryParse(addon.id),
            quantity: totalAdditiveQuantity,
            unitPrice: addon.price,
            vatRatio: defaultVatRatio,
            itemTypeId: item.menuItem.itemTypeId ?? 0,
          ),
        );
      }
    }

    return inputs;
  }

  /// Evaluates and calculates the full invoice response using [InvoiceCalculator].
  InvoiceCalculationResult? get calculationResult {
    if (items.isEmpty) return null;

    // 1. Resolve Invoice-Level Discount
    double discountOnTotal = 0.0;
    DiscountType calcDiscountType = DiscountType.percentage;

    if (dynamicDiscountIsActive && activeDiscountModel != null) {
      discountOnTotal = activeDiscountModel?.discount?.discountValue ?? 0.0;
      calcDiscountType = activeDiscountModel?.discount?.discountType == 1
          ? DiscountType.percentage
          : DiscountType.fixedAmount;
    } else if (selectedDiscountType == DiscountTypeEnum.direct &&
        saveDiscountModel != null) {
      discountOnTotal = saveDiscountModel!.value ?? 0.0;
      calcDiscountType = saveDiscountModel!.type == 1
          ? DiscountType.percentage
          : DiscountType.fixedAmount;
    }

    // 2. Resolve Coupon / Voucher
    VoucherInput? voucherInput;
    if (selectedDiscountType == DiscountTypeEnum.coupon &&
        couponDiscountvalue != null) {
      voucherInput = VoucherInput(
        code: 'COUPON',
        discountType: DiscountType.fixedAmount,
        value: couponDiscountvalue!,
      );
    }

    // 3. Resolve Delivery & Service Charge
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

    // 4. Build Input Payload
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

    // 5. Calculate (Pass backend-specific IDs for Note & Offer item types)
    const calculator = InvoiceCalculator(
      noteItemTypeId: 99,
      offerItemTypeId: 100,
    );

    final response = calculator.calculate(input);
    return response.data;
  }

  // =====================================================================
  // CALCULATED GETTERS
  // =====================================================================

  /// Total raw price of items before discount or tax
  double get subtotal => calculationResult?.totalOfItems ?? 0.0;

  /// Calculates total applied discount amount (item + invoice level)
  double get totalDiscountAmount => calculationResult?.totalDiscount ?? 0.0;

  /// Subtotal minus total discounts (excluding VAT)
  double get netSubtotal => calculationResult?.totalWithoutVAT ?? 0.0;

  /// Computed VAT amount
  double get vatAmount => calculationResult?.totalVAT ?? 0.0;

  /// Computed Tobacco Tax amount
  double get tobaccoTaxAmount => calculationResult?.totalTobaccoTax ?? 0.0;

  /// Computed Dine-In Service Charge amount
  double get dineInCost => calculationResult?.dineInCost ?? 0.0;

  /// Final payable grand total
  double get grandTotal => calculationResult?.netTotal ?? 0.0;

  // =====================================================================
  // API PAYLOAD MAPPER
  // =====================================================================

  SaveInvoiceRequestModel get toSaveInvoiceRequestModel {
    SaveDiscountModel? appliedDiscount;
    int? activeInvoiceDiscountId;

    if (dynamicDiscountIsActive && activeDiscountModel != null) {
      activeInvoiceDiscountId = activeDiscountModel?.discount?.id;
      appliedDiscount = SaveDiscountModel(
        type: activeDiscountModel?.discount?.discountType,
        value: activeDiscountModel?.discount?.discountValue,
      );
    } else if (selectedDiscountType == DiscountTypeEnum.direct &&
        saveDiscountModel != null) {
      appliedDiscount = saveDiscountModel;
    } else if (selectedDiscountType == DiscountTypeEnum.coupon &&
        couponDiscountvalue != null) {
      appliedDiscount = SaveDiscountModel(type: 2, value: couponDiscountvalue);
    }

    final invoiceItems = items.map((item) {
      final grouped = <String, int>{};
      for (var addon in item.addons) {
        grouped[addon.id] = (grouped[addon.id] ?? 0) + 1;
      }
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
        additives: grouped.entries
            .map(
              (e) => SaveAdditiveModel(
                additiveId: int.parse(e.key),
                quantity: e.value.toDouble(),
              ),
            )
            .toList(),
      );
    }).toList();

    final invoiceModel = SaveInvoiceModel(
      postype: selectedOrderType.apiValue,
      foodTableId: int.tryParse(selectedTable?.id ?? ''),
      waiterId: int.tryParse(selectedWaiter?.id?.toString() ?? ''),
      deliveryManId: int.tryParse(selectedDeliveryMan?.id?.toString() ?? ''),
      deliveryCompanyId: selectedDeliveryCompany?.id,
      clientId: selectedPerson?.id,
      takeawayDateTime: fromBranchDateTime,
      discount: appliedDiscount?.value == 0 ? null : appliedDiscount,
      paidAmount: grandTotal,
      totalInvoicePrice: grandTotal,
      invoiceDiscountId: activeInvoiceDiscountId,
    );

    return SaveInvoiceRequestModel(invoice: invoiceModel, items: invoiceItems);
  }

  // =====================================================================
  // COPYWITH & EQUATABLE
  // =====================================================================

  CartState copyWith({
    SettingsModel? settingsModel,
    CartOrderType? selectedOrderType,
    DiscountTypeEnum? selectedDiscountType,
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
    bool? isLoading,
    bool? isSubmitting,
    String? errorMessage,
    String? successMessage,
    TableEntity? selectedTable,
    DateTime? fromBranchDateTime,
  }) {
    return CartState(
      settingsModel: settingsModel ?? this.settingsModel,
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
      isLoading: isLoading ?? this.isLoading,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: errorMessage,
      successMessage: successMessage,
      saveDiscountModel: saveDiscountModel ?? this.saveDiscountModel,
      selectedTable: selectedTable ?? this.selectedTable,
      fromBranchDateTime: fromBranchDateTime ?? this.fromBranchDateTime,
    );
  }

  @override
  List<Object?> get props => [
    settingsModel,
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
    fromBranchDateTime,
    discountAmount,
    isLoading,
    isSubmitting,
    errorMessage,
    successMessage,
    selectedTable,
  ];
}
