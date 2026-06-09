import 'package:apex_restaurant/core/shared/entity/base_request.dart';

class GetTablesRequestModel extends BaseRequest {
  final String? id;

  final String? floorID;
  final bool? forPOS;

  const GetTablesRequestModel({
    super.pageNumber,
    super.pageSize,
    this.id,
    super.name,
    this.floorID,
    this.forPOS,
  });
}
