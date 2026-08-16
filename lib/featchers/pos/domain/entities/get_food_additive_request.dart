import '../../../../core/shared/entity/base_request.dart';

class GetFoodAdditivesRequest extends BaseRequest {
  final int? categoryID;

  const GetFoodAdditivesRequest({
    super.pageNumber,
    super.pageSize,
    super.name,
    this.categoryID,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (pageNumber != null) 'pageNumber': pageNumber,
      if (pageSize != null) 'pageSize': pageSize,
      if (name != null) 'name': name,
      if (categoryID != null) 'categoryID': categoryID,
    };
  }
}
