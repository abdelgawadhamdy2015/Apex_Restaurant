part of 'cart_state.dart';

sealed class CartInvoiceMode {
  const CartInvoiceMode();

  bool get isReturn;

  // ---- What is allowed -------------------------------------------------
  bool get allowsEditing;
  bool get allowsDynamicDiscount;
  bool get allowsSizeDiscount;
  bool get allowsCustomerDiscount;
  bool get allowsInvoiceDiscount;
  bool get allowsManualDiscountEditing;
  bool get allowsVoucher;

  /// When true the restored discount is sent even if the "activeDiscount"
  /// setting is currently off.
  bool get ignoresActiveDiscountSetting;

  // ---- How values are computed ----------------------------------------
  double quantityOf(OrderItem item);
  double itemDiscountValue(OrderItem item);
  bool priceIncludesVat(CartState state);
  double totalDiscount(
    InvoiceCalculationResult? result,
    DiscountTypeEnum discountType,
  );
}

/// New / pending / previous invoices.
class StandardInvoiceMode extends CartInvoiceMode {
  const StandardInvoiceMode();

  @override
  bool get isReturn => false;
  @override
  bool get allowsEditing => true;
  @override
  bool get allowsDynamicDiscount => true;
  @override
  bool get allowsSizeDiscount => true;
  @override
  bool get allowsCustomerDiscount => true;
  @override
  bool get allowsInvoiceDiscount => true;
  @override
  bool get allowsManualDiscountEditing => true;
  @override
  bool get allowsVoucher => true;
  @override
  bool get ignoresActiveDiscountSetting => false;

  @override
  double quantityOf(OrderItem item) => item.quantity.toDouble();

  @override
  double itemDiscountValue(OrderItem item) => item.discount;

  @override
  bool priceIncludesVat(CartState state) =>
      state.settingsModel?.posRestaurant?.priceIncludeVat ?? false;

  @override
  double totalDiscount(
    InvoiceCalculationResult? result,
    DiscountTypeEnum discountType,
  ) {
    return discountType == DiscountTypeEnum.direct
        ? result?.totalDiscount ?? 0.0
        : result?.voucherDiscount ?? 0.0;
  }
}

/// Return invoices: only the discounts restored from the ORIGINAL invoice
/// are used (invoice-level discount split per item + per-item discount).
/// Dynamic / size / customer / voucher discounts are ignored.
class ReturnInvoiceMode extends CartInvoiceMode {
  const ReturnInvoiceMode();

  @override
  bool get isReturn => true;
  @override
  bool get allowsEditing => false;
  @override
  bool get allowsDynamicDiscount => false;
  @override
  bool get allowsSizeDiscount => false;
  @override
  bool get allowsCustomerDiscount => false;
  @override
  bool get allowsInvoiceDiscount => false;
  @override
  bool get allowsManualDiscountEditing => false;
  @override
  bool get allowsVoucher => false;
  @override
  bool get ignoresActiveDiscountSetting => true;

  @override
  double quantityOf(OrderItem item) => (item.availableQuantity ?? 0).toDouble();

  /// A fixed discount belongs to the ORIGINAL quantity, so split it per unit
  /// and multiply by the returned quantity. Percentage discounts scale by
  /// themselves with the line total.
  @override
  double itemDiscountValue(OrderItem item) {
    if (item.isPercentageDiscount) return item.discount;

    final originalQty = item.quantity.toDouble();
    if (originalQty <= 0) return item.discount;

    final returnedQty = quantityOf(item).clamp(0.0, originalQty);

    // Whole quantity returned: keep the exact discount (no rounding drift).
    if (returnedQty == originalQty) return item.discount;

    return item.discount / originalQty * returnedQty;
  }

  /// Return invoices use the VAT mode of the original invoice.
  @override
  bool priceIncludesVat(CartState state) => state.priceIncludeVat;

  @override
  double totalDiscount(
    InvoiceCalculationResult? result,
    DiscountTypeEnum discountType,
  ) => result?.totalDiscount ?? 0.0;
}
