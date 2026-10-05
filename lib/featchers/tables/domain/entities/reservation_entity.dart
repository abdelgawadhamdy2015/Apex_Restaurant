import 'package:equatable/equatable.dart';

enum ReservationStatus { pending, confirmed, cancelled }

class ReservationEntity extends Equatable {
  final String id;
  final String tableNumber;
  final String tableId;
  final String customerId;
  final String customerName;
  final DateTime dateTime;
  final int seatsCount;
  final int durationMinutes;
  final ReservationStatus status;
  final String? notes;

  const ReservationEntity({
    required this.id,
    required this.tableNumber,
    required this.tableId,
    required this.customerId,
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
    tableId,
    customerName,
    customerId,
    dateTime,
    seatsCount,
    durationMinutes,
    status,
    notes,
  ];
}
