import 'package:apex_restaurant/core/service/api_service.dart';
import 'package:apex_restaurant/core/shared/entity/base_request.dart';
import 'package:apex_restaurant/core/shared/model/base_response.dart';
import 'package:apex_restaurant/featchers/cart/data/models/apply_discount_request_model.dart';
import 'package:apex_restaurant/featchers/cart/data/models/complete_payment_request_model.dart';
import 'package:apex_restaurant/featchers/pos/domain/entities/menu_item.dart';

import '../models/delivery_agent_model.dart';
import '../models/discount_result_model.dart';
import '../models/waiter_model.dart';

/// Talks directly to `ApiService`. Throws on failure (DioException or
/// otherwise) — the repository layer is responsible for catching that and
/// converting it to an [ApiResult.failure] via [ErrorHandler].
abstract class CartRemoteDataSource {
  Future<BaseResponse<List<DeliveryAgentModel>?>> getDeliveryAgents({
    BaseRequest? request,
  });

  Future<BaseResponse<List<WaiterModel>?>> getWaiters({BaseRequest? request});

  Future<BaseResponse<DiscountResultModel?>> applyDiscount(
    ApplyDiscountRequestModel request,
  );

  Future<BaseResponse<dynamic>> holdOrder(Order order);

  Future<BaseResponse<dynamic>> completePayment(
    CompletePaymentRequestModel request,
  );
}

class CartRemoteDataSourceImpl implements CartRemoteDataSource {
  final ApiService _apiService;
  CartRemoteDataSourceImpl(this._apiService);

  @override
  Future<BaseResponse<List<DeliveryAgentModel>?>> getDeliveryAgents({
    BaseRequest? request,
  }) {
    final queryRequest = BaseRequest(
      pageNumber: request?.pageNumber ?? 1,
      pageSize: request?.pageSize ?? 50,
      name: request?.name,
    );

    return _apiService.getAllDeliveryAgents(queryRequest);
  }

  @override
  Future<BaseResponse<List<WaiterModel>?>> getWaiters({BaseRequest? request}) {
    final queryRequest = BaseRequest(
      pageNumber: request?.pageNumber ?? 1,
      pageSize: request?.pageSize ?? 50,
      name: request?.name,
    );

    return _apiService.getAllWaiters(queryRequest);
  }

  @override
  Future<BaseResponse<DiscountResultModel?>> applyDiscount(
    ApplyDiscountRequestModel request,
  ) {
    return _apiService.applyDiscountCode(request.toJson());
  }

  @override
  Future<BaseResponse<dynamic>> holdOrder(Order order) {
    return _apiService.holdOrder({
      'items': order.items
          .map((i) => {'itemId': i.menuItem.itemId, 'quantity': i.quantity})
          .toList(),
      'tableId': order.tableId,
    });
  }

  @override
  Future<BaseResponse<dynamic>> completePayment(
    CompletePaymentRequestModel request,
  ) {
    return _apiService.completePayment(request.toJson());
  }
}
