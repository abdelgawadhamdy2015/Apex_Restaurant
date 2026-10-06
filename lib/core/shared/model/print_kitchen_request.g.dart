// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'print_kitchen_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PrintKitchenRequest _$PrintKitchenRequestFromJson(Map<String, dynamic> json) =>
    PrintKitchenRequest(
      invoiceId: (json['InvoiceID'] as num).toInt(),
      printAll: json['PrintAll'] as bool? ?? true,
      arabic: json['arabic'] as bool? ?? true,
      printingToolTocken: json['printingToolTocken'] as String?,
    );

Map<String, dynamic> _$PrintKitchenRequestToJson(
  PrintKitchenRequest instance,
) => <String, dynamic>{
  'InvoiceID': instance.invoiceId,
  'PrintAll': ?instance.printAll,
  'arabic': ?instance.arabic,
  'printingToolTocken': ?instance.printingToolTocken,
};
