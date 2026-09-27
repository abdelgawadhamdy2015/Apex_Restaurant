import 'package:json_annotation/json_annotation.dart';

part 'safe_model.g.dart';

@JsonSerializable()
class SafeModel {
  final int? id;
  final String? latinName;
  final String? arabicName;
  final int? code;

  SafeModel({this.id, this.latinName, this.arabicName, this.code});

  factory SafeModel.fromJson(Map<String, dynamic> json) =>
      _$SafeModelFromJson(json);

  Map<String, dynamic> toJson() => _$SafeModelToJson(this);
}
