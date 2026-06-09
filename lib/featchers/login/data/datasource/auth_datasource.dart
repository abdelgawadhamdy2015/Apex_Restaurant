import 'package:apex_restaurant/core/service/api_service.dart';
import 'package:apex_restaurant/core/shared/model/base_response.dart';
import 'package:apex_restaurant/featchers/login/data/models/login_data.dart';
import 'package:apex_restaurant/featchers/login/data/models/login_request_body.dart';

abstract class AuthDatasource {
  Future<BaseResponse<LoginData?>> login(LoginRequest request);
}

class AuthDatasourceImp extends AuthDatasource {
  AuthDatasourceImp(this.service);
  final ApiService service;
  @override
  Future<BaseResponse<LoginData?>> login(LoginRequest request) async {
    return await service.login(request);
  }
}
