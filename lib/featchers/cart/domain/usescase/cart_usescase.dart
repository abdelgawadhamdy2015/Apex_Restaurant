import 'package:apex_restaurant/featchers/cart/data/models/check_voucher_request.dart';
import 'package:apex_restaurant/featchers/cart/data/models/check_voucher_response.dart';
import 'package:apex_restaurant/featchers/cart/data/models/get_delivery_companies_request.dart';
import 'package:apex_restaurant/featchers/pos/data/models/delivery_company.dart';

import '../../../../core/service/api_result.dart';
import '../../../../core/shared/entity/base_request.dart';
import '../../../../core/shared/model/base_response.dart';
import '../../data/models/apply_discount_request_model.dart';
import '../../data/models/client_request_model.dart';
import '../../data/models/discount_result_model.dart';
import '../../data/models/dynamic_discount.dart';
import '../../data/models/get_client_request.dart';
import '../../data/models/invoice_request.dart';
import '../../data/models/pos_client_model.dart';
import '../../data/models/waiter_model.dart';
import '../repo/cart_repo.dart';

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

  Future<ApiResult<BaseResponse<List<WaiterModel>?>>> call({
    BaseRequest? request,
  }) {
    return repository.getDeliveryAgents(request: request);
  }
}

class GetAllDeliveryCompanyUseCase {
  final CartRepository _repository;
  GetAllDeliveryCompanyUseCase(this._repository);
  Future<ApiResult<BaseResponse<List<DeliveryCompanyModel>?>>> call({
    GetDeliveryCompaniesRequest? request,
  }) => _repository.getAllDeliveryCompany(request: request);
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

class CheckVoucherUseCase {
  final CartRepository repository;
  CheckVoucherUseCase(this.repository);

  Future<ApiResult<BaseResponse<CheckVoucherResponse?>>> call(
    CheckVoucherRequest request,
  ) {
    return repository.checkVoucher(request);
  }
}

class SavePendingRestaurantPosInvoiceUseCase {
  final CartRepository repository;
  SavePendingRestaurantPosInvoiceUseCase(this.repository);

  Future<ApiResult<BaseResponse<dynamic>>> call(
    SaveRestaurantPosInvoiceRequest order,
  ) {
    return repository.savePendingRestaurantPosInvoice(order);
  }
}

class SaveBookingTableRestaurantPosInvoiceUseCase {
  final CartRepository repository;
  SaveBookingTableRestaurantPosInvoiceUseCase(this.repository);

  Future<ApiResult<BaseResponse<dynamic>>> call(
    SaveRestaurantPosInvoiceRequest order,
  ) {
    return repository.saveBookingTableRestaurantPosInvoice(order);
  }
}

class GetDynamicInvoiceDiscountUseCase {
  final CartRepository repository;
  GetDynamicInvoiceDiscountUseCase(this.repository);

  Future<ApiResult<BaseResponse<List<DynamicDiscountModel>?>>> call() {
    return repository.getDynamicInvoiceDiscount();
  }
}
