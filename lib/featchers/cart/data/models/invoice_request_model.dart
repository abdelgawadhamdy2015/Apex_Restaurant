import 'package:json_annotation/json_annotation.dart';

part 'invoice_request_model.g.dart';

@JsonSerializable(explicitToJson: true)
class SaveInvoiceRequestModel {
  final SaveInvoiceModel? invoice;
  final List<InvoiceItemModel>? items;
  final List<SavePaymentModel>? payments;
  final String? gediaKey;

  const SaveInvoiceRequestModel({
    this.invoice,
    this.items,
    this.payments,
    this.gediaKey,
  });

  factory SaveInvoiceRequestModel.fromJson(Map<String, dynamic> json) =>
      _$SaveInvoiceRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$SaveInvoiceRequestModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class SaveInvoiceModel {
  final int? postype;
  final int? foodTableId;
  final int? waiterId;
  final int? deliveryCompanyId;
  final int? deliveryManId;
  final String? notes;
  final SaveDiscountModel? discount;
  final double? paidAmount;
  final double? totalInvoicePrice;
  final int? clientId;
  final int? invoiceDiscountId;
  final DateTime? takeawayDateTime;
  const SaveInvoiceModel({
    this.postype,
    this.foodTableId,
    this.waiterId,
    this.deliveryCompanyId,
    this.deliveryManId,
    this.notes,
    this.discount,
    this.paidAmount,
    this.totalInvoicePrice,
    this.clientId,
    this.invoiceDiscountId,
    this.takeawayDateTime,
  });

  factory SaveInvoiceModel.fromJson(Map<String, dynamic> json) =>
      _$SaveInvoiceModelFromJson(json);

  Map<String, dynamic> toJson() => _$SaveInvoiceModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class SaveDiscountModel {
  final int? type;
  final double? value;

  const SaveDiscountModel({this.type, this.value});

  factory SaveDiscountModel.fromJson(Map<String, dynamic> json) =>
      _$SaveDiscountModelFromJson(json);

  Map<String, dynamic> toJson() => _$SaveDiscountModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class InvoiceItemModel {
  final int? itemId;
  final int? sizeId;
  final double? quantity;
  final double? price;
  final String? notes;
  final SaveDiscountModel? discount;
  final int? itemDiscountId;
  final List<SaveAdditiveModel>? additives;

  const InvoiceItemModel({
    this.itemId,
    this.sizeId,
    this.quantity,
    this.price,
    this.notes,
    this.discount,
    this.itemDiscountId,
    this.additives,
  });

  factory InvoiceItemModel.fromJson(Map<String, dynamic> json) =>
      _$InvoiceItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$InvoiceItemModelToJson(this);
}

@JsonSerializable()
class SaveAdditiveModel {
  final int? additiveId;
  final double? quantity;

  const SaveAdditiveModel({this.additiveId, this.quantity});

  factory SaveAdditiveModel.fromJson(Map<String, dynamic> json) =>
      _$SaveAdditiveModelFromJson(json);

  Map<String, dynamic> toJson() => _$SaveAdditiveModelToJson(this);
}

@JsonSerializable()
class SavePaymentModel {
  final int? paymentMethodId;
  final double? amount;

  const SavePaymentModel({this.paymentMethodId, this.amount});

  factory SavePaymentModel.fromJson(Map<String, dynamic> json) =>
      _$SavePaymentModelFromJson(json);

  Map<String, dynamic> toJson() => _$SavePaymentModelToJson(this);
}
