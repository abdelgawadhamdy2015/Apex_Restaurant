import 'package:apex_restaurant/featchers/orders/data/model/get_pinding_invoice.dart';
import 'package:apex_restaurant/featchers/tables/domain/entities/floor_entity.dart';
import 'package:apex_restaurant/featchers/tables/domain/entities/table_entity.dart';

import '../../data/models/get_floor_request.dart';
import '../../data/models/get_reservations_request.dart';
import '../../data/models/get_table_request.dart';
import '../../data/models/reservation_requests.dart';
import 'package:equatable/equatable.dart';

abstract class TablesEvent extends Equatable {
  const TablesEvent();

  @override
  List<Object?> get props => [];
}

class FetchReservationsEvent extends TablesEvent {
  final GetReservationRequest request;
  const FetchReservationsEvent(this.request);
  @override
  List<Object?> get props => [request];
}

class SwitchMainTabEvent extends TablesEvent {
  final int tabIndex; // 0: Tables, 1: Reservations
  const SwitchMainTabEvent(this.tabIndex);

  @override
  List<Object?> get props => [tabIndex];
}

class AddReservationEvent extends TablesEvent {
  final ReserveFoodTableRequest reservation;
  const AddReservationEvent(this.reservation);

  @override
  List<Object?> get props => [reservation];
}

class CancelReservationEvent extends TablesEvent {
  final String id;
  const CancelReservationEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class FetchFloorsEvent extends TablesEvent {
  final GetFloorsRequest request;
  const FetchFloorsEvent(this.request);
  @override
  List<Object?> get props => [request];
}

class FetchTablesEvent extends TablesEvent {
  final GetTablesRequest request;
  const FetchTablesEvent(this.request);

  @override
  List<Object?> get props => [request];
}

class RestoreOrderEvent extends TablesEvent {
  final int invoiceId;
  final bool canEdite;
  const RestoreOrderEvent({required this.invoiceId, this.canEdite = true});
  @override
  List<Object?> get props => [invoiceId, canEdite];
}

class ClearRestoredInvoiceEvent extends TablesEvent {
  const ClearRestoredInvoiceEvent();
}

class SelectTableEvent extends TablesEvent {
  final TableEntity tableEntity;
  const SelectTableEvent({required this.tableEntity});
  @override
  List<Object?> get props => [tableEntity];
}

class SelectFloorEvent extends TablesEvent {
  final FloorEntity floorEntity;
  const SelectFloorEvent({required this.floorEntity});
  @override
  List<Object?> get props => [floorEntity];
}

class FetchRestaurantPosBookingTableEvent extends TablesEvent {
  final GetPindingInvoicesRequest request;
  const FetchRestaurantPosBookingTableEvent({required this.request});
  @override
  List<Object?> get props => [request];
}
