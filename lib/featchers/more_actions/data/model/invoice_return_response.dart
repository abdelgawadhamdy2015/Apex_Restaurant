import 'package:json_annotation/json_annotation.dart';

part 'invoice_return_response.g.dart';

@JsonSerializable()
class InvoiceReturnResponse {
  @JsonKey(name: 'isTransferDataToNewYear')
  final bool? isTransferDataToNewYear;

  @JsonKey(name: 'invoiceId')
  final int? invoiceId;

  @JsonKey(name: 'serviceProvider')
  final List<dynamic>? serviceProvider;

  @JsonKey(name: 'invoiceCode')
  final String? invoiceCode;

  @JsonKey(name: 'reportStatus')
  final int? reportStatus;

  @JsonKey(name: 'parentInvoiceCode')
  final String? parentInvoiceCode;

  @JsonKey(name: 'invoiceTypeId')
  final int? invoiceTypeId;

  @JsonKey(name: 'invoiceSubTypesId')
  final int? invoiceSubTypesId;

  @JsonKey(name: 'qrCode')
  final String? qrCode;

  @JsonKey(name: 'bookIndex')
  final String? bookIndex;

  @JsonKey(name: 'invoiceDate')
  final DateTime? invoiceDate;

  @JsonKey(name: 'storeId')
  final int? storeId;

  @JsonKey(name: 'storeIdTo')
  final int? storeIdTo;

  @JsonKey(name: 'storeNameAr')
  final String? storeNameAr;

  @JsonKey(name: 'storeNameEn')
  final String? storeNameEn;

  @JsonKey(name: 'storeToNameAr')
  final String? storeToNameAr;

  @JsonKey(name: 'storeToNameEn')
  final String? storeToNameEn;

  @JsonKey(name: 'storeStatus')
  final int? storeStatus;

  @JsonKey(name: 'notes')
  final String? notes;

  @JsonKey(name: 'branchId')
  final int? branchId;

  @JsonKey(name: 'branchNameAr')
  final String? branchNameAr;

  @JsonKey(name: 'branchNameEn')
  final String? branchNameEn;

  @JsonKey(name: 'branchPhoneNumber')
  final String? branchPhoneNumber;

  @JsonKey(name: 'branchAddressAr')
  final String? branchAddressAr;

  @JsonKey(name: 'branchAddressEn')
  final String? branchAddressEn;

  @JsonKey(name: 'commercialRegisterNumber')
  final String? commercialRegisterNumber;

  @JsonKey(name: 'branchZipCode')
  final String? branchZipCode;

  @JsonKey(name: 'branchCountry')
  final String? branchCountry;

  @JsonKey(name: 'branchCity')
  final String? branchCity;

  @JsonKey(name: 'branch_District')
  final String? branchDistrict;

  @JsonKey(name: 'branchStreet')
  final String? branchStreet;

  @JsonKey(name: 'branchBuildingNumber')
  final String? branchBuildingNumber;

  @JsonKey(name: 'itemCardModel')
  final dynamic itemCardModel;

  @JsonKey(name: 'personId')
  final int? personId;

  @JsonKey(name: 'personNameAr')
  final String? personNameAr;

  @JsonKey(name: 'personNameEn')
  final String? personNameEn;

  @JsonKey(name: 'isCustomerAndSupplier')
  final bool? isCustomerAndSupplier;

  @JsonKey(name: 'personTaxNumber')
  final String? personTaxNumber;

  @JsonKey(name: 'personAddressAr')
  final String? personAddressAr;

  @JsonKey(name: 'personAddressEn')
  final String? personAddressEn;

  @JsonKey(name: 'personPhone')
  final String? personPhone;

  @JsonKey(name: 'personFax')
  final String? personFax;

  @JsonKey(name: 'personEmail')
  final String? personEmail;

  @JsonKey(name: 'personCreditLimit')
  final double? personCreditLimit;

  @JsonKey(name: 'balance')
  final double? balance;

  @JsonKey(name: 'isCreditor')
  final bool? isCreditor;

  @JsonKey(name: 'personStatus')
  final int? personStatus;

  @JsonKey(name: 'personCode')
  final int? personCode;

  @JsonKey(name: 'personCreditPeriod')
  final int? personCreditPeriod;

  @JsonKey(name: 'personDiscountRatio')
  final double? personDiscountRatio;

  @JsonKey(name: 'personBuildingNumber')
  final String? personBuildingNumber;

  @JsonKey(name: 'personStreetName')
  final String? personStreetName;

  @JsonKey(name: 'personNeighborhood')
  final String? personNeighborhood;

  @JsonKey(name: 'personCity')
  final String? personCity;

