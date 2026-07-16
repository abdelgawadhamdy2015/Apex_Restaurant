import 'package:json_annotation/json_annotation.dart';

part 'category_response.g.dart';

@JsonSerializable()
class CategoryResponse {
  final int id;
  final String arabicName;
  final String latinName;
  final String code;
  final int orderSerial;
  final String color;
  final int status;
  final String? notes;
  final String? imagePath;
  final List<AdditiveModel> additives;

  const CategoryResponse({
    required this.id,
    required this.arabicName,
    required this.latinName,
    required this.code,
    required this.orderSerial,
    required this.color,
    required this.status,
    this.notes,
    this.imagePath,
    required this.additives,
  });

  factory CategoryResponse.fromJson(Map<String, dynamic> json) =>
      _$CategoryResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryResponseToJson(this);
}

@JsonSerializable()
class AdditiveModel {
  final int id;
  final String arabicName;
  final String latinName;
  final double price;
  final String? notes;
  final String? imagePath;

  const AdditiveModel({
    required this.id,
    required this.arabicName,
    required this.latinName,
    required this.price,
    this.notes,
    this.imagePath,
  });

  factory AdditiveModel.fromJson(Map<String, dynamic> json) =>
      _$AdditiveModelFromJson(json);

  Map<String, dynamic> toJson() => _$AdditiveModelToJson(this);
}
