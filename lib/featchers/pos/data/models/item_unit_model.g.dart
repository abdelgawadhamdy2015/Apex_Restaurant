// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_unit_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ItemUnitModel _$ItemUnitModelFromJson(Map<String, dynamic> json) =>
    ItemUnitModel(
      id: (json['id'] as num?)?.toInt(),
      itemId: (json['itemId'] as num?)?.toInt(),
      unitId: (json['unitId'] as num?)?.toInt(),
      conversionFactor: (json['conversionFactor'] as num?)?.toDouble(),
      purchasePrice: (json['purchasePrice'] as num?)?.toDouble(),
      salePrice1: (json['salePrice1'] as num?)?.toDouble(),
      salePrice2: (json['salePrice2'] as num?)?.toDouble(),
      salePrice3: (json['salePrice3'] as num?)?.toDouble(),
      salePrice4: (json['salePrice4'] as num?)?.toDouble(),
      barcode: json['barcode'] as String?,
      sizeId: (json['sizeId'] as num?)?.toInt(),
      calories: (json['calories'] as num?)?.toDouble(),
      isActive: json['isActive'] as bool?,
    );

Map<String, dynamic> _$ItemUnitModelToJson(ItemUnitModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'itemId': instance.itemId,
      'unitId': instance.unitId,
      'conversionFactor': instance.conversionFactor,
      'purchasePrice': instance.purchasePrice,
      'salePrice1': instance.salePrice1,
      'salePrice2': instance.salePrice2,
      'salePrice3': instance.salePrice3,
      'salePrice4': instance.salePrice4,
      'barcode': instance.barcode,
      'sizeId': instance.sizeId,
      'calories': instance.calories,
      'isActive': instance.isActive,
    };
