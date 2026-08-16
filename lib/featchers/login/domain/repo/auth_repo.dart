import '../../../../core/service/api_result.dart';
import '../../../../core/shared/model/base_response.dart';
import '../../data/models/login_data.dart';
import '../../data/models/login_request_body.dart';

abstract class AuthRepo {
  AuthRepo();
  Future<ApiResult<BaseResponse<LoginData?>>> login(LoginRequest request);
}