  @JsonKey(name: 'personCountry')
  final String? personCountry;

  @JsonKey(name: 'personResponsibleAr')
  final String? personResponsibleAr;

  @JsonKey(name: 'personResponsibleEn')
  final String? personResponsibleEn;

  @JsonKey(name: 'salesManId')
  final int? salesManId;

  @JsonKey(name: 'salesManNameAr')
  final String? salesManNameAr;

  @JsonKey(name: 'salesManNameEn')
  final String? salesManNameEn;

  @JsonKey(name: 'salesManPhone')
  final String? salesManPhone;

  @JsonKey(name: 'salesManEmail')
  final String? salesManEmail;

  @JsonKey(name: 'employeeId')
  final int? employeeId;

  @JsonKey(name: 'employeeNameAr')
  final String? employeeNameAr;

  @JsonKey(name: 'employeeNameEn')
  final String? employeeNameEn;

  @JsonKey(name: 'browserName')
  final String? browserName;

  @JsonKey(name: 'code')
  final int? code;

  @JsonKey(name: 'invoiceType')
  final String? invoiceType;

  @JsonKey(name: 'serialize')
  final double? serialize;

  @JsonKey(name: 'totalPrice')
  final double? totalPrice;

  @JsonKey(name: 'totalPriceSubVat')
  final double? totalPriceSubVat;

  @JsonKey(name: 'totalDiscountValue')
  final double? totalDiscountValue;

  @JsonKey(name: 'totalDiscountRatio')
  final double? totalDiscountRatio;

  @JsonKey(name: 'net')
  final double? net;

  @JsonKey(name: 'paid')
  final double? paid;

  @JsonKey(name: 'remain')
  final double? remain;

  @JsonKey(name: 'virualPaid')
  final double? virualPaid;

  @JsonKey(name: 'totalAfterDiscount')
  final double? totalAfterDiscount;

  @JsonKey(name: 'totalAfterDiscountSubVat')
  final double? totalAfterDiscountSubVat;

  @JsonKey(name: 'totalVat')
  final double? totalVat;

  @JsonKey(name: 'applyVat')
  final bool? applyVat;

  @JsonKey(name: 'priceWithVat')
  final bool? priceWithVat;

  @JsonKey(name: 'discountType')
  final int? discountType;

  @JsonKey(name: 'paymentType')
  final int? paymentType;

  @JsonKey(name: 'totalPaymentsMethod')
  final double? totalPaymentsMethod;

  @JsonKey(name: 'activeDiscount')
  final bool? activeDiscount;

  @JsonKey(name: 'canDeleted')
  final bool? canDeleted;

  @JsonKey(name: 'isDeleted')
  final bool? isDeleted;

  @JsonKey(name: 'isAccredited')
  final bool? isAccredited;

  @JsonKey(name: 'roundNumber')
  final int? roundNumber;

  @JsonKey(name: 'balanceBarcode')
  final String? balanceBarcode;

  @JsonKey(name: 'isCollectionReceipt')
  final bool? isCollectionReceipt;

  @JsonKey(name: 'isDiscountRatio')
  final bool? isDiscountRatio;

  @JsonKey(name: 'isReturn')
  final bool? isReturn;

  @JsonKey(name: 'priceListId')
  final int? priceListId;

  @JsonKey(name: 'isExpenses')
  final bool? isExpenses;

  @JsonKey(name: 'isCompositSerial')
  final bool? isCompositSerial;

  @JsonKey(name: 'canSettled')
  final bool? canSettled;

  @JsonKey(name: 'foodTableID')
  final String? foodTableId;

  @JsonKey(name: 'foodTableName_ar')
  final String? foodTableNameAr;

  @JsonKey(name: 'foodTableName_en')
  final String? foodTableNameEn;

  @JsonKey(name: 'floorID')
  final String? floorId;

  @JsonKey(name: 'floorName_ar')
  final String? floorNameAr;

  @JsonKey(name: 'floorName_en')
  final String? floorNameEn;

  @JsonKey(name: 'deliveryCompanyID')
  final String? deliveryCompanyId;

  @JsonKey(name: 'deliveryCompanyName_ar')
  final String? deliveryCompanyNameAr;

  @JsonKey(name: 'deliveryCompanyName_en')
  final String? deliveryCompanyNameEn;

  @JsonKey(name: 'deliveryManID')
  final String? deliveryManId;

  @JsonKey(name: 'deliveryManName_ar')
  final String? deliveryManNameAr;

  @JsonKey(name: 'deliveryManName_en')
  final String? deliveryManNameEn;

  @JsonKey(name: 'orderNumber')
  final String? orderNumber;

  @JsonKey(name: 'voucherCode')
  final String? voucherCode;

