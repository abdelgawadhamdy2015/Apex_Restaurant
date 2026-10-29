import 'package:json_annotation/json_annotation.dart';

part 'print_kitchen_response.g.dart';

@JsonSerializable()
class PrintKitchenResponse {
  final dynamic unixTime;
  final List<PrintKitchenFile> files;

  const PrintKitchenResponse({this.unixTime, this.files = const []});

  factory PrintKitchenResponse.fromJson(Map<String, dynamic> json) =>
      _$PrintKitchenResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PrintKitchenResponseToJson(this);
}

@JsonSerializable()
class PrintKitchenFile {
  @JsonKey(name: 'printerID')
  final int? printerId;

  @JsonKey(name: 'printerName_ar')
  final String? printerNameAr;

  @JsonKey(name: 'printerName_en')
  final String? printerNameEn;

  @JsonKey(name: 'printerIP')
  final String? printerIp;

  @JsonKey(name: 'printingFilePath')
  final String? printingFilePath;

  @JsonKey(name: 'error_ar')
  final String? errorAr;

  @JsonKey(name: 'error_en')
  final String? errorEn;

  @JsonKey(name: 'fileGenerated')
  final bool? fileGenerated;

  @JsonKey(name: 'kitchenID')
  final int? kitchenId;

  const PrintKitchenFile({
    this.printerId,
    this.printerNameAr,
    this.printerNameEn,
    this.printerIp,
    this.printingFilePath,
    this.errorAr,
    this.errorEn,
    this.fileGenerated,
    this.kitchenId,
  });

  factory PrintKitchenFile.fromJson(Map<String, dynamic> json) =>
      _$PrintKitchenFileFromJson(json);

  Map<String, dynamic> toJson() => _$PrintKitchenFileToJson(this);
}
