import 'package:freezed_annotation/freezed_annotation.dart';
part 'base_response.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class BaseResponse<T> {
  final int? result;
  final T? data;
  final int? totalCount;
  final String? errorMessageAr;
  final String? errorMessageEn;
  final AlertModel? alart;

  BaseResponse({
    this.result,
    this.data,
    this.totalCount,
    this.errorMessageAr,
    this.errorMessageEn,
    this.alart,
  });

  factory BaseResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) => _$BaseResponseFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(Object Function(T value) toJsonT) =>
      _$BaseResponseToJson(this, toJsonT);
}

@JsonSerializable()
class AlertModel {
  final int? alartType;
  final int? type;
  final String? titleAr;
  final String? titleEn;
  final String? messageAr;
  final String? messageEn;

  AlertModel({
    this.alartType,
    this.type,
    this.titleAr,
    this.titleEn,
    this.messageAr,
    this.messageEn,
  });

  factory AlertModel.fromJson(Map<String, dynamic> json) =>
      _$AlertModelFromJson(json);

  Map<String, dynamic> toJson() => _$AlertModelToJson(this);
}
