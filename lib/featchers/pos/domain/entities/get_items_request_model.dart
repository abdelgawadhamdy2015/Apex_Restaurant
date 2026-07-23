import 'package:apex_restaurant/core/shared/entity/base_request.dart';

class GetItemsRequest extends BaseRequest {
  final int? statues;
  final int? categoryId;
  final int? companyId;
  final String? searchKey;

  const GetItemsRequest({
    super.pageNumber = 1,
    super.pageSize = 50,
    this.statues,
    super.name,
    this.categoryId,
    this.companyId,
    this.searchKey,
  });

  Map<String, dynamic> toJson() {
    return {
      'pageNumber': pageNumber,
      'pageSize': pageSize,
      if (statues != null) 'statues': statues,
      if (name != null) 'name': name,
      if (categoryId != null) 'CategoryId': categoryId,
      if (companyId != null) 'CompanyId': companyId,
      if (searchKey != null) 'SearchKey': searchKey,
    };
  }
}
