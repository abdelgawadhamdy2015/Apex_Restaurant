/// A delivery rider/agent that can be assigned to a delivery order.
///
/// Field names follow the same convention as `DeliveryCompanyModel`
/// (`arabicName` is referenced elsewhere in the POS bloc) — adjust to match
/// your actual API response shape.
class DeliveryAgentModel {
  const DeliveryAgentModel({
    required this.id,
    this.arabicName,
    this.englishName,
    this.phoneNumber,
    this.isAvailable = true,
  });

  final int id;
  final String? arabicName;
  final String? englishName;
  final String? phoneNumber;
  final bool isAvailable;

  factory DeliveryAgentModel.fromJson(Map<String, dynamic> json) {
    return DeliveryAgentModel(
      id: json['id'] as int,
      arabicName: json['arabicName'] as String?,
      englishName: json['englishName'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      isAvailable: json['isAvailable'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'arabicName': arabicName,
    'englishName': englishName,
    'phoneNumber': phoneNumber,
    'isAvailable': isAvailable,
  };
}
