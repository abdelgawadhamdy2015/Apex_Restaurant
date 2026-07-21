/// A waiter/server that can be assigned to a dine-in order.
class WaiterModel {
  const WaiterModel({required this.id, this.arabicName, this.englishName});

  final int id;
  final String? arabicName;
  final String? englishName;

  factory WaiterModel.fromJson(Map<String, dynamic> json) {
    return WaiterModel(
      id: json['id'] as int,
      arabicName: json['arabicName'] as String?,
      englishName: json['englishName'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'arabicName': arabicName,
    'englishName': englishName,
  };
}
