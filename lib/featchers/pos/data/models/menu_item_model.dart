import 'package:apex_restaurant/featchers/pos/domain/entities/menu_item.dart';

class MenuItemModel extends MenuItem {
  const MenuItemModel({
    required super.id,
    required super.name,
    required super.description,
    required super.price,
    required super.imageUrl,
    required super.categoryId,
    super.isAvailable,
  });

  factory MenuItemModel.fromJson(Map<String, dynamic> json) => MenuItemModel(
    id: json['id'] as String,
    name: json['name'] as String,
    description: json['description'] as String,
    price: (json['price'] as num).toDouble(),
    imageUrl: json['image_url'] as String,
    categoryId: json['category_id'] as String,
    isAvailable: json['is_available'] as bool? ?? true,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'price': price,
    'image_url': imageUrl,
    'category_id': categoryId,
    'is_available': isAvailable,
  };
}

class MenuCategoryModel extends MenuCategory {
  const MenuCategoryModel({
    required super.id,
    required super.name,
    required super.icon,
    required super.items,
  });

  factory MenuCategoryModel.fromJson(Map<String, dynamic> json) =>
      MenuCategoryModel(
        id: json['id'] as String,
        name: json['name'] as String,
        icon: json['icon'] as String,
        items: (json['items'] as List<dynamic>? ?? [])
            .map((e) => MenuItemModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}
