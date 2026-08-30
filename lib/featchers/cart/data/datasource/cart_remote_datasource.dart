import 'package:apex_restaurant/featchers/cart/data/models/check_voucher_request.dart';
import 'package:apex_restaurant/featchers/cart/data/models/check_voucher_response.dart';
import 'package:apex_restaurant/featchers/cart/data/models/get_delivery_companies_request.dart';
import 'package:apex_restaurant/featchers/pos/data/models/delivery_company.dart';

import '../../../../core/service/api_service.dart';
import '../../../../core/shared/entity/base_request.dart';
import '../../../../core/shared/model/base_response.dart';
import '../models/apply_discount_request_model.dart';
import '../models/client_request_model.dart';
import '../models/dynamic_discount.dart';
import '../models/get_client_request.dart';
import '../models/invoice_request.dart';
import '../models/pos_client_model.dart';

import '../models/discount_result_model.dart';
import '../models/waiter_model.dart';

abstract class CartRemoteDataSource {
  Future<BaseResponse<List<WaiterModel>?>> getDeliveryAgents({
    BaseRequest? request,
  });
  Future<BaseResponse<List<DeliveryCompanyModel>?>> getAllDeliveryCompany({
    GetDeliveryCompaniesRequest? request,
  });
  Future<BaseResponse<List<WaiterModel>?>> getWaiters({BaseRequest? request});
  Future<BaseResponse<List<PosClientModel>?>> getPersons({
    required GetClientsRequest request,
  });

  Future<BaseResponse<DiscountResultModel?>> applyDiscount(
    ApplyDiscountRequestModel request,
  );

  Future<BaseResponse<CheckVoucherResponse?>> checkVoucher(
    CheckVoucherRequest request,
  );

  Future<BaseResponse<dynamic>> updatePosClient({
    required ClientRequestModel request,
  });

  Future<BaseResponse<dynamic>> addPosClient({
    required ClientRequestModel request,
  });
  Future<BaseResponse<List<DynamicDiscountModel>?>> getDynamicInvoiceDiscount();
  Future<BaseResponse<dynamic>> savePendingRestaurantPosInvoice(
    SaveRestaurantPosInvoiceRequest request,
  );
  Future<BaseResponse<dynamic>> saveBookingTableRestaurantPosInvoice(
    SaveRestaurantPosInvoiceRequest request,
  );
}

class CartRemoteDataSourceImpl implements CartRemoteDataSource {
  final ApiService _apiService;
  CartRemoteDataSourceImpl(this._apiService);

  @override
  Future<BaseResponse<List<WaiterModel>?>> getDeliveryAgents({
    BaseRequest? request,
  }) {
    final queryRequest = BaseRequest(
      pageNumber: request?.pageNumber,
      pageSize: request?.pageSize,
      name: request?.name,
    );

    return _apiService.getListOfDeliveryMen(queryRequest);
  }

  @override
  Future<BaseResponse<List<DeliveryCompanyModel>?>> getAllDeliveryCompany({
    GetDeliveryCompaniesRequest? request,
  }) async {
    return await _apiService.getAllDeliveryCompany(request);
  }

  @override
  Future<BaseResponse<List<WaiterModel>?>> getWaiters({BaseRequest? request}) {
    final queryRequest = BaseRequest(
      pageNumber: request?.pageNumber,
      pageSize: request?.pageSize,
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
  Future<BaseResponse<dynamic>> savePendingRestaurantPosInvoice(
    SaveRestaurantPosInvoiceRequest request,
  ) {
    return _apiService.savePendingRestaurantPosInvoice(request);
  }

  @override
  Future<BaseResponse<dynamic>> saveBookingTableRestaurantPosInvoice(
    SaveRestaurantPosInvoiceRequest request,
  ) {
    return _apiService.saveBookingTableRestaurantPosInvoice(request);
  }

  @override
  Future<BaseResponse<List<PosClientModel>?>> getPersons({
    required GetClientsRequest request,
  }) {
    return _apiService.getAllPersons(request);
  }

  @override
  Future<BaseResponse<dynamic>> updatePosClient({
    required ClientRequestModel request,
  }) {
    return _apiService.updatePosClient(request);
  }

  @override
  Future<BaseResponse<dynamic>> addPosClient({
    required ClientRequestModel request,
  }) {
    return _apiService.addPosClient(request);
  }

  @override
  Future<BaseResponse<List<DynamicDiscountModel>?>>
  getDynamicInvoiceDiscount() async {
    return await _apiService.getDynamicInvoiceDiscounts();
  }

  @override
  Future<BaseResponse<CheckVoucherResponse?>> checkVoucher(
    CheckVoucherRequest request,
  ) async {
    return await _apiService.checkPOSVoucher(request);
  }
}
