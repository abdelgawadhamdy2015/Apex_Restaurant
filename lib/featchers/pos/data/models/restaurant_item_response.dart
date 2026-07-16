import 'package:json_annotation/json_annotation.dart';

part 'restaurant_item_response.g.dart';

@JsonSerializable()
class RestaurantItemResponse {
  final int itemId;
  final String itemCode;
  final String itemNameAr;
  final String itemNameEn;
  final String? imagePath;
  final int categoryId;
  final double defaultPrice;
  final bool isOffer;
  final int orderSerial;
  final int count;
  final List<dynamic> posTypes;
  final List<ItemSizeResponse> sizes;
  final List<dynamic> offersItems;

  const RestaurantItemResponse({
    required this.itemId,
    required this.itemCode,
    required this.itemNameAr,
    required this.itemNameEn,
    this.imagePath,
    required this.categoryId,
    required this.defaultPrice,
    required this.isOffer,
    required this.orderSerial,
    required this.count,
    required this.posTypes,
    required this.sizes,
    required this.offersItems,
  });

  factory RestaurantItemResponse.fromJson(Map<String, dynamic> json) =>
      _$RestaurantItemResponseFromJson(json);

  Map<String, dynamic> toJson() => _$RestaurantItemResponseToJson(this);
}

@JsonSerializable()
class ItemSizeResponse {
  final int variantId;
  final int sizeId;
  final String sizeNameAr;
  final String sizeNameEn;
  final double price;
  final bool isActive;
  final ItemDiscountResponse discount;

  const ItemSizeResponse({
    required this.variantId,
    required this.sizeId,
    required this.sizeNameAr,
    required this.sizeNameEn,
    required this.price,
    required this.isActive,
    required this.discount,
  });

  factory ItemSizeResponse.fromJson(Map<String, dynamic> json) =>
      _$ItemSizeResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ItemSizeResponseToJson(this);
}

@JsonSerializable()
class ItemDiscountResponse {
  final int id;
  final String? arabicName;
  final String? latinName;
  final int discountNatural;
  final double discountValue;
  final double maxDiscountValue;
  final double minInvoiceNet;
  final bool includeFoodAdditions;

  const ItemDiscountResponse({
    required this.id,
    this.arabicName,
    this.latinName,
    required this.discountNatural,
    required this.discountValue,
    required this.maxDiscountValue,
    required this.minInvoiceNet,
    required this.includeFoodAdditions,
  });

  factory ItemDiscountResponse.fromJson(Map<String, dynamic> json) =>
      _$ItemDiscountResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ItemDiscountResponseToJson(this);
}
