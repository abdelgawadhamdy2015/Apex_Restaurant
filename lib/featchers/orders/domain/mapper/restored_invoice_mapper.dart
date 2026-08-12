import 'package:apex_restaurant/featchers/cart/data/enums/cart_enum.dart';
import 'package:apex_restaurant/featchers/cart/data/models/invoice_request_model.dart';
import 'package:apex_restaurant/featchers/cart/data/models/pos_client_model.dart';
import 'package:apex_restaurant/featchers/cart/data/models/waiter_model.dart';
import 'package:apex_restaurant/featchers/orders/data/model/restored_invoice_model.dart';
import 'package:apex_restaurant/featchers/pos/data/models/category_model.dart';
import 'package:apex_restaurant/featchers/pos/data/models/delivery_company.dart';
import 'package:apex_restaurant/featchers/pos/data/models/restaurant_item.dart';
import 'package:apex_restaurant/featchers/pos/domain/entities/menu_item.dart';
import 'package:apex_restaurant/featchers/pos/presentation/bloc/pos_bloc.dart';
import 'package:apex_restaurant/featchers/tables/domain/entities/table_entity.dart';
import 'package:apex_restaurant/featchers/cart/data/models/restored_cart_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    // work fine
    PosClientModel? client;
    if (inv?.clientId != null || inv?.client != null) {
      final clientId = inv?.client?.id ?? 0;
      final arName = inv?.client?.arabicName ?? '';
      final enName = inv?.client?.latinName ?? '';
      client = PosClientModel(
        id: clientId,
        arabicName: arName,
        latinName: enName,
      );
    }
    // not test
    WaiterModel? waiter;
    if (inv?.waiterId != null || inv?.waiter != null) {
      final waiterId = inv?.waiterId ?? _extractNestedId(inv?.waiter);
      final arName =
          inv?.waiterArabicName ??
          _extractNestedString(inv?.waiter, 'arabicName') ??
          '';
      final enName =
          inv?.waiterLatinName ??
          _extractNestedString(inv?.waiter, 'latinName') ??
          '';
      if (waiterId != null) {
        waiter = WaiterModel(
          id: waiterId,
          arabicName: arName,
          latinName: enName,
        );
      }
    }
    // not work can be from save
    WaiterModel? deliveryMan;
    if (inv?.deliveryManId != null || inv?.deliveryMan != null) {
      final delId = inv?.deliveryManId ?? _extractNestedId(inv?.deliveryMan);
      final arName =
          inv?.deliveryManArabicName ??
          _extractNestedString(inv?.deliveryMan, 'arabicName') ??
          '';
      final enName =
          inv?.deliveryManLatinName ??
          _extractNestedString(inv?.deliveryMan, 'latinName') ??
          '';
      if (delId != null) {
        deliveryMan = WaiterModel(
          id: delId,
          arabicName: arName,
          latinName: enName,
        );
      }
    }
    // not test
    DeliveryCompanyModel? deliveryCompany;
    if (inv?.deliveryCompanyId != null || inv?.deliveryCompany != null) {
      final compId =
          inv?.deliveryCompanyId ?? _extractNestedId(inv?.deliveryCompany);
      final arName =
          inv?.deliveryCompanyArabicName ??
          _extractNestedString(inv?.deliveryCompany, 'arabicName') ??
          '';
      final enName =
          inv?.deliveryCompanyLatinName ??
          _extractNestedString(inv?.deliveryCompany, 'latinName') ??
          '';
      if (compId != null) {
        deliveryCompany = DeliveryCompanyModel(
          id: compId,
          arabicName: arName,
          latinName: enName,
        );
      }
    }
    // not test
    TableEntity? table;
    if (inv?.foodTableId != null || inv?.foodTable != null) {
      final tableId = inv?.foodTableId ?? _extractNestedId(inv?.foodTable);
      final arName =
          inv?.foodTableArabicName ??
          _extractNestedString(inv?.foodTable, 'arabicName') ??
          '';
      final enName =
          inv?.foodTableLatinName ??
          _extractNestedString(inv?.foodTable, 'latinName') ??
          '';
      if (tableId != null) {
        table = TableEntity(
          id: tableId.toString(),
          arabicName: arName,
          latinName: enName,
        );
      }
    }

    // -------------------------------------------------------------------
    // 3. EXTRACT INVOICE DISCOUNT
    // -------------------------------------------------------------------

    // not sure yet
    SaveDiscountModel? saveDiscountModel;
    if (inv?.invoiceDiscount != null) {
      if (inv!.invoiceDiscount is Map) {
        final val =
            (inv.invoiceDiscount['discountValue'] as num?)?.toDouble() ?? 0.0;
        final isPerc = (inv.invoiceDiscount['isPercentage'] as bool?) ?? false;
        if (val > 0) {
          saveDiscountModel = SaveDiscountModel(
            type: isPerc ? 1 : 2,
            value: val,
          );
        }
      } else if (inv.invoiceDiscount is num &&
          (inv.invoiceDiscount as num) > 0) {
        saveDiscountModel = SaveDiscountModel(
          type: 2,
          value: (inv.invoiceDiscount as num).toDouble(),
        );
      }
    }

    // -------------------------------------------------------------------
    // 4. MAP ITEMS AND ADDONS
    // -------------------------------------------------------------------
    final mainItemsMap = <int, RestoredInvoiceItemModel>{};
    final Map<int, List<AdditiveModel>> itemAddonsMap = {};
    int fallbackCounter = 1;

    for (var item in rawItems) {
      if (item.parentTransactionId == null || item.parentTransactionId == 0) {
        final int transId =
            (item.transactionId != null && item.transactionId != 0)
            ? item.transactionId!
            : (DateTime.now().microsecondsSinceEpoch + (fallbackCounter++));
        mainItemsMap[transId] = item;
      }
    }

    for (var item in rawItems) {
      if (item.parentTransactionId != null && item.parentTransactionId != 0) {
        final parentId = item.parentTransactionId!;

        String additiveId = (item.foodAdditiveId ?? item.itemId ?? 0)
            .toString();
        if (additiveId == '0' && item.additive != null) {
          additiveId = (_extractNestedId(item.additive) ?? 0).toString();
        }

        String arName =
            item.itemArabicName ??
            _extractNestedString(item.additive, 'arabicName') ??
            '';
        String enName =
            item.itemLatinName ??
            _extractNestedString(item.additive, 'latinName') ??
            '';

        final additiveModel = AdditiveModel(
          id: additiveId,
          arabicName: arName,
          latinName: enName,
          price: item.price ?? 0.0,
          notes: item.notes,
        );

        itemAddonsMap.putIfAbsent(parentId, () => []).add(additiveModel);
      }
    }

    final List<OrderItem> orderItems = [];

    for (var entry in mainItemsMap.entries) {
      final transId = entry.key;
      final mainItem = entry.value;

      final String itemNameAr =
          mainItem.itemArabicName ??
          _extractNestedString(mainItem.item, 'arabicName') ??
          '';
      final String itemNameEn =
          mainItem.itemLatinName ??
          _extractNestedString(mainItem.item, 'latinName') ??
          '';

      ItemSize? selectedSize;
      if (mainItem.sizeId != null || mainItem.size != null) {
        final int sId = mainItem.sizeId ?? _extractNestedId(mainItem.size) ?? 0;
        // final String sizeNameAr =
        //     mainItem.sizeArabicName ??
        //     _extractNestedString(mainItem.size, 'arabicName') ??
        //     '';
        // final String sizeNameEn =
        //     mainItem.sizeLatinName ??
        //     _extractNestedString(mainItem.size, 'latinName') ??
        //     '';
        final selecteItem = context
            .read<PosBloc>()
            .state
            .currentMenuItems
            .where((item) {
              return item.itemId == mainItem.itemId;
            })
            .first;
        selectedSize = selecteItem.sizes.where((s) => s.sizeId == sId).first;

        //  ItemSize(
        //   variantId: 0,
        //   sizeId: sId,
        //   sizeNameAr: sizeNameAr,
        //   sizeNameEn: sizeNameEn,
        //   price: mainItem.price ?? 0.0,
        //   isActive: true,
        //   discount: const [],
        // );
      }

      final restaurantItem = RestaurantItem(
        itemId: mainItem.itemId ?? _extractNestedId(mainItem.item) ?? 0,
        itemCode: '',
        itemNameAr: itemNameAr,
        itemNameEn: itemNameEn,
        imagePath: mainItem.itemImagePath,
        categoryId: 0,
        defaultPrice: mainItem.price ?? 0.0,
        isOffer: false,
        orderSerial: 0,
        count: 0,
        posTypes: const [],
        sizes: selectedSize != null ? [selectedSize] : const [],
        offersItems: const [],
      );

      final addonsList = itemAddonsMap[transId] ?? [];

      double discountVal = 0.0;
      bool isPercentage = false;
      if (mainItem.itemDiscount != null) {
        if (mainItem.itemDiscount is Map) {
          discountVal =
              (mainItem.itemDiscount['discountValue'] as num?)?.toDouble() ??
              0.0;
          isPercentage =
              (mainItem.itemDiscount['isPercentage'] as bool?) ?? false;
        } else if (mainItem.itemDiscount is num) {
          discountVal = (mainItem.itemDiscount as num).toDouble();
        }
      }

      orderItems.add(
        OrderItem(
          transactionId: transId,
          menuItem: restaurantItem,
          selectedSize: selectedSize,
          quantity: (mainItem.quantity ?? 1).toInt(),
          notes: mainItem.notes,
          addons: addonsList,
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
      saveDiscountModel: saveDiscountModel,
    );
  }

  int? _extractNestedId(dynamic obj) {
    if (obj == null) return null;
    if (obj is Map) return (obj['id'] as num?)?.toInt();
    try {
      return obj.id;
    } catch (_) {}
    return null;
  }

  String? _extractNestedString(dynamic obj, String key) {
    if (obj == null) return null;
    if (obj is Map) return obj[key]?.toString();
    try {
      if (key == 'arabicName') return obj.arabicName;
      if (key == 'latinName') return obj.latinName;
    } catch (_) {}
    return null;
  }
}
