import 'package:apex_restaurant/core/shared/entity/base_request.dart';

class GetItemsRequestModel extends BaseRequest {
  final int? status;
  final String? id;

  final int? categoryId;
  final int? companyId;
  final String? searchKey;

  const GetItemsRequestModel({
    super.pageNumber,
    super.pageSize,
    this.status,
    this.id,
    super.name,
    this.categoryId,
    this.companyId,
    this.searchKey,
  });

  @override
  GetItemsRequestModel copyWith({
    int? pageNumber,
    int? pageSize,
    int? status,
    String? id,
    String? name,
    int? categoryId,
    int? companyId,
    String? searchKey,
  }) {
    return GetItemsRequestModel(
      pageNumber: pageNumber ?? super.pageNumber,
      pageSize: pageSize ?? super.pageSize,
      status: status ?? this.status,
      id: id ?? this.id,
      name: name ?? super.name,
      categoryId: categoryId ?? this.categoryId,
      companyId: companyId ?? this.companyId,
      searchKey: searchKey ?? this.searchKey,
    );
  }
}
