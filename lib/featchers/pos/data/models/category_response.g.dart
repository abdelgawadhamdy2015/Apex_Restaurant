// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CategoryResponse _$CategoryResponseFromJson(Map<String, dynamic> json) =>
    CategoryResponse(
      id: (json['id'] as num).toInt(),
      arabicName: json['arabicName'] as String,
      latinName: json['latinName'] as String,
      code: json['code'] as String,
      orderSerial: (json['orderSerial'] as num).toInt(),
      color: json['color'] as String,
      status: (json['status'] as num).toInt(),
      notes: json['notes'] as String?,
      imagePath: json['imagePath'] as String?,
      additives: (json['additives'] as List<dynamic>)
          .map((e) => AdditiveModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CategoryResponseToJson(CategoryResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'arabicName': instance.arabicName,
      'latinName': instance.latinName,
      'code': instance.code,
      'orderSerial': instance.orderSerial,
      'color': instance.color,
      'status': instance.status,
      'notes': instance.notes,
      'imagePath': instance.imagePath,
      'additives': instance.additives,
    };

AdditiveModel _$AdditiveModelFromJson(Map<String, dynamic> json) =>
    AdditiveModel(
      id: (json['id'] as num).toInt(),
      arabicName: json['arabicName'] as String,
      latinName: json['latinName'] as String,
      price: (json['price'] as num).toDouble(),
      notes: json['notes'] as String?,
      imagePath: json['imagePath'] as String?,
    );

Map<String, dynamic> _$AdditiveModelToJson(AdditiveModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'arabicName': instance.arabicName,
      'latinName': instance.latinName,
      'price': instance.price,
      'notes': instance.notes,
      'imagePath': instance.imagePath,
    };
