import 'package:apex_restaurant/featchers/tables/data/models/get_floor_request.dart';
import 'package:apex_restaurant/featchers/tables/data/models/get_reservations_request.dart';
import 'package:apex_restaurant/featchers/tables/data/models/get_table_request.dart';
import 'package:apex_restaurant/featchers/tables/domain/entities/reservation_entity.dart';
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
  final ReservationEntity reservation;
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
