import '../../../../core/service/api_result.dart';
import '../../../../core/shared/model/base_response.dart';
import '../../data/models/get_floor_request.dart';
import '../../data/models/get_reservations_request.dart';
import '../../data/models/get_table_request.dart';
import '../../data/models/reservation_requests.dart';
import '../entities/floor_entity.dart';
import '../entities/reservation_data_entity.dart';
import '../entities/table_entity.dart';
import '../repo/tables_repository.dart';

class GetReservationsUseCase {
  final TablesRepository repository;

  GetReservationsUseCase(this.repository);

  Future<ApiResult<BaseResponse<ReservationsDataEntity>>> call(
    GetReservationRequest request,
  ) async {
    return await repository.getReservations(request);
  }
}

class CreateReservationUseCase {
  final TablesRepository repository;

  CreateReservationUseCase(this.repository);

  Future<ApiResult<BaseResponse<dynamic>>> call(
    ReserveFoodTableRequest reservation,
  ) async {
    return await repository.createReservation(reservation);
  }
}

class CancelReservationUseCase {
  final TablesRepository repository;

  CancelReservationUseCase(this.repository);

  Future<ApiResult<BaseResponse<dynamic>>> call(String id) async {
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
