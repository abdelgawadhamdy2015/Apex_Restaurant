// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'food_additive_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FoodAdditiveModel _$FoodAdditiveModelFromJson(Map<String, dynamic> json) =>
    FoodAdditiveModel(
      id: json['id'] as String?,
      arabicName: json['arabicName'] as String?,
      latinName: json['latinName'] as String?,
      price: (json['price'] as num?)?.toDouble(),
      imagePath: json['imagePath'] as String?,
    );

Map<String, dynamic> _$FoodAdditiveModelToJson(FoodAdditiveModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'arabicName': instance.arabicName,
      'latinName': instance.latinName,
      'price': instance.price,
      'imagePath': instance.imagePath,
    };
