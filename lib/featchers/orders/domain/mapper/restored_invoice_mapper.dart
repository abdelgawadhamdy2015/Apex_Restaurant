import 'dart:developer';

import 'package:material_ui/material_ui.dart';

import '../../../cart/data/enums/cart_enum.dart';
import '../../../cart/data/models/invoice_request.dart';
import '../../../cart/data/models/pos_client_model.dart';
import '../../../cart/data/models/restored_cart_data.dart';
import '../../../cart/data/models/waiter_model.dart';
import '../../../pos/data/models/category_model.dart';
import '../../../pos/data/models/delivery_company.dart';
import '../../../pos/data/models/restaurant_item.dart';
import '../../../pos/domain/entities/menu_item.dart';
import '../../../tables/domain/entities/table_entity.dart';
import '../../data/model/restored_invoice_model.dart';

extension RestoredInvoiceMapper on RestoredInvoiceModel {
  RestoredCartData toRestoredCartData(BuildContext context, {bool? isReturn}) {
    final rawItems = items ?? [];
    final inv = invoice;
    final bool returning = isReturn == true;

    // 1. ORDER TYPE
    CartOrderType orderType = CartOrderType.TAKEAWAY;
    if (inv?.posType != null) {
      orderType = CartOrderType.values.firstWhere(
        (e) => e.apiValue == inv!.posType,
        orElse: () => CartOrderType.TAKEAWAY,
      );
    }

    // 2. ENTITIES
    PosClientModel? client;
    final clientId = inv?.clientId ?? inv?.client?.id;
    if (clientId != null && clientId != 0) {
      client = PosClientModel(
        id: clientId,
        arabicName: inv?.clientArabicName ?? inv?.client?.arabicName ?? '',
        latinName: inv?.clientLatinName ?? inv?.client?.latinName ?? '',
      );
    }

    WaiterModel? waiter;
    final waiterId = inv?.waiterId ?? inv?.waiter?.id;
    if (waiterId != null && waiterId != 0) {
      waiter = WaiterModel(
        id: waiterId,
        arabicName: inv?.waiterArabicName ?? inv?.waiter?.arabicName ?? '',
        latinName: inv?.waiterLatinName ?? inv?.waiter?.latinName ?? '',
      );
    }

    WaiterModel? deliveryMan;
    final delId = inv?.deliveryManId ?? inv?.deliveryMan?.id;
    if (delId != null && delId != 0) {
      deliveryMan = WaiterModel(
        id: delId,
        arabicName:
            inv?.deliveryManArabicName ?? inv?.deliveryMan?.arabicName ?? '',
        latinName:
            inv?.deliveryManLatinName ?? inv?.deliveryMan?.latinName ?? '',
      );
    }

    DeliveryCompanyModel? deliveryCompany;
    final compId = inv?.deliveryCompanyId ?? inv?.deliveryCompany?.id;
    if (compId != null && compId != 0) {
      deliveryCompany = DeliveryCompanyModel(
        id: compId,
        arabicName:
            inv?.deliveryCompanyArabicName ??
            inv?.deliveryCompany?.arabicName ??
            '',
        latinName:
            inv?.deliveryCompanyLatinName ??
            inv?.deliveryCompany?.latinName ??
            '',
      );
    }

    TableEntity? table;
    // Normalize to String: foodTableId is int?, foodTable.id is String?
    final String? tableId = inv?.foodTableId?.toString() ?? inv?.foodTable?.id;
    if (tableId != null && tableId.isNotEmpty && tableId != '0') {
      table = TableEntity(
        id: tableId,
        arabicName:
            inv?.foodTableArabicName ?? inv?.foodTable?.arabicName ?? '',
        latinName: inv?.foodTableLatinName ?? inv?.foodTable?.latinName ?? '',
      );
    }

    // 3. INVOICE DISCOUNT
    // On return invoices the invoice-level discount is NOT restored here:
    // it is split across the items (see step 4) so that removing an item
    // removes only its own share of the discount.
    RestaurantPosDiscountRequest? restaurantPosDiscountRequest;
    if (!returning && inv?.invoiceDiscount != null) {
      final discount = inv!.invoiceDiscount!;
      final double val = discount.discountValue ?? 0.0;
      if (val > 0) {
        //  confirm with backend whether discountType or discountNatural
        // decides percentage vs fixed.
        final bool isPerc = discount.discountNatural == 1;
        restaurantPosDiscountRequest = RestaurantPosDiscountRequest(
          type: isPerc ? 1 : 2,
          value: val,
        );
      }
    }

    // 4. ITEMS AND ADDONS
    final mainItemsMap = <int, RestoredInvoiceItem>{};
    final flatAdditivesMap = <int, List<RestoredInvoiceItem>>{};
    int fallbackCounter = 1;

    for (final item in rawItems) {
      if (item.parentTransactionId == null || item.parentTransactionId == 0) {
        final int transId =
            (item.transactionId != null && item.transactionId != 0)
            ? item.transactionId!
            : (DateTime.now().microsecondsSinceEpoch + (fallbackCounter++));

        mainItemsMap[transId] = item;
      } else {
        flatAdditivesMap
            .putIfAbsent(item.parentTransactionId!, () => [])
            .add(item);
      }
    }

    final List<OrderItem> orderItems = [];

    for (final entry in mainItemsMap.entries) {
      final transId = entry.key;
      final mainItem = entry.value;

      final String itemNameAr =
          mainItem.itemArabicName ?? mainItem.item?.arabicName ?? '';
      final String itemNameEn =
          mainItem.itemLatinName ?? mainItem.item?.latinName ?? '';

      ItemSize? selectedSize;
      if (mainItem.sizeId != null || mainItem.size != null) {
        selectedSize = ItemSize(
          sizeId: mainItem.sizeId ?? mainItem.size?.id,
          sizeNameAr: mainItem.sizeArabicName ?? mainItem.size?.arabicName,
          sizeNameEn: mainItem.sizeLatinName ?? mainItem.size?.latinName,
          price: mainItem.price ?? mainItem.size?.price,
          isActive: true,
        );
      }

      final restaurantItem = RestaurantItem(
        itemId: mainItem.itemId ?? mainItem.item?.id ?? 0,
        itemCode: '',
        itemNameAr: itemNameAr,
        itemNameEn: itemNameEn,
        imagePath: mainItem.item?.imagePath ?? mainItem.itemImagePath,
        categoryId: mainItem.item?.categoryId ?? 0,
        defaultPrice: mainItem.price ?? mainItem.item?.price ?? 0.0,
        isOffer: false,
        orderSerial: 0,
        count: 0,
        posTypes: const [],
        sizes: selectedSize != null ? [selectedSize] : const [],
        offersItems: const [],
        // Per-item flag (was: invoice-level tobaccoTax > 0 for every item)
        isTobaccoTax: mainItem.isTobaccoTax ?? false,
      );

      final List<AdditiveModel> allAddons = [
        ..._mapNestedAddons(mainItem.additives, transId),
        ..._mapFlatAddons(flatAdditivesMap[transId], transId),
      ];

      double discountVal = mainItem.itemDiscount?.discountValue ?? 0.0;
      bool isPercentage = mainItem.itemDiscount?.discountNatural == 1;

      // RETURN INVOICES ONLY: build a fixed discount for the returned
      // quantity = item's own discount + its share of the invoice discount
      // (splitedDiscountValue). Other invoice types are untouched.
      if (returning) {
        final double soldQty = mainItem.quantity ?? 0.0;
        final double returnQty = mainItem.availableQuantity ?? soldQty;
        final double ratio = soldQty > 0
            ? (returnQty / soldQty).clamp(0.0, 1.0).toDouble()
            : 0.0;
        final double unitPrice = mainItem.price ?? mainItem.item?.price ?? 0.0;

        // Item's own discount converted to a fixed amount for returned qty
        double ownDiscount = 0.0;
        if (discountVal > 0) {
          ownDiscount = isPercentage
              ? unitPrice * returnQty * discountVal / 100
              : discountVal * ratio;
        }

        // This item's share of the invoice-level discount
        final double splitShare =
            (mainItem.splitedDiscountValue ?? 0.0) * ratio;

        discountVal = double.parse(
          (ownDiscount + splitShare).toStringAsFixed(2),
        );
        isPercentage = false; // always a fixed amount on returns
      }

      log("mainItem.invoiceDetailsId : ${mainItem.invoiceDetailsId}");
      orderItems.add(
        OrderItem(
          transactionId: transId.toString(),
          menuItem: restaurantItem,
          selectedSize: selectedSize,
          quantity: (mainItem.quantity ?? 1).toInt(),
          notes: mainItem.itemNote ?? mainItem.notes,
          addons: allAddons,
          discount: discountVal,
          isPercentageDiscount: isPercentage,
          invoiceDetailsId: mainItem.invoiceDetailsId,
          availableQuantity: mainItem.availableQuantity,
        ),
      );
    }

    return RestoredCartData(
      invoiceID: inv?.invoiceId,
      orderNumber: inv?.orderNumber,
      invoiceCode: inv?.invoiceCode,
      invoiceDate: inv?.invoiceDate,
      voucherId: inv?.voucherId,
      items: orderItems,
      orderType: orderType,
      client: client,
      waiter: waiter,
      deliveryMan: deliveryMan,
      deliveryCompany: deliveryCompany,
      table: table,
      restaurantPosDiscountRequest: restaurantPosDiscountRequest,
      isReturnInvoice: isReturn,
      payments: payments ?? const [],
      totalInvoicePrice: inv?.totalInvoicePrice,
      paidAmount: inv?.paidAmount,
      notes: inv?.notes,
      voucherCode: inv?.voucherCode,
      deliveryCost: inv?.deliveryCost,
      totalVat: inv?.totalVat,
      invoiceSubTypesId: inv?.invoiceSubTypesId,
      priceIncludeVat: inv?.priceIncludeVat,
    );
  }

