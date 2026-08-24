import 'package:equatable/equatable.dart';

enum ReservationStatus { pending, confirmed, cancelled }

class ReservationEntity extends Equatable {
  final String id;
  final String tableNumber;
  final String customerName;
  final DateTime dateTime;
  final int seatsCount;
  final int durationMinutes;
  final ReservationStatus status;
  final String? notes;

  const ReservationEntity({
    required this.id,
    required this.tableNumber,
    required this.customerName,
    required this.dateTime,
    required this.seatsCount,
    required this.durationMinutes,
    required this.status,
    this.notes,
  });

  @override
  List<Object?> get props => [
    id,
    tableNumber,
    customerName,
    dateTime,
    seatsCount,
    durationMinutes,
    status,
    notes,
  ];
}
