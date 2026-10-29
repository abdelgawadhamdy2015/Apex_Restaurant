import 'package:json_annotation/json_annotation.dart';

part 'return_response.g.dart';

@JsonSerializable()
class ReturnResponseData {
  final int? invoiceId;
  final String? invoiceCode;
  final int? originalInvoiceId;
  final String? originalInvoiceCode;
  final String? returnType;
  final double? itemTotal;
  final double? itemDiscount;
  final double? invoiceDiscount;
  final double? vat;
  final double? tobaccoTax;
  final double? serviceFee;
  final double? deliveryFee;
  final double? finalTotal;
  final double? voucherRate;
  final int? roundNumber;

  const ReturnResponseData({
    this.invoiceId,
    this.invoiceCode,
    this.originalInvoiceId,
    this.originalInvoiceCode,
    this.returnType,
    this.itemTotal,
    this.itemDiscount,
    this.invoiceDiscount,
    this.vat,
    this.tobaccoTax,
    this.serviceFee,
    this.deliveryFee,
    this.finalTotal,
    this.voucherRate,
    this.roundNumber,
  });

  factory ReturnResponseData.fromJson(Map<String, dynamic> json) =>
      _$ReturnResponseDataFromJson(json);

  Map<String, dynamic> toJson() => _$ReturnResponseDataToJson(this);
}

@JsonSerializable()
class PrintResponseData {
  final String? fileURL;
  final String? fileName;
  final String? htmlPrint;
  final String? fileBase64;
  final bool? isFireFox;
  final int? result;
  final int? resultForPrint;
  final dynamic data;
  final bool? isOverSize;

  const PrintResponseData({
    this.fileURL,
    this.fileName,
    this.htmlPrint,
    this.fileBase64,
    this.isFireFox,
    this.result,
    this.resultForPrint,
    this.data,
    this.isOverSize,
  });

  factory PrintResponseData.fromJson(Map<String, dynamic> json) =>
      _$PrintResponseDataFromJson(json);

  Map<String, dynamic> toJson() => _$PrintResponseDataToJson(this);
}
