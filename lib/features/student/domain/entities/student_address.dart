/// A student's present/permanent home address — district/sub-district
/// reference the shared BD-districts dataset (see
/// `lib/features/association/data/models/bd_district.dart`) by slug ID,
/// mirroring how the backend denormalizes Association's district fields.
///
/// Distinct from the marketplace `Address` model (per-order shipping
/// snapshot) — this is identity-level data used to prefill it.
class StudentAddress {
  final String districtId;
  final String districtName;
  final String? subDistrictId;
  final String? subDistrictName;
  final String? addressLine;

  StudentAddress({
    required this.districtId,
    required this.districtName,
    this.subDistrictId,
    this.subDistrictName,
    this.addressLine,
  });

  factory StudentAddress.fromJson(Map<String, dynamic> json) {
    return StudentAddress(
      districtId: json['district_id'] as String? ?? '',
      districtName: json['district_name'] as String? ?? '',
      subDistrictId: json['sub_district_id'] as String?,
      subDistrictName: json['sub_district_name'] as String?,
      addressLine: json['address_line'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'district_id': districtId,
    if (subDistrictId != null) 'sub_district_id': subDistrictId,
    if (addressLine != null) 'address_line': addressLine,
  };

  String get displayLabel {
    final parts = [
      if (addressLine != null && addressLine!.isNotEmpty) addressLine,
      if (subDistrictName != null) subDistrictName,
      districtName,
    ];
    return parts.join(', ');
  }
}
