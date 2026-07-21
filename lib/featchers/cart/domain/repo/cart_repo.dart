import 'package:apex_restaurant/core/service/api_result.dart';
import 'package:apex_restaurant/core/shared/entity/base_request.dart';
import 'package:apex_restaurant/core/shared/model/base_response.dart';
import 'package:apex_restaurant/featchers/cart/data/models/apply_discount_request_model.dart';
import 'package:apex_restaurant/featchers/cart/data/models/complete_payment_request_model.dart';
import 'package:apex_restaurant/featchers/pos/domain/entities/menu_item.dart';

import '../../data/models/delivery_agent_model.dart';
import '../../data/models/discount_result_model.dart';
import '../../data/models/waiter_model.dart';

abstract class CartRepository {
  Future<ApiResult<BaseResponse<List<DeliveryAgentModel>?>>> getDeliveryAgents({
    BaseRequest? request,
  });

  Future<ApiResult<BaseResponse<List<WaiterModel>?>>> getWaiters({
    BaseRequest? request,
  });

  Future<ApiResult<BaseResponse<DiscountResultModel?>>> applyDiscount(
    ApplyDiscountRequestModel request,
  );

  Future<ApiResult<BaseResponse<dynamic>>> holdOrder(Order order);

  Future<ApiResult<BaseResponse<dynamic>>> completePayment(
    CompletePaymentRequestModel request,
  );
}
