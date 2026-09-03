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
  final bool? isTobaccoTax;
  final int? itemTypeId;

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
    this.isTobaccoTax,
    this.itemTypeId,
  });

  factory RestaurantItem.fromJson(Map<String, dynamic> json) =>
      _$RestaurantItemFromJson(json);

  Map<String, dynamic> toJson() => _$RestaurantItemToJson(this);
}

@JsonSerializable()
class ItemSize {
  final int? variantId;
  final int? sizeId;
  final String? sizeNameAr;
  final String? sizeNameEn;
  final double? price;
  final bool? isActive;

  /// The API now returns this array under the key `"discounts"` (plural),
  /// with each entry a wrapper of `{ "discount": {...}, "posTypeID": N }`
  /// — one entry per POS type the discount applies to — rather than a
  /// flat list of discounts directly.
  final List<ItemSizeDiscount?>? discounts;

  const ItemSize({
    this.variantId,
    required this.sizeId,
    required this.sizeNameAr,
    required this.sizeNameEn,
    required this.price,
    this.isActive,
    this.discounts,
  });

  factory ItemSize.fromJson(Map<String, dynamic> json) =>
      _$ItemSizeFromJson(json);

  Map<String, dynamic> toJson() => _$ItemSizeToJson(this);

  /// Convenience: unique underlying [ItemDiscount]s across all POS-type
  /// wrapper entries (since the same discount is often repeated once per
  /// POS type, e.g. posTypeID 1..5 all pointing at the same discount id).
  List<ItemDiscount> get uniqueDiscounts {
    final seen = <int>{};
    final result = <ItemDiscount>[];
    for (final entry in discounts ?? const []) {
      final d = entry?.discount;
      if (d != null && seen.add(d.id)) {
        result.add(d);
      }
    }
    return result;
  }

  /// Returns the discount applicable to a given POS type id, if any.
  ItemDiscount? discountForPosType(int posTypeId) {
    for (final entry in discounts ?? const []) {
      if (entry?.posTypeID == posTypeId) return entry?.discount;
    }
    return null;
  }
}

/// Wraps an [ItemDiscount] together with the POS type id it applies to.
/// Matches API entries shaped like:
/// ```json
/// { "discount": { ... }, "posTypeID": 1 }
/// ```
@JsonSerializable()
class ItemSizeDiscount {
  final ItemDiscount? discount;
  final int? posTypeID;

  const ItemSizeDiscount({this.discount, this.posTypeID});

  factory ItemSizeDiscount.fromJson(Map<String, dynamic> json) =>
      _$ItemSizeDiscountFromJson(json);

  Map<String, dynamic> toJson() => _$ItemSizeDiscountToJson(this);
}

@JsonSerializable()
class ItemDiscount {
  final String id;

  /// New: short numeric code identifying the discount (e.g. `1`).
  final int? code;
  final String? arabicName;
  final String? latinName;
  final int discountNatural;
  final double discountValue;
  final double maxDiscountValue;
  final double minInvoiceNet;
  final bool includeFoodAdditions;

  /// New: list of POS type ids this discount is configured for
  /// (e.g. `[1, 2, 3, 4, 5]`).
  final List<int>? posTypes;

  const ItemDiscount({
    required this.id,
    this.code,
    this.arabicName,
    this.latinName,
    required this.discountNatural,
    required this.discountValue,
    required this.maxDiscountValue,
    required this.minInvoiceNet,
    required this.includeFoodAdditions,
    this.posTypes,
  });

  factory ItemDiscount.fromJson(Map<String, dynamic> json) =>
      _$ItemDiscountFromJson(json);

  Map<String, dynamic> toJson() => _$ItemDiscountToJson(this);
}
