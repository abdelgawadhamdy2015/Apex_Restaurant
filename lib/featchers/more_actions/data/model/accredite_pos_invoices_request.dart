import 'package:json_annotation/json_annotation.dart';

part 'accredite_pos_invoices_request.g.dart';

@JsonSerializable(includeIfNull: false)
class AccreditePOSInvoicesRequest {
  final int? employeesId;
  final String? username;
  final String? password;

  @JsonKey(name: 'DrawerCash')
  final double? drawerCash;

  @JsonKey(name: 'CreateCashDeficitReceipt')
  final bool? createCashDeficitReceipt;

  @JsonKey(name: 'PrintRecsWithSaving')
  final bool? printRecsWithSaving;

  const AccreditePOSInvoicesRequest({
    this.employeesId,
    this.username,
    this.password,
    this.drawerCash,
    this.createCashDeficitReceipt,
    this.printRecsWithSaving,
  });

  factory AccreditePOSInvoicesRequest.fromJson(Map<String, dynamic> json) =>
      _$AccreditePOSInvoicesRequestFromJson(json);

  Map<String, dynamic> toJson() => _$AccreditePOSInvoicesRequestToJson(this);
}
