import 'package:apex_restaurant/core/service/api_result.dart';
import 'package:apex_restaurant/core/shared/model/base_response.dart';
import 'package:apex_restaurant/featchers/tables/data/models/get_floor_request.dart';
import 'package:apex_restaurant/featchers/tables/data/models/get_reservations_request.dart';
import 'package:apex_restaurant/featchers/tables/data/models/get_table_request.dart';
import 'package:apex_restaurant/featchers/tables/domain/entities/floor_entity.dart';
import 'package:apex_restaurant/featchers/tables/domain/entities/reservation_data_entity.dart';
import 'package:apex_restaurant/featchers/tables/domain/entities/reservation_entity.dart';
import 'package:apex_restaurant/featchers/tables/domain/entities/table_entity.dart';
import 'package:apex_restaurant/featchers/tables/domain/repo/tables_repository.dart';

class GetReservationsUseCase {
  final TablesRepository repository;

  GetReservationsUseCase(this.repository);

  Future<ApiResult<BaseResponse<ReservationsDataEntity>>> call(
    GetReservationRequest request,
  ) async {
    return await repository.getReservations(request);
  }
}

// domain/usecases/create_reservation_usecase.dart
class CreateReservationUseCase {
  final TablesRepository repository;

  CreateReservationUseCase(this.repository);

  Future<void> call(ReservationEntity reservation) async {
    return await repository.createReservation(reservation);
  }
}

// domain/usecases/cancel_reservation_usecase.dart
class CancelReservationUseCase {
  final TablesRepository repository;

  CancelReservationUseCase(this.repository);

  Future<void> call(String id) async {
    return await repository.cancelReservation(id);
  }
}

class GetFloorsUseCase {
  final TablesRepository repository;
  GetFloorsUseCase(this.repository);
  Future<ApiResult<BaseResponse<List<FloorEntity>?>>> call({
    required GetFloorsRequest request,
  }) => repository.getFloors(request: request);
}

class GetTablesUseCase {
  final TablesRepository repository;
  GetTablesUseCase(this.repository);
  Future<ApiResult<BaseResponse<List<TableEntity>?>>> call({
    required GetTablesRequest request,
  }) => repository.getTables(request: request);
}
