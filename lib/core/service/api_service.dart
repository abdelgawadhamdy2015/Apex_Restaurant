import 'package:apex_restaurant/core/service/api_constants.dart';
import 'package:apex_restaurant/core/shared/model/base_response.dart';
import 'package:apex_restaurant/featchers/home/data/models/employee_branch.dart';
import 'package:apex_restaurant/featchers/login/data/models/login_data.dart';
import 'package:apex_restaurant/featchers/login/data/models/login_request_body.dart';
import 'package:apex_restaurant/featchers/pos/data/models/floor_model.dart';
import 'package:apex_restaurant/featchers/pos/data/models/table_model.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
part 'api_service.g.dart';

@RestApi(baseUrl: ApiConstants.baseUsrl)
abstract class ApiService {
  factory ApiService(Dio dio, {String baseUrl}) = _ApiService;
  @POST(ApiConstants.login)
  Future<BaseResponse<LoginData>> login(@Body() LoginRequest loginRequestBody);

  @GET(ApiConstants.getEmployeeBranches)
  Future<BaseResponse<List<EmployeeBranch>>> getEmployeeBranches();

  @GET(ApiConstants.getAllFloors)
  Future<BaseResponse<List<FloorModel>>> getAllFloors({
    @Query("pageNumber") int? pageNumber,
    @Query("pageSize") int? pageSize,
    @Query("id") String? id,
    @Query("name") String? name,
    @Query("branchID") int? branchId,
  });

  @GET(ApiConstants.getAllFoodTables)
  Future<BaseResponse<List<TableModel>>> getAllFoodTables({
    @Query("pageNumber") int? pageNumber,
    @Query("pageSize") int? pageSize,
    @Query("id") String? id,
    @Query("name") String? name,
    @Query("floorID") String? floorID,
    @Query("forPOS") bool? forPOS,
  });
}
