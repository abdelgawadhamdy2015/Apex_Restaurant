import 'package:json_annotation/json_annotation.dart';

part 'save_table_data.g.dart';

@JsonSerializable(explicitToJson: true)
class SaveTableData {
  final dynamic invoiceFiles;
  final dynamic eInvoiceError;
  final dynamic eInvoiceFields;
  final dynamic invPurchaseAdditionalCostsRelations;

  final List<SaveTableInvoiceDetail>? invoicesDetails;
  final List<dynamic>? invoicePaymentsMethods;

  final dynamic kitchenPrintingSystem;
  final dynamic extractedRestItemsDetails;

  final int? branchId;
  final int? invoiceId;
  final int? tabId;
  final String? reqId;
  final int? serviceProviderId;

  final String? invoiceType;
  final int? code;
  final num? serialize;
  final int? parentInvoiceCode;
  final bool? isDeleted;
  final int? bookIndex;
  final DateTime? invoiceDate;

  final int? storeId;
  final int? storeIdTo;
  final int? transferStatus;
  final num? totalPrice;
  final String? notes;
  final String? transferNotesAR;
  final String? transferNotesEN;

  final int? invoiceTypeId;
  final int? invoiceSubTypesId;
  final String? browserName;
  final bool? isAccredite;
  final int? employeeId;
  final int? personId;

  final num? totalDiscountValue;
  final num? totalDiscountRatio;
  final num? net;
  final num? paid;
  final num? remain;
  final num? virualPaid;
  final num? totalAfterDiscount;
  final num? totalVat;

  final bool? applyVat;
  final bool? priceWithVat;

  final int? discountType;
  final int? paymentType;
  final bool? activeDiscount;
  final bool? isReturn;

  final int? salesManId;
  final int? priceListId;
  final int? invoiceTransferType;
  final int? roundNumber;
  final int? posSessionId;

  final num? actualNet;
  final String? codeOfflinePOS;
  final num? totalOtherAdditions;

  final bool? isCollectionReceipt;
  final bool? eInvoiceReported;
  final String? eInvoiceCode;
  final bool? isDiscountRatio;

  final DateTime? lastTimeProfitCalced;
  final bool? isExpenses;
  final int? settlement;
  final bool? canSettled;
  final DateTime? orderReceivedTime;
  final DateTime? creationDate;

  final num? deliveryCost;
  final num? dineInCost;
  final num? tobaccoTax;

  final int? posType;
  final int? deliveryCompanyId;
  final int? deliveryManId;

  final dynamic deliveryMan;

  final int? foodTablesId;
  final dynamic foodTables;

  final int? restaurantPosSessionId;
  final int? waiterId;
  final int? personAddressId;
  final int? personPhoneId;

  final num? invoiceDiscountValue;
  final int? invoiceDiscountType;

  final dynamic deliveryCompany;
  final dynamic waiter;
  final dynamic personAddress;
  final dynamic personPhone;
  final dynamic restaurantPosSession;
  final int? invoiceDiscountId;

  final bool? isAsync;

  final dynamic quantitySettlement;
  final dynamic person;
  final dynamic branch;
  final dynamic employee;
  final dynamic store;
  final dynamic storeTo;
  final dynamic invoiceDiscount;
  final dynamic salesMan;

  @JsonKey(name: 'voucherID')
  final int? voucherId;

  final dynamic voucher;
  final int? orderNumber;
  final num? voucherDiscountValue;

  const SaveTableData({
    this.invoiceFiles,
    this.eInvoiceError,
    this.eInvoiceFields,
    this.invPurchaseAdditionalCostsRelations,
    this.invoicesDetails,
    this.invoicePaymentsMethods,
    this.kitchenPrintingSystem,
    this.extractedRestItemsDetails,
    this.branchId,
    this.invoiceId,
    this.tabId,
    this.reqId,
    this.serviceProviderId,
    this.invoiceType,
    this.code,
    this.serialize,
    this.parentInvoiceCode,
    this.isDeleted,
    this.bookIndex,
    this.invoiceDate,
    this.storeId,
    this.storeIdTo,
    this.transferStatus,
    this.totalPrice,
    this.notes,
    this.transferNotesAR,
    this.transferNotesEN,
    this.invoiceTypeId,
    this.invoiceSubTypesId,
    this.browserName,
    this.isAccredite,
    this.employeeId,
    this.personId,
    this.totalDiscountValue,
    this.totalDiscountRatio,
    this.net,
    this.paid,
    this.remain,
    this.virualPaid,
    this.totalAfterDiscount,
    this.totalVat,
    this.applyVat,
    this.priceWithVat,
    this.discountType,
    this.paymentType,
    this.activeDiscount,
    this.isReturn,
    this.salesManId,
    this.priceListId,
    this.invoiceTransferType,
    this.roundNumber,
    this.posSessionId,
    this.actualNet,
    this.codeOfflinePOS,
    this.totalOtherAdditions,
    this.isCollectionReceipt,
    this.eInvoiceReported,
    this.eInvoiceCode,
    this.isDiscountRatio,
    this.lastTimeProfitCalced,
    this.isExpenses,
    this.settlement,
    this.canSettled,
    this.orderReceivedTime,
    this.creationDate,
    this.deliveryCost,
    this.dineInCost,
    this.tobaccoTax,
    this.posType,
    this.deliveryCompanyId,
    this.deliveryManId,
    this.deliveryMan,
    this.foodTablesId,
    this.foodTables,
    this.restaurantPosSessionId,
    this.waiterId,
    this.personAddressId,
    this.personPhoneId,
    this.invoiceDiscountValue,
    this.invoiceDiscountType,
    this.deliveryCompany,
    this.waiter,
    this.personAddress,
    this.personPhone,
    this.restaurantPosSession,
    this.invoiceDiscountId,
    this.isAsync,
    this.quantitySettlement,
    this.person,
    this.branch,
    this.employee,
    this.store,
    this.storeTo,
    this.invoiceDiscount,
    this.salesMan,
    this.voucherId,
    this.voucher,
    this.orderNumber,
    this.voucherDiscountValue,
  });