  @JsonKey(name: 'voucherDiscount')
  final double? voucherDiscount;

  @JsonKey(name: 'deliverCost')
  final double? deliverCost;

  @JsonKey(name: 'dineInServiceValue')
  final double? dineInServiceValue;

  @JsonKey(name: 'tobaccoTAXValue')
  final double? tobaccoTaxValue;

  @JsonKey(name: 'waiterID')
  final String? waiterId;

  @JsonKey(name: 'waiterName_ar')
  final String? waiterNameAr;

  @JsonKey(name: 'waiterName_en')
  final String? waiterNameEn;

  @JsonKey(name: 'timeOfRecieve')
  final String? timeOfRecieve;

  @JsonKey(name: 'quantitySettlement')
  final List<dynamic>? quantitySettlement;

  @JsonKey(name: 'invoiceDetails')
  final List<InvoiceDetail>? invoiceDetails;

  @JsonKey(name: 'otherAdditionList')
  final List<dynamic>? otherAdditionList;

  @JsonKey(name: 'paymentsMethods')
  final List<PaymentMethod>? paymentsMethods;

  @JsonKey(name: 'filesDetails')
  final List<dynamic>? filesDetails;

  @JsonKey(name: 'eInvoiceFields')
  final List<dynamic>? eInvoiceFields;

  const InvoiceReturnResponse({
    this.isTransferDataToNewYear,
    this.invoiceId,
    this.serviceProvider,
    this.invoiceCode,
    this.reportStatus,
    this.parentInvoiceCode,
    this.invoiceTypeId,
    this.invoiceSubTypesId,
    this.qrCode,
    this.bookIndex,
    this.invoiceDate,
    this.storeId,
    this.storeIdTo,
    this.storeNameAr,
    this.storeNameEn,
    this.storeToNameAr,
    this.storeToNameEn,
    this.storeStatus,
    this.notes,
    this.branchId,
    this.branchNameAr,
    this.branchNameEn,
    this.branchPhoneNumber,
    this.branchAddressAr,
    this.branchAddressEn,
    this.commercialRegisterNumber,
    this.branchZipCode,
    this.branchCountry,
    this.branchCity,
    this.branchDistrict,
    this.branchStreet,
    this.branchBuildingNumber,
    this.itemCardModel,
    this.personId,
    this.personNameAr,
    this.personNameEn,
    this.isCustomerAndSupplier,
    this.personTaxNumber,
    this.personAddressAr,
    this.personAddressEn,
    this.personPhone,
    this.personFax,
    this.personEmail,
    this.personCreditLimit,
    this.balance,
    this.isCreditor,
    this.personStatus,
    this.personCode,
    this.personCreditPeriod,
    this.personDiscountRatio,
    this.personBuildingNumber,
    this.personStreetName,
    this.personNeighborhood,
    this.personCity,
    this.personCountry,
    this.personResponsibleAr,
    this.personResponsibleEn,
    this.salesManId,
    this.salesManNameAr,
    this.salesManNameEn,
    this.salesManPhone,
    this.salesManEmail,
    this.employeeId,
    this.employeeNameAr,
    this.employeeNameEn,
    this.browserName,
    this.code,
    this.invoiceType,
    this.serialize,
    this.totalPrice,
    this.totalPriceSubVat,
    this.totalDiscountValue,
    this.totalDiscountRatio,
    this.net,
    this.paid,
    this.remain,
    this.virualPaid,
    this.totalAfterDiscount,
    this.totalAfterDiscountSubVat,
    this.totalVat,
    this.applyVat,
    this.priceWithVat,
    this.discountType,
    this.paymentType,
    this.totalPaymentsMethod,
    this.activeDiscount,
    this.canDeleted,
    this.isDeleted,
    this.isAccredited,
    this.roundNumber,
    this.balanceBarcode,
    this.isCollectionReceipt,
    this.isDiscountRatio,
    this.isReturn,
    this.priceListId,
    this.isExpenses,
    this.isCompositSerial,
    this.canSettled,
    this.foodTableId,
    this.foodTableNameAr,
    this.foodTableNameEn,
    this.floorId,
    this.floorNameAr,
    this.floorNameEn,
    this.deliveryCompanyId,
    this.deliveryCompanyNameAr,
    this.deliveryCompanyNameEn,
    this.deliveryManId,
    this.deliveryManNameAr,
    this.deliveryManNameEn,
    this.orderNumber,
    this.voucherCode,
    this.voucherDiscount,
    this.deliverCost,
    this.dineInServiceValue,
    this.tobaccoTaxValue,
    this.waiterId,
    this.waiterNameAr,
    this.waiterNameEn,
    this.timeOfRecieve,
    this.quantitySettlement,
    this.invoiceDetails,
    this.otherAdditionList,
    this.paymentsMethods,
    this.filesDetails,
    this.eInvoiceFields,
  });

