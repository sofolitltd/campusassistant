import 'career_user.dart';

enum CareerJobStatus { pending, applied, completed }

/// Opt-in peer sharing: a job defaults to private (never shown to anyone
/// else). Sharing at batch/department/university snapshots the poster's own
/// affiliation at creation time — mirrors Community's post scope.
enum CareerJobScope { private_, batch, department, university }

CareerJobScope careerJobScopeFromString(String? value) {
  switch (value) {
    case 'batch':
      return CareerJobScope.batch;
    case 'department':
      return CareerJobScope.department;
    case 'university':
      return CareerJobScope.university;
    default:
      return CareerJobScope.private_;
  }
}

String careerJobScopeToString(CareerJobScope scope) =>
    scope == CareerJobScope.private_ ? 'private' : scope.name;

CareerJobStatus careerJobStatusFromString(String? value) {
  switch (value) {
    case 'applied':
      return CareerJobStatus.applied;
    case 'completed':
      return CareerJobStatus.completed;
    default:
      return CareerJobStatus.pending;
  }
}

String careerJobStatusToString(CareerJobStatus status) => status.name;

class CareerJob {
  final String id;
  final String? circularId;
  final String title;
  final String organization;
  final String postLink;
  final String resourceLink;
  final List<String> attachmentUrls;
  final DateTime? publishDate;
  final DateTime? deadlineDate;
  final CareerJobStatus status;
  final String notes;
  final DateTime createdAt;
  final CareerJobScope scope;
  final CareerUser? poster;

  CareerJob({
    required this.id,
    this.circularId,
    required this.title,
    required this.organization,
    required this.postLink,
    required this.resourceLink,
    this.attachmentUrls = const [],
    this.publishDate,
    this.deadlineDate,
    required this.status,
    this.notes = '',
    required this.createdAt,
    this.scope = CareerJobScope.private_,
    this.poster,
  });

  bool get isPastDeadline =>
      deadlineDate != null && deadlineDate!.isBefore(DateTime.now());

  factory CareerJob.fromJson(Map<String, dynamic> json) {
    final attachmentsJson = json['attachment_urls'] as List? ?? [];
    final posterJson = json['poster'] as Map<String, dynamic>?;
    return CareerJob(
      id: json['id'] as String? ?? '',
      circularId: json['circular_id'] as String?,
      title: json['title'] as String? ?? '',
      organization: json['organization'] as String? ?? '',
      postLink: json['post_link'] as String? ?? '',
      resourceLink: json['resource_link'] as String? ?? '',
      attachmentUrls: attachmentsJson.map((e) => e.toString()).toList(),
      publishDate: json['publish_date'] != null
          ? DateTime.tryParse(json['publish_date'].toString())
          : null,
      deadlineDate: json['deadline_date'] != null
          ? DateTime.tryParse(json['deadline_date'].toString())
          : null,
      status: careerJobStatusFromString(json['status'] as String?),
      notes: json['notes'] as String? ?? '',
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? '') ??
          DateTime.now(),
      scope: careerJobScopeFromString(json['scope'] as String?),
      poster: posterJson != null && (posterJson['id'] as String?)?.isNotEmpty == true
          ? CareerUser.fromJson(posterJson)
          : null,
    );
  }

  Map<String, dynamic> toCreateJson() {
    return {
      'title': title,
      'organization': organization,
      'post_link': postLink,
      'resource_link': resourceLink,
      'attachment_urls': attachmentUrls,
      // Go's time.Time JSON unmarshal requires an RFC3339 offset/Z suffix;
      // a bare local DateTime.toIso8601String() (e.g. "...T00:00:00.000")
      // has neither and fails to parse server-side, so always send UTC.
      if (publishDate != null) 'publish_date': publishDate!.toUtc().toIso8601String(),
      if (deadlineDate != null) 'deadline_date': deadlineDate!.toUtc().toIso8601String(),
      'notes': notes,
      'scope': careerJobScopeToString(scope),
    };
  }
}
