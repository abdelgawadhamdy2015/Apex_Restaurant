import 'package:json_annotation/json_annotation.dart';

part 'transactions_response.g.dart';

@JsonSerializable()
class TransactionsResponse {
  final double? totalAdds;
  final double? totalRemoves;
  final double? fund;
  final List<TransactionItem>? items;

  TransactionsResponse({
    this.totalAdds,
    this.totalRemoves,
    this.fund,
    this.items,
  });

  factory TransactionsResponse.fromJson(Map<String, dynamic> json) =>
      _$TransactionsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionsResponseToJson(this);
}

@JsonSerializable()
class TransactionItem {
  final DateTime? date;

  @JsonKey(name: 'type_ar')
  final String? typeAr;

  @JsonKey(name: 'type_en')
  final String? typeEn;

  final double? amount;
  final String? notes;

  @JsonKey(name: 'user_ar')
  final String? userAr;

  @JsonKey(name: 'user_en')
  final String? userEn;

  final int? signal;

  TransactionItem({
    this.date,
    this.typeAr,
    this.typeEn,
    this.amount,
    this.notes,
    this.userAr,
    this.userEn,
    this.signal,
  });

  factory TransactionItem.fromJson(Map<String, dynamic> json) =>
      _$TransactionItemFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionItemToJson(this);
}
