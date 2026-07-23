import 'package:json_annotation/json_annotation.dart';

part 'reservation_requests.g.dart';

@JsonSerializable()
class ReserveFoodTableRequest {
  @JsonKey(name: 'foodTablesID')
  final String? foodTablesId;
  @JsonKey(name: 'CustomerID')
  final int? customerId;
  @JsonKey(name: 'ReservationDate')
  final String? reservationDate;
  @JsonKey(name: 'ReservationPeriod')
  final int? reservationPeriod;
  @JsonKey(name: 'SeatsCount')
  final int? seatsCount;
  @JsonKey(name: 'Notes')
  final String? notes;

  const ReserveFoodTableRequest({
    this.foodTablesId,
    this.customerId,
    this.reservationDate,
    this.reservationPeriod,
    this.seatsCount,
    this.notes,
  });

  factory ReserveFoodTableRequest.fromJson(Map<String, dynamic> json) =>
      _$ReserveFoodTableRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ReserveFoodTableRequestToJson(this);
}

@JsonSerializable()
class CancelReserveFoodTableRequest {
  @JsonKey(name: 'ReservationID')
  final String? reservationId;

  const CancelReserveFoodTableRequest({this.reservationId});

  factory CancelReserveFoodTableRequest.fromJson(Map<String, dynamic> json) =>
      _$CancelReserveFoodTableRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CancelReserveFoodTableRequestToJson(this);
}

@JsonSerializable()
class EditReserveFoodTableRequest {
  @JsonKey(name: 'foodTablesID')
  final String? foodTablesId;
  @JsonKey(name: 'CustomerID')
  final int? customerId;
  @JsonKey(name: 'ReservationDate')
  final String? reservationDate;
  @JsonKey(name: 'ReservationPeriod')
  final int? reservationPeriod;
  @JsonKey(name: 'SeatsCount')
  final int? seatsCount;
  @JsonKey(name: 'Notes')
  final String? notes;
  @JsonKey(name: 'ReservationID')
  final String? reservationId;

  const EditReserveFoodTableRequest({
    this.foodTablesId,
    this.customerId,
    this.reservationDate,
    this.reservationPeriod,
    this.seatsCount,
    this.notes,
    this.reservationId,
  });

  factory EditReserveFoodTableRequest.fromJson(Map<String, dynamic> json) =>
      _$EditReserveFoodTableRequestFromJson(json);

  Map<String, dynamic> toJson() => _$EditReserveFoodTableRequestToJson(this);
}
