// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'print_kitchen_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PrintKitchenResponse _$PrintKitchenResponseFromJson(
  Map<String, dynamic> json,
) => PrintKitchenResponse(
  unixTime: json['unixTime'],
  files:
      (json['files'] as List<dynamic>?)
          ?.map((e) => PrintKitchenFile.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$PrintKitchenResponseToJson(
  PrintKitchenResponse instance,
) => <String, dynamic>{'unixTime': instance.unixTime, 'files': instance.files};

PrintKitchenFile _$PrintKitchenFileFromJson(Map<String, dynamic> json) =>
    PrintKitchenFile(
      printerId: (json['printerID'] as num?)?.toInt(),
      printerNameAr: json['printerName_ar'] as String?,
      printerNameEn: json['printerName_en'] as String?,
      printerIp: json['printerIP'] as String?,
      printingFilePath: json['printingFilePath'] as String?,
      errorAr: json['error_ar'] as String?,
      errorEn: json['error_en'] as String?,
      fileGenerated: json['fileGenerated'] as bool?,
      kitchenId: (json['kitchenID'] as num?)?.toInt(),
    );

Map<String, dynamic> _$PrintKitchenFileToJson(PrintKitchenFile instance) =>
    <String, dynamic>{
      'printerID': instance.printerId,
      'printerName_ar': instance.printerNameAr,
      'printerName_en': instance.printerNameEn,
      'printerIP': instance.printerIp,
      'printingFilePath': instance.printingFilePath,
      'error_ar': instance.errorAr,
      'error_en': instance.errorEn,
      'fileGenerated': instance.fileGenerated,
      'kitchenID': instance.kitchenId,
    };
