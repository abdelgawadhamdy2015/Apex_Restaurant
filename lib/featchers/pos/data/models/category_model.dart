import 'package:json_annotation/json_annotation.dart';

part 'category_model.g.dart';

@JsonSerializable()
class CategoryModel {
  final int? id;
  final int? code;
  final String? arabicName;
  final String? latinName;
  final int? status;

  const CategoryModel({
    this.id,
    this.code,
    this.arabicName,
    this.latinName,
    this.status,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryModelToJson(this);
}