  List<AdditiveModel> _mapNestedAddons(
    List<RestoredInvoiceAdditive>? rawAddons,
    int parentTransId,
  ) {
    final result = <AdditiveModel>[];
    if (rawAddons == null) return result;

    for (final rawAddon in rawAddons) {
      final additiveId = (rawAddon.additiveId ?? rawAddon.additive?.id ?? 0)
          .toString();
      final arName = rawAddon.arabicName ?? rawAddon.additive?.arabicName ?? '';
      final enName = rawAddon.latinName ?? rawAddon.additive?.latinName ?? '';
      final price = rawAddon.price ?? rawAddon.additive?.price ?? 0.0;
      final qty = (rawAddon.quantity ?? 1).toInt().clamp(1, 1 << 20);
      final invoiceDetailsId = rawAddon.invoiceDetailsId;
      final avialableQuantity = rawAddon.availableQuantity;
      log("mapper : $invoiceDetailsId");
      for (int i = 0; i < qty; i++) {
        result.add(
          AdditiveModel(
            id: additiveId,
            availableQuantity: avialableQuantity,
            invoiceDetailsId: invoiceDetailsId,
            arabicName: arName,
            latinName: enName,
            price: price,
            imagePath: rawAddon.imagePath,
            transactionId: rawAddon.transactionId?.toString(),
            parentTransactionId: (rawAddon.parentTransactionId ?? parentTransId)
                .toString(),
          ),
        );
      }
    }
    return result;
  }

