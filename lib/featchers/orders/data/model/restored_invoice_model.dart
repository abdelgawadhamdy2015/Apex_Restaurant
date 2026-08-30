import 'package:json_annotation/json_annotation.dart';

part 'restored_invoice_model.g.dart';

@JsonSerializable()
class RestoredInvoiceModel {
  final RestoredInvoiceInfo? invoice;
  final List<RestoredInvoiceItem>? items;
  final List<RestoredInvoicePayment>? payments;

  const RestoredInvoiceModel({this.invoice, this.items, this.payments});

  factory RestoredInvoiceModel.fromJson(Map<String, dynamic> json) =>
      _$RestoredInvoiceModelFromJson(json);

  Map<String, dynamic> toJson() => _$RestoredInvoiceModelToJson(this);
}

@JsonSerializable()
class RestoredInvoiceInfo {
  final int? invoiceId;
  final int? invoiceDiscountId;
  final int? orderNumber;
  final String? invoiceCode;
  final DateTime? invoiceDate;
  final int? posType;
  final bool canEdit;
  final int? foodTableId;
  final String? foodTableArabicName;
  final String? foodTableLatinName;

  final int? waiterId;
  final String? waiterArabicName;
  final String? waiterLatinName;

  final int? deliveryCompanyId;
  final String? deliveryCompanyArabicName;
  final String? deliveryCompanyLatinName;

  final int? deliveryManId;
  final String? deliveryManArabicName;
  final String? deliveryManLatinName;

  final int? clientId;
  final String? clientArabicName;
  final String? clientLatinName;

  final int? personAddressId;
  final RestoredAddress? address;

  final int? personPhoneId;
  final RestoredPhone? phone;

  final String? notes;
  final RestoredInvoiceDiscount? invoiceDiscount;

  final double? totalInvoicePrice;
  final double? paidAmount;
  final double? remain;
  final double? totalVat;
  final double? deliveryCost;
  final double? dineInCost;
  final double? tobaccoTax;

  final RestoredClient? client;
  final RestoredWaiter? waiter;
  final RestoredDeliveryCompany? deliveryCompany;
  final RestoredDeliveryMan? deliveryMan;
  final RestoredFoodTable? foodTable;

  final String? voucherId;

  const RestoredInvoiceInfo({
    this.invoiceId,
    this.invoiceDiscountId,
    this.orderNumber,
    this.invoiceCode,
    this.invoiceDate,
    this.posType,
    this.foodTableId,
    this.foodTableArabicName,
    this.foodTableLatinName,
    this.waiterId,
    this.waiterArabicName,
    this.waiterLatinName,
    this.deliveryCompanyId,
    this.deliveryCompanyArabicName,
    this.deliveryCompanyLatinName,
    this.deliveryManId,
    this.deliveryManArabicName,
    this.deliveryManLatinName,
    this.clientId,
    this.clientArabicName,
    this.clientLatinName,
    this.personAddressId,
    this.address,
    this.personPhoneId,
    this.phone,
    this.notes,
    this.invoiceDiscount,
    this.totalInvoicePrice,
    this.paidAmount,
    this.remain,
    this.totalVat,
    this.deliveryCost,
    this.dineInCost,
    this.tobaccoTax,
    this.client,
    this.waiter,
    this.deliveryCompany,
    this.deliveryMan,
    this.foodTable,
    this.voucherId,
    this.canEdit = true,
  });

  factory RestoredInvoiceInfo.fromJson(Map<String, dynamic> json) =>
      _$RestoredInvoiceInfoFromJson(json);

  Map<String, dynamic> toJson() => _$RestoredInvoiceInfoToJson(this);
}

@JsonSerializable()
class RestoredAddress {
  final int? id;
  final String? addressLineAr;
  final String? addressLineEn;
  final String? city;
  final String? street;
  final String? district;
  final String? buildingNo;
  final String? floor;
  final String? apartmentNo;
  final String? landmark;
  final bool? isDefault;
  final int? personsId;
  final bool? isDeleted;
  final dynamic persons;

  const RestoredAddress({
    this.id,
    this.addressLineAr,
    this.addressLineEn,
    this.city,
    this.street,
    this.district,
    this.buildingNo,
    this.floor,
    this.apartmentNo,
    this.landmark,
    this.isDefault,
    this.personsId,
    this.isDeleted,
    this.persons,
  });

