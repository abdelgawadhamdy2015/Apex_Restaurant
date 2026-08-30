import 'package:freezed_annotation/freezed_annotation.dart';
part 'check_voucher_request.g.dart';

@JsonSerializable()
class CheckVoucherRequest {
  final String? code;
  final int? posType;
  final int? customerId;

  CheckVoucherRequest({this.code, this.posType, this.customerId});

  factory CheckVoucherRequest.fromJson(Map<String, dynamic> json) =>
      _$CheckVoucherRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CheckVoucherRequestToJson(this);
}
