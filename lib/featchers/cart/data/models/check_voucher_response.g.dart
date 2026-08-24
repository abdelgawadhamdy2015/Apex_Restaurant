// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'check_voucher_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CheckVoucherResponse _$CheckVoucherResponseFromJson(
  Map<String, dynamic> json,
) => CheckVoucherResponse(
  yourActualDiscountValue: (json['yourActualDiscountValue'] as num?)
      ?.toDouble(),
  voucherId: json['voucherID'] as String?,
  voucherCode: json['voucherCode'] as String?,
  discountNatural: (json['discountNatural'] as num?)?.toInt(),
  discountValue: (json['discountValue'] as num?)?.toDouble(),
  minimumCharge: (json['minimumCharge'] as num?)?.toDouble(),
  maximumDiscountValue: (json['maximumDiscountValue'] as num?)?.toDouble(),
);

Map<String, dynamic> _$CheckVoucherResponseToJson(
  CheckVoucherResponse instance,
) => <String, dynamic>{
  'yourActualDiscountValue': instance.yourActualDiscountValue,
  'voucherID': instance.voucherId,
  'voucherCode': instance.voucherCode,
  'discountNatural': instance.discountNatural,
  'discountValue': instance.discountValue,
  'minimumCharge': instance.minimumCharge,
  'maximumDiscountValue': instance.maximumDiscountValue,
};
