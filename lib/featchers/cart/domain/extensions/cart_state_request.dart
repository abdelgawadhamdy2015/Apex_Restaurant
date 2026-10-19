part of '../../presentation/bloc/cart_state.dart';

extension CartStateRequest on CartState {
  SaveRestaurantPosInvoiceRequest get toSaveRestaurantPosInvoiceRequest {
    final discountInfo = _resolveInvoiceDiscountForRequest();

    return SaveRestaurantPosInvoiceRequest(
      invoice: _buildInvoiceInfo(discountInfo),
      items: _buildItemRequests(),
      payments: const [],
      gediaKey: '',
    );
  }

  // ---------------------------------------------------------------------------
  // Invoice-level discount
  // ---------------------------------------------------------------------------

  ({
    RestaurantPosDiscountRequest? discount,
    int? invoiceDiscountId,
    String? voucherCode,
  })
  _resolveInvoiceDiscountForRequest() {
    RestaurantPosDiscountRequest? applied;
    int? invoiceDiscountId;
    String? voucherCode;

    switch (activeDiscountSource) {
      case DiscountSource.dynamic:
        final effective = effectiveDynamicInvoiceDiscount;
        // null => min invoice net not reached: nothing is sent.
        if (effective != null) {
          final dynamicDiscount = matchedDynamicDiscount?.discount;
          invoiceDiscountId = int.tryParse(dynamicDiscount?.id ?? '');
          applied = RestaurantPosDiscountRequest(
            // a capped percentage is sent as a fixed amount
            type: effective.capped ? 2 : (dynamicDiscount?.discountType ?? 0),
            value: effective.value,
          );
        }
        break;
      case DiscountSource.customer:
        applied = customerDiscount;
        break;
      case DiscountSource.manualInvoice:
        applied = restaurantPosDiscountRequest;
        break;
      case DiscountSource.size:
      case DiscountSource.manualItem:
      case DiscountSource.none:
        break;
    }

    // Voucher (never on returns: mode.allowsVoucher == false)
    if (mode.allowsVoucher &&
        applied == null &&
        selectedDiscountType == DiscountTypeEnum.coupon &&
        voucherData != null) {
      voucherCode = voucherData?.voucherCode;
      applied = RestaurantPosDiscountRequest(
        type: voucherData?.discountNatural ?? 0,
        value: voucherData?.discountValue ?? 0,
      );
    }

    return (
      discount: applied,
      invoiceDiscountId: invoiceDiscountId,
      voucherCode: voucherCode,
    );
  }

  /// The `discount` field of the invoice: only manual ("direct") discounts
  /// are sent here; coupons are sent through `voucherCode`.
  RestaurantPosDiscountRequest? _discountToSend(
    RestaurantPosDiscountRequest? applied,
  ) {
    if (applied == null || applied.value == 0) return null;
    if (selectedDiscountType != DiscountTypeEnum.direct) return null;

    final settingOff = settingsModel?.posRestaurant?.activeDiscount == false;
    if (settingOff && !mode.ignoresActiveDiscountSetting) return null;

    return applied;
  }

  // ---------------------------------------------------------------------------
  // Invoice header
  // ---------------------------------------------------------------------------

  RestaurantPosInvoiceInfoRequest _buildInvoiceInfo(
    ({
      RestaurantPosDiscountRequest? discount,
      int? invoiceDiscountId,
      String? voucherCode,
    })
    discountInfo,
  ) {
    final isDelivery = selectedOrderType == CartOrderType.DELIVERY;
    final isDineIn = selectedOrderType == CartOrderType.DINE_IN;

    final deliveryCost = isDeliveryOrder
        ? calculationResult?.deliveryCost ??
              (settingsModel?.posRestaurant?.deliveryCost ?? 0.0)
        : 0.0;

    return RestaurantPosInvoiceInfoRequest(
      invoiceId: isPending ? 0 : invoiceId,
      pendingInvoiceId: invoiceId,
      postype: selectedOrderType.apiValue,
      foodTableId: isDineIn ? int.tryParse(selectedTable?.id ?? '') : null,
      waiterId: isDineIn
          ? int.tryParse(selectedWaiter?.id?.toString() ?? '')
          : null,
      deliveryManId: isDelivery
          ? int.tryParse(selectedDeliveryMan?.id?.toString() ?? '')
          : null,
      deliveryCompanyId: selectedOrderType == CartOrderType.DELIVERY_COMPANY
          ? selectedDeliveryCompany?.id
          : null,
      voucherCode: selectedDiscountType == DiscountTypeEnum.coupon
          ? discountInfo.voucherCode
          : null,
      clientId: selectedPerson?.id ?? 0,
      personAddressId: isDelivery
          ? (int.tryParse(selectedAddress?.id.toString() ?? '') ?? 0)
          : 0,
      personPhoneId: isDelivery
          ? selectedPerson?.personPhones?.firstOrNull?.id ?? 0
          : 0,
      orderReceivedTime: selectedOrderType == CartOrderType.FROMBRANCH
          ? fromBranchDateTime
          : null,
      discount: _discountToSend(discountInfo.discount),
      paidAmount: grandTotal,
      totalInvoicePrice: grandTotal,
      invoiceDiscountId: discountInfo.invoiceDiscountId,
      deliveryCost: deliveryCost,
      invoiceDate: invoiceDate,
    );
  }

  // ---------------------------------------------------------------------------
  // Items
  // ---------------------------------------------------------------------------

  List<RestaurantPosInvoiceItemRequest> _buildItemRequests() {
    final ids = _TxIdGenerator();
    return [
      for (var i = 0; i < items.length; i++)
        _buildItemRequest(items[i], i, ids),
    ];
  }

  RestaurantPosInvoiceItemRequest _buildItemRequest(
    OrderItem item,
    int index,
    _TxIdGenerator ids,
  ) {
    final parentTxId = _parentTxIdFor(item, index);
    final discount = _resolveItemDiscount(item);

    return RestaurantPosInvoiceItemRequest(
      transactionID: parentTxId,
      itemId: item.menuItem.itemId,
      invoiceDetailsId: item.invoiceDetailsId,
      sizeId: item.selectedSize?.sizeId ?? 0,
      quantity: mode.quantityOf(item),
      price: _unitPriceOf(item),
      notes: item.notes,
      discount: discount.value > 0
          ? RestaurantPosDiscountRequest(
              type: discount.isPercentage ? 1 : 2,
              value: discount.value,
            )
          : null,
      itemDiscountId: discount.discountId,
      additives: _buildAdditiveRequests(item, parentTxId, ids),
    );
  }

  List<RestaurantPosItemAdditiveRequest> _buildAdditiveRequests(
    OrderItem item,
    String parentTxId,
    _TxIdGenerator ids,
  ) {
    final addons = <String, AdditiveModel>{};
    final counts = <String, int>{};

    for (final addon in item.addons) {
      final key =
          '${addon.id}_${addon.transactionId}_${addon.parentTransactionId}';
      addons[key] = addon;
      counts[key] = (counts[key] ?? 0) + 1;
    }

    return addons.entries.map((entry) {
      final addon = entry.value;
      return RestaurantPosItemAdditiveRequest(
        transactionID: _addonTxId(addon, ids),
        parentTransactionId: _addonParentTxId(addon, parentTxId),
        additiveId: int.parse(addon.id),
        quantity: counts[entry.key]!.toDouble(),
        invoiceDetailsId: addon.invoiceDetailsId,
      );
    }).toList();
  }
}
