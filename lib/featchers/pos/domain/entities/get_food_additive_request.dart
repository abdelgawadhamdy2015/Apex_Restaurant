import 'package:apex_restaurant/core/shared/entity/base_request.dart';

class GetFoodAdditivesRequest extends BaseRequest {
  final int? categoryID;

  const GetFoodAdditivesRequest({
    super.pageNumber = 1,
    super.pageSize = 50,
    super.name,
    this.categoryID,
  });

  Map<String, dynamic> toJson() {
    return {
      'pageNumber': pageNumber,
      'pageSize': pageSize,
      'name': name,
      if (categoryID != null) 'categoryID': categoryID,
    };
  }
}
