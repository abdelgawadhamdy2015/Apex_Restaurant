import 'package:json_annotation/json_annotation.dart';

part 'pinding_invoice_model.g.dart';

@JsonSerializable()
class PindingInvoiceModel {
  final int? invoiceId;
  final int? orderNumber;
  final String? code;
  final DateTime? invoiceDate;
  final int? itemsCount;
  final List<PindingInvoiceItemModel>? items;
  final double? invoiceTotal;

  const PindingInvoiceModel({
    this.invoiceId,
    this.orderNumber,
    this.code,
    this.invoiceDate,
    this.itemsCount,
    this.items,
    this.invoiceTotal,
  });

  factory PindingInvoiceModel.fromJson(Map<String, dynamic> json) =>
      _$PindingInvoiceModelFromJson(json);

  Map<String, dynamic> toJson() => _$PindingInvoiceModelToJson(this);
}

@JsonSerializable()
class PindingInvoiceItemModel {
  final int? itemId;
  final String? itemNameAr;
  final double? quantity;
  final double? price;
  final double? total;
  final String? itemNameEn;

  const PindingInvoiceItemModel({
    this.itemId,
    this.itemNameAr,
    this.quantity,
    this.price,
    this.total,
    this.itemNameEn,
  });

  factory PindingInvoiceItemModel.fromJson(Map<String, dynamic> json) =>
      _$PindingInvoiceItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$PindingInvoiceItemModelToJson(this);
}
