class GetFloorsRequestModel {
  final int? pageNumber;
  final int? pageSize;
  final String? id;
  final String? name;
  final int? branchId;

  const GetFloorsRequestModel({
    this.pageNumber,
    this.pageSize,
    this.id,
    this.name,
    this.branchId,
  });
}
