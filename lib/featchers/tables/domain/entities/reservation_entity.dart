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

  ReservationEntity copyWith({
    String? id,
    String? tableNumber,
    String? tableId,
    String? customerId,
    String? customerName,
    DateTime? dateTime,
    int? seatsCount,
    int? durationMinutes,
    ReservationStatus? status,
    String? notes,
  }) {
    return ReservationEntity(
      id: id ?? this.id,
      tableNumber: tableNumber ?? this.tableNumber,
      tableId: tableId ?? this.tableId,
      customerId: customerId ?? this.customerId,
      customerName: customerName ?? this.customerName,
      dateTime: dateTime ?? this.dateTime,
      seatsCount: seatsCount ?? this.seatsCount,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      status: status ?? this.status,
      notes: notes ?? this.notes,
    );
  }

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
