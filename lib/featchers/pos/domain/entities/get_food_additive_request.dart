import 'package:apex_restaurant/core/shared/entity/base_request.dart';

class GetFoodAdditiveRequest extends BaseRequest {
  final int? categoryID;

  const GetFoodAdditiveRequest({
    super.pageNumber,
    super.pageSize,
    super.name,
    this.categoryID,
  });
}
