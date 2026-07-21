import 'package:apex_restaurant/core/service/api_constants.dart';
import 'package:apex_restaurant/core/shared/model/base_response.dart';
import 'package:apex_restaurant/featchers/cart/data/models/delivery_agent_model.dart';
import 'package:apex_restaurant/featchers/cart/data/models/discount_result_model.dart';
import 'package:apex_restaurant/featchers/cart/data/models/waiter_model.dart';
import 'package:apex_restaurant/featchers/home/data/models/employee_branch.dart';
import 'package:apex_restaurant/featchers/home/data/models/session_model.dart';
import 'package:apex_restaurant/featchers/home/data/models/user_data_model.dart';
import 'package:apex_restaurant/featchers/login/data/models/login_data.dart';
import 'package:apex_restaurant/featchers/login/data/models/login_request_body.dart';
import 'package:apex_restaurant/featchers/payment/data/model/payment_success_model.dart';
import 'package:apex_restaurant/featchers/pos/data/models/category_model.dart';
import 'package:apex_restaurant/featchers/pos/data/models/delivery_company.dart';
import 'package:apex_restaurant/featchers/pos/data/models/floor_model.dart';
import 'package:apex_restaurant/featchers/pos/data/models/restaurant_item.dart';
import 'package:apex_restaurant/featchers/pos/data/models/table_model.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
part 'api_service.g.dart';

@RestApi(baseUrl: ApiConstants.baseUsrl)
abstract class ApiService {
  factory ApiService(Dio dio, {String baseUrl}) = _ApiService;
  @POST(ApiConstants.login)
  Future<BaseResponse<LoginData?>> login(@Body() LoginRequest loginRequestBody);
  @GET(ApiConstants.openRestaurantPos)
  Future<BaseResponse<SessionModel?>> openRestaurantPos();
  @GET(ApiConstants.openRestaurantPosSession)
  Future<BaseResponse<SessionModel?>> openRestaurantPosSession();
  @GET("${ApiConstants.getUserData}/{id}")
  Future<BaseResponse<UserDataModel?>> getUserData(@Path("id") int id);
  @GET(ApiConstants.getEmployeeBranches)
  Future<BaseResponse<List<EmployeeBranch>?>> getEmployeeBranches();

  @GET(ApiConstants.getAllCategoriesDropDown)
  Future<BaseResponse<List<CategoryModel>?>> getAllCategories();

  @GET(ApiConstants.getAllItems)
  Future<BaseResponse<List<RestaurantItem>?>> getItemsByCategory({
    @Query("pageNumber") int? pageNumber,
    @Query("pageSize") int? pageSize,
    @Query("statues") int? statues,
    @Query("name") String? name,
    @Query("CategoryId") int? categoryId,
    @Query("CompanyId") int? companyId,
    @Query("SearchKey") String? searchKey,
  });

  @GET(ApiConstants.getAllDeliveryAgents)
  Future<BaseResponse<List<DeliveryAgentModel>?>> getAllDeliveryAgents({
    @Query("pageNumber") int? pageNumber,
    @Query("pageSize") int? pageSize,
    @Query("name") String? name,
  });

  @GET(ApiConstants.getAllWaiters)
  Future<BaseResponse<List<WaiterModel>?>> getAllWaiters({
    @Query("pageNumber") int? pageNumber,
    @Query("pageSize") int? pageSize,
    @Query("name") String? name,
  });

  @POST(ApiConstants.applyDiscountCode)
  Future<BaseResponse<DiscountResultModel?>> applyDiscountCode(
    @Body() Map<String, dynamic> body,
  );

  @POST(ApiConstants.holdOrder)
  Future<BaseResponse<dynamic>> holdOrder(@Body() Map<String, dynamic> body);

  @POST(ApiConstants.completePayment)
  Future<BaseResponse<dynamic>> completePayment(
    @Body() Map<String, dynamic> body,
  );
  @GET(ApiConstants.getAllFloors)
  Future<BaseResponse<List<FloorModel>?>> getAllFloors({
    @Query("pageNumber") int? pageNumber,
    @Query("pageSize") int? pageSize,
    @Query("id") String? id,
    @Query("name") String? name,
    @Query("branchID") int? branchId,
  });

  @GET(ApiConstants.getAllFoodTables)
  Future<BaseResponse<List<TableModel>?>> getAllFoodTables({
    @Query("pageNumber") int? pageNumber,
    @Query("pageSize") int? pageSize,
    @Query("id") String? id,
    @Query("name") String? name,
    @Query("floorID") String? floorID,
    @Query("forPOS") bool? forPOS,
  });

  @GET(ApiConstants.getAllFoodAdditives)
  Future<BaseResponse<List<AdditiveModel>?>> getAllFoodAdditives({
    @Query("pageNumber") int? pageNumber,
    @Query("pageSize") int? pageSize,
    @Query("name") String? name,
    @Query("categoryID") int? categoryID,
  });

  @GET(ApiConstants.getAllDeliveryCompany)
  Future<BaseResponse<List<DeliveryCompanyModel>?>> getAllDeliveryCompany({
    @Query("pageNumber") int? pageNumber,
    @Query("pageSize") int? pageSize,
    @Query("name") String? name,
  });

  @POST("api/payments/process")
  Future<BaseResponse<PaymentSuccessModel>> processPayment(
    @Body() Map<String, dynamic> body,
  );
}
