import 'package:json_annotation/json_annotation.dart';

part 'invoice_request.g.dart';

@JsonSerializable(includeIfNull: false)
class SaveRestaurantPosInvoiceRequest {
  @JsonKey(name: 'Invoice')
  final RestaurantPosInvoiceInfoRequest invoice;

  @JsonKey(name: 'Items')
  final List<RestaurantPosInvoiceItemRequest> items;

  @JsonKey(name: 'Payments')
  final List<RestaurantPosPaymentRequest> payments;

  @JsonKey(name: 'gediaKey')
  final String gediaKey;

  const SaveRestaurantPosInvoiceRequest({
    required this.invoice,
    this.items = const [],
    this.payments = const [],
    this.gediaKey = '',
  });

  factory SaveRestaurantPosInvoiceRequest.fromJson(Map<String, dynamic> json) =>
      _$SaveRestaurantPosInvoiceRequestFromJson(json);

  Map<String, dynamic> toJson() =>
      _$SaveRestaurantPosInvoiceRequestToJson(this);
}

@JsonSerializable()
class RestaurantPosInvoiceInfoRequest {
  @JsonKey(name: 'InvoiceId')
  final int? invoiceId;

  @JsonKey(name: 'PendingInvoiceId')
  final int? pendingInvoiceId;

  @JsonKey(name: 'Postype')
  final int postype;

  @JsonKey(name: 'FoodTableId')
  final int? foodTableId;

  @JsonKey(name: 'WaiterId')
  final int? waiterId;

  @JsonKey(name: 'DeliveryCompanyId')
  final int? deliveryCompanyId;

  @JsonKey(name: 'VoucherCode')
  final String? voucherCode;

  @JsonKey(name: 'DeliveryManId')
  final int? deliveryManId;

  @JsonKey(name: 'Notes')
  final String? notes;

  @JsonKey(name: 'Discount')
  final RestaurantPosDiscountRequest? discount;

  @JsonKey(name: 'PaidAmount')
  final double paidAmount;

  @JsonKey(name: 'TotalInvoicePrice')
  final double totalInvoicePrice;

  @JsonKey(name: 'ClientId')
  final int clientId;

  @JsonKey(name: 'InvoiceDiscountId')
  final int? invoiceDiscountId;

  @JsonKey(name: 'PersonAddressId')
  final int personAddressId;

  @JsonKey(name: 'PersonPhoneId')
  final int personPhoneId;

  @JsonKey(name: 'OrderReceivedTime')
  final DateTime? orderReceivedTime;

  @JsonKey(name: 'DeliveryCost')
  final double deliveryCost;

  @JsonKey(name: 'PrintingKitchenKey')
  final String? printingKitchenKey;

  @JsonKey(name: 'isArabic')
  final bool isArabic;

  const RestaurantPosInvoiceInfoRequest({
    this.invoiceId,
    this.pendingInvoiceId,
    required this.postype,
    this.foodTableId,
    this.waiterId,
    this.deliveryCompanyId,
    this.voucherCode,
    this.deliveryManId,
    this.notes,
    this.discount,
    required this.paidAmount,
    required this.totalInvoicePrice,
    required this.clientId,
    this.invoiceDiscountId,
    this.personAddressId = 0,
    this.personPhoneId = 0,
    this.orderReceivedTime,
    this.deliveryCost = 0,
    this.printingKitchenKey,
    this.isArabic = false,
  });

  factory RestaurantPosInvoiceInfoRequest.fromJson(Map<String, dynamic> json) =>
      _$RestaurantPosInvoiceInfoRequestFromJson(json);

  Map<String, dynamic> toJson() =>
      _$RestaurantPosInvoiceInfoRequestToJson(this);
}

@JsonSerializable()
class RestaurantPosDiscountRequest {
  @JsonKey(name: 'Type')
  final int type;

  @JsonKey(name: 'Value')
  final double value;

  const RestaurantPosDiscountRequest({required this.type, required this.value});

  factory RestaurantPosDiscountRequest.fromJson(Map<String, dynamic> json) =>
      _$RestaurantPosDiscountRequestFromJson(json);

  Map<String, dynamic> toJson() => _$RestaurantPosDiscountRequestToJson(this);
}

@JsonSerializable()
class RestaurantPosInvoiceItemRequest {
  @JsonKey(name: 'ItemId')
  final int itemId;

  @JsonKey(name: 'SizeId')
  final int? sizeId;

  @JsonKey(name: 'Quantity')
  final double quantity;

  @JsonKey(name: 'Price')
  final double price;

  @JsonKey(name: 'Notes')
  final String? notes;

  @JsonKey(name: 'Discount')
  final RestaurantPosDiscountRequest? discount;

  @JsonKey(name: 'ItemDiscountId')
  final int? itemDiscountId;

  @JsonKey(name: 'Additives')
  final List<RestaurantPosItemAdditiveRequest> additives;

  const RestaurantPosInvoiceItemRequest({
    required this.itemId,
    this.sizeId,
    required this.quantity,
    required this.price,
    this.notes,
    this.discount,
    this.itemDiscountId,
    this.additives = const [],
  });

  factory RestaurantPosInvoiceItemRequest.fromJson(Map<String, dynamic> json) =>
      _$RestaurantPosInvoiceItemRequestFromJson(json);

  Map<String, dynamic> toJson() =>
      _$RestaurantPosInvoiceItemRequestToJson(this);
}

@JsonSerializable()
class RestaurantPosItemAdditiveRequest {
  @JsonKey(name: 'AdditiveId')
  final int additiveId;

  @JsonKey(name: 'Quantity')
  final double quantity;

  const RestaurantPosItemAdditiveRequest({
    required this.additiveId,
    required this.quantity,
  });

  factory RestaurantPosItemAdditiveRequest.fromJson(
    Map<String, dynamic> json,
  ) => _$RestaurantPosItemAdditiveRequestFromJson(json);

  Map<String, dynamic> toJson() =>
      _$RestaurantPosItemAdditiveRequestToJson(this);
}

@JsonSerializable()
class RestaurantPosPaymentRequest {
  @JsonKey(name: 'PaymentMethodId')
  final int paymentMethodId;

  @JsonKey(name: 'Amount')
  final double amount;

  const RestaurantPosPaymentRequest({
    required this.paymentMethodId,
    required this.amount,
  });

  factory RestaurantPosPaymentRequest.fromJson(Map<String, dynamic> json) =>
      _$RestaurantPosPaymentRequestFromJson(json);

  Map<String, dynamic> toJson() => _$RestaurantPosPaymentRequestToJson(this);
}
