import 'package:json_annotation/json_annotation.dart';

import 'employee_model.dart';
import 'other_settings_model.dart';

part 'user_data_model.g.dart';

@JsonSerializable()
class UserDataModel {
  final int? id;
  final String? username;
  final String? password;
  final String? email;
  final bool? isActive;
  final bool? aMdeactiveForYearAccrediting;
  final int? employeesId;
  final int? permissionListId;
  final String? fcmToken;
  final int? languageID;

  final List<OtherSettingsModel>? otherSettings;
  final EmployeeModel? employees;

  final String? updateTime;

  UserDataModel({
    this.id,
    this.username,
    this.password,
    this.email,
    this.isActive,
    this.aMdeactiveForYearAccrediting,
    this.employeesId,
    this.permissionListId,
    this.fcmToken,
    this.languageID,
    this.otherSettings,
    this.employees,
    this.updateTime,
  });

  factory UserDataModel.fromJson(Map<String, dynamic> json) =>
      _$UserDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserDataModelToJson(this);
}
