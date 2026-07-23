// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderModel _$OrderModelFromJson(Map<String, dynamic> json) => OrderModel(
  id: json['id'] as String,
  invoiceNumber: json['invoiceNumber'] as String,
  orderQueueNumber: json['orderQueueNumber'] as String?,
  customerName: json['customerName'] as String?,
  dateTime: DateTime.parse(json['dateTime'] as String),
  totalAmount: (json['totalAmount'] as num).toDouble(),
  itemsCount: (json['itemsCount'] as num).toInt(),
  items:
      (json['items'] as List<dynamic>?)
          ?.map((e) => OrderItemModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  isHeld: json['isHeld'] as bool? ?? false,
);

Map<String, dynamic> _$OrderModelToJson(OrderModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'invoiceNumber': instance.invoiceNumber,
      'orderQueueNumber': instance.orderQueueNumber,
      'customerName': instance.customerName,
      'dateTime': instance.dateTime.toIso8601String(),
      'totalAmount': instance.totalAmount,
      'itemsCount': instance.itemsCount,
      'items': instance.items,
      'isHeld': instance.isHeld,
    };
