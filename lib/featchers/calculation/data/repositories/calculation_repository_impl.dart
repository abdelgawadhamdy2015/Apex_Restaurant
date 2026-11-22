import 'package:apex_restaurant/featchers/calculation/data/datasources/calculation_remote_data_source.dart';
import 'package:apex_restaurant/featchers/calculation/data/models/calculation_api_response.dart';

import '../models/calculation_requests.dart';
import '../models/calculation_result.dart';
import '../../domain/repositories/calculation_repository.dart';

class CalculationRepositoryImpl implements CalculationRepository {
  final CalculationRemoteDataSource remoteDataSource;

  CalculationRepositoryImpl(this.remoteDataSource);

  @override
  Future<String?> openNewCart(OpenNewCartRequest request) async {
    final response = await remoteDataSource.openNewCart(request);

    if (!response.isSuccess ||
        response.data == null ||
        response.data!.isEmpty) {
      throw Exception(
        response.errorMessageAr ??
            response.errorMessageEn ??
            response.note ??
            'Failed to open calculation cart',
      );
    }

    return response.data;
  }

  @override
  Future<CalculationResult?> addItem(AddCalculationItemRequest request) async {
    final response = await remoteDataSource.addItem(request);

    if (!response.isSuccess || response.data == null) {
      throw Exception(
        response.errorMessageAr ??
            response.errorMessageEn ??
            response.note ??
            'Failed to calculate cart item',
      );
    }

    return response.data!;
  }

  @override
  Future<CalculationResult> editItem(EditCalculationItemRequest request) async {
    final response = await remoteDataSource.editItem(request);
    return _parseCalculationResult(response);
  }

  @override
  Future<CalculationResult> clearAllItems(String cartId) async {
    final response = await remoteDataSource.clearAllItems(cartId);
    return _parseCalculationResult(response);
  }

  @override
  Future<void> removeCart(String cartId) async {
    final response = await remoteDataSource.removeCart(cartId);

    if (!response.isSuccess) {
      throw Exception(
        response.errorMessageAr ??
            response.errorMessageEn ??
            response.note ??
            'Failed to remove calculation cart',
      );
    }
  }

  CalculationResult _parseCalculationResult(
    CalculationApiResponse<CalculationResult?> response,
  ) {
    if (!response.isSuccess || response.data == null) {
      throw Exception(
        response.errorMessageAr ??
            response.errorMessageEn ??
            response.note ??
            'Calculation operation failed',
      );
    }

    return response.data!;
  }

  @override
  Future<CalculationResult> setPosType(SetPosTypeRequest request) async =>
      _parseCalculationResult(await remoteDataSource.setPosType(request));

  @override
  Future<CalculationResult> setDiscountOnTotal(
    SetDiscountOnTotalRequest request,
  ) async => _parseCalculationResult(
    await remoteDataSource.setDiscountOnTotal(request),
  );

  @override
  Future<CalculationResult> addVoucher(AddVoucherRequest request) async =>
      _parseCalculationResult(await remoteDataSource.addVoucher(request));

  @override
  Future<CalculationResult> removeVoucher(String cartId) async =>
      _parseCalculationResult(await remoteDataSource.removeVoucher(cartId));
}
