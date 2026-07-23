import 'package:apex_restaurant/featchers/pos/data/enums/table_status.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/table_entity.dart';

part 'table_model.g.dart';

@JsonSerializable()
class TableModel extends TableEntity {
  const TableModel({
    required super.id,
    required super.code,
    required super.arabicName,
    required super.latinName,
    super.notes,
    required super.status,
    required super.seatNumbers,
    required super.tableTypeID,
    required super.tableTypeNameAr,
    required super.tableTypeNameEn,
    required super.floorID,
    required super.floorNameAr,
    required super.floorNameEn,
    required super.serviceRatio,
    required super.xloc,
    required super.yloc,
    required super.isReserved,
  });

  factory TableModel.fromJson(Map<String, dynamic> json) =>
      _$TableModelFromJson(json);
  Map<String, dynamic> toJson() => _$TableModelToJson(this);
}
