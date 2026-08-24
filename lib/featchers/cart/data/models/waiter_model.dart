import 'package:json_annotation/json_annotation.dart';

part 'waiter_model.g.dart';

@JsonSerializable()
class WaiterModel {
  final int? id;
  final String? arabicName;
  final String? latinName;
  final int? status;
  final int? code;

  const WaiterModel({
    this.id,
    this.arabicName,
    this.latinName,
    this.status,
    this.code,
  });

  factory WaiterModel.fromJson(Map<String, dynamic> json) =>
      _$WaiterModelFromJson(json);

  Map<String, dynamic> toJson() => _$WaiterModelToJson(this);
}
