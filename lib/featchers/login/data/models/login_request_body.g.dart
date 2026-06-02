// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_request_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginRequest _$LoginRequestFromJson(Map<String, dynamic> json) => LoginRequest(
  username: json['username'] as String,
  password: json['password'] as String?,
  companyName: json['companyName'] as String,
  isLoginFromMobile: json['isLoginFromMobile'] as bool?,
  fcmToken: json['FCMToken'] as String?,
);

Map<String, dynamic> _$LoginRequestToJson(LoginRequest instance) =>
    <String, dynamic>{
      'username': instance.username,
      'password': instance.password,
      'companyName': instance.companyName,
      'isLoginFromMobile': instance.isLoginFromMobile,
      'FCMToken': instance.fcmToken,
    };
