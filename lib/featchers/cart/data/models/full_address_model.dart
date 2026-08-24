class AddressModel {
  final int id;

  final String label;

  final String fullAddress;

  const AddressModel({
    required this.id,
    required this.label,
    required this.fullAddress,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: json['id'] as int,
      label: json['label'] as String? ?? '',
      fullAddress: json['fullAddress'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'label': label,
    'fullAddress': fullAddress,
  };
}
