class FloorEntity {
  final String id;
  final int code;
  final String arabicName;
  final String latinName;
  final String? notes;
  final int status;
  final int tableCount;
  final int branchId;
  final String branchNameAr;
  final String branchNameEn;

  const FloorEntity({
    required this.id,
    required this.code,
    required this.arabicName,
    required this.latinName,
    this.notes,
    required this.status,
    required this.tableCount,
    required this.branchId,
    required this.branchNameAr,
    required this.branchNameEn,
  });
}
