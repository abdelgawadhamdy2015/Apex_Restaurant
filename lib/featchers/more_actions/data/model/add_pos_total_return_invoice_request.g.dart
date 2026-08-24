// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_pos_total_return_invoice_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddPOSTotalReturnInvoiceRequest _$AddPOSTotalReturnInvoiceRequestFromJson(
  Map<String, dynamic> json,
) => AddPOSTotalReturnInvoiceRequest(
  financialYearId: (json['financialYearId'] as num).toInt(),
  id: (json['id'] as num).toInt(),
  isArabic: json['isArabic'] as bool,
);

Map<String, dynamic> _$AddPOSTotalReturnInvoiceRequestToJson(
  AddPOSTotalReturnInvoiceRequest instance,
) => <String, dynamic>{
  'financialYearId': instance.financialYearId,
  'id': instance.id,
  'isArabic': instance.isArabic,
};
