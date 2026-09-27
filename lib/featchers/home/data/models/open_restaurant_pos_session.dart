import 'package:json_annotation/json_annotation.dart';

part 'open_restaurant_pos_session.g.dart';

@JsonSerializable()
class OpenSessionRequest {
  const OpenSessionRequest({this.safeId, this.openingBalance});

  final int? safeId;
  final num? openingBalance;

  factory OpenSessionRequest.fromJson(Map<String, dynamic> json) =>
      _$OpenSessionRequestFromJson(json);

  Map<String, dynamic> toJson() => _$OpenSessionRequestToJson(this);
}