  List<AdditiveModel> _mapFlatAddons(
    List<RestoredInvoiceItem>? flatAddons,
    int parentTransId,
  ) {
    final result = <AdditiveModel>[];
    if (flatAddons == null) return result;

    for (final addonItem in flatAddons) {
      final additiveId =
          (addonItem.foodAdditiveId ??
                  addonItem.itemId ??
                  addonItem.item?.id ??
                  0)
              .toString();
      final arName =
          addonItem.itemArabicName ?? addonItem.item?.arabicName ?? '';
      final enName = addonItem.itemLatinName ?? addonItem.item?.latinName ?? '';
      final price = addonItem.price ?? addonItem.item?.price ?? 0.0;
      final qty = (addonItem.quantity ?? 1).toInt().clamp(1, 1 << 20);
      final invoiceDetailsId = addonItem.invoiceDetailsId;
      final avialableQuantity = addonItem.availableQuantity;

      for (int i = 0; i < qty; i++) {
        result.add(
          AdditiveModel(
            id: additiveId,
            availableQuantity: avialableQuantity,
            invoiceDetailsId: invoiceDetailsId,
            arabicName: arName,
            latinName: enName,
            price: price,
            imagePath: addonItem.itemImagePath ?? addonItem.item?.imagePath,
            transactionId: addonItem.transactionId?.toString(),
            parentTransactionId: parentTransId.toString(),
          ),
        );
      }
    }
    return result;
  }
}
