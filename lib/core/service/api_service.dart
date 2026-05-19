import 'package:apex_restaurant/core/service/api_constants.dart';
import 'package:apex_restaurant/core/shared/model/base_response.dart';
import 'package:apex_restaurant/featchers/login/data/models/login_data.dart';
import 'package:apex_restaurant/featchers/login/data/models/login_request_body.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
part 'api_service.g.dart';

@RestApi(baseUrl: ApiConstants.baseUsrl)
abstract class ApiService {
  factory ApiService(Dio dio, {String baseUrl}) = _ApiService;
  @POST(ApiConstants.login)
  Future<BaseResponse<LoginData>> login(@Body() LoginRequest loginRequestBody);
}
