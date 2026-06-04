import 'package:json_annotation/json_annotation.dart';

part 'employee_model.g.dart';

@JsonSerializable()
class EmployeeModel {
  final int? id;
  final bool? isServiceProvider;
  final int? code;
  final int? status;
  final String? arabicName;
  final String? latinName;
  final int? jobId;

  final String? image;
  final String? imagePath;
  final String? notes;

  final int? gLBranchId;
  final int? financialAccountId;

  final bool? canDelete;
  final int? userId;

  final String? uTime;

  final String? phone;
  final String? email;
  final String? address;

  final int? salesPriceId;

  final bool? activateMaobileApp;

  EmployeeModel({
    this.id,
    this.isServiceProvider,
    this.code,
    this.status,
    this.arabicName,
    this.latinName,
    this.jobId,
    this.image,
    this.imagePath,
    this.notes,
    this.gLBranchId,
    this.financialAccountId,
    this.canDelete,
    this.userId,
    this.uTime,
    this.phone,
    this.email,
    this.address,
    this.salesPriceId,
    this.activateMaobileApp,
  });

  factory EmployeeModel.fromJson(Map<String, dynamic> json) =>
      _$EmployeeModelFromJson(json);

  Map<String, dynamic> toJson() => _$EmployeeModelToJson(this);
}
