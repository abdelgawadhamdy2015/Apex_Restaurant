class GetItemsRequestModel {
  final int? pageNumber;
  final int? pageSize;
  final int? status;
  final String? id;
  final String? name;
  final String? categories;
  final bool? isRestaurantItem;
  final bool? isRestaurantIngrediant;

  const GetItemsRequestModel({
    this.pageNumber,
    this.pageSize,
    this.status,
    this.id,
    this.name,
    this.categories,
    this.isRestaurantItem,
    this.isRestaurantIngrediant,
  });

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
      pageNumber: pageNumber ?? this.pageNumber,
      pageSize: pageSize ?? this.pageSize,
      status: status ?? this.status,
      id: id ?? this.id,
      name: name ?? this.name,
      categories: categories ?? this.categories,
      isRestaurantItem: isRestaurantItem ?? this.isRestaurantItem,
      isRestaurantIngrediant:
          isRestaurantIngrediant ?? this.isRestaurantIngrediant,
    );
  }
}
