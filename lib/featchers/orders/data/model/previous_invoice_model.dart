import 'package:json_annotation/json_annotation.dart';

part 'previous_invoice_model.g.dart';

@JsonSerializable()
class PreviousInvoiceModel {
  final int? invoiceId;
  final String? invoiceCode;
  final DateTime? invoiceDate;
  final String? personNameAr;
  final String? personNameEn;
  final double? totalAmount;

  const PreviousInvoiceModel({
    this.invoiceId,
    this.invoiceCode,
    this.invoiceDate,
    this.personNameAr,
    this.personNameEn,
    this.totalAmount,
  });

  factory PreviousInvoiceModel.fromJson(Map<String, dynamic> json) =>
      _$PreviousInvoiceModelFromJson(json);

  Map<String, dynamic> toJson() => _$PreviousInvoiceModelToJson(this);
}
