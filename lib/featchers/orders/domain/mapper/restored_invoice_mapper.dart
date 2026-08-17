import 'package:flutter/material.dart';

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
  RestoredCartData toRestoredCartData(BuildContext context) {
    final rawItems = items ?? [];
    final inv = invoice;

    // -------------------------------------------------------------------
    // 1. EXTRACT ORDER TYPE
    // -------------------------------------------------------------------
    CartOrderType orderType = CartOrderType.TAKEAWAY;
    if (inv?.posType != null) {
      orderType = CartOrderType.values.firstWhere(
        (e) => e.apiValue == inv!.posType,
        orElse: () => CartOrderType.TAKEAWAY,
      );
    }

    // -------------------------------------------------------------------
    // 2. EXTRACT ENTITIES (Client, Waiter, Delivery Man, Company, Table)
    // -------------------------------------------------------------------
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
    final tableId = inv?.foodTableId ?? inv?.foodTable?.id;
    if (tableId != null && tableId != 0) {
      table = TableEntity(
        id: tableId.toString(),
        arabicName:
            inv?.foodTableArabicName ?? inv?.foodTable?.arabicName ?? '',
        latinName: inv?.foodTableLatinName ?? inv?.foodTable?.latinName ?? '',
      );
    }

    // -------------------------------------------------------------------
    // 3. EXTRACT INVOICE DISCOUNT
    // -------------------------------------------------------------------
    RestaurantPosDiscountRequest? restaurantPosDiscountRequest;
    if (inv?.invoiceDiscount != null) {
      final discount = inv!.invoiceDiscount!;
      final double val = discount.discountValue ?? 0.0;
      if (val > 0) {
        // discountType 1 = Percentage, 2 = Fixed Value
        final bool isPerc = discount.discountType == 1;
        restaurantPosDiscountRequest = RestaurantPosDiscountRequest(
          type: isPerc ? 1 : 2,
          value: val,
        );
      }
    }

    // -------------------------------------------------------------------
    // 4. MAP ITEMS AND ADDONS
    // -------------------------------------------------------------------
    final mainItemsMap = <int, RestoredInvoiceItem>{};
    final flatAdditivesMap = <int, List<RestoredInvoiceItem>>{};
    int fallbackCounter = 1;

    for (var item in rawItems) {
      if (item.parentTransactionId == null || item.parentTransactionId == 0) {
        final int transId =
            (item.transactionId != null && item.transactionId != 0)
            ? item.transactionId!
            : (DateTime.now().microsecondsSinceEpoch + (fallbackCounter++));

        mainItemsMap[transId] = item;
      } else {
        // Collect flat additives linked to a parent transaction ID
        flatAdditivesMap
            .putIfAbsent(item.parentTransactionId!, () => [])
            .add(item);
      }
    }

    final List<OrderItem> orderItems = [];

    for (var entry in mainItemsMap.entries) {
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
        imagePath: mainItem.itemImagePath,
        categoryId: mainItem.item?.categoryId ?? 0,
        defaultPrice: mainItem.price ?? mainItem.item?.price ?? 0.0,
        isOffer: false,
        orderSerial: 0,
        count: 0,
        posTypes: const [],
        sizes: selectedSize != null ? [selectedSize] : const [],
        offersItems: const [],
        isTobaccoTax: inv?.tobaccoTax != null && inv!.tobaccoTax! > 0,
      );

      // Combine both nested additives and flat additives linked by parentTransactionId
      final List<AdditiveModel> allAddons = [];
      allAddons.addAll(_mapNestedAddons(mainItem.additives));
      allAddons.addAll(_mapFlatAddons(flatAdditivesMap[transId]));

      double discountVal = mainItem.itemDiscount?.discountValue ?? 0.0;
      bool isPercentage = mainItem.itemDiscount?.discountType == 1;

      orderItems.add(
        OrderItem(
          transactionId: transId.toString(),
          menuItem: restaurantItem,
          selectedSize: selectedSize,
          quantity: (mainItem.quantity ?? 1).toInt(),
          notes: mainItem.notes,
          addons: allAddons,
          discount: discountVal,
          isPercentageDiscount: isPercentage,
        ),
      );
    }

    return RestoredCartData(
      items: orderItems,
      orderType: orderType,
      client: client,
      waiter: waiter,
      deliveryMan: deliveryMan,
      deliveryCompany: deliveryCompany,
      table: table,
      restaurantPosDiscountRequest: restaurantPosDiscountRequest,
    );
  }

  /// Converts nested `RestoredInvoiceAdditive` items into a flat list of `AdditiveModel`.
  List<AdditiveModel> _mapNestedAddons(
    List<RestoredInvoiceAdditive>? rawAddons,
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

      for (int i = 0; i < qty; i++) {
        result.add(
          AdditiveModel(
            id: additiveId,
            arabicName: arName,
            latinName: enName,
            price: price,
            imagePath: rawAddon.imagePath,
          ),
        );
      }
    }

    return result;
  }

  /// Converts flat `RestoredInvoiceItem` additives into a list of `AdditiveModel`.
  List<AdditiveModel> _mapFlatAddons(List<RestoredInvoiceItem>? flatAddons) {
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

      for (int i = 0; i < qty; i++) {
        result.add(
          AdditiveModel(
            id: additiveId,
            arabicName: arName,
            latinName: enName,
            price: price,
            imagePath: addonItem.itemImagePath,
          ),
        );
      }
    }

    return result;
  }
}
