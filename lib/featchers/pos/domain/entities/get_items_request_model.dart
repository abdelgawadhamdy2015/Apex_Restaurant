import '../../../../core/shared/entity/base_request.dart';

class GetItemsRequest extends BaseRequest {
  final int? statues;
  final int? categoryId;
  final int? companyId;
  final String? searchKey;
  final List<int>? itemIds;

  const GetItemsRequest({
    super.pageNumber,
    super.pageSize,
    this.statues,
    super.name,
    this.categoryId,
    this.companyId,
    this.searchKey,
    this.itemIds,
  });

  @override
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{
      if (pageNumber != null) 'PageNumber': pageNumber.toString(),
      if (pageSize != null) 'PageSize': pageSize.toString(),
      if (statues != null) 'statues': statues.toString(),
      if (name != null) 'name': name,
      if (categoryId != null) 'CategoryId': categoryId.toString(),
      if (companyId != null) 'CompanyId': companyId.toString(),
      if (searchKey != null) 'SearchKey': searchKey,
    };

    if (itemIds != null) {
      for (int i = 0; i < itemIds!.length; i++) {
        data['ItemIds[$i]'] = itemIds![i].toString();
      }
    }

    return data;
  }
}
