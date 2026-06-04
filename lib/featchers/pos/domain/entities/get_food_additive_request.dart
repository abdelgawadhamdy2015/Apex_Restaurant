class GetFoodAdditiveRequest {
  final int? pageNumber;
  final int? pageSize;
  final String? name;
  final int? categoryID;

  const GetFoodAdditiveRequest({
    this.pageNumber,
    this.pageSize,
    this.name,
    this.categoryID,
  });
}
