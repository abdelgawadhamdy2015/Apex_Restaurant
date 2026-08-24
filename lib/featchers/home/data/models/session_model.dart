import 'package:freezed_annotation/freezed_annotation.dart';
part 'session_model.g.dart';

@JsonSerializable()
class SessionModel {
  final int id;
  final int? openingbalance;
  final DateTime? openedAt;
  SessionModel(this.id, {this.openingbalance, this.openedAt});

  factory SessionModel.fromJson(Map<String, dynamic> json) =>
      _$SessionModelFromJson(json);

  Map<String, dynamic> toJson() => _$SessionModelToJson(this);
}
