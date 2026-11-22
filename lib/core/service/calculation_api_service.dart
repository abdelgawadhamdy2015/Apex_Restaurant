import 'package:apex_restaurant/featchers/calculation/data/models/calculation_api_response.dart';
import 'package:apex_restaurant/featchers/calculation/data/models/calculation_result.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'calculation_api_service.g.dart';

@RestApi()
abstract class CalculationApiService {
  factory CalculationApiService(Dio dio, {String? baseUrl}) =
      _CalculationApiService;

  @POST('/Calculation/OpenNewCart')
  Future<CalculationApiResponse<String>> openNewCart(
    @Queries() Map<String, dynamic> query,
  );

  @POST('/Calculation/AddItem')
  Future<CalculationApiResponse<CalculationResult?>> addItem(
    @Queries() Map<String, dynamic> query,
  );

  @POST('/Calculation/EditItem')
  Future<CalculationApiResponse<CalculationResult?>> editItem(
    @Queries() Map<String, dynamic> query,
  );

  @POST('/Calculation/ClearAllItems')
  Future<CalculationApiResponse<CalculationResult?>> clearAllItems(
    @Queries() Map<String, dynamic> query,
  );

  @POST('/Calculation/getCalculationResult')
  Future<CalculationApiResponse<CalculationResult?>> getCalculationResult(
    @Queries() Map<String, dynamic> query,
  );

  @POST('/Calculation/SetPosType')
  Future<CalculationApiResponse<CalculationResult?>> setPosType(
    @Queries() Map<String, dynamic> query,
  );

  @POST('/Calculation/AddVoucher')
  Future<CalculationApiResponse<CalculationResult?>> addVoucher(
    @Queries() Map<String, dynamic> query,
  );

  @POST('/Calculation/RemoveVoucher')
  Future<CalculationApiResponse<CalculationResult?>> removeVoucher(
    @Queries() Map<String, dynamic> query,
  );

  @POST('/Calculation/setDiscountOnTotal')
  Future<CalculationApiResponse<CalculationResult?>> setDiscountOnTotal(
    @Queries() Map<String, dynamic> query,
  );

  @POST('/Calculation/RemoveCart')
  Future<CalculationApiResponse<CalculationResult?>> removeCart(
    @Queries() Map<String, dynamic> query,
  );
}
