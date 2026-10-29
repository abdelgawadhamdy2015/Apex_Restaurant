import 'package:json_annotation/json_annotation.dart';

part 'print_kitchen_request.g.dart';

@JsonSerializable(includeIfNull: false)
class PrintKitchenRequest {
  @JsonKey(name: 'InvoiceID')
  final int invoiceId;

  @JsonKey(name: 'PrintAll')
  final bool? printAll;

  @JsonKey(name: 'arabic')
  final bool? arabic;

  @JsonKey(name: 'printingToolTocken')
  final String? printingToolTocken;

  const PrintKitchenRequest({
    required this.invoiceId,
    this.printAll = true,
    this.arabic = true,
    this.printingToolTocken,
  });

  factory PrintKitchenRequest.fromJson(Map<String, dynamic> json) =>
      _$PrintKitchenRequestFromJson(json);

  Map<String, dynamic> toJson() => _$PrintKitchenRequestToJson(this);
}
