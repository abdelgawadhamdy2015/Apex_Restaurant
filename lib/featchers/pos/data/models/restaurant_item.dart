import 'package:json_annotation/json_annotation.dart';

part 'restaurant_item.g.dart';

@JsonSerializable()
class RestaurantItem {
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
  final List<ItemSize> sizes;
  final List<dynamic> offersItems;

  const RestaurantItem({
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

  factory RestaurantItem.fromJson(Map<String, dynamic> json) =>
      _$RestaurantItemFromJson(json);

  Map<String, dynamic> toJson() => _$RestaurantItemToJson(this);
}

@JsonSerializable()
class ItemSize {
  final int variantId;
  final int sizeId;
  final String sizeNameAr;
  final String sizeNameEn;
  final double price;
  final bool isActive;
  final List<ItemDiscount?>? discount;

  const ItemSize({
    required this.variantId,
    required this.sizeId,
    required this.sizeNameAr,
    required this.sizeNameEn,
    required this.price,
    required this.isActive,
    required this.discount,
  });

  factory ItemSize.fromJson(Map<String, dynamic> json) =>
      _$ItemSizeFromJson(json);

  Map<String, dynamic> toJson() => _$ItemSizeToJson(this);
}

@JsonSerializable()
class ItemDiscount {
  final int id;
  final String? arabicName;
  final String? latinName;
  final int discountNatural;
  final double discountValue;
  final double maxDiscountValue;
  final double minInvoiceNet;
  final bool includeFoodAdditions;

  const ItemDiscount({
    required this.id,
    this.arabicName,
    this.latinName,
    required this.discountNatural,
    required this.discountValue,
    required this.maxDiscountValue,
    required this.minInvoiceNet,
    required this.includeFoodAdditions,
  });

  factory ItemDiscount.fromJson(Map<String, dynamic> json) =>
      _$ItemDiscountFromJson(json);

  Map<String, dynamic> toJson() => _$ItemDiscountToJson(this);
}
