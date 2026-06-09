import 'package:apex_restaurant/core/service/api_result.dart';
import 'package:apex_restaurant/core/shared/model/base_response.dart';
import 'package:apex_restaurant/featchers/login/data/models/login_data.dart';
import 'package:apex_restaurant/featchers/login/data/models/login_request_body.dart';
import 'package:apex_restaurant/featchers/login/domain/repo/auth_repo.dart';

class LoginUsecase {
  final AuthRepo repo;
  LoginUsecase(this.repo);

  Future<ApiResult<BaseResponse<LoginData?>>> call(LoginRequest request) =>
      repo.login(request);
}
