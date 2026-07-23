import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/floor_entity.dart';
part 'floor_model.g.dart';

@JsonSerializable()
class FloorModel extends FloorEntity {
  const FloorModel({
    required super.id,
    required super.code,
    required super.arabicName,
    required super.latinName,
    super.notes,
    required super.status,
    required super.tableCount,
    required super.branchId,
    required super.branchNameAr,
    required super.branchNameEn,
  });

  factory FloorModel.fromJson(Map<String, dynamic> json) =>
      _$FloorModelFromJson(json);

  Map<String, dynamic> toJson() => _$FloorModelToJson(this);
}