  factory SaveTableData.fromJson(Map<String, dynamic> json) =>
      _$SaveTableDataFromJson(json);

  Map<String, dynamic> toJson() => _$SaveTableDataToJson(this);
}

@JsonSerializable()
class SaveTableInvoiceDetail {
  final String? itemNote;

  final int? id;
  final int? invoiceId;
  final int? itemId;
  final int? unitId;
  final int? uniqueId;
  final int? noteId;
  final int? sizeId;

  final num? quantity;
  final num? price;
  final num? totalWithSplitedDiscount;
  final num? totalWithOutSplitedDiscount;

  final DateTime? expireDate;
  final int? signal;
  final int? itemTypeId;

  final num? discountValue;
  final num? discountRatio;
  final num? vatRatio;
  final num? vatValue;
  final num? transQuantity;
  final num? returnQuantity;

  final int? statusOfTrans;

  final num? splitedDiscountValue;
  final num? splitedDiscountRatio;
  final num? avgPrice;
  final num? cost;
  final num? autoDiscount;

  final int? priceList;
  final num? minimumPrice;
  final num? conversionFactor;
  final int? indexOfSerialNo;
  final int? indexOfItem;

  final String? balanceBarcode;
  final int? parentItemId;
  final num? otherAdditions;
  final String? codeOfflinePOS;

  final num? vatValueForPrint;
  final bool? isDiscountRatioItem;

  final num? actualQuantity;
  final num? quantityDifference;
  final bool? isSettled;

  final dynamic serialsWillBeSttled;
  final bool? isCompositSerial;

  final int? foodAdditiveId;
  final num? itemTobaccoTax;

  @JsonKey(name: 'transactionID')
  final int? transactionId;

  @JsonKey(name: 'parentTransactionID')
  final int? parentTransactionId;

  final num? extractedQuantity;
  final int? itemDiscountsId;
  final num? printedQty;
  final bool? isVisable;

  final dynamic foodAdditive;
  final dynamic itemDiscounts;
  final dynamic units;
  final dynamic sizes;
  final dynamic items;
  final dynamic note;

  const SaveTableInvoiceDetail({
    this.itemNote,
    this.id,
    this.invoiceId,
    this.itemId,
    this.unitId,
    this.uniqueId,
    this.noteId,
    this.sizeId,
    this.quantity,
    this.price,
    this.totalWithSplitedDiscount,
    this.totalWithOutSplitedDiscount,
    this.expireDate,
    this.signal,
    this.itemTypeId,
    this.discountValue,
    this.discountRatio,
    this.vatRatio,
    this.vatValue,
    this.transQuantity,
    this.returnQuantity,
    this.statusOfTrans,
    this.splitedDiscountValue,
    this.splitedDiscountRatio,
    this.avgPrice,
    this.cost,
    this.autoDiscount,
    this.priceList,
    this.minimumPrice,
    this.conversionFactor,
    this.indexOfSerialNo,
    this.indexOfItem,
    this.balanceBarcode,
    this.parentItemId,
    this.otherAdditions,
    this.codeOfflinePOS,
    this.vatValueForPrint,
    this.isDiscountRatioItem,
    this.actualQuantity,
    this.quantityDifference,
    this.isSettled,
    this.serialsWillBeSttled,
    this.isCompositSerial,
    this.foodAdditiveId,
    this.itemTobaccoTax,
    this.transactionId,
    this.parentTransactionId,
    this.extractedQuantity,
    this.itemDiscountsId,
    this.printedQty,
    this.isVisable,
    this.foodAdditive,
    this.itemDiscounts,
    this.units,
    this.sizes,
    this.items,
    this.note,
  });

  factory SaveTableInvoiceDetail.fromJson(Map<String, dynamic> json) =>
      _$SaveTableInvoiceDetailFromJson(json);

  Map<String, dynamic> toJson() => _$SaveTableInvoiceDetailToJson(this);
}
