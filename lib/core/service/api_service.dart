import 'package:apex_restaurant/core/service/api_constants.dart';
import 'package:apex_restaurant/core/shared/entity/base_request.dart';
import 'package:apex_restaurant/core/shared/model/base_response.dart';
import 'package:apex_restaurant/featchers/cart/data/models/delivery_agent_model.dart';
import 'package:apex_restaurant/featchers/cart/data/models/discount_result_model.dart';
import 'package:apex_restaurant/featchers/cart/data/models/get_client_request.dart';
import 'package:apex_restaurant/featchers/cart/data/models/pos_client_model.dart';
import 'package:apex_restaurant/featchers/cart/data/models/client_request_model.dart';
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
import 'package:apex_restaurant/featchers/pos/domain/entities/get_food_additive_request.dart';
import 'package:apex_restaurant/featchers/pos/domain/entities/get_items_request_model.dart';
import 'package:apex_restaurant/featchers/tables/data/models/get_floor_request.dart';
import 'package:apex_restaurant/featchers/tables/data/models/get_reservations_request.dart';
import 'package:apex_restaurant/featchers/tables/data/models/get_table_request.dart';
import 'package:apex_restaurant/featchers/tables/data/models/reservation_requests.dart';
import 'package:apex_restaurant/featchers/tables/data/models/reservations_data.dart';
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

  @GET(ApiConstants.getAllFloors)
  Future<BaseResponse<List<FloorModel>?>> getAllFloors(
    @Queries() GetFloorsRequest request,
  );

  @GET(ApiConstants.getAllFoodTables)
  Future<BaseResponse<List<TableModel>?>> getAllFoodTables(
    @Queries() GetTablesRequest request,
  );

  @GET(ApiConstants.getAllItems)
  Future<BaseResponse<List<RestaurantItem>?>> getItemsByCategory(
    @Queries() GetItemsRequest request,
  );

  @GET(ApiConstants.getAllFoodAdditives)
  Future<BaseResponse<List<AdditiveModel>?>> getAllFoodAdditives(
    @Queries() GetFoodAdditivesRequest request,
  );

  @GET(ApiConstants.getAllDeliveryAgents)
  Future<BaseResponse<List<DeliveryAgentModel>?>> getAllDeliveryAgents(
    @Queries() BaseRequest request,
  );

  @GET(ApiConstants.getAllWaiters)
  Future<BaseResponse<List<WaiterModel>?>> getAllWaiters(
    @Queries() BaseRequest request,
  );
  @GET(ApiConstants.getAllPersons)
  Future<BaseResponse<List<PosClientModel>?>> getAllPersons(
    @Queries() GetClientsRequest request,
  );
  @POST(ApiConstants.addPosClient)
  Future<BaseResponse<dynamic>> addPosClient(@Body() ClientRequestModel body);
  @POST(ApiConstants.updatePosClient)
  Future<BaseResponse<dynamic>> updatePosClient(
    @Body() ClientRequestModel body,
  );
  @GET(ApiConstants.getAllDeliveryCompany)
  Future<BaseResponse<List<DeliveryCompanyModel>?>> getAllDeliveryCompany(
    @Queries() BaseRequest request,
  );

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

  @GET(ApiConstants.getAllReservations)
  Future<BaseResponse<ReservationsData>> getAllReservation(
    @Queries() GetReservationRequest request,
  );
  @POST(ApiConstants.reserveFoodTable)
  Future<BaseResponse<dynamic>> reserveFoodTable(
    @Body() ReserveFoodTableRequest request,
  );

  @POST(ApiConstants.cancelReserveFoodTable)
  Future<BaseResponse<dynamic>> cancelReserveFoodTable(
    @Body() CancelReserveFoodTableRequest request,
  );

  @POST(ApiConstants.editReserveFoodTable)
  Future<BaseResponse<dynamic>> editReserveFoodTable(
    @Body() EditReserveFoodTableRequest request,
  );

  @POST("api/payments/process")
  Future<BaseResponse<PaymentSuccessModel>> processPayment(
    @Body() Map<String, dynamic> body,
  );
}