  factory RestoredAddress.fromJson(Map<String, dynamic> json) =>
      _$RestoredAddressFromJson(json);

  Map<String, dynamic> toJson() => _$RestoredAddressToJson(this);
}

@JsonSerializable()
class RestoredPhone {
  const RestoredPhone();

  factory RestoredPhone.fromJson(Map<String, dynamic> json) =>
      _$RestoredPhoneFromJson(json);

  Map<String, dynamic> toJson() => _$RestoredPhoneToJson(this);
}

@JsonSerializable()
class RestoredInvoiceDiscount {
  final String? id;
  final String? arabicName;
  final String? latinName;
  final int? discountType;
  final int? discountNatural;
  final double? discountValue;
  final bool? isAutomatic;

  const RestoredInvoiceDiscount({
    this.id,
    this.arabicName,
    this.latinName,
    this.discountType,
    this.discountNatural,
    this.discountValue,
    this.isAutomatic,
  });

  factory RestoredInvoiceDiscount.fromJson(Map<String, dynamic> json) =>
      _$RestoredInvoiceDiscountFromJson(json);

  Map<String, dynamic> toJson() => _$RestoredInvoiceDiscountToJson(this);
}

@JsonSerializable()
class RestoredClient {
  final int? id;
  final String? arabicName;
  final String? latinName;
  final double? price;
  final int? categoryId;

  const RestoredClient({
    this.id,
    this.arabicName,
    this.latinName,
    this.price,
    this.categoryId,
  });

  factory RestoredClient.fromJson(Map<String, dynamic> json) =>
      _$RestoredClientFromJson(json);

  Map<String, dynamic> toJson() => _$RestoredClientToJson(this);
}

@JsonSerializable()
class RestoredWaiter {
  final int? id;
  final String? arabicName;
  final String? latinName;
  final double? price;
  final int? categoryId;

  const RestoredWaiter({
    this.id,
    this.arabicName,
    this.latinName,
    this.price,
    this.categoryId,
  });

  factory RestoredWaiter.fromJson(Map<String, dynamic> json) =>
      _$RestoredWaiterFromJson(json);

  Map<String, dynamic> toJson() => _$RestoredWaiterToJson(this);
}

@JsonSerializable()
class RestoredDeliveryCompany {
  final int? id;
  final String? arabicName;
  final String? latinName;
  final double? price;
  final int? categoryId;

  const RestoredDeliveryCompany({
    this.id,
    this.arabicName,
    this.latinName,
    this.price,
    this.categoryId,
  });

  factory RestoredDeliveryCompany.fromJson(Map<String, dynamic> json) =>
      _$RestoredDeliveryCompanyFromJson(json);

  Map<String, dynamic> toJson() => _$RestoredDeliveryCompanyToJson(this);
}

@JsonSerializable()
class RestoredDeliveryMan {
  final int? id;
  final String? arabicName;
  final String? latinName;
  final double? price;
  final int? categoryId;

  const RestoredDeliveryMan({
    this.id,
    this.arabicName,
    this.latinName,
    this.price,
    this.categoryId,
  });

  factory RestoredDeliveryMan.fromJson(Map<String, dynamic> json) =>
      _$RestoredDeliveryManFromJson(json);

  Map<String, dynamic> toJson() => _$RestoredDeliveryManToJson(this);
}

@JsonSerializable()
class RestoredFoodTable {
  final String? id;
  final String? arabicName;
  final String? latinName;
  final double? price;
  final int? categoryId;

  const RestoredFoodTable({
    this.id,
    this.arabicName,
    this.latinName,
    this.price,
    this.categoryId,
  });

  factory RestoredFoodTable.fromJson(Map<String, dynamic> json) =>
      _$RestoredFoodTableFromJson(json);

  Map<String, dynamic> toJson() => _$RestoredFoodTableToJson(this);
}

@JsonSerializable()
class RestoredInvoiceItem {
  final int? transactionId;
  final int? parentTransactionId;

  final int? itemId;
  final String? itemArabicName;
  final String? itemLatinName;
  final String? itemImagePath;

  final int? sizeId;
  final String? sizeArabicName;
  final String? sizeLatinName;

  final double? quantity;
  final double? price;
  final String? notes;

