import '../enums/table_status.dart';

class PosTable {
  final int id;
  final String name;
  final String zone;
  final TableStatus status;

  const PosTable({
    required this.id,
    required this.name,
    required this.zone,
    required this.status,
  });
}
