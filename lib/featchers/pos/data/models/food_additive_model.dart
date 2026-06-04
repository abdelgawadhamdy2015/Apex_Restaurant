import 'package:json_annotation/json_annotation.dart';

part 'food_additive_model.g.dart';

@JsonSerializable()
class FoodAdditiveModel {
  final String? id;
  final String? arabicName;
  final String? latinName;
  final double? price;
  final String? imagePath;
  final String? notes;

  const FoodAdditiveModel({
    this.id,
    this.arabicName,
    this.latinName,
    this.price,
    this.imagePath,
    this.notes,
  });

  factory FoodAdditiveModel.fromJson(Map<String, dynamic> json) =>
      _$FoodAdditiveModelFromJson(json);

  Map<String, dynamic> toJson() => _$FoodAdditiveModelToJson(this);
}