  final RestoredItemDiscount? itemDiscount;
  final List<RestoredInvoiceAdditive>? additives;

  final RestoredItem? item;
  final RestoredSize? size;

  final dynamic additive;
  final int? foodAdditiveId;

  const RestoredInvoiceItem({
    this.transactionId,
    this.parentTransactionId,
    this.itemId,
    this.itemArabicName,
    this.itemLatinName,
    this.itemImagePath,
    this.sizeId,
    this.sizeArabicName,
    this.sizeLatinName,
    this.quantity,
    this.price,
    this.notes,
    this.itemDiscount,
    this.additives,
    this.item,
    this.size,
    this.additive,
    this.foodAdditiveId,
  });

  factory RestoredInvoiceItem.fromJson(Map<String, dynamic> json) =>
      _$RestoredInvoiceItemFromJson(json);

  Map<String, dynamic> toJson() => _$RestoredInvoiceItemToJson(this);
}

@JsonSerializable()
class RestoredItemDiscount {
  final String? id;
  final String? arabicName;
  final String? latinName;
  final int? discountType;
  final int? discountNatural;
  final double? discountValue;
  final bool? isAutomatic;

  const RestoredItemDiscount({
    this.id,
    this.arabicName,
    this.latinName,
    this.discountType,
    this.discountNatural,
    this.discountValue,
    this.isAutomatic,
  });

  factory RestoredItemDiscount.fromJson(Map<String, dynamic> json) =>
      _$RestoredItemDiscountFromJson(json);

  Map<String, dynamic> toJson() => _$RestoredItemDiscountToJson(this);
}

@JsonSerializable()
class RestoredInvoiceAdditive {
  final String? additiveId;
  final String? arabicName;
  final String? latinName;
  final String? imagePath;

  final double? quantity;
  final double? price;

  final RestoredAdditive? additive;

  final int? transactionId;
  final int? parentTransactionId;

  const RestoredInvoiceAdditive({
    this.additiveId,
    this.arabicName,
    this.latinName,
    this.imagePath,
    this.quantity,
    this.price,
    this.additive,
    this.transactionId,
    this.parentTransactionId,
  });

  factory RestoredInvoiceAdditive.fromJson(Map<String, dynamic> json) =>
      _$RestoredInvoiceAdditiveFromJson(json);

  Map<String, dynamic> toJson() => _$RestoredInvoiceAdditiveToJson(this);
}

@JsonSerializable()
class RestoredAdditive {
  final int? id;
  final String? arabicName;
  final String? latinName;
  final double? price;
  final int? categoryId;

  const RestoredAdditive({
    this.id,
    this.arabicName,
    this.latinName,
    this.price,
    this.categoryId,
  });

  factory RestoredAdditive.fromJson(Map<String, dynamic> json) =>
      _$RestoredAdditiveFromJson(json);

  Map<String, dynamic> toJson() => _$RestoredAdditiveToJson(this);
}

@JsonSerializable()
class RestoredItem {
  final int? id;
  final String? arabicName;
  final String? latinName;
  final double? price;
  final int? categoryId;

  const RestoredItem({
    this.id,
    this.arabicName,
    this.latinName,
    this.price,
    this.categoryId,
  });

  factory RestoredItem.fromJson(Map<String, dynamic> json) =>
      _$RestoredItemFromJson(json);

  Map<String, dynamic> toJson() => _$RestoredItemToJson(this);
}

@JsonSerializable()
class RestoredSize {
  final int? id;
  final String? arabicName;
  final String? latinName;
  final double? price;
  final int? categoryId;

  const RestoredSize({
    this.id,
    this.arabicName,
    this.latinName,
    this.price,
    this.categoryId,
  });

  factory RestoredSize.fromJson(Map<String, dynamic> json) =>
      _$RestoredSizeFromJson(json);

  Map<String, dynamic> toJson() => _$RestoredSizeToJson(this);
}

@JsonSerializable()
class RestoredInvoicePayment {
  final int? paymentMethodId;
  final double? amount;

  const RestoredInvoicePayment({this.paymentMethodId, this.amount});

  factory RestoredInvoicePayment.fromJson(Map<String, dynamic> json) =>
      _$RestoredInvoicePaymentFromJson(json);

  Map<String, dynamic> toJson() => _$RestoredInvoicePaymentToJson(this);
}
