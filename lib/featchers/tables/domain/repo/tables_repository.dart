import 'package:apex_restaurant/core/service/api_result.dart';
import 'package:apex_restaurant/core/shared/model/base_response.dart';
import 'package:apex_restaurant/featchers/tables/data/models/get_floor_request.dart';
import 'package:apex_restaurant/featchers/tables/data/models/get_reservations_request.dart';
import 'package:apex_restaurant/featchers/tables/data/models/get_table_request.dart';
import 'package:apex_restaurant/featchers/tables/domain/entities/floor_entity.dart';
import 'package:apex_restaurant/featchers/tables/domain/entities/reservation_data_entity.dart';
import 'package:apex_restaurant/featchers/tables/domain/entities/reservation_entity.dart';
import 'package:apex_restaurant/featchers/tables/domain/entities/table_entity.dart';

abstract class TablesRepository {
  Future<ApiResult<BaseResponse<ReservationsDataEntity>>> getReservations(
    GetReservationRequest request,
  );
  Future<void> createReservation(ReservationEntity reservation);
  Future<void> editReservation(ReservationEntity reservation);
  Future<void> cancelReservation(String id);
  Future<ApiResult<BaseResponse<List<FloorEntity>?>>> getFloors({
    required GetFloorsRequest request,
  });

  Future<ApiResult<BaseResponse<List<TableEntity>?>>> getTables({
    required GetTablesRequest request,
  });
}
