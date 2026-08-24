import '../../../pos/data/enums/table_status.dart';

class TableEntity {
  final String? id;
  final int? code;
  final String? arabicName;
  final String? latinName;
  final String? notes;
  final TableStatus? status;
  final int? seatNumbers;
  final int? tableTypeID;
  final String? tableTypeNameAr;
  final String? tableTypeNameEn;
  final String? floorID;
  final String? floorNameAr;
  final String? floorNameEn;
  final DateTime? uTime;
  final double? serviceRatio;
  final bool? canDelete;
  final bool? canEdit;
  final double? xloc;
  final double? yloc;
  final bool? isReserved;

  const TableEntity({
    this.id,
    this.code,
    this.arabicName,
    this.latinName,
    this.notes,
    this.status,
    this.seatNumbers,
    this.tableTypeID,
    this.tableTypeNameAr,
    this.tableTypeNameEn,
    this.floorID,
    this.floorNameAr,
    this.floorNameEn,
    this.uTime,
    this.serviceRatio,
    this.canDelete,
    this.canEdit,
    this.xloc,
    this.yloc,
    this.isReserved,
  });
}
