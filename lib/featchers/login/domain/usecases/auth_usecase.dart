import '../../../../core/service/api_result.dart';
import '../../../../core/shared/model/base_response.dart';
import '../../data/models/login_data.dart';
import '../../data/models/login_request_body.dart';
import '../repo/auth_repo.dart';

class LoginUsecase {
  final AuthRepo repo;
  LoginUsecase(this.repo);

  Future<ApiResult<BaseResponse<LoginData?>>> call(LoginRequest request) =>
      repo.login(request);
}
