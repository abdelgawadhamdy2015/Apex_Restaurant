import 'package:apex_restaurant/core/service/api_result.dart';
import 'package:apex_restaurant/core/shared/entity/base_request.dart';
import 'package:apex_restaurant/core/shared/model/base_response.dart';
import 'package:apex_restaurant/featchers/cart/data/models/apply_discount_request_model.dart';
import 'package:apex_restaurant/featchers/cart/data/models/client_request_model.dart';
import 'package:apex_restaurant/featchers/cart/data/models/complete_payment_request_model.dart';
import 'package:apex_restaurant/featchers/cart/data/models/delivery_agent_model.dart';
import 'package:apex_restaurant/featchers/cart/data/models/discount_result_model.dart';
import 'package:apex_restaurant/featchers/cart/data/models/get_client_request.dart';
import 'package:apex_restaurant/featchers/cart/data/models/pos_client_model.dart';
import 'package:apex_restaurant/featchers/cart/data/models/waiter_model.dart';
import 'package:apex_restaurant/featchers/cart/domain/repo/cart_repo.dart';
import 'package:apex_restaurant/featchers/pos/domain/entities/menu_item.dart';

class GetWaitersUseCase {
  final CartRepository repository;
  GetWaitersUseCase(this.repository);

  Future<ApiResult<BaseResponse<List<WaiterModel>?>>> call({
    BaseRequest? request,
  }) {
    return repository.getWaiters(request: request);
  }
}

class GetDeliveryAgentsUseCase {
  final CartRepository repository;
  GetDeliveryAgentsUseCase(this.repository);

  Future<ApiResult<BaseResponse<List<DeliveryAgentModel>?>>> call({
    BaseRequest? request,
  }) {
    return repository.getDeliveryAgents(request: request);
  }
}

class GetAllPosClientsUseCase {
  final CartRepository repository;
  GetAllPosClientsUseCase(this.repository);

  Future<ApiResult<BaseResponse<List<PosClientModel>?>>> call({
    required GetClientsRequest request,
  }) {
    return repository.getPosClients(request: request);
  }
}

class AddPosClientUseCase {
  final CartRepository repository;
  AddPosClientUseCase(this.repository);

  Future<ApiResult<BaseResponse<dynamic>>> call({
    required ClientRequestModel request,
  }) {
    return repository.addPosClient(request: request);
  }
}

class UpdatePosClientUseCase {
  final CartRepository repository;
  UpdatePosClientUseCase(this.repository);

  Future<ApiResult<BaseResponse<dynamic>>> call({
    required ClientRequestModel request,
  }) {
    return repository.updatePosClient(request: request);
  }
}

class ApplyDiscountUseCase {
  final CartRepository repository;
  ApplyDiscountUseCase(this.repository);

  Future<ApiResult<BaseResponse<DiscountResultModel?>>> call(
    ApplyDiscountRequestModel request,
  ) {
    return repository.applyDiscount(request);
  }
}

class HoldOrderUseCase {
  final CartRepository repository;
  HoldOrderUseCase(this.repository);

  Future<ApiResult<BaseResponse<dynamic>>> call(Order order) {
    return repository.holdOrder(order);
  }
}

class CompletePaymentUseCase {
  final CartRepository repository;
  CompletePaymentUseCase(this.repository);

  Future<ApiResult<BaseResponse<dynamic>>> call(
    CompletePaymentRequestModel request,
  ) {
    return repository.completePayment(request);
  }
}
