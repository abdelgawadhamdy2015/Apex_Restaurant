// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'success_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SuccessResponseModel _$SuccessResponseModelFromJson(
  Map<String, dynamic> json,
) => SuccessResponseModel(
  invoiceCode: json['invoiceCode'] as String?,
  printingCheque: json['printingCheque'] == null
      ? null
      : PrintingChequeModel.fromJson(
          json['printingCheque'] as Map<String, dynamic>,
        ),
  printingData: json['printingData'] == null
      ? null
      : PrintingDataModel.fromJson(
          json['printingData'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$SuccessResponseModelToJson(
  SuccessResponseModel instance,
) => <String, dynamic>{
  'invoiceCode': instance.invoiceCode,
  'printingCheque': instance.printingCheque,
  'printingData': instance.printingData,
};

PrintingChequeModel _$PrintingChequeModelFromJson(Map<String, dynamic> json) =>
    PrintingChequeModel(
      fileURL: json['fileURL'] as String?,
      fileName: json['fileName'] as String?,
      htmlPrint: json['htmlPrint'] as String?,
      fileBase64: json['fileBase64'] as String?,
      isFireFox: json['isFireFox'] as bool?,
      result: (json['result'] as num?)?.toInt(),
      resultForPrint: (json['resultForPrint'] as num?)?.toInt(),
      data: json['data'],
      isOverSize: json['isOverSize'] as bool?,
    );

Map<String, dynamic> _$PrintingChequeModelToJson(
  PrintingChequeModel instance,
) => <String, dynamic>{
  'fileURL': instance.fileURL,
  'fileName': instance.fileName,
  'htmlPrint': instance.htmlPrint,
  'fileBase64': instance.fileBase64,
  'isFireFox': instance.isFireFox,
  'result': instance.result,
  'resultForPrint': instance.resultForPrint,
  'data': instance.data,
  'isOverSize': instance.isOverSize,
};

PrintingDataModel _$PrintingDataModelFromJson(Map<String, dynamic> json) =>
    PrintingDataModel(
      result: (json['result'] as num?)?.toInt(),
      dataCount: (json['dataCount'] as num?)?.toInt(),
      data: json['data'],
      printingData: json['printingData'],
      alart: json['alart'],
      id: (json['id'] as num?)?.toInt(),
      code: json['code'] as String?,
      note: json['note'] as String?,
      totalCount: (json['totalCount'] as num?)?.toInt(),
      errorMessageAr: json['errorMessageAr'] as String?,
      errorMessageEn: json['errorMessageEn'] as String?,
      total: (json['total'] as num?)?.toDouble(),
      dateTimeNow: json['dateTimeNow'] == null
          ? null
          : DateTime.parse(json['dateTimeNow'] as String),
      updateNumber: (json['updateNumber'] as num?)?.toInt(),
      isUpdate: (json['isUpdate'] as num?)?.toInt(),
      isPrint: json['isPrint'] as bool?,
      permissionListId: (json['permissionListId'] as num?)?.toInt(),
      employyeNameAr: json['employyeNameAr'] as String?,
      employyeNameEn: json['employyeNameEn'] as String?,
      posPrintFilesAr: json['posPrintFilesAr'],
      posPrintFilesEn: json['posPrintFilesEn'],
      returnPosPrintFilesAr: json['returnPosPrintFilesAr'],
      returnPosPrintFilesEn: json['returnPosPrintFilesEn'],
      isAuthorizedOnDashboardData: json['isAuthorizedOnDashboardData'] as bool?,
    );

Map<String, dynamic> _$PrintingDataModelToJson(PrintingDataModel instance) =>
    <String, dynamic>{
      'result': instance.result,
      'dataCount': instance.dataCount,
      'data': instance.data,
      'printingData': instance.printingData,
      'alart': instance.alart,
      'id': instance.id,
      'code': instance.code,
      'note': instance.note,
      'totalCount': instance.totalCount,
      'errorMessageAr': instance.errorMessageAr,
      'errorMessageEn': instance.errorMessageEn,
      'total': instance.total,
      'dateTimeNow': instance.dateTimeNow?.toIso8601String(),
      'updateNumber': instance.updateNumber,
      'isUpdate': instance.isUpdate,
      'isPrint': instance.isPrint,
      'permissionListId': instance.permissionListId,
      'employyeNameAr': instance.employyeNameAr,
      'employyeNameEn': instance.employyeNameEn,
      'posPrintFilesAr': instance.posPrintFilesAr,
      'posPrintFilesEn': instance.posPrintFilesEn,
      'returnPosPrintFilesAr': instance.returnPosPrintFilesAr,
      'returnPosPrintFilesEn': instance.returnPosPrintFilesEn,
      'isAuthorizedOnDashboardData': instance.isAuthorizedOnDashboardData,
    };
