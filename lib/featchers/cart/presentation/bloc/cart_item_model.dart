// cart_item_model.dart
import 'package:equatable/equatable.dart';

class CartItemModel extends Equatable {
  final String id;
  final String name;
  final double basePrice;
  final String details;
  final List<String> extras;
  final String? imageUrl;
  final int quantity;

  const CartItemModel({
    required this.id,
    required this.name,
    required this.basePrice,
    this.details = '',
    this.extras = const [],
    this.imageUrl,
    this.quantity = 1,
  });

  double get totalPrice => basePrice * quantity;

  CartItemModel copyWith({
    String? id,
    String? name,
    double? basePrice,
    String? details,
    List<String>? extras,
    String? imageUrl,
    int? quantity,
  }) {
    return CartItemModel(
      id: id ?? this.id,
      name: name ?? this.name,
      basePrice: basePrice ?? this.basePrice,
      details: details ?? this.details,
      extras: extras ?? this.extras,
      imageUrl: imageUrl ?? this.imageUrl,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    basePrice,
    details,
    extras,
    imageUrl,
    quantity,
  ];
}
