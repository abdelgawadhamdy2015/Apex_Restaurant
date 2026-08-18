import 'package:apex_restaurant/featchers/orders/data/model/pinding_invoice_model.dart';
import 'package:apex_restaurant/featchers/orders/data/model/restored_invoice_model.dart';

import '../../domain/entities/floor_entity.dart';
import '../../domain/entities/reservation_entity.dart';
import '../../domain/entities/table_entity.dart';
import 'package:equatable/equatable.dart';

enum TablesStatus { initial, loading, success, pindingSussess, failure }

class TablesState extends Equatable {
  final TablesStatus status;
  final int activeTab; // 0: Tables, 1: Reservations
  final List<TableEntity> tables;
  final List<FloorEntity> floors;
  final List<ReservationEntity> reservations;
  final String? errorMessage;
  final List<PindingInvoiceModel>? pindingInvoices;
  final int? restoringInvoiceId;
  final RestoredInvoiceModel? restoredInvoiceModel;
  final bool canEdit;
  const TablesState({
    this.status = TablesStatus.initial,
    this.activeTab = 0,
    this.reservations = const [],
    this.errorMessage,
    this.tables = const [],
    this.floors = const [],
    this.pindingInvoices,
    this.restoringInvoiceId,
    this.restoredInvoiceModel,
    this.canEdit = true,
  });

  TablesState copyWith({
    TablesStatus? status,
    int? activeTab,
    List<TableEntity>? tables,
    List<FloorEntity>? floors,
    List<ReservationEntity>? reservations,
    List<PindingInvoiceModel>? pindingInvoices,
    String? errorMessage,
    int? restoringInvoiceId,
    RestoredInvoiceModel? restoredInvoiceModel,
    bool? canEdit,
    bool? clearRestoringId,
  }) {
    return TablesState(
      status: status ?? this.status,
      activeTab: activeTab ?? this.activeTab,
      tables: tables ?? this.tables,
      floors: floors ?? this.floors,
      pindingInvoices: pindingInvoices ?? this.pindingInvoices,
      reservations: reservations ?? this.reservations,
      errorMessage: errorMessage,
      restoringInvoiceId: clearRestoringId == true
          ? null
          : restoringInvoiceId ?? this.restoringInvoiceId,
      restoredInvoiceModel: clearRestoringId == true
          ? null
          : restoredInvoiceModel ?? this.restoredInvoiceModel,
      canEdit: canEdit ?? this.canEdit,
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
    pindingInvoices,
    restoringInvoiceId,
  ];
}
