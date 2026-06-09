import 'package:apex_restaurant/core/shared/entity/base_request.dart';

class GetFloorsRequestModel extends BaseRequest {
  final String? id;
  final int? branchId;

  const GetFloorsRequestModel({
    super.pageNumber,
    super.pageSize,
    this.id,
    super.name,
    this.branchId,
  });
}
