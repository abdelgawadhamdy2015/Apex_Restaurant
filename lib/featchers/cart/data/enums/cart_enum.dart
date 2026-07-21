// ignore_for_file: constant_identifier_names

/// All order fulfilment types the cart screen supports.
enum CartOrderType { TAKEAWAY, PICKUP, DINE_IN, DELIVERY, DELIVERY_COMPANY }

extension CartOrderTypeX on CartOrderType {
  String get arabicLabel {
    switch (this) {
      case CartOrderType.TAKEAWAY:
        return 'سفري';
      case CartOrderType.PICKUP:
        return 'استلام';
      case CartOrderType.DINE_IN:
        return 'محلي';
      case CartOrderType.DELIVERY:
        return 'توصيل';
      case CartOrderType.DELIVERY_COMPANY:
        return 'شركات التوصيل';
    }
  }

  /// Value sent to the backend — adjust to match your API's expected enum/int.
  int get apiValue {
    switch (this) {
      case CartOrderType.TAKEAWAY:
        return 1;
      case CartOrderType.PICKUP:
        return 2;
      case CartOrderType.DINE_IN:
        return 3;
      case CartOrderType.DELIVERY:
        return 4;
      case CartOrderType.DELIVERY_COMPANY:
        return 5;
    }
  }

  /// Whether this order type carries a separate delivery fee in the summary.
  bool get hasDeliveryFee =>
      this == CartOrderType.DELIVERY || this == CartOrderType.DELIVERY_COMPANY;

  /// Whether this type needs a delivery-agent selector.
  bool get needsDeliveryAgent => this == CartOrderType.DELIVERY;

  /// Whether this type needs a waiter + table selector.
  bool get needsWaiterAndTable => this == CartOrderType.DINE_IN;

  /// Whether this type needs a delivery-company selector.
  bool get needsDeliveryCompany => this == CartOrderType.DELIVERY_COMPANY;
}

/// Coupon vs. direct-discount selector on the cart screen.
enum CartDiscountMode { COUPON, DIRECT }

/// Payment method chosen on "إتمام الدفع".
enum PaymentMethod { CASH, CARD }
