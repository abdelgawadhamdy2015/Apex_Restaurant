// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'menu_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MenuItemModel _$MenuItemModelFromJson(Map<String, dynamic> json) =>
    MenuItemModel(
      id: (json['id'] as num?)?.toInt(),
      itemCode: json['itemCode'] as String?,
      typeId: (json['typeId'] as num?)?.toInt(),
      usedInSales: json['usedInSales'] as bool?,
      canReturnBackToStore: json['canReturnBackToStore'] as bool?,
      depositeUnit: (json['depositeUnit'] as num?)?.toInt(),
      withdrawUnit: (json['withdrawUnit'] as num?)?.toInt(),
      reportUnit: (json['reportUnit'] as num?)?.toInt(),
      vat: (json['vat'] as num?)?.toDouble(),
      applyVAT: json['applyVAT'] as bool?,
      model: json['model'] as String?,
      description: json['description'] as String?,
      arabicName: json['arabicName'] as String?,
      latinName: json['latinName'] as String?,
      groupId: (json['groupId'] as num?)?.toInt(),
      status: (json['status'] as num?)?.toInt(),
      image: json['image'] as String?,
      imageName: json['imageName'] as String?,
      imagePath: json['imagePath'] as String?,
      category: json['category'] == null
          ? null
          : CategoryModel.fromJson(json['category'] as Map<String, dynamic>),
      units: (json['units'] as List<dynamic>?)
          ?.map((e) => ItemUnitModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MenuItemModelToJson(MenuItemModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'itemCode': instance.itemCode,
      'typeId': instance.typeId,
      'usedInSales': instance.usedInSales,
      'canReturnBackToStore': instance.canReturnBackToStore,
      'depositeUnit': instance.depositeUnit,
      'withdrawUnit': instance.withdrawUnit,
      'reportUnit': instance.reportUnit,
      'vat': instance.vat,
      'applyVAT': instance.applyVAT,
      'model': instance.model,
      'description': instance.description,
      'arabicName': instance.arabicName,
      'latinName': instance.latinName,
      'groupId': instance.groupId,
      'status': instance.status,
      'image': instance.image,
      'imageName': instance.imageName,
      'imagePath': instance.imagePath,
      'category': instance.category,
      'units': instance.units,
    };
