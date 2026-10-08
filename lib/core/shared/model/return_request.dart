import 'package:json_annotation/json_annotation.dart';

part 'return_request.g.dart';

@JsonSerializable(includeIfNull: false)
class ReturnRequest {
  @JsonKey(name: 'OriginalInvoiceId')
  final int originalInvoiceId;

  @JsonKey(name: 'FinancialYearId')
  final int? financialYearId;

  @JsonKey(name: 'Reason')
  final String? reason;

  @JsonKey(name: 'Notes')
  final String? notes;

  @JsonKey(name: 'CanPrint')
  final bool? canPrint;

  @JsonKey(name: 'IsArabic')
  final bool? isArabic;

  @JsonKey(name: 'TotalInvoicePrice')
  final double? totalInvoicePrice;

  @JsonKey(name: 'IsTotalReturn')
  final bool? isTotalReturn;

  @JsonKey(name: 'ReturnedInvoiceItems')
  final List<ReturnedInvoiceItem>? returnedInvoiceItems;

  @JsonKey(name: 'PaymentMethods')
  final List<PaymentMethod>? paymentMethods;

  const ReturnRequest({
    required this.originalInvoiceId,
    this.financialYearId = 1,
    this.reason,
    this.notes,
    this.canPrint,
    this.isArabic = true,
    this.totalInvoicePrice,
    this.isTotalReturn,
    this.returnedInvoiceItems,
    this.paymentMethods,
  });

  factory ReturnRequest.fromJson(Map<String, dynamic> json) =>
      _$ReturnRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ReturnRequestToJson(this);
}

@JsonSerializable(includeIfNull: false)
class ReturnedInvoiceItem {
  @JsonKey(name: 'InvoiceDetailId')
  final int invoiceDetailId;

  @JsonKey(name: 'Quantity')
  final double quantity;

  const ReturnedInvoiceItem({
    required this.invoiceDetailId,
    required this.quantity,
  });

  factory ReturnedInvoiceItem.fromJson(Map<String, dynamic> json) =>
      _$ReturnedInvoiceItemFromJson(json);

  Map<String, dynamic> toJson() => _$ReturnedInvoiceItemToJson(this);
}

@JsonSerializable(includeIfNull: false)
class PaymentMethod {
  @JsonKey(name: 'PaymentMethodId')
  final int? paymentMethodId;

  @JsonKey(name: 'Value')
  final double? value;

  @JsonKey(name: 'Cheque')
  final String? cheque;

  const PaymentMethod({this.paymentMethodId, this.value, this.cheque = ''});

  factory PaymentMethod.fromJson(Map<String, dynamic> json) =>
      _$PaymentMethodFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentMethodToJson(this);
}
