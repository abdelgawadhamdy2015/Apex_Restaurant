import 'package:apex_restaurant/core/shared/entity/base_request.dart';

class GetItemsRequest extends BaseRequest {
  final int? statues;
  final int? categoryId;
  final int? companyId;
  final String? searchKey;

  const GetItemsRequest({
    super.pageNumber,
    super.pageSize,
    this.statues,
    super.name,
    this.categoryId,
    this.companyId,
    this.searchKey,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (pageNumber != null) 'pageNumber': pageNumber,
      if (pageSize != null) 'pageSize': pageSize,
      if (statues != null) 'statues': statues,
      if (name != null) 'name': name,
      if (categoryId != null) 'CategoryId': categoryId,
      if (companyId != null) 'CompanyId': companyId,
      if (searchKey != null) 'SearchKey': searchKey,
    };
  }
}
