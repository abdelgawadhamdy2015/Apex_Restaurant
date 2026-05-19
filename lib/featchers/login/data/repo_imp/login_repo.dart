import 'dart:developer';

import 'package:apex_restaurant/core/service/api_error_handler.dart';
import 'package:apex_restaurant/core/service/api_result.dart';
import 'package:apex_restaurant/core/service/api_service.dart';
import 'package:apex_restaurant/core/shared/model/base_response.dart';
import 'package:apex_restaurant/featchers/login/domain/repo/auth_repo.dart';
import 'package:apex_restaurant/featchers/login/data/models/login_request_body.dart';

import '../models/login_data.dart';

class AuthRepoImp extends AuthRepo {
  final ApiService _apiService;

  AuthRepoImp(this._apiService);
  @override
  Future<ApiResult<BaseResponse<LoginData>>> login(
    LoginRequest loginRequest,
  ) async {
    try {
      final response = await _apiService.login(loginRequest);
      return ApiResult.success(response);
    } catch (error) {
      log('Login error: $error');
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }
}
