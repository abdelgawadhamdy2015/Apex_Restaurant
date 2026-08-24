import '../enums/cart_enum.dart';

/// Sent to the backend when the user taps "تطبيق" on the cart screen.
///
/// Exactly one of [code] (coupon mode) or [directDiscountValue] (direct
/// discount mode) is expected to be set, matching [mode].
class ApplyDiscountRequestModel {
  const ApplyDiscountRequestModel({
    required this.mode,
    required this.subtotal,
    this.code,
    this.directDiscountValue,
    this.isPercentageDiscount = false,
  });

  final CartDiscountMode mode;

  /// Current order subtotal — some backends need this to validate min-order
  /// coupon rules or to compute the resulting discount amount.
  final double subtotal;

  /// Coupon code text, used when [mode] is [CartDiscountMode.COUPON].
  final String? code;

  /// Manually entered discount value, used when [mode] is
  /// [CartDiscountMode.DIRECT]. Interpreted as a percentage or a flat amount
  /// depending on [isPercentageDiscount].
  final double? directDiscountValue;
  final bool isPercentageDiscount;

  Map<String, dynamic> toJson() => {
    'mode': mode.name,
    'subtotal': subtotal,
    if (code != null) 'code': code,
    if (directDiscountValue != null) 'directDiscountValue': directDiscountValue,
    'isPercentageDiscount': isPercentageDiscount,
  };
}
