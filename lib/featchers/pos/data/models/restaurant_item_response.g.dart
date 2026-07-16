// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'restaurant_item_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RestaurantItemResponse _$RestaurantItemResponseFromJson(
  Map<String, dynamic> json,
) => RestaurantItemResponse(
  itemId: (json['itemId'] as num).toInt(),
  itemCode: json['itemCode'] as String,
  itemNameAr: json['itemNameAr'] as String,
  itemNameEn: json['itemNameEn'] as String,
  imagePath: json['imagePath'] as String?,
  categoryId: (json['categoryId'] as num).toInt(),
  defaultPrice: (json['defaultPrice'] as num).toDouble(),
  isOffer: json['isOffer'] as bool,
  orderSerial: (json['orderSerial'] as num).toInt(),
  count: (json['count'] as num).toInt(),
  posTypes: json['posTypes'] as List<dynamic>,
  sizes: (json['sizes'] as List<dynamic>)
      .map((e) => ItemSizeResponse.fromJson(e as Map<String, dynamic>))
      .toList(),
  offersItems: json['offersItems'] as List<dynamic>,
);

Map<String, dynamic> _$RestaurantItemResponseToJson(
  RestaurantItemResponse instance,
) => <String, dynamic>{
  'itemId': instance.itemId,
  'itemCode': instance.itemCode,
  'itemNameAr': instance.itemNameAr,
  'itemNameEn': instance.itemNameEn,
  'imagePath': instance.imagePath,
  'categoryId': instance.categoryId,
  'defaultPrice': instance.defaultPrice,
  'isOffer': instance.isOffer,
  'orderSerial': instance.orderSerial,
  'count': instance.count,
  'posTypes': instance.posTypes,
  'sizes': instance.sizes,
  'offersItems': instance.offersItems,
};

ItemSizeResponse _$ItemSizeResponseFromJson(Map<String, dynamic> json) =>
    ItemSizeResponse(
      variantId: (json['variantId'] as num).toInt(),
      sizeId: (json['sizeId'] as num).toInt(),
      sizeNameAr: json['sizeNameAr'] as String,
      sizeNameEn: json['sizeNameEn'] as String,
      price: (json['price'] as num).toDouble(),
      isActive: json['isActive'] as bool,
      discount: ItemDiscountResponse.fromJson(
        json['discount'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$ItemSizeResponseToJson(ItemSizeResponse instance) =>
    <String, dynamic>{
      'variantId': instance.variantId,
      'sizeId': instance.sizeId,
      'sizeNameAr': instance.sizeNameAr,
      'sizeNameEn': instance.sizeNameEn,
      'price': instance.price,
      'isActive': instance.isActive,
      'discount': instance.discount,
    };

ItemDiscountResponse _$ItemDiscountResponseFromJson(
  Map<String, dynamic> json,
) => ItemDiscountResponse(
  id: (json['id'] as num).toInt(),
  arabicName: json['arabicName'] as String?,
  latinName: json['latinName'] as String?,
  discountNatural: (json['discountNatural'] as num).toInt(),
  discountValue: (json['discountValue'] as num).toDouble(),
  maxDiscountValue: (json['maxDiscountValue'] as num).toDouble(),
  minInvoiceNet: (json['minInvoiceNet'] as num).toDouble(),
  includeFoodAdditions: json['includeFoodAdditions'] as bool,
);

Map<String, dynamic> _$ItemDiscountResponseToJson(
  ItemDiscountResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'arabicName': instance.arabicName,
  'latinName': instance.latinName,
  'discountNatural': instance.discountNatural,
  'discountValue': instance.discountValue,
  'maxDiscountValue': instance.maxDiscountValue,
  'minInvoiceNet': instance.minInvoiceNet,
  'includeFoodAdditions': instance.includeFoodAdditions,
};
