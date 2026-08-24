import 'package:freezed_annotation/freezed_annotation.dart';

part 'employee_branch.g.dart';

@JsonSerializable()
class EmployeeBranch {
  final int branchId;
  final String arabicName;
  final String latinName;
  final bool selected;

  const EmployeeBranch({
    required this.branchId,
    required this.arabicName,
    required this.latinName,
    required this.selected,
  });

  factory EmployeeBranch.fromJson(Map<String, dynamic> json) =>
      _$EmployeeBranchFromJson(json);

  Map<String, dynamic> toJson() => _$EmployeeBranchToJson(this);

  // EmployeeBranch copyWith({
  //   int? branchId,
  //   String? arabicName,
  //   String? latinName,
  //   bool? selected,
  // }) {
  //   return EmployeeBranch(
  //     branchId: branchId ?? this.branchId,
  //     arabicName: arabicName ?? this.arabicName,
  //     latinName: latinName ?? this.latinName,
  //     selected: selected ?? this.selected,
  //   );
  // }
}
