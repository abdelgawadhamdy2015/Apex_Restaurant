import 'package:equatable/equatable.dart';

class OrderItemEntity extends Equatable {
  final String id;
  final String name;
  final double price;
  final int quantity;
  final String? imageUrl;

  /// Free-form option/addon lines shown under the item name,
  /// e.g. "صوص جانبي", "بطاطس مقلية (وسط) x1".
  final List<String> notes;

  const OrderItemEntity({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
    this.imageUrl,
    this.notes = const [],
  });

  double get totalPrice => price * quantity;

  OrderItemEntity copyWith({int? quantity}) {
    return OrderItemEntity(
      id: id,
      name: name,
      price: price,
      quantity: quantity ?? this.quantity,
      imageUrl: imageUrl,
      notes: notes,
    );
  }

  @override
  List<Object?> get props => [id, name, price, quantity, imageUrl, notes];
}
