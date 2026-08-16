import '../../../../core/shared/entity/base_request.dart';

class GetItemsRequest extends BaseRequest {
  final int? statues;
  final int? categoryId;
  final int? companyId;
  final String? searchKey;
  final int? itemId;
  const GetItemsRequest({
    super.pageNumber,
    super.pageSize,
    this.statues,
    super.name,
    this.categoryId,
    this.companyId,
    this.searchKey,
    this.itemId,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (pageNumber != null) 'PageNumber': pageNumber,
      if (pageSize != null) 'PageSize': pageSize,
      if (statues != null) 'statues': statues,
      if (name != null) 'name': name,
      if (categoryId != null) 'CategoryId': categoryId,
      if (companyId != null) 'CompanyId': companyId,
      if (searchKey != null) 'SearchKey': searchKey,
      if (itemId != null) "itemId": itemId,
    };
  }
}