  factory InvoiceReturnResponse.fromJson(Map<String, dynamic> json) =>
      _$InvoiceReturnResponseFromJson(json);

  Map<String, dynamic> toJson() => _$InvoiceReturnResponseToJson(this);
}

@JsonSerializable()
class InvoiceDetail {
  @JsonKey(name: 'isTransferDataToNewYear')
  final bool? isTransferDataToNewYear;

  final int? id;
  final int? invoiceId;
  final String? uniqueId;

  final int? itemId;
  final String? itemCode;
  final String? itemNameAr;
  final String? itemNameEn;
  final int? parentItemId;

  final int? unitId;
  final int? noteId;
  final String? unitNameAr;
  final String? unitNameEn;

  final dynamic serialNumbers;

  final double? quantity;
  final double? oldQuantity;
  final double? actualQuantity;
  final double? quantityDifference;

  final double? price;
  final double? total;
  final double? totalItemSubVat;

  final DateTime? expireDate;

  final int? signal;
  final int? itemTypeId;

  final double? discountValue;
  final double? discountRatio;
  final double? vatRatio;
  final double? vatValue;

  final double? transQuantity;
  final double? returnQuantity;
  final int? statusOfTrans;

  final double? splitedDiscountValue;
  final double? splitedDiscountRatio;
  final double? avgPrice;
  final double? cost;
  final double? autoDiscount;
  final double? priceList;
  final double? minimumPrice;
  final double? conversionFactor;

  final int? indexOfItem;

  final bool? canDelete;
  final bool? applyVat;
  final bool? isBalanceBarcode;

  final String? balanceBarcode;
  final double? vatValueForPrint;

  final bool? isDiscountRatioItem;
  final bool? isSettled;

  final String? itemNote;
  final dynamic itemCardModel;

  final bool? isCompositSerial;

  @JsonKey(name: 'sizeID')
  final int? sizeId;

  @JsonKey(name: 'sizeName_ar')
  final String? sizeNameAr;

  @JsonKey(name: 'sizeName_en')
  final String? sizeNameEn;

  final double? itemTobaccoTAXValue;

  final List<dynamic>? invoiceSerialDtos;
  final List<dynamic>? storeSerialDtos;
  final List<dynamic>? serialsWillBeSettled;
  final List<dynamic>? listSerialsForCheck;
  final List<dynamic>? existedSerials;
  final List<dynamic>? transferSerialDtos;
  final List<dynamic>? itemUnits;

  final int? parentTransactionID;

  const InvoiceDetail({
    this.isTransferDataToNewYear,
    this.id,
    this.invoiceId,
    this.uniqueId,
    this.itemId,
    this.itemCode,
    this.itemNameAr,
    this.itemNameEn,
    this.parentItemId,
    this.unitId,
    this.noteId,
    this.unitNameAr,
    this.unitNameEn,
    this.serialNumbers,
    this.quantity,
    this.oldQuantity,
    this.actualQuantity,
    this.quantityDifference,
    this.price,
    this.total,
    this.totalItemSubVat,
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
    this.indexOfItem,
    this.canDelete,
    this.applyVat,
    this.isBalanceBarcode,
    this.balanceBarcode,
    this.vatValueForPrint,
    this.isDiscountRatioItem,
    this.isSettled,
    this.itemNote,
    this.itemCardModel,
    this.isCompositSerial,
    this.sizeId,
    this.sizeNameAr,
    this.sizeNameEn,
    this.itemTobaccoTAXValue,
    this.invoiceSerialDtos,
    this.storeSerialDtos,
    this.serialsWillBeSettled,
    this.listSerialsForCheck,
    this.existedSerials,
    this.transferSerialDtos,
    this.itemUnits,
    this.parentTransactionID,
  });

  factory InvoiceDetail.fromJson(Map<String, dynamic> json) =>
      _$InvoiceDetailFromJson(json);

  Map<String, dynamic> toJson() => _$InvoiceDetailToJson(this);
}

@JsonSerializable()
class PaymentMethod {
  final int? paymentMethodId;
  final String? paymentNameAr;
  final String? paymentNameEn;
  final double? value;
  final dynamic cheque;

  const PaymentMethod({
    this.paymentMethodId,
    this.paymentNameAr,
    this.paymentNameEn,
    this.value,
    this.cheque,
  });

  factory PaymentMethod.fromJson(Map<String, dynamic> json) =>
      _$PaymentMethodFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentMethodToJson(this);
}
