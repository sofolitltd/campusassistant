/// Mirrors backend domain.BDDistrict / BDSubDistrict — the static list of
/// Bangladesh's 64 districts and their upazilas, served by GET /bd-districts.
class BDSubDistrict {
  final String id;
  final String name;

  BDSubDistrict({required this.id, required this.name});

  factory BDSubDistrict.fromJson(Map<String, dynamic> json) {
    return BDSubDistrict(
      id: json['id'] as String,
      name: json['name'] as String,
    );
  }
}

class BDDistrict {
  final String id;
  final String name;
  final String division;
  final List<BDSubDistrict> subDistricts;

  BDDistrict({
    required this.id,
    required this.name,
    required this.division,
    required this.subDistricts,
  });

  factory BDDistrict.fromJson(Map<String, dynamic> json) {
    final subs = json['sub_districts'] as List? ?? [];
    return BDDistrict(
      id: json['id'] as String,
      name: json['name'] as String,
      division: json['division'] as String? ?? '',
      subDistricts: subs
          .map((e) => BDSubDistrict.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
