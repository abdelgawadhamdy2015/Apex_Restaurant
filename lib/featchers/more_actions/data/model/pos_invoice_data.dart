import 'package:apex_restaurant/core/shared/enums/ui_enum.dart';
import 'package:json_annotation/json_annotation.dart';

part 'pos_invoice_data.g.dart';

@JsonSerializable()
class PosInvoiceData {
  final int invoiceId;
  final bool isTransferDataToNewYear;
  final String invoiceType;
  final int invoiceTypeId;
  final DateTime invoiceDate;
  final double totalPrice;
  final double discount;

  @JsonKey(fromJson: ReturnType.fromValue, toJson: _returnTypeToJson)
  final ReturnType invoiceSubTypesId;

  final int paymentType;
  final String personNameAr;
  final String personNameEn;
  final double paid;
  final int reportStatus;

  const PosInvoiceData({
    required this.invoiceId,
    required this.isTransferDataToNewYear,
    required this.invoiceType,
    required this.invoiceTypeId,
    required this.invoiceDate,
    required this.totalPrice,
    required this.discount,
    required this.invoiceSubTypesId,
    required this.paymentType,
    required this.personNameAr,
    required this.personNameEn,
    required this.paid,
    required this.reportStatus,
  });

  factory PosInvoiceData.fromJson(Map<String, dynamic> json) =>
      _$PosInvoiceDataFromJson(json);

  Map<String, dynamic> toJson() => _$PosInvoiceDataToJson(this);
}

int _returnTypeToJson(ReturnType type) => type.value;
