import 'package:apex_restaurant/core/shared/entity/base_request.dart';

class GetClientsRequest extends BaseRequest {
  final String? type;
  final int? status;

  final int? customerActivity;

  final int? salesManId;

  final String? ids;

  final List<int>? typeArr;

  final bool? isSupplier;

  const GetClientsRequest({
    this.isSupplier,
    super.name,
    super.pageNumber,
    super.pageSize,
    this.type,
    this.status,
    this.customerActivity,
    this.salesManId,
    this.ids,
    this.typeArr,
  });
  @override
  Map<String, dynamic> toJson() => <String, dynamic>{
    if (name != null) 'Name': name,
    'PageNumber': pageNumber,
    'PageSize': pageSize,
    if (type != null) 'Type': type,
    if (status != null) 'Status': status,
    if (customerActivity != null) 'CustomerActivity': customerActivity,
    if (salesManId != null) 'SalesManId': salesManId,
    if (ids != null) 'ids': ids,
    if (typeArr != null) 'TypeArr': typeArr,
    if (isSupplier != null) 'IsSupplier': isSupplier,
  };
}
