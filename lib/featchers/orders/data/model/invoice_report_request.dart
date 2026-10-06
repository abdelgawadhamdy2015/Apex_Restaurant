import 'package:json_annotation/json_annotation.dart';

part 'invoice_report_request.g.dart';

@JsonSerializable(includeIfNull: false)
class InvoiceReportRequest {
  final int? invoiceId;
  final String? invoiceCode;
  final bool? isPriceOffer;
  final int? exportType;
  final int? fileId;
  final int? financialYearId;
  final int? subScreenId;
  final int? screenId;
  final bool? isArabic;
  final int? reportId;
  final int? invoiceTypeId;

  const InvoiceReportRequest({
    this.invoiceId,
    this.invoiceCode,
    this.isPriceOffer,
    this.exportType = 1,
    this.fileId,
    this.financialYearId = 1,
    this.subScreenId,
    this.screenId = 732,
    this.isArabic = true,
    this.reportId,
    this.invoiceTypeId,
  });

  factory InvoiceReportRequest.fromJson(Map<String, dynamic> json) =>
      _$InvoiceReportRequestFromJson(json);

  Map<String, dynamic> toJson() => _$InvoiceReportRequestToJson(this);
}
