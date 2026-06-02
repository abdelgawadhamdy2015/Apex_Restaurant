// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee_branch.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EmployeeBranch _$EmployeeBranchFromJson(Map<String, dynamic> json) =>
    EmployeeBranch(
      branchId: (json['branchId'] as num).toInt(),
      arabicName: json['arabicName'] as String,
      latinName: json['latinName'] as String,
      selected: json['selected'] as bool,
    );

Map<String, dynamic> _$EmployeeBranchToJson(EmployeeBranch instance) =>
    <String, dynamic>{
      'branchId': instance.branchId,
      'arabicName': instance.arabicName,
      'latinName': instance.latinName,
      'selected': instance.selected,
    };
