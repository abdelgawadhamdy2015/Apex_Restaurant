// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserInfo _$UserInfoFromJson(Map<String, dynamic> json) => UserInfo(
  userId: json['userId'] as String?,
  userName: json['userName'] as String?,
  employeesId: (json['employeesId'] as num?)?.toInt(),
  arabicName: json['arabicName'] as String?,
  latinName: json['latinName'] as String?,
  permissionNameAr: json['permissionNameAr'] as String?,
  permissionNameEn: json['permissionNameEn'] as String?,
  imageUrl: json['imageUrl'] as String?,
);

Map<String, dynamic> _$UserInfoToJson(UserInfo instance) => <String, dynamic>{
  'userId': instance.userId,
  'userName': instance.userName,
  'employeesId': instance.employeesId,
  'arabicName': instance.arabicName,
  'latinName': instance.latinName,
  'permissionNameAr': instance.permissionNameAr,
  'permissionNameEn': instance.permissionNameEn,
  'imageUrl': instance.imageUrl,
};

UserPermissions _$UserPermissionsFromJson(Map<String, dynamic> json) =>
    UserPermissions(
      id: (json['id'] as num?)?.toInt(),
      isAdd: json['isAdd'] as bool?,
      isEdit: json['isEdit'] as bool?,
      isDelete: json['isDelete'] as bool?,
      isShow: json['isShow'] as bool?,
      isPrint: json['isPrint'] as bool?,
    );

Map<String, dynamic> _$UserPermissionsToJson(UserPermissions instance) =>
    <String, dynamic>{
      'id': instance.id,
      'isAdd': instance.isAdd,
      'isEdit': instance.isEdit,
      'isDelete': instance.isDelete,
      'isShow': instance.isShow,
      'isPrint': instance.isPrint,
    };

CompanyInfo _$CompanyInfoFromJson(Map<String, dynamic> json) => CompanyInfo(
  companyNameAr: json['companyNameAr'] as String?,
  companyNameEn: json['companyNameEn'] as String?,
  subId: (json['subId'] as num?)?.toInt(),
);

Map<String, dynamic> _$CompanyInfoToJson(CompanyInfo instance) =>
    <String, dynamic>{
      'companyNameAr': instance.companyNameAr,
      'companyNameEn': instance.companyNameEn,
      'subId': instance.subId,
    };
