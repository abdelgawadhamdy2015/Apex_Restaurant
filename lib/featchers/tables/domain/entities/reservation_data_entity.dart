// domain/entities/reservations_data_entity.dart
import 'package:apex_restaurant/featchers/tables/domain/entities/reservation_entity.dart';
import 'package:equatable/equatable.dart';

class ReservationsDataEntity extends Equatable {
  final int? allCount;
  final int? waitingCount;
  final int? confirmedCount;
  final int? canceledCount;
  final List<ReservationEntity> data;

  const ReservationsDataEntity({
    this.allCount,
    this.waitingCount,
    this.confirmedCount,
    this.canceledCount,
    this.data = const [],
  });

  @override
  List<Object?> get props => [
    allCount,
    waitingCount,
    confirmedCount,
    canceledCount,
    data,
  ];
}
