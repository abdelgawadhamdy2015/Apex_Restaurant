import '../../../../core/service/api_result.dart';
import '../../../../core/shared/entity/base_request.dart';
import '../../../../core/shared/model/base_response.dart';
import '../../data/models/apply_discount_request_model.dart';
import '../../data/models/client_request_model.dart';
import '../../data/models/dynamic_discount.dart';
import '../../data/models/get_client_request.dart';
import '../../data/models/invoice_request.dart';
import '../../data/models/pos_client_model.dart';

import '../../data/models/discount_result_model.dart';
import '../../data/models/waiter_model.dart';

abstract class CartRepository {
  Future<ApiResult<BaseResponse<List<WaiterModel>?>>> getDeliveryAgents({
    BaseRequest? request,
  });

  Future<ApiResult<BaseResponse<List<WaiterModel>?>>> getWaiters({
    BaseRequest? request,
  });

  Future<ApiResult<BaseResponse<DiscountResultModel?>>> applyDiscount(
    ApplyDiscountRequestModel request,
  );

  Future<ApiResult<BaseResponse<dynamic>>> savePendingRestaurantPosInvoice(
    SaveRestaurantPosInvoiceRequest request,
  );

  Future<ApiResult<BaseResponse<dynamic>>> saveBookingTableRestaurantPosInvoice(
    SaveRestaurantPosInvoiceRequest request,
  );
  Future<ApiResult<BaseResponse<List<PosClientModel>?>>> getPosClients({
    required GetClientsRequest request,
  });

  Future<ApiResult<BaseResponse<dynamic>>> addPosClient({
    required ClientRequestModel request,
  });
  Future<ApiResult<BaseResponse<dynamic>>> updatePosClient({
    required ClientRequestModel request,
  });
  Future<ApiResult<BaseResponse<List<DynamicDiscountModel>?>>>
  getDynamicInvoiceDiscount();
}
