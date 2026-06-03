import 'package:json_annotation/json_annotation.dart';

part 'login_data.g.dart';

@JsonSerializable()
class LoginData {
  final bool? isPeriodEnded;
  final bool? isGedieaActive;
  final DateTime? startPeriod;
  final DateTime? endPeriod;

  final List<AppModel>? apps;

  final AuthTokenModel? authToken;

  final bool? isHaveUpdate;

  @JsonKey(name: 'premissions')
  final List<PermissionGroupModel>? permissions;

  final CompanyInfoModel? companyInfo;

  final int? updateNumber;
  final int? serverID;

  final int? maxPosCode;
  final int? maxReturnPosCode;
  @JsonValue("forcedMessages_ar")
  final List<dynamic>? forcedMessagesAr;
  @JsonValue("forcedMessages_en")
  final List<dynamic>? forcedMessagesEn;

  final bool? isRestaurant;

  const LoginData({
    this.isPeriodEnded,
    this.isGedieaActive,
    this.startPeriod,
    this.endPeriod,
    this.apps,
    this.authToken,
    this.isHaveUpdate,
    this.permissions,
    this.companyInfo,
    this.updateNumber,
    this.serverID,
    this.maxPosCode,
    this.maxReturnPosCode,
    this.forcedMessagesAr,
    this.forcedMessagesEn,
    this.isRestaurant,
  });

  factory LoginData.fromJson(Map<String, dynamic> json) =>
      _$LoginDataFromJson(json);

  Map<String, dynamic> toJson() => _$LoginDataToJson(this);
}

@JsonSerializable()
class AppModel {
  final String? appNameAr;
  final String? appNameEn;
  final int? id;

  const AppModel({this.appNameAr, this.appNameEn, this.id});

  factory AppModel.fromJson(Map<String, dynamic> json) =>
      _$AppModelFromJson(json);

  Map<String, dynamic> toJson() => _$AppModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class AuthTokenModel {
  final String? token;
  final UserInfoModel? userInfo;

  final List<dynamic>? allowedModule;
  final List<dynamic>? allowedForms;
  @JsonValue("expires_in")
  final DateTime? expiresInn;

  const AuthTokenModel({
    this.token,
    this.userInfo,
    this.allowedModule,
    this.allowedForms,
    this.expiresInn,
  });

  factory AuthTokenModel.fromJson(Map<String, dynamic> json) =>
      _$AuthTokenModelFromJson(json);

  Map<String, dynamic> toJson() => _$AuthTokenModelToJson(this);
}

@JsonSerializable()
class UserInfoModel {
  final String? userId;
  final int? employeesId;
  final String? userName;

  final String? arabicName;
  final String? latinName;

  final String? permissionNameAr;
  final String? permissionNameEn;

  final String? imageUrl;

  const UserInfoModel({
    this.userId,
    this.employeesId,
    this.userName,
    this.arabicName,
    this.latinName,
    this.permissionNameAr,
    this.permissionNameEn,
    this.imageUrl,
  });

  factory UserInfoModel.fromJson(Map<String, dynamic> json) =>
      _$UserInfoModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserInfoModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class PermissionGroupModel {
  final int? mainFormCode;

  final String? arabicName;
  final String? latinName;

  final List<SubPermissionModel>? subPermissions;

  const PermissionGroupModel({
    this.mainFormCode,
    this.arabicName,
    this.latinName,
    this.subPermissions,
  });

  factory PermissionGroupModel.fromJson(Map<String, dynamic> json) =>
      _$PermissionGroupModelFromJson(json);

  Map<String, dynamic> toJson() => _$PermissionGroupModelToJson(this);
}

@JsonSerializable()
class SubPermissionModel {
  final int? mainFormCode;
  final int? subFormCode;

  final String? arabicName;
  final String? latinName;

  final bool? isAdd;
  final bool? isEdit;
  final bool? isDelete;
  final bool? isShow;
  final bool? isPrint;

  const SubPermissionModel({
    this.mainFormCode,
    this.subFormCode,
    this.arabicName,
    this.latinName,
    this.isAdd,
    this.isEdit,
    this.isDelete,
    this.isShow,
    this.isPrint,
  });

  factory SubPermissionModel.fromJson(Map<String, dynamic> json) =>
      _$SubPermissionModelFromJson(json);

  Map<String, dynamic> toJson() => _$SubPermissionModelToJson(this);
}

@JsonSerializable()
class CompanyInfoModel {
  final String? companyNameAr;
  final String? companyNameEn;
  final int? subId;

  const CompanyInfoModel({this.companyNameAr, this.companyNameEn, this.subId});

  factory CompanyInfoModel.fromJson(Map<String, dynamic> json) =>
      _$CompanyInfoModelFromJson(json);

  Map<String, dynamic> toJson() => _$CompanyInfoModelToJson(this);
}
