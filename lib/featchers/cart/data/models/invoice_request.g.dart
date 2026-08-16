// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invoice_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SaveRestaurantPosInvoiceRequest _$SaveRestaurantPosInvoiceRequestFromJson(
  Map<String, dynamic> json,
) => SaveRestaurantPosInvoiceRequest(
  invoice: RestaurantPosInvoiceInfoRequest.fromJson(
    json['Invoice'] as Map<String, dynamic>,
  ),
  items:
      (json['Items'] as List<dynamic>?)
          ?.map(
            (e) => RestaurantPosInvoiceItemRequest.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList() ??
      const [],
  payments:
      (json['Payments'] as List<dynamic>?)
          ?.map(
            (e) =>
                RestaurantPosPaymentRequest.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const [],
  gediaKey: json['gediaKey'] as String? ?? '',
);

Map<String, dynamic> _$SaveRestaurantPosInvoiceRequestToJson(
  SaveRestaurantPosInvoiceRequest instance,
) => <String, dynamic>{
  'Invoice': instance.invoice,
  'Items': instance.items,
  'Payments': instance.payments,
  'gediaKey': instance.gediaKey,
};

RestaurantPosInvoiceInfoRequest _$RestaurantPosInvoiceInfoRequestFromJson(
  Map<String, dynamic> json,
) => RestaurantPosInvoiceInfoRequest(
  invoiceId: (json['InvoiceId'] as num?)?.toInt(),
  pendingInvoiceId: (json['PendingInvoiceId'] as num?)?.toInt(),
  postype: (json['Postype'] as num).toInt(),
  foodTableId: (json['FoodTableId'] as num?)?.toInt(),
  waiterId: (json['WaiterId'] as num?)?.toInt(),
  deliveryCompanyId: (json['DeliveryCompanyId'] as num?)?.toInt(),
  voucherCode: json['VoucherCode'] as String?,
  deliveryManId: (json['DeliveryManId'] as num?)?.toInt(),
  notes: json['Notes'] as String?,
  discount: json['Discount'] == null
      ? null
      : RestaurantPosDiscountRequest.fromJson(
          json['Discount'] as Map<String, dynamic>,
        ),
  paidAmount: (json['PaidAmount'] as num).toDouble(),
  totalInvoicePrice: (json['TotalInvoicePrice'] as num).toDouble(),
  clientId: (json['ClientId'] as num).toInt(),
  invoiceDiscountId: (json['InvoiceDiscountId'] as num?)?.toInt(),
  personAddressId: (json['PersonAddressId'] as num?)?.toInt() ?? 0,
  personPhoneId: (json['PersonPhoneId'] as num?)?.toInt() ?? 0,
  orderReceivedTime: json['OrderReceivedTime'] == null
      ? null
      : DateTime.parse(json['OrderReceivedTime'] as String),
  deliveryCost: (json['DeliveryCost'] as num?)?.toDouble() ?? 0,
  printingKitchenKey: json['PrintingKitchenKey'] as String?,
  isArabic: json['isArabic'] as bool? ?? false,
);

Map<String, dynamic> _$RestaurantPosInvoiceInfoRequestToJson(
  RestaurantPosInvoiceInfoRequest instance,
) => <String, dynamic>{
  'InvoiceId': instance.invoiceId,
  'PendingInvoiceId': instance.pendingInvoiceId,
  'Postype': instance.postype,
  'FoodTableId': instance.foodTableId,
  'WaiterId': instance.waiterId,
  'DeliveryCompanyId': instance.deliveryCompanyId,
  'VoucherCode': instance.voucherCode,
  'DeliveryManId': instance.deliveryManId,
  'Notes': instance.notes,
  'Discount': instance.discount,
  'PaidAmount': instance.paidAmount,
  'TotalInvoicePrice': instance.totalInvoicePrice,
  'ClientId': instance.clientId,
  'InvoiceDiscountId': instance.invoiceDiscountId,
  'PersonAddressId': instance.personAddressId,
  'PersonPhoneId': instance.personPhoneId,
  'OrderReceivedTime': instance.orderReceivedTime?.toIso8601String(),
  'DeliveryCost': instance.deliveryCost,
  'PrintingKitchenKey': instance.printingKitchenKey,
  'isArabic': instance.isArabic,
};

RestaurantPosDiscountRequest _$RestaurantPosDiscountRequestFromJson(
  Map<String, dynamic> json,
) => RestaurantPosDiscountRequest(
  type: (json['Type'] as num).toInt(),
  value: (json['Value'] as num).toDouble(),
);

Map<String, dynamic> _$RestaurantPosDiscountRequestToJson(
  RestaurantPosDiscountRequest instance,
) => <String, dynamic>{'Type': instance.type, 'Value': instance.value};

RestaurantPosInvoiceItemRequest _$RestaurantPosInvoiceItemRequestFromJson(
  Map<String, dynamic> json,
) => RestaurantPosInvoiceItemRequest(
  itemId: (json['ItemId'] as num).toInt(),
  sizeId: (json['SizeId'] as num?)?.toInt(),
  quantity: (json['Quantity'] as num).toDouble(),
  price: (json['Price'] as num).toDouble(),
  notes: json['Notes'] as String?,
  discount: json['Discount'] == null
      ? null
      : RestaurantPosDiscountRequest.fromJson(
          json['Discount'] as Map<String, dynamic>,
        ),
  itemDiscountId: (json['ItemDiscountId'] as num?)?.toInt(),
  additives:
      (json['Additives'] as List<dynamic>?)
          ?.map(
            (e) => RestaurantPosItemAdditiveRequest.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList() ??
      const [],
);

Map<String, dynamic> _$RestaurantPosInvoiceItemRequestToJson(
  RestaurantPosInvoiceItemRequest instance,
) => <String, dynamic>{
  'ItemId': instance.itemId,
  'SizeId': instance.sizeId,
  'Quantity': instance.quantity,
  'Price': instance.price,
  'Notes': instance.notes,
  'Discount': instance.discount,
  'ItemDiscountId': instance.itemDiscountId,
  'Additives': instance.additives,
};

RestaurantPosItemAdditiveRequest _$RestaurantPosItemAdditiveRequestFromJson(
  Map<String, dynamic> json,
) => RestaurantPosItemAdditiveRequest(
  additiveId: (json['AdditiveId'] as num).toInt(),
  quantity: (json['Quantity'] as num).toDouble(),
);

Map<String, dynamic> _$RestaurantPosItemAdditiveRequestToJson(
  RestaurantPosItemAdditiveRequest instance,
) => <String, dynamic>{
  'AdditiveId': instance.additiveId,
  'Quantity': instance.quantity,
};

RestaurantPosPaymentRequest _$RestaurantPosPaymentRequestFromJson(
  Map<String, dynamic> json,
) => RestaurantPosPaymentRequest(
  paymentMethodId: (json['PaymentMethodId'] as num).toInt(),
  amount: (json['Amount'] as num).toDouble(),
);

Map<String, dynamic> _$RestaurantPosPaymentRequestToJson(
  RestaurantPosPaymentRequest instance,
) => <String, dynamic>{
  'PaymentMethodId': instance.paymentMethodId,
  'Amount': instance.amount,
};
