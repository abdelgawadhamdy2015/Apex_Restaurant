import 'package:apex_restaurant/core/service/calculation_api_service.dart';
import 'package:apex_restaurant/featchers/calculation/data/models/calculation_api_response.dart';
import 'package:apex_restaurant/featchers/calculation/data/models/calculation_result.dart';

import '../models/calculation_requests.dart';

abstract class CalculationRemoteDataSource {
  Future<CalculationApiResponse<String?>> openNewCart(
    OpenNewCartRequest request,
  );

  Future<CalculationApiResponse<CalculationResult?>> addItem(
    AddCalculationItemRequest request,
  );
  Future<CalculationApiResponse<CalculationResult?>> editItem(
    EditCalculationItemRequest request,
  );

  Future<CalculationApiResponse<CalculationResult?>> clearAllItems(
    String cartId,
  );

  Future<CalculationApiResponse<CalculationResult?>> removeCart(String cartId);
  Future<CalculationApiResponse<CalculationResult?>> setPosType(
    SetPosTypeRequest r,
  );
  Future<CalculationApiResponse<CalculationResult?>> setDiscountOnTotal(
    SetDiscountOnTotalRequest r,
  );
  Future<CalculationApiResponse<CalculationResult?>> addVoucher(
    AddVoucherRequest r,
  );
  Future<CalculationApiResponse<CalculationResult?>> removeVoucher(
    String cartId,
  );
}

class CalculationRemoteDataSourceImpl implements CalculationRemoteDataSource {
  final CalculationApiService apiService;

  CalculationRemoteDataSourceImpl(this.apiService);

  @override
  Future<CalculationApiResponse<String?>> openNewCart(
    OpenNewCartRequest request,
  ) {
    return apiService.openNewCart(request.toQuery());
  }

  @override
  Future<CalculationApiResponse<CalculationResult?>> addItem(
    AddCalculationItemRequest request,
  ) {
    return apiService.addItem(request.toQuery());
  }

  @override
  Future<CalculationApiResponse<CalculationResult?>> editItem(
    EditCalculationItemRequest request,
  ) {
    return apiService.editItem(request.toQuery());
  }

  @override
  Future<CalculationApiResponse<CalculationResult?>> clearAllItems(
    String cartId,
  ) {
    return apiService.clearAllItems({'CartID': cartId});
  }

  @override
  Future<CalculationApiResponse<CalculationResult?>> removeCart(String cartId) {
    return apiService.removeCart({'CartID': cartId});
  }

  @override
  Future<CalculationApiResponse<CalculationResult?>> setPosType(
    SetPosTypeRequest r,
  ) => apiService.setPosType(r.toQuery());
  @override
  Future<CalculationApiResponse<CalculationResult?>> setDiscountOnTotal(
    SetDiscountOnTotalRequest r,
  ) => apiService.setDiscountOnTotal(r.toQuery());
  @override
  Future<CalculationApiResponse<CalculationResult?>> addVoucher(
    AddVoucherRequest r,
  ) => apiService.addVoucher(r.toQuery());
  @override
  Future<CalculationApiResponse<CalculationResult?>> removeVoucher(
    String cartId,
  ) => apiService.removeVoucher({'CartID': cartId});
}
