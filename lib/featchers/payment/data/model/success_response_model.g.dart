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
);

Map<String, dynamic> _$SuccessResponseModelToJson(
  SuccessResponseModel instance,
) => <String, dynamic>{
  'invoiceCode': instance.invoiceCode,
  'printingCheque': instance.printingCheque,
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
