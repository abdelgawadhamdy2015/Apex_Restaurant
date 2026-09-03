import 'package:json_annotation/json_annotation.dart';

part 'success_response_model.g.dart';

@JsonSerializable()
class SuccessResponseModel {
  final String? invoiceCode;
  final PrintingChequeModel? printingCheque;
  final PrintingDataModel? printingData;

  const SuccessResponseModel({
    this.invoiceCode,
    this.printingCheque,
    this.printingData,
  });

  factory SuccessResponseModel.fromJson(Map<String, dynamic> json) =>
      _$SuccessResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$SuccessResponseModelToJson(this);
}

@JsonSerializable()
class PrintingChequeModel {
  final String? fileURL;
  final String? fileName;
  final String? htmlPrint;
  final String? fileBase64;
  final bool? isFireFox;
  final int? result;
  final int? resultForPrint;
  final dynamic data;
  final bool? isOverSize;

  const PrintingChequeModel({
    this.fileURL,
    this.fileName,
    this.htmlPrint,
    this.fileBase64,
    this.isFireFox,
    this.result,
    this.resultForPrint,
    this.data,
    this.isOverSize,
  });

  factory PrintingChequeModel.fromJson(Map<String, dynamic> json) =>
      _$PrintingChequeModelFromJson(json);

  Map<String, dynamic> toJson() => _$PrintingChequeModelToJson(this);
}

@JsonSerializable()
class PrintingDataModel {
  final int? result;
  final int? dataCount;
  final dynamic data;
  final dynamic printingData;
  final dynamic alart;
  final int? id;
  final String? code;
  final String? note;
  final int? totalCount;
  final String? errorMessageAr;
  final String? errorMessageEn;
  final double? total;
  final DateTime? dateTimeNow;
  final int? updateNumber;
  final int? isUpdate;
  final bool? isPrint;
  final int? permissionListId;
  final String? employyeNameAr;
  final String? employyeNameEn;
  final dynamic posPrintFilesAr;
  final dynamic posPrintFilesEn;
  final dynamic returnPosPrintFilesAr;
  final dynamic returnPosPrintFilesEn;
  final bool? isAuthorizedOnDashboardData;

  const PrintingDataModel({
    this.result,
    this.dataCount,
    this.data,
    this.printingData,
    this.alart,
    this.id,
    this.code,
    this.note,
    this.totalCount,
    this.errorMessageAr,
    this.errorMessageEn,
    this.total,
    this.dateTimeNow,
    this.updateNumber,
    this.isUpdate,
    this.isPrint,
    this.permissionListId,
    this.employyeNameAr,
    this.employyeNameEn,
    this.posPrintFilesAr,
    this.posPrintFilesEn,
    this.returnPosPrintFilesAr,
    this.returnPosPrintFilesEn,
    this.isAuthorizedOnDashboardData,
  });

  factory PrintingDataModel.fromJson(Map<String, dynamic> json) =>
      _$PrintingDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$PrintingDataModelToJson(this);
}
