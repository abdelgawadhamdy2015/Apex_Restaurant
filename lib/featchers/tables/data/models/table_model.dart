import '../../../pos/data/enums/table_status.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/table_entity.dart';

part 'table_model.g.dart';

@JsonSerializable()
class TableModel extends TableEntity {
  const TableModel({
    super.id,
    super.code,
    super.arabicName,
    super.latinName,
    super.notes,
    super.status,
    super.seatNumbers,
    super.tableTypeID,
    super.tableTypeNameAr,
    super.tableTypeNameEn,
    super.floorID,
    super.floorNameAr,
    super.floorNameEn,
    super.uTime,
    super.serviceRatio,
    super.canDelete,
    super.canEdit,
    super.xloc,
    super.yloc,
    super.isReserved,
    super.bookingTableInvoiceId,
  });

  factory TableModel.fromJson(Map<String, dynamic> json) =>
      _$TableModelFromJson(json);

  Map<String, dynamic> toJson() => _$TableModelToJson(this);

  TableEntity toEntity() {
    return TableEntity(
      id: id,
      code: code,
      arabicName: arabicName,
      latinName: latinName,
      notes: notes,
      status: status,
      seatNumbers: seatNumbers,
      tableTypeID: tableTypeID,
      tableTypeNameAr: tableTypeNameAr,
      tableTypeNameEn: tableTypeNameEn,
      floorID: floorID,
      floorNameAr: floorNameAr,
      floorNameEn: floorNameEn,
      uTime: uTime,
      serviceRatio: serviceRatio,
      canDelete: canDelete,
      canEdit: canEdit,
      xloc: xloc,
      yloc: yloc,
      isReserved: isReserved,
      bookingTableInvoiceId: bookingTableInvoiceId,
    );
  }
}
