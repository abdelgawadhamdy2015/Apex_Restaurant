import 'package:apex_restaurant/featchers/tables/domain/entities/floor_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'floor_model.g.dart';

@JsonSerializable()
class FloorModel {
  String? id;
  int? code;
  String? arabicName;
  String? latinName;
  String? notes;
  int? status;
  int? tableCount;
  int? branchId;
  String? branchNameAr;
  String? branchNameEn;
  DateTime? uTime;
  bool? canDelete;
  bool? canEdit;

  FloorModel({
    this.id,
    this.code,
    this.arabicName,
    this.latinName,
    this.notes,
    this.status,
    this.tableCount,
    this.branchId,
    this.branchNameAr,
    this.branchNameEn,
    this.uTime,
    this.canDelete,
    this.canEdit,
  });

  factory FloorModel.fromJson(Map<String, dynamic> json) =>
      _$FloorModelFromJson(json);

  Map<String, dynamic> toJson() => _$FloorModelToJson(this);

  FloorModel copyWith({
    String? id,
    int? code,
    String? arabicName,
    String? latinName,
    String? notes,
    int? status,
    int? tableCount,
    int? branchId,
    String? branchNameAr,
    String? branchNameEn,
    DateTime? uTime,
    bool? canDelete,
    bool? canEdit,
  }) {
    return FloorModel(
      id: id ?? this.id,
      code: code ?? this.code,
      arabicName: arabicName ?? this.arabicName,
      latinName: latinName ?? this.latinName,
      notes: notes ?? this.notes,
      status: status ?? this.status,
      tableCount: tableCount ?? this.tableCount,
      branchId: branchId ?? this.branchId,
      branchNameAr: branchNameAr ?? this.branchNameAr,
      branchNameEn: branchNameEn ?? this.branchNameEn,
      uTime: uTime ?? this.uTime,
      canDelete: canDelete ?? this.canDelete,
      canEdit: canEdit ?? this.canEdit,
    );
  }

  FloorEntity toEntity() {
    return FloorEntity(
      id: id ?? '',
      code: code ?? 0,
      arabicName: arabicName ?? '',
      latinName: latinName ?? '',
      notes: notes,
      status: status ?? 0,
      tableCount: tableCount ?? 0,
      branchId: branchId ?? 0,
      branchNameAr: branchNameAr ?? '',
      branchNameEn: branchNameEn ?? '',
    );
  }
}
