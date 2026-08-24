// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'check_voucher_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CheckVoucherRequest _$CheckVoucherRequestFromJson(Map<String, dynamic> json) =>
    CheckVoucherRequest(
      code: json['code'] as String?,
      posType: (json['posType'] as num?)?.toInt(),
      customerId: (json['customerId'] as num?)?.toInt(),
    );

Map<String, dynamic> _$CheckVoucherRequestToJson(
  CheckVoucherRequest instance,
) => <String, dynamic>{
  'code': instance.code,
  'posType': instance.posType,
  'customerId': instance.customerId,
};
