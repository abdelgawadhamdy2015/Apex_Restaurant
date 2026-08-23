// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginData _$LoginDataFromJson(Map<String, dynamic> json) => LoginData(
  isPeriodEnded: json['isPeriodEnded'] as bool?,
  isGedieaActive: json['isGedieaActive'] as bool?,
  startPeriod: json['startPeriod'] == null
      ? null
      : DateTime.parse(json['startPeriod'] as String),
  endPeriod: json['endPeriod'] == null
      ? null
      : DateTime.parse(json['endPeriod'] as String),
  apps: (json['apps'] as List<dynamic>?)
      ?.map((e) => AppModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  authToken: json['authToken'] == null
      ? null
      : AuthTokenModel.fromJson(json['authToken'] as Map<String, dynamic>),
  isHaveUpdate: json['isHaveUpdate'] as bool?,
  permissions: (json['premissions'] as List<dynamic>?)
      ?.map((e) => PermissionGroupModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  companyInfo: json['companyInfo'] == null
      ? null
      : CompanyInfoModel.fromJson(json['companyInfo'] as Map<String, dynamic>),
  updateNumber: (json['updateNumber'] as num?)?.toInt(),
  serverID: (json['serverID'] as num?)?.toInt(),
  maxPosCode: (json['maxPosCode'] as num?)?.toInt(),
  maxReturnPosCode: (json['maxReturnPosCode'] as num?)?.toInt(),
  forcedMessagesAr: json['forcedMessagesAr'] as List<dynamic>?,
  forcedMessagesEn: json['forcedMessagesEn'] as List<dynamic>?,
  isRestaurant: json['isRestaurant'] as bool?,
);

Map<String, dynamic> _$LoginDataToJson(LoginData instance) => <String, dynamic>{
  'isPeriodEnded': instance.isPeriodEnded,
  'isGedieaActive': instance.isGedieaActive,
  'startPeriod': instance.startPeriod?.toIso8601String(),
  'endPeriod': instance.endPeriod?.toIso8601String(),
  'apps': instance.apps,
  'authToken': instance.authToken,
  'isHaveUpdate': instance.isHaveUpdate,
  'premissions': instance.permissions,
  'companyInfo': instance.companyInfo,
  'updateNumber': instance.updateNumber,
  'serverID': instance.serverID,
  'maxPosCode': instance.maxPosCode,
  'maxReturnPosCode': instance.maxReturnPosCode,
  'forcedMessagesAr': instance.forcedMessagesAr,
  'forcedMessagesEn': instance.forcedMessagesEn,
  'isRestaurant': instance.isRestaurant,
};

AppModel _$AppModelFromJson(Map<String, dynamic> json) => AppModel(
  appNameAr: json['appNameAr'] as String?,
  appNameEn: json['appNameEn'] as String?,
  id: (json['id'] as num?)?.toInt(),
);

Map<String, dynamic> _$AppModelToJson(AppModel instance) => <String, dynamic>{
  'appNameAr': instance.appNameAr,
  'appNameEn': instance.appNameEn,
  'id': instance.id,
};

AuthTokenModel _$AuthTokenModelFromJson(Map<String, dynamic> json) =>
    AuthTokenModel(
      token: json['token'] as String?,
      userInfo: json['userInfo'] == null
          ? null
          : LoginUserData.fromJson(json['userInfo'] as Map<String, dynamic>),
      allowedModule: json['allowedModule'] as List<dynamic>?,
      allowedForms: json['allowedForms'] as List<dynamic>?,
      expiresInn: json['expiresInn'] == null
          ? null
          : DateTime.parse(json['expiresInn'] as String),
    );

Map<String, dynamic> _$AuthTokenModelToJson(AuthTokenModel instance) =>
    <String, dynamic>{
      'token': instance.token,
      'userInfo': instance.userInfo?.toJson(),
      'allowedModule': instance.allowedModule,
      'allowedForms': instance.allowedForms,
      'expiresInn': instance.expiresInn?.toIso8601String(),
    };

LoginUserData _$LoginUserDataFromJson(Map<String, dynamic> json) =>
    LoginUserData(
      userId: json['userId'] as String?,
      employeesId: (json['employeesId'] as num?)?.toInt(),
      userName: json['userName'] as String?,
      arabicName: json['arabicName'] as String?,
      latinName: json['latinName'] as String?,
      permissionNameAr: json['permissionNameAr'] as String?,
      permissionNameEn: json['permissionNameEn'] as String?,
      imageUrl: json['imageUrl'] as String?,
    );

Map<String, dynamic> _$LoginUserDataToJson(LoginUserData instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'employeesId': instance.employeesId,
      'userName': instance.userName,
      'arabicName': instance.arabicName,
      'latinName': instance.latinName,
      'permissionNameAr': instance.permissionNameAr,
      'permissionNameEn': instance.permissionNameEn,
      'imageUrl': instance.imageUrl,
    };

PermissionGroupModel _$PermissionGroupModelFromJson(
  Map<String, dynamic> json,
) => PermissionGroupModel(
  mainFormCode: (json['mainFormCode'] as num?)?.toInt(),
  arabicName: json['arabicName'] as String?,
  latinName: json['latinName'] as String?,
  subPermissions: (json['subPermissions'] as List<dynamic>?)
      ?.map((e) => SubPermissionModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$PermissionGroupModelToJson(
  PermissionGroupModel instance,
) => <String, dynamic>{
  'mainFormCode': instance.mainFormCode,
  'arabicName': instance.arabicName,
  'latinName': instance.latinName,
  'subPermissions': instance.subPermissions?.map((e) => e.toJson()).toList(),
};

SubPermissionModel _$SubPermissionModelFromJson(Map<String, dynamic> json) =>
    SubPermissionModel(
      mainFormCode: (json['mainFormCode'] as num?)?.toInt(),
      subFormCode: (json['subFormCode'] as num?)?.toInt(),
      arabicName: json['arabicName'] as String?,
      latinName: json['latinName'] as String?,
      isAdd: json['isAdd'] as bool?,
      isEdit: json['isEdit'] as bool?,
      isDelete: json['isDelete'] as bool?,
      isShow: json['isShow'] as bool?,
      isPrint: json['isPrint'] as bool?,
    );

Map<String, dynamic> _$SubPermissionModelToJson(SubPermissionModel instance) =>
    <String, dynamic>{
      'mainFormCode': instance.mainFormCode,
      'subFormCode': instance.subFormCode,
      'arabicName': instance.arabicName,
      'latinName': instance.latinName,
      'isAdd': instance.isAdd,
      'isEdit': instance.isEdit,
      'isDelete': instance.isDelete,
      'isShow': instance.isShow,
      'isPrint': instance.isPrint,
    };

CompanyInfoModel _$CompanyInfoModelFromJson(Map<String, dynamic> json) =>
    CompanyInfoModel(
      companyNameAr: json['companyNameAr'] as String?,
      companyNameEn: json['companyNameEn'] as String?,
      subId: (json['subId'] as num?)?.toInt(),
    );

Map<String, dynamic> _$CompanyInfoModelToJson(CompanyInfoModel instance) =>
    <String, dynamic>{
      'companyNameAr': instance.companyNameAr,
      'companyNameEn': instance.companyNameEn,
      'subId': instance.subId,
    };
