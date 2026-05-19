import 'package:json_annotation/json_annotation.dart';
part 'api_error_model.g.dart';

@JsonSerializable()
class ApiErrorModel {
  final String? errorMessageAr;
  final String? errorMessageEn;

  final int? code;

  ApiErrorModel({
    required this.errorMessageAr,
    required this.errorMessageEn,
    required this.code,
  });

  factory ApiErrorModel.fromJson(Map<String, dynamic> json) =>
      _$ApiErrorModelFromJson(json);

  Map<String, dynamic> toJson() => _$ApiErrorModelToJson(this);
}
