import 'package:json_annotation/json_annotation.dart';

part 'get_invoice_accrediting_data_request.g.dart';

@JsonSerializable(includeIfNull: false)
class GetInvoiceAccreditingDataRequest {
  final int? employeesId;
  final String? username;
  final String? password;

  const GetInvoiceAccreditingDataRequest({
    this.employeesId,
    this.username,
    this.password,
  });

  factory GetInvoiceAccreditingDataRequest.fromJson(
    Map<String, dynamic> json,
  ) => _$GetInvoiceAccreditingDataRequestFromJson(json);

  Map<String, dynamic> toJson() =>
      _$GetInvoiceAccreditingDataRequestToJson(this);
}
