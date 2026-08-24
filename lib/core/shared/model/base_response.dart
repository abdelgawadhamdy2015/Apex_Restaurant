import 'package:freezed_annotation/freezed_annotation.dart';

part 'base_response.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class BaseResponse<T> {
  final int? result;
  final int? dataCount;
  final T? data;
  final dynamic printingData;

  @JsonKey(name: 'alart')
  final AlertModel? alert;

  final dynamic id;
  final dynamic code;
  final String? note;
  final int? totalCount;

  final dynamic errors;
  final String? errorMessageAr;
  final String? errorMessageEn;

  final double? total;
  final DateTime? dateTimeNow;
  final int? updateNumber;
  final int? isUpdate;
  final bool? isPrint;

  final int? permissionListId;

  @JsonKey(name: 'employyeNameAr')
  final String? employeeNameAr;

  @JsonKey(name: 'employyeNameEn')
  final String? employeeNameEn;

  final dynamic posPrintFilesAr;
  final dynamic posPrintFilesEn;
  final dynamic returnPosPrintFilesAr;
  final dynamic returnPosPrintFilesEn;

  final bool? isAuthorizedOnDashboardData;

  const BaseResponse({
    this.result,
    this.dataCount,
    this.data,
    this.printingData,
    this.alert,
    this.id,
    this.code,
    this.note,
    this.totalCount,
    this.errors,
    this.errorMessageAr,
    this.errorMessageEn,
    this.total,
    this.dateTimeNow,
    this.updateNumber,
    this.isUpdate,
    this.isPrint,
    this.permissionListId,
    this.employeeNameAr,
    this.employeeNameEn,
    this.posPrintFilesAr,
    this.posPrintFilesEn,
    this.returnPosPrintFilesAr,
    this.returnPosPrintFilesEn,
    this.isAuthorizedOnDashboardData,
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

  const AlertModel({
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
