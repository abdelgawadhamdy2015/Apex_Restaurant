// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserDataModel _$UserDataModelFromJson(Map<String, dynamic> json) =>
    UserDataModel(
      id: (json['id'] as num?)?.toInt(),
      username: json['username'] as String?,
      password: json['password'] as String?,
      email: json['email'] as String?,
      isActive: json['isActive'] as bool?,
      aMdeactiveForYearAccrediting:
          json['aMdeactiveForYearAccrediting'] as bool?,
      employeesId: (json['employeesId'] as num?)?.toInt(),
      permissionListId: (json['permissionListId'] as num?)?.toInt(),
      fcmToken: json['fcmToken'] as String?,
      languageID: (json['languageID'] as num?)?.toInt(),
      otherSettings: (json['otherSettings'] as List<dynamic>?)
          ?.map((e) => OtherSettingsModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      employees: json['employees'] == null
          ? null
          : EmployeeModel.fromJson(json['employees'] as Map<String, dynamic>),
      updateTime: json['updateTime'] as String?,
    );

Map<String, dynamic> _$UserDataModelToJson(UserDataModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'password': instance.password,
      'email': instance.email,
      'isActive': instance.isActive,
      'aMdeactiveForYearAccrediting': instance.aMdeactiveForYearAccrediting,
      'employeesId': instance.employeesId,
      'permissionListId': instance.permissionListId,
      'fcmToken': instance.fcmToken,
      'languageID': instance.languageID,
      'otherSettings': instance.otherSettings,
      'employees': instance.employees,
      'updateTime': instance.updateTime,
    };
