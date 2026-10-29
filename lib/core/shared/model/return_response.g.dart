// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'return_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReturnResponseData _$ReturnResponseDataFromJson(Map<String, dynamic> json) =>
    ReturnResponseData(
      invoiceId: (json['invoiceId'] as num?)?.toInt(),
      invoiceCode: json['invoiceCode'] as String?,
      originalInvoiceId: (json['originalInvoiceId'] as num?)?.toInt(),
      originalInvoiceCode: json['originalInvoiceCode'] as String?,
      returnType: json['returnType'] as String?,
      itemTotal: (json['itemTotal'] as num?)?.toDouble(),
      itemDiscount: (json['itemDiscount'] as num?)?.toDouble(),
      invoiceDiscount: (json['invoiceDiscount'] as num?)?.toDouble(),
      vat: (json['vat'] as num?)?.toDouble(),
      tobaccoTax: (json['tobaccoTax'] as num?)?.toDouble(),
      serviceFee: (json['serviceFee'] as num?)?.toDouble(),
      deliveryFee: (json['deliveryFee'] as num?)?.toDouble(),
      finalTotal: (json['finalTotal'] as num?)?.toDouble(),
      voucherRate: (json['voucherRate'] as num?)?.toDouble(),
      roundNumber: (json['roundNumber'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ReturnResponseDataToJson(ReturnResponseData instance) =>
    <String, dynamic>{
      'invoiceId': instance.invoiceId,
      'invoiceCode': instance.invoiceCode,
      'originalInvoiceId': instance.originalInvoiceId,
      'originalInvoiceCode': instance.originalInvoiceCode,
      'returnType': instance.returnType,
      'itemTotal': instance.itemTotal,
      'itemDiscount': instance.itemDiscount,
      'invoiceDiscount': instance.invoiceDiscount,
      'vat': instance.vat,
      'tobaccoTax': instance.tobaccoTax,
      'serviceFee': instance.serviceFee,
      'deliveryFee': instance.deliveryFee,
      'finalTotal': instance.finalTotal,
      'voucherRate': instance.voucherRate,
      'roundNumber': instance.roundNumber,
    };

PrintResponseData _$PrintResponseDataFromJson(Map<String, dynamic> json) =>
    PrintResponseData(
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

Map<String, dynamic> _$PrintResponseDataToJson(PrintResponseData instance) =>
    <String, dynamic>{
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
