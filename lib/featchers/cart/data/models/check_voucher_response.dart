import 'package:json_annotation/json_annotation.dart';

part 'check_voucher_response.g.dart';

@JsonSerializable()
class CheckVoucherResponse {
  @JsonKey(name: 'yourActualDiscountValue')
  final double? yourActualDiscountValue;

  @JsonKey(name: 'voucherID')
  final String? voucherId;

  @JsonKey(name: 'voucherCode')
  final String? voucherCode;

  @JsonKey(name: 'discountNatural')
  final int? discountNatural;

  @JsonKey(name: 'discountValue')
  final double? discountValue;

  @JsonKey(name: 'minimumCharge')
  final double? minimumCharge;

  @JsonKey(name: 'maximumDiscountValue')
  final double? maximumDiscountValue;

  const CheckVoucherResponse({
    this.yourActualDiscountValue,
    this.voucherId,
    this.voucherCode,
    this.discountNatural,
    this.discountValue,
    this.minimumCharge,
    this.maximumDiscountValue,
  });

  factory CheckVoucherResponse.fromJson(Map<String, dynamic> json) =>
      _$CheckVoucherResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CheckVoucherResponseToJson(this);
}
