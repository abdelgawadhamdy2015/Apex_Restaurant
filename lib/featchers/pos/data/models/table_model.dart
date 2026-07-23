import 'package:apex_restaurant/featchers/pos/data/enums/table_status.dart';
import 'package:apex_restaurant/featchers/tables/domain/entities/table_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'table_model.g.dart';

@JsonSerializable()
class TableModel {
  String? tableId;
  String? arabicName;
  String? latinName;
  TableStatus? status;
  int? tableTypeId;
  String? tableTypeNameAr;
  String? tableTypeNameEn;
  bool? isReserved;
  int? locationX;
  int? locationY;

  @JsonKey(name: 'reservationCustomer_ar')
  String? reservationCustomerAr;

  @JsonKey(name: 'reservationCustomer_en')
  String? reservationCustomerEn;

  String? reservationStartTime;
  String? reservationEndTime;

  TableModel({
    this.tableId,
    this.arabicName,
    this.latinName,
    this.status,
    this.tableTypeId,
    this.tableTypeNameAr,
    this.tableTypeNameEn,
    this.isReserved,
    this.locationX,
    this.locationY,
    this.reservationCustomerAr,
    this.reservationCustomerEn,
    this.reservationStartTime,
    this.reservationEndTime,
  });

  factory TableModel.fromJson(Map<String, dynamic> json) =>
      _$TableModelFromJson(json);

  Map<String, dynamic> toJson() => _$TableModelToJson(this);

  TableEntity toEntity() {
    return TableEntity(
      id: tableId ?? '',
      code: 0,
      arabicName: arabicName ?? '',
      latinName: latinName ?? '',
      notes: null,
      status: status ?? TableStatus.available,
      seatNumbers: 0,
      tableTypeID: tableTypeId ?? 0,
      tableTypeNameAr: tableTypeNameAr ?? '',
      tableTypeNameEn: tableTypeNameEn ?? '',
      floorID: '',
      floorNameAr: '',
      floorNameEn: '',
      serviceRatio: 0.0,
      xloc: locationX?.toDouble() ?? 0.0,
      yloc: locationY?.toDouble() ?? 0.0,
      isReserved: isReserved ?? false,
    );
  }
}
