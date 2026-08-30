import 'package:json_annotation/json_annotation.dart';

part 'get_all_pos_invoice_request.g.dart';

@JsonSerializable(includeIfNull: false)
class GetAllPosInvoiceRequest {
  final int pageNumber;
  final int pageSize;
  final int invoiceTypeId;
  final int invoiceCode;
  final String? invoiceType;
  final DateTime? invoiceDate;
  final DateTime? dateFrom;
  final DateTime? dateTo;
  final int storeId;
  final int personId;
  final bool isReturn;
  final int sessionId;
  final int financialYearId;

  const GetAllPosInvoiceRequest({
    this.pageNumber = 1,
    this.pageSize = 20,
    this.invoiceTypeId = 11,
    this.invoiceCode = 0,
    this.invoiceType,
    this.invoiceDate,
    this.dateFrom,
    this.dateTo,
    this.storeId = 0,
    this.personId = 0,
    this.isReturn = true,
    this.sessionId = 0,
    this.financialYearId = 0,
  });

  factory GetAllPosInvoiceRequest.fromJson(Map<String, dynamic> json) =>
      _$GetAllPosInvoiceRequestFromJson(json);

  Map<String, dynamic> toJson() => _$GetAllPosInvoiceRequestToJson(this);
}
