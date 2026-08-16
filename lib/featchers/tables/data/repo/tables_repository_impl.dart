import 'dart:developer';

import '../../../../core/service/api_error_handler.dart';
import '../../../../core/service/api_result.dart';
import '../../../../core/shared/model/base_response.dart';
import '../datasource/tables_remote_data_source.dart';
import '../models/get_floor_request.dart';
import '../models/get_reservations_request.dart';
import '../models/get_table_request.dart';
import '../models/reservation_requests.dart';
import '../../domain/entities/floor_entity.dart';
import '../../domain/entities/reservation_data_entity.dart';
import '../../domain/entities/reservation_entity.dart';
import '../../domain/entities/table_entity.dart';
import '../../domain/repo/tables_repository.dart';

class TablesRepositoryImpl implements TablesRepository {
  final TablesRemoteDataSource remoteDataSource;

  TablesRepositoryImpl(this.remoteDataSource);

  @override
  Future<ApiResult<BaseResponse<ReservationsDataEntity>>> getReservations(
    GetReservationRequest request,
  ) async {
    try {
      final response = await remoteDataSource.fetchReservations(request);

      // Convert response.data (Model) into ReservationsDataEntity (Domain Entity)
      final reservationsDataEntity =
          response.data?.toEntity() ?? const ReservationsDataEntity();

      return ApiResult.success(
        BaseResponse<ReservationsDataEntity>(
          result: response.result,
          data: reservationsDataEntity,
          totalCount: response.totalCount,
          errorMessageAr: response.errorMessageAr,
          errorMessageEn: response.errorMessageEn,
          alert: response.alert,
        ),
      );
    } catch (error, s) {
      log("$error, \n $s");

      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }

  @override
  Future<ApiResult<BaseResponse<dynamic>>> createReservation(
    ReserveFoodTableRequest request,
  ) async {
    try {
      final response = await remoteDataSource.addReservation(request);
      return ApiResult.success(response);
    } catch (error, s) {
      log("$error, \n $s");

      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }

  @override
  Future<ApiResult<BaseResponse<void>>> editReservation(
    ReservationEntity reservation,
  ) async {
    try {
      final request = EditReserveFoodTableRequest(
        reservationId: reservation.id,
        foodTablesId: reservation.tableNumber,
        customerId: int.tryParse(reservation.customerName) ?? 0,
        reservationDate: reservation.dateTime.toIso8601String(),
        reservationPeriod: reservation.durationMinutes * 60,
        seatsCount: reservation.seatsCount,
        notes: reservation.notes,
      );

      final response = await remoteDataSource.editReservation(request);
      return ApiResult.success(response);
    } catch (error, s) {
      log("$error, \n $s");

      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }

  @override
  Future<ApiResult<BaseResponse<void>>> cancelReservation(String id) async {
    try {
      final request = CancelReserveFoodTableRequest(reservationId: id);
      final response = await remoteDataSource.cancelReservation(request);
      return ApiResult.success(response);
    } catch (error, s) {
      log("$error, \n $s");

      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }

  @override
  Future<ApiResult<BaseResponse<List<FloorEntity>?>>> getFloors({
    required GetFloorsRequest request,
  }) async {
    try {
      final response = await remoteDataSource.getFloors(request: request);
      final entityList = response.data?.map((m) => m.toEntity()).toList();

      return ApiResult.success(
        BaseResponse<List<FloorEntity>?>(
          result: response.result,
          data: entityList,
          totalCount: response.totalCount,
          errorMessageAr: response.errorMessageAr,
          errorMessageEn: response.errorMessageEn,
          alert: response.alert,
        ),
      );
    } catch (error, s) {
      log("$error, \n $s");

      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }

  @override
  Future<ApiResult<BaseResponse<List<TableEntity>?>>> getTables({
    required GetTablesRequest request,
  }) async {
    try {
      final response = await remoteDataSource.getTables(request: request);
      final entityList = response.data?.map((m) => m.toEntity()).toList();

      return ApiResult.success(
        BaseResponse<List<TableEntity>?>(
          result: response.result,
          data: entityList,
          totalCount: response.totalCount,
          errorMessageAr: response.errorMessageAr,
          errorMessageEn: response.errorMessageEn,
          alert: response.alert,
        ),
      );
    } catch (error, s) {
      log("$error, \n $s");
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }
}
