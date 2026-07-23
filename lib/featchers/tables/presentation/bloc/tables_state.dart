import 'package:apex_restaurant/featchers/tables/domain/entities/floor_entity.dart';
import 'package:apex_restaurant/featchers/tables/domain/entities/reservation_entity.dart';
import 'package:apex_restaurant/featchers/tables/domain/entities/table_entity.dart';
import 'package:equatable/equatable.dart';

enum TablesStatus { initial, loading, success, failure }

class TablesState extends Equatable {
  final TablesStatus status;
  final int activeTab; // 0: Tables, 1: Reservations
  final List<TableEntity> tables;
  final List<FloorEntity> floors;
  final List<ReservationEntity> reservations;
  final String? errorMessage;

  const TablesState({
    this.status = TablesStatus.initial,
    this.activeTab = 0,
    this.reservations = const [],
    this.errorMessage,
    this.tables = const [],
    this.floors = const [],
  });

  TablesState copyWith({
    TablesStatus? status,
    int? activeTab,
    List<TableEntity>? tables,
    List<FloorEntity>? floors,
    List<ReservationEntity>? reservations,
    String? errorMessage,
  }) {
    return TablesState(
      status: status ?? this.status,
      activeTab: activeTab ?? this.activeTab,
      tables: tables ?? this.tables,
      floors: floors ?? this.floors,
      reservations: reservations ?? this.reservations,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    activeTab,
    tables,
    floors,
    reservations,
    errorMessage,
  ];
}
