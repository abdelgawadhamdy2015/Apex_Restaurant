import 'package:json_annotation/json_annotation.dart';

import 'user_info.dart';

part 'login_data.g.dart';

@JsonSerializable()
class LoginData {
  bool? isPeriodEnded;
  String? startPeriod;
  String? endPeriod;
  List<LoginResponseApps>? apps;
  AuthToken? authToken;
  bool? isHaveUpdate;
  List<UserPremissions>? premissions;
  CompanyInfo? companyInfo;
  int? updateNumber;
  int? serverID;

  LoginData(
      {this.isPeriodEnded,
      this.startPeriod,
      this.endPeriod,
      this.apps,
      this.authToken,
      this.isHaveUpdate,
      this.premissions,
      this.companyInfo,
      this.updateNumber,
      this.serverID});

  factory LoginData.fromJson(Map<String, dynamic> json) =>
      _$LoginDataFromJson(json);

  Map<String, dynamic> toJson() => _$LoginDataToJson(this);
}

@JsonSerializable()
class LoginResponseApps {
  String? appNameAr;
  String? appNameEn;
  int? id;

  LoginResponseApps({this.appNameAr, this.appNameEn, this.id});
  factory LoginResponseApps.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseAppsFromJson(json);
  Map<String, dynamic> toJson() => _$LoginResponseAppsToJson(this);
}

@JsonSerializable()
class AuthToken {
  String? token;
  UserInfo? userInfo;
  String? expiresIn;

  AuthToken({this.token, this.userInfo, this.expiresIn});
  factory AuthToken.fromJson(Map<String, dynamic> json) =>
      _$AuthTokenFromJson(json);

  Map<String, dynamic> toJson() => _$AuthTokenToJson(this);
}
