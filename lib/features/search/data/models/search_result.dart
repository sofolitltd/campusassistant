import '/features/association/domain/entities/association.dart';
import '/features/career/circular/data/models/career_circular.dart';
import '/features/club/data/models/club_model.dart';
import '/features/club/domain/entities/club.dart';
import '/features/course/data/models/course_model.dart';
import '/features/course/domain/entities/course.dart';
import '/features/lost_found/data/models/lost_found_item.dart';
import '/features/marketplace/data/models/product.dart';
import '/features/notice/data/models/notice_model.dart';
import '/features/resource/data/models/resource_model.dart';
import '/features/resource/domain/entities/resource.dart';
import '/features/staff/data/models/staff_model.dart';
import '/features/staff/domain/entities/staff.dart';
import '/features/teacher/data/models/teacher_model.dart';
import '/features/teacher/domain/entities/teacher.dart';

/// Models for the unified `GET /search` endpoint response:
/// ```json
/// {
///   "data": {
///     "query": "string",
///     "total": 0,
///     "results": {
///       "resource": [<raw Resource>], "course": [<raw Course>],
///       "notice": [<raw Notice>], "club": [<raw Club>],
///       "association": [<raw Association>], "teacher": [<raw Teacher>],
///       "staff": [<raw Staff>], "marketplace": [<raw Product>],
///       "lost_found": [<raw LostFoundItem>], "career": [<raw CareerCircular>]
///     }
///   }
/// }
/// ```
/// Each category's array is the FULL raw entity JSON — byte-identical in
/// shape to what that entity's own dedicated list endpoint returns (e.g.
/// `GET /resources`, `GET /clubs`, ...), so results here can be rendered
/// with the exact same widgets those list pages use. Every list is parsed
/// using each feature's existing model, never hand-rolled parsing.
///
/// Keys present depend on the requested `types` filter (default: all 10); a
/// type with no matches may be an absent key or an empty list — both are
/// handled the same way here (default to `[]`).
class SearchResults {
  final String query;
  final int total;
  final List<Resource> resources;
  final List<Course> courses;
  final List<NoticeModel> notices;
  final List<Club> clubs;
  final List<Association> associations;
  final List<Teacher> teachers;
  final List<Staff> staffList;
  final List<Product> products;
  final List<LostFoundItem> lostFoundItems;
  final List<CareerCircular> careerCirculars;

  const SearchResults({
    required this.query,
    required this.total,
    required this.resources,
    required this.courses,
    required this.notices,
    required this.clubs,
    required this.associations,
    required this.teachers,
    required this.staffList,
    required this.products,
    required this.lostFoundItems,
    required this.careerCirculars,
  });

  bool get isEmpty => total == 0;

  /// Only [resources] is ever overridden today (resource-subtype chip
  /// filtering) — recomputes [total] to match so `isEmpty` stays correct.
  SearchResults copyWith({List<Resource>? resources}) {
    final newResources = resources ?? this.resources;
    return SearchResults(
      query: query,
      total: total - this.resources.length + newResources.length,
      resources: newResources,
      courses: courses,
      notices: notices,
      clubs: clubs,
      associations: associations,
      teachers: teachers,
      staffList: staffList,
      products: products,
      lostFoundItems: lostFoundItems,
      careerCirculars: careerCirculars,
    );
  }

  static List<T> _parseList<T>(
    Map<String, dynamic> rawResults,
    String key,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    final list = rawResults[key] as List? ?? const [];
    return list.whereType<Map<String, dynamic>>().map(fromJson).toList();
  }

  factory SearchResults.fromJson(Map<String, dynamic> json) {
    final rawResults = json['results'] as Map<String, dynamic>? ?? {};

    final resources = _parseList(
      rawResults,
      'resource',
      (e) => ResourceModel.fromJson(e).toEntity(),
    );
    final courses = _parseList(
      rawResults,
      'course',
      (e) => CourseModel.fromJson(e).toEntity(),
    );
    final notices = _parseList(rawResults, 'notice', NoticeModel.fromJson);
    final clubs = _parseList(
      rawResults,
      'club',
      (e) => ClubModel.fromJson(e).toEntity(),
    );
    final associations = _parseList(
      rawResults,
      'association',
      Association.fromJson,
    );
    final teachers = _parseList(
      rawResults,
      'teacher',
      (e) => TeacherModel.fromJson(e).toEntity(),
    );
    final staffList = _parseList(
      rawResults,
      'staff',
      (e) => StaffModel.fromJson(e).toEntity(),
    );
    final products = _parseList(rawResults, 'marketplace', Product.fromJson);
    final lostFoundItems = _parseList(
      rawResults,
      'lost_found',
      LostFoundItem.fromJson,
    );
    final careerCirculars = _parseList(
      rawResults,
      'career',
      CareerCircular.fromJson,
    );

    // The backend also sends a `total`, but recompute client-side from the
    // parsed lists defensively in case of drift between the two.
    final computedTotal = resources.length +
        courses.length +
        notices.length +
        clubs.length +
        associations.length +
        teachers.length +
        staffList.length +
        products.length +
        lostFoundItems.length +
        careerCirculars.length;

    return SearchResults(
      query: json['query']?.toString() ?? '',
      total: computedTotal,
      resources: resources,
      courses: courses,
      notices: notices,
      clubs: clubs,
      associations: associations,
      teachers: teachers,
      staffList: staffList,
      products: products,
      lostFoundItems: lostFoundItems,
      careerCirculars: careerCirculars,
    );
  }
}
