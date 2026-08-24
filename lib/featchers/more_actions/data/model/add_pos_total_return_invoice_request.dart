import 'package:json_annotation/json_annotation.dart';

part 'add_pos_total_return_invoice_request.g.dart';

@JsonSerializable()
class AddPOSTotalReturnInvoiceRequest {
  final int financialYearId;
  final int id;
  final bool isArabic;

  const AddPOSTotalReturnInvoiceRequest({
    required this.financialYearId,
    required this.id,
    required this.isArabic,
  });

  factory AddPOSTotalReturnInvoiceRequest.fromJson(Map<String, dynamic> json) =>
      _$AddPOSTotalReturnInvoiceRequestFromJson(json);

  Map<String, dynamic> toJson() =>
      _$AddPOSTotalReturnInvoiceRequestToJson(this);
}
