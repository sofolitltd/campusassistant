class ContributorModel {
  final String id;
  final String name;
  final String imageUrl;
  final String tier;
  final String universityName;
  final String departmentName;
  final String session;

  ContributorModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.tier,
    required this.universityName,
    required this.departmentName,
    required this.session,
  });

  factory ContributorModel.fromJson(Map<String, dynamic> json) {
    return ContributorModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      imageUrl: json['image_url'] as String? ?? '',
      tier: json['tier'] as String? ?? '',
      universityName: json['university_name'] as String? ?? '',
      departmentName: json['department_name'] as String? ?? '',
      session: json['session'] as String? ?? '',
    );
  }
}
