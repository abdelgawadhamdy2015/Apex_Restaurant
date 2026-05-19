import 'package:json_annotation/json_annotation.dart';
part 'login_request_body.g.dart';

@JsonSerializable()
class LoginRequest {
  final String username;
  final String? password;
  final String companyName;
  final bool? isLoginFromMobile;
  @JsonKey(name: 'FCMToken')
  final String? fcmToken;

  LoginRequest(
      {required this.username,
      this.password,
      required this.companyName,
      required this.isLoginFromMobile,
      this.fcmToken});
  Map<String, dynamic> toJson() => _$LoginRequestToJson(this);
}
