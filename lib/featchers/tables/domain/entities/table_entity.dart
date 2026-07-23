import 'package:apex_restaurant/featchers/pos/data/enums/table_status.dart';

class TableEntity {
  final String id;
  final int code;
  final String arabicName;
  final String latinName;
  final String? notes;
  final TableStatus status;
  final int seatNumbers;
  final int tableTypeID;
  final String tableTypeNameAr;
  final String tableTypeNameEn;
  final String floorID;
  final String floorNameAr;
  final String floorNameEn;
  final double serviceRatio;
  final double xloc;
  final double yloc;
  final bool isReserved;

  const TableEntity({
    required this.id,
    required this.code,
    required this.arabicName,
    required this.latinName,
    this.notes,
    required this.status,
    required this.seatNumbers,
    required this.tableTypeID,
    required this.tableTypeNameAr,
    required this.tableTypeNameEn,
    required this.floorID,
    required this.floorNameAr,
    required this.floorNameEn,
    required this.serviceRatio,
    required this.xloc,
    required this.yloc,
    required this.isReserved,
  });
}
