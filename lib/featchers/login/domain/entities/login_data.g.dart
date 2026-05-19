// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginData _$LoginDataFromJson(Map<String, dynamic> json) => LoginData(
  isPeriodEnded: json['isPeriodEnded'] as bool?,
  startPeriod: json['startPeriod'] as String?,
  endPeriod: json['endPeriod'] as String?,
  apps: (json['apps'] as List<dynamic>?)
      ?.map((e) => LoginResponseApps.fromJson(e as Map<String, dynamic>))
      .toList(),
  authToken: json['authToken'] == null
      ? null
      : AuthToken.fromJson(json['authToken'] as Map<String, dynamic>),
  isHaveUpdate: json['isHaveUpdate'] as bool?,
  premissions: (json['premissions'] as List<dynamic>?)
      ?.map((e) => UserPremissions.fromJson(e as Map<String, dynamic>))
      .toList(),
  companyInfo: json['companyInfo'] == null
      ? null
      : CompanyInfo.fromJson(json['companyInfo'] as Map<String, dynamic>),
  updateNumber: (json['updateNumber'] as num?)?.toInt(),
  serverID: (json['serverID'] as num?)?.toInt(),
);

Map<String, dynamic> _$LoginDataToJson(LoginData instance) => <String, dynamic>{
  'isPeriodEnded': instance.isPeriodEnded,
  'startPeriod': instance.startPeriod,
  'endPeriod': instance.endPeriod,
  'apps': instance.apps,
  'authToken': instance.authToken,
  'isHaveUpdate': instance.isHaveUpdate,
  'premissions': instance.premissions,
  'companyInfo': instance.companyInfo,
  'updateNumber': instance.updateNumber,
  'serverID': instance.serverID,
};

LoginResponseApps _$LoginResponseAppsFromJson(Map<String, dynamic> json) =>
    LoginResponseApps(
      appNameAr: json['appNameAr'] as String?,
      appNameEn: json['appNameEn'] as String?,
      id: (json['id'] as num?)?.toInt(),
    );

Map<String, dynamic> _$LoginResponseAppsToJson(LoginResponseApps instance) =>
    <String, dynamic>{
      'appNameAr': instance.appNameAr,
      'appNameEn': instance.appNameEn,
      'id': instance.id,
    };

AuthToken _$AuthTokenFromJson(Map<String, dynamic> json) => AuthToken(
  token: json['token'] as String?,
  userInfo: json['userInfo'] == null
      ? null
      : UserInfo.fromJson(json['userInfo'] as Map<String, dynamic>),
  expiresIn: json['expiresIn'] as String?,
);

Map<String, dynamic> _$AuthTokenToJson(AuthToken instance) => <String, dynamic>{
  'token': instance.token,
  'userInfo': instance.userInfo,
  'expiresIn': instance.expiresIn,
};
