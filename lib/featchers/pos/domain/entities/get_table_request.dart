class GetTablesRequestModel {
  final int? pageNumber;
  final int? pageSize;
  final String? id;
  final String? name;
  final String? floorID;
  final bool? forPOS;

  const GetTablesRequestModel({
    this.pageNumber,
    this.pageSize,
    this.id,
    this.name,
    this.floorID,
    this.forPOS,
  });
}
