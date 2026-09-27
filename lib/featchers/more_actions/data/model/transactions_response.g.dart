// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transactions_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionsResponse _$TransactionsResponseFromJson(
  Map<String, dynamic> json,
) => TransactionsResponse(
  totalAdds: (json['totalAdds'] as num?)?.toDouble(),
  totalRemoves: (json['totalRemoves'] as num?)?.toDouble(),
  fund: (json['fund'] as num?)?.toDouble(),
  items: (json['items'] as List<dynamic>?)
      ?.map((e) => TransactionItem.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$TransactionsResponseToJson(
  TransactionsResponse instance,
) => <String, dynamic>{
  'totalAdds': instance.totalAdds,
  'totalRemoves': instance.totalRemoves,
  'fund': instance.fund,
  'items': instance.items,
};

TransactionItem _$TransactionItemFromJson(Map<String, dynamic> json) =>
    TransactionItem(
      date: json['date'] == null
          ? null
          : DateTime.parse(json['date'] as String),
      typeAr: json['type_ar'] as String?,
      typeEn: json['type_en'] as String?,
      amount: (json['amount'] as num?)?.toDouble(),
      notes: json['notes'] as String?,
      userAr: json['user_ar'] as String?,
      userEn: json['user_en'] as String?,
      signal: (json['signal'] as num?)?.toInt(),
    );

Map<String, dynamic> _$TransactionItemToJson(TransactionItem instance) =>
    <String, dynamic>{
      'date': instance.date?.toIso8601String(),
      'type_ar': instance.typeAr,
      'type_en': instance.typeEn,
      'amount': instance.amount,
      'notes': instance.notes,
      'user_ar': instance.userAr,
      'user_en': instance.userEn,
      'signal': instance.signal,
    };
