import 'package:json_annotation/json_annotation.dart';

part 'restaurant_invoice_accrediting_data.g.dart';

@JsonSerializable()
class RestaurantInvoiceAccreditingData {
  final double totalExpectedCash;
  final double totalOfInvoices;
  final double totalCredit;
  final double totalCash;
  final double totalOther;
  final double totalOfReturns;
  final double deliveryMen;
  final double deliveryCompanies;

  const RestaurantInvoiceAccreditingData({
    required this.totalExpectedCash,
    required this.totalOfInvoices,
    required this.totalCredit,
    required this.totalCash,
    required this.totalOther,
    required this.totalOfReturns,
    required this.deliveryMen,
    required this.deliveryCompanies,
  });

  factory RestaurantInvoiceAccreditingData.fromJson(
    Map<String, dynamic> json,
  ) => _$RestaurantInvoiceAccreditingDataFromJson(json);

  Map<String, dynamic> toJson() =>
      _$RestaurantInvoiceAccreditingDataToJson(this);
}
