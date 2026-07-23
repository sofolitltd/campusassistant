class Address {
  final String id;
  final String label;
  final String recipientName;
  final String phone;
  final String addressLine;
  final String city;
  final bool isDefault;

  Address({
    required this.id,
    required this.label,
    required this.recipientName,
    required this.phone,
    required this.addressLine,
    required this.city,
    this.isDefault = false,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: json['id'] as String,
      label: json['label'] as String? ?? '',
      recipientName: json['recipient_name'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      addressLine: json['address_line'] as String? ?? '',
      city: json['city'] as String? ?? '',
      isDefault: json['is_default'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'label': label,
      'recipient_name': recipientName,
      'phone': phone,
      'address_line': addressLine,
      'city': city,
      'is_default': isDefault,
    };
  }
}
