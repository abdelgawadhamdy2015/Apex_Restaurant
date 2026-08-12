import 'package:json_annotation/json_annotation.dart';

part 'restored_invoice_model.g.dart';

@JsonSerializable()
class RestoredInvoiceModel {
  final RestoredInvoiceDetailsModel? invoice;
  final List<RestoredInvoiceItemModel>? items;
  final List<RestoredInvoicePaymentModel>? payments;

  const RestoredInvoiceModel({this.invoice, this.items, this.payments});

  factory RestoredInvoiceModel.fromJson(Map<String, dynamic> json) =>
      _$RestoredInvoiceModelFromJson(json);

  Map<String, dynamic> toJson() => _$RestoredInvoiceModelToJson(this);
}

@JsonSerializable()
class RestoredInvoiceDetailsModel {
  final int? invoiceId;
  final int? orderNumber;
  final String? invoiceCode;
  final String? invoiceDate;
  final int? posType;

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
  final String? address;

  final int? personPhoneId;
  final String? phone;

  final String? notes;
  final dynamic invoiceDiscount;

  final double? totalInvoicePrice;
  final double? paidAmount;
  final double? remain;
  final double? totalVat;
  final double? deliveryCost;
  final double? dineInCost;
  final double? tobaccoTax;

  final RestoredInvoiceClientModel? client;
  final dynamic waiter;
  final dynamic deliveryCompany;
  final dynamic deliveryMan;
  final dynamic foodTable;

  const RestoredInvoiceDetailsModel({
    this.invoiceId,
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
  });

  factory RestoredInvoiceDetailsModel.fromJson(Map<String, dynamic> json) =>
      _$RestoredInvoiceDetailsModelFromJson(json);

  Map<String, dynamic> toJson() => _$RestoredInvoiceDetailsModelToJson(this);
}

@JsonSerializable()
class RestoredInvoiceClientModel {
  final int? id;
  final String? arabicName;
  final String? latinName;

  const RestoredInvoiceClientModel({this.id, this.arabicName, this.latinName});

  factory RestoredInvoiceClientModel.fromJson(Map<String, dynamic> json) =>
      _$RestoredInvoiceClientModelFromJson(json);

  Map<String, dynamic> toJson() => _$RestoredInvoiceClientModelToJson(this);
}

@JsonSerializable()
class RestoredInvoiceItemModel {
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

  final dynamic itemDiscount;
  final List<dynamic>? additives;

  final RestoredInvoiceItemInfoModel? item;
  final dynamic size;
  final dynamic additive;
  final int? foodAdditiveId;

  const RestoredInvoiceItemModel({
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

  factory RestoredInvoiceItemModel.fromJson(Map<String, dynamic> json) =>
      _$RestoredInvoiceItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$RestoredInvoiceItemModelToJson(this);
}

@JsonSerializable()
class RestoredInvoiceItemInfoModel {
  final int? id;
  final String? arabicName;
  final String? latinName;

  const RestoredInvoiceItemInfoModel({
    this.id,
    this.arabicName,
    this.latinName,
  });

  factory RestoredInvoiceItemInfoModel.fromJson(Map<String, dynamic> json) =>
      _$RestoredInvoiceItemInfoModelFromJson(json);

  Map<String, dynamic> toJson() => _$RestoredInvoiceItemInfoModelToJson(this);
}

@JsonSerializable()
class RestoredInvoicePaymentModel {
  final int? paymentMethodId;
  final String? arabicName;
  final String? latinName;
  final double? amount;

  final RestoredInvoicePaymentMethodModel? paymentMethod;

  const RestoredInvoicePaymentModel({
    this.paymentMethodId,
    this.arabicName,
    this.latinName,
    this.amount,
    this.paymentMethod,
  });

  factory RestoredInvoicePaymentModel.fromJson(Map<String, dynamic> json) =>
      _$RestoredInvoicePaymentModelFromJson(json);

  Map<String, dynamic> toJson() => _$RestoredInvoicePaymentModelToJson(this);
}

@JsonSerializable()
class RestoredInvoicePaymentMethodModel {
  final int? id;
  final String? arabicName;
  final String? latinName;

  const RestoredInvoicePaymentMethodModel({
    this.id,
    this.arabicName,
    this.latinName,
  });

  factory RestoredInvoicePaymentMethodModel.fromJson(
    Map<String, dynamic> json,
  ) => _$RestoredInvoicePaymentMethodModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$RestoredInvoicePaymentMethodModelToJson(this);
}
