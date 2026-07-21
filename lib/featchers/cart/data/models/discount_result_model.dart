/// Result of applying a coupon or direct discount, as computed server-side.
///
/// Some backends validate + compute the whole breakdown (min-order rules,
/// stacking rules, etc.) rather than trusting the client — this model
/// carries that authoritative result back to the cart screen.
class DiscountResultModel {
  const DiscountResultModel({
    required this.isValid,
    required this.discountAmount,
    this.message,
  });

  final bool isValid;
  final double discountAmount;
  final String? message;

  factory DiscountResultModel.fromJson(Map<String, dynamic> json) {
    return DiscountResultModel(
      isValid: json['isValid'] as bool? ?? false,
      discountAmount: (json['discountAmount'] as num?)?.toDouble() ?? 0.0,
      message: json['message'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'isValid': isValid,
    'discountAmount': discountAmount,
    'message': message,
  };
}
