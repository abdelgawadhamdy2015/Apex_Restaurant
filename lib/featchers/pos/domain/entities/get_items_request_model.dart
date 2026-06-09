import 'package:apex_restaurant/core/shared/entity/base_request.dart';

class GetItemsRequestModel extends BaseRequest {
  final int? status;
  final String? id;

  final String? categories;
  final bool? isRestaurantItem;
  final bool? isRestaurantIngrediant;

  const GetItemsRequestModel({
    super.pageNumber,
    super.pageSize,
    this.status,
    this.id,
    super.name,
    this.categories,
    this.isRestaurantItem,
    this.isRestaurantIngrediant,
  });

  @override
  GetItemsRequestModel copyWith({
    int? pageNumber,
    int? pageSize,
    int? status,
    String? id,
    String? name,
    String? categories,
    bool? isRestaurantItem,
    bool? isRestaurantIngrediant,
  }) {
    return GetItemsRequestModel(
      pageNumber: pageNumber ?? super.pageNumber,
      pageSize: pageSize ?? super.pageSize,
      status: status ?? this.status,
      id: id ?? this.id,
      name: name ?? super.name,
      categories: categories ?? this.categories,
      isRestaurantItem: isRestaurantItem ?? this.isRestaurantItem,
      isRestaurantIngrediant:
          isRestaurantIngrediant ?? this.isRestaurantIngrediant,
    );
  }
}
