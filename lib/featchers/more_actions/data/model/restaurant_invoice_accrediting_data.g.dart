// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'restaurant_invoice_accrediting_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RestaurantInvoiceAccreditingData _$RestaurantInvoiceAccreditingDataFromJson(
  Map<String, dynamic> json,
) => RestaurantInvoiceAccreditingData(
  totalExpectedCash: (json['totalExpectedCash'] as num).toDouble(),
  totalOfInvoices: (json['totalOfInvoices'] as num).toDouble(),
  totalCredit: (json['totalCredit'] as num).toDouble(),
  totalCash: (json['totalCash'] as num).toDouble(),
  totalOther: (json['totalOther'] as num).toDouble(),
  totalOfReturns: (json['totalOfReturns'] as num).toDouble(),
  deliveryMen: (json['deliveryMen'] as num).toDouble(),
  deliveryCompanies: (json['deliveryCompanies'] as num).toDouble(),
);

Map<String, dynamic> _$RestaurantInvoiceAccreditingDataToJson(
  RestaurantInvoiceAccreditingData instance,
) => <String, dynamic>{
  'totalExpectedCash': instance.totalExpectedCash,
  'totalOfInvoices': instance.totalOfInvoices,
  'totalCredit': instance.totalCredit,
  'totalCash': instance.totalCash,
  'totalOther': instance.totalOther,
  'totalOfReturns': instance.totalOfReturns,
  'deliveryMen': instance.deliveryMen,
  'deliveryCompanies': instance.deliveryCompanies,
};
