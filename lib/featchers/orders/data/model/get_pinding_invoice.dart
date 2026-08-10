class GetPindingInvoicesRequest {
  final int? foodTableId;
  final int? pageNumber;
  final int? pageSize;

  const GetPindingInvoicesRequest({
    this.foodTableId,
    this.pageNumber,
    this.pageSize,
  });

  Map<String, dynamic> toJson() {
    return {
      'FoodTableId': foodTableId,
      'PageNumber': pageNumber,
      'PageSize': pageSize,
    };
  }
}
