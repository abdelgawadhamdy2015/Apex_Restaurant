import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:apex_restaurant/featchers/tables/domain/entities/reservation_entity.dart';

part 'reservation_model.g.dart';

@JsonSerializable()
class ReservationModel {
  final String? id;
  final String? tableId;
  @JsonKey(name: 'tableName_ar')
  final String? tableNameAr;
  @JsonKey(name: 'tableName_en')
  final String? tableNameEn;
  final String? date;
  final String? time;
  final String? customerId;
  @JsonKey(name: 'customerName_ar')
  final String? customerNameAr;
  @JsonKey(name: 'customerName_en')
  final String? customerNameEn;
  final int? seatsCount;
  final int? duration;
  final int? statusCode;
  @JsonKey(name: 'statusName_ar')
  final String? statusNameAr;
  @JsonKey(name: 'statusName_en')
  final String? statusNameEn;
  final bool? canEdit;
  final bool? canCancel;
  final String? notes;

  const ReservationModel({
    this.id,
    this.tableId,
    this.tableNameAr,
    this.tableNameEn,
    this.date,
    this.time,
    this.customerId,
    this.customerNameAr,
    this.customerNameEn,
    this.seatsCount,
    this.duration,
    this.statusCode,
    this.statusNameAr,
    this.statusNameEn,
    this.canEdit,
    this.canCancel,
    this.notes,
  });

  factory ReservationModel.fromJson(Map<String, dynamic> json) =>
      _$ReservationModelFromJson(json);

  Map<String, dynamic> toJson() => _$ReservationModelToJson(this);

  /// Map Data Model -> Domain Entity
  ReservationEntity toEntity({String locale = 'en'}) {
    final isAr = locale.startsWith('ar');

    // Parse DateTime safely from 'date' field
    DateTime parsedDate = DateTime.now();
    if (date != null) {
      parsedDate = DateTime.tryParse(date!) ?? DateTime.now();
    }

    // Map statusCode to Domain ReservationStatus enum
    ReservationStatus mappedStatus;
    switch (statusCode) {
      case 2:
        mappedStatus = ReservationStatus.confirmed;
        break;
      case 3:
        mappedStatus = ReservationStatus.cancelled;
        break;
      case 1:
      default:
        mappedStatus = ReservationStatus.pending;
        break;
    }

    return ReservationEntity(
      id: id ?? '',
      tableNumber: (isAr ? tableNameAr : tableNameEn) ?? '',
      customerName: (isAr ? customerNameAr : customerNameEn) ?? '',
      dateTime: parsedDate,
      seatsCount: seatsCount ?? 1,
      durationHours: (duration ?? 30) ~/ 60 > 0 ? (duration! ~/ 60) : 1,
      status: mappedStatus,
      notes: notes ?? '',
    );
  }
}
