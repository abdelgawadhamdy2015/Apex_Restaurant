import 'package:freezed_annotation/freezed_annotation.dart';

part 'success_response_model.g.dart';

@JsonSerializable()
class SuccessResponseModel {
  final String? invoiceCode;
  final PrintingChequeModel? printingCheque;

  const SuccessResponseModel({this.invoiceCode, this.printingCheque});

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
