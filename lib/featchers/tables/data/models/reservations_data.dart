import 'reservation_model.dart';
import '../../domain/entities/reservation_data_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'reservations_data.g.dart';

@JsonSerializable()
class ReservationsData {
  final int? allCount;
  final int? waitingCount;
  final int? confirmedCount;
  final int? canceledCount;
  final List<ReservationModel>? data;

  ReservationsData({
    this.allCount,
    this.waitingCount,
    this.confirmedCount,
    this.canceledCount,
    this.data,
  });

  factory ReservationsData.fromJson(Map<String, dynamic> json) =>
      _$ReservationsDataFromJson(json);

  Map<String, dynamic> toJson() => _$ReservationsDataToJson(this);

  ReservationsDataEntity toEntity() {
    return ReservationsDataEntity(
      allCount: allCount ?? 0,
      waitingCount: waitingCount ?? 0,
      confirmedCount: confirmedCount ?? 0,
      canceledCount: canceledCount ?? 0,
      data: data?.map((model) => model.toEntity()).toList() ?? [],
    );
  }
}
