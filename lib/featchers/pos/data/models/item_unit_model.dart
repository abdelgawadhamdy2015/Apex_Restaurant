import 'package:json_annotation/json_annotation.dart';

part 'item_unit_model.g.dart';

@JsonSerializable()
class ItemUnitModel {
  final int? id;
  final int? itemId;
  final int? unitId;

  final double? conversionFactor;
  final double? purchasePrice;

  final double? salePrice1;
  final double? salePrice2;
  final double? salePrice3;
  final double? salePrice4;

  final String? barcode;

  final int? sizeId;
  final double? calories;

  final bool? isActive;

  const ItemUnitModel({
    this.id,
    this.itemId,
    this.unitId,
    this.conversionFactor,
    this.purchasePrice,
    this.salePrice1,
    this.salePrice2,
    this.salePrice3,
    this.salePrice4,
    this.barcode,
    this.sizeId,
    this.calories,
    this.isActive,
  });

  factory ItemUnitModel.fromJson(Map<String, dynamic> json) =>
      _$ItemUnitModelFromJson(json);

  Map<String, dynamic> toJson() => _$ItemUnitModelToJson(this);
}
