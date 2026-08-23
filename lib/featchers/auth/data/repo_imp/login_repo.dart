import '../../../../core/service/api_error_handler.dart';
import '../../../../core/service/api_result.dart';
import '../../../../core/shared/model/base_response.dart';
import '../datasource/auth_datasource.dart';
import '../../domain/repo/auth_repo.dart';
import '../models/login_request_body.dart';

import '../models/login_data.dart';

class AuthRepoImp extends AuthRepo {
  final AuthDatasource datasource;

  AuthRepoImp(this.datasource);
  @override
  Future<ApiResult<BaseResponse<LoginData?>>> login(
    LoginRequest loginRequest,
  ) async {
    try {
      final response = await datasource.login(loginRequest);
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }
}
