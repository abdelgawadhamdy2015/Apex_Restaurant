import 'api_constants.dart';
import '../shared/entity/base_request.dart';
import '../shared/model/base_response.dart';
import '../shared/model/settings_model.dart';
import '../../featchers/cart/data/models/discount_result_model.dart';
import '../../featchers/cart/data/models/dynamic_discount.dart';
import '../../featchers/cart/data/models/get_client_request.dart';
import '../../featchers/cart/data/models/invoice_request.dart';
import '../../featchers/cart/data/models/pos_client_model.dart';
import '../../featchers/cart/data/models/client_request_model.dart';
import '../../featchers/cart/data/models/waiter_model.dart';
import '../../featchers/home/data/models/employee_branch.dart';
import '../../featchers/home/data/models/session_model.dart';
import '../../featchers/home/data/models/user_data_model.dart';
import '../../featchers/login/data/models/login_data.dart';
import '../../featchers/login/data/models/login_request_body.dart';
import '../../featchers/orders/data/model/get_pinding_invoice.dart';
import '../../featchers/orders/data/model/get_previous_invoice_request.dart';
import '../../featchers/orders/data/model/pinding_invoice_model.dart';
import '../../featchers/orders/data/model/previous_invoice_model.dart';
import '../../featchers/orders/data/model/restored_invoice_model.dart';
import '../../featchers/payment/data/model/success_response_model.dart';
import '../../featchers/pos/data/models/category_model.dart';
import '../../featchers/pos/data/models/delivery_company.dart';
import '../../featchers/pos/data/models/floor_model.dart';
import '../../featchers/pos/data/models/restaurant_item.dart';
import '../../featchers/pos/domain/entities/get_food_additive_request.dart';
import '../../featchers/pos/domain/entities/get_items_request_model.dart';
import '../../featchers/tables/data/models/get_floor_request.dart';
import '../../featchers/tables/data/models/get_reservations_request.dart';
import '../../featchers/tables/data/models/get_table_request.dart';
import '../../featchers/tables/data/models/reservation_requests.dart';
import '../../featchers/tables/data/models/reservations_data.dart';
import '../../featchers/tables/data/models/table_model.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart' hide Headers;
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
  @GET(ApiConstants.currentPOSsession)
  Future<BaseResponse<SessionModel?>> currentPOSsession();
  @POST("${ApiConstants.closePOSSeassion}/{sessionId}")
  Future<BaseResponse<void>> closeRestaurantPosSession(
    @Path("sessionId") int sessionId,
  );

  @GET(ApiConstants.getSettings)
  Future<BaseResponse<SettingsModel?>> getSettings();
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

  @GET(ApiConstants.getRestaurantItemsPOS)
  Future<BaseResponse<List<RestaurantItem>?>> getItemsByCategory(
    @Queries() GetItemsRequest request,
  );

  @GET(ApiConstants.getAllFoodAdditives)
  Future<BaseResponse<List<AdditiveModel>?>> getAllFoodAdditives(
    @Queries() GetFoodAdditivesRequest? request,
  );

  @GET(ApiConstants.getListOfWaiters)
  Future<BaseResponse<List<WaiterModel>?>> getAllWaiters(
    @Queries() BaseRequest request,
  );
  @GET(ApiConstants.getListOfDeliveryMen)
  Future<BaseResponse<List<WaiterModel>?>> getListOfDeliveryMen(
    @Queries() BaseRequest request,
  );
  @GET(ApiConstants.getAllDeliveryCompany)
  Future<BaseResponse<List<DeliveryCompanyModel>?>> getAllDeliveryCompany(
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

  @POST(ApiConstants.applyDiscountCode)
  Future<BaseResponse<DiscountResultModel?>> applyDiscountCode(
    @Body() Map<String, dynamic> body,
  );

  @POST(ApiConstants.holdOrder)
  Future<BaseResponse<dynamic>> holdOrder(@Body() Map<String, dynamic> body);

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

  @POST(ApiConstants.saveRestaurantPosInvoice)
  Future<BaseResponse<SuccessResponseModel>> saveRestaurantPosInvoice(
    @Body() SaveRestaurantPosInvoiceRequest request,
  );

  @POST(ApiConstants.savePendingRestaurantPosInvoice)
  Future<BaseResponse<dynamic>> savePendingRestaurantPosInvoice(
    @Body() SaveRestaurantPosInvoiceRequest request,
  );

  @POST(ApiConstants.saveBookingTableRestaurantPosInvoice)
  Future<BaseResponse<dynamic>> saveBookingTableRestaurantPosInvoice(
    @Body() SaveRestaurantPosInvoiceRequest request,
  );

  @GET(ApiConstants.getPendingRestaurantPosInvoiceDetails)
  Future<BaseResponse<List<PindingInvoiceModel>?>>
  getPendingRestaurantPosInvoiceDetails(
    @Queries() GetPindingInvoicesRequest? request,
  );
  @GET(ApiConstants.getPosInvoiceDataById)
  Future<BaseResponse<RestoredInvoiceModel?>> getPosInvoiceDataById(
    @Query('InvoiceId') int invoiceId,
  );

  @GET(ApiConstants.getItemById)
  Future<BaseResponse<RestoredInvoiceModel?>> getItemById(
    @Query('Id') int itemId,
  );

  @GET(ApiConstants.getRestaurantPosBookingTable)
  Future<BaseResponse<List<PindingInvoiceModel>?>> getRestaurantPosBookingTable(
    @Queries() GetPindingInvoicesRequest? request,
  );

  @POST(ApiConstants.getListPosInvoiceData)
  @Headers({
    'Content-Type': 'application/json-patch+json',
    'Accept': 'text/plain',
  })
  Future<BaseResponse<List<PreviousInvoiceModel>?>> getListPosInvoiceData(
    @Body() GetPreviousInvoiceRequest request,
  );
  @GET(ApiConstants.getDynamicInvoiceDiscounts)
  Future<BaseResponse<List<DynamicDiscountModel>?>>
  getDynamicInvoiceDiscounts();

  @DELETE(ApiConstants.deletetPendingInvoiceAndBokkingTable)
  Future<BaseResponse<UserDataModel?>> deletetPendingInvoiceAndBokkingTable(
    @Query("Id") int id,
  );
}
