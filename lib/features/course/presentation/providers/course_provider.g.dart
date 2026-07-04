// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(courseRepository)
final courseRepositoryProvider = CourseRepositoryProvider._();

final class CourseRepositoryProvider
    extends
        $FunctionalProvider<
          CourseRepository,
          CourseRepository,
          CourseRepository
        >
    with $Provider<CourseRepository> {
  CourseRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'courseRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$courseRepositoryHash();

  @$internal
  @override
  $ProviderElement<CourseRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  CourseRepository create(Ref ref) {
    return courseRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CourseRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CourseRepository>(value),
    );
  }
}

String _$courseRepositoryHash() => r'd384569ab245678a01d1658b9d8f352f98046773';

@ProviderFor(courses)
final coursesProvider = CoursesFamily._();

final class CoursesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Course>>,
          List<Course>,
          FutureOr<List<Course>>
        >
    with $FutureModifier<List<Course>>, $FutureProvider<List<Course>> {
  CoursesProvider._({
    required CoursesFamily super.from,
    required ({
      String universityId,
      String departmentId,
      String? courseYear,
      String? batchId,
    })
    super.argument,
  }) : super(
         retry: null,
         name: r'coursesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$coursesHash();

  @override
  String toString() {
    return r'coursesProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<List<Course>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Course>> create(Ref ref) {
    final argument =
        this.argument
            as ({
              String universityId,
              String departmentId,
              String? courseYear,
              String? batchId,
            });
    return courses(
      ref,
      universityId: argument.universityId,
      departmentId: argument.departmentId,
      courseYear: argument.courseYear,
      batchId: argument.batchId,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is CoursesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$coursesHash() => r'881b8175e7507d8d27bc35e29329bf540a9f9188';

final class CoursesFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<Course>>,
          ({
            String universityId,
            String departmentId,
            String? courseYear,
            String? batchId,
          })
        > {
  CoursesFamily._()
    : super(
        retry: null,
        name: r'coursesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  CoursesProvider call({
    required String universityId,
    required String departmentId,
    String? courseYear,
    String? batchId,
  }) => CoursesProvider._(
    argument: (
      universityId: universityId,
      departmentId: departmentId,
      courseYear: courseYear,
      batchId: batchId,
    ),
    from: this,
  );

  @override
  String toString() => r'coursesProvider';
}

@ProviderFor(courseByCode)
final courseByCodeProvider = CourseByCodeFamily._();

final class CourseByCodeProvider
    extends $FunctionalProvider<AsyncValue<Course?>, Course?, FutureOr<Course?>>
    with $FutureModifier<Course?>, $FutureProvider<Course?> {
  CourseByCodeProvider._({
    required CourseByCodeFamily super.from,
    required ({String universityId, String departmentId, String courseCode})
    super.argument,
  }) : super(
         retry: null,
         name: r'courseByCodeProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$courseByCodeHash();

  @override
  String toString() {
    return r'courseByCodeProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<Course?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Course?> create(Ref ref) {
    final argument =
        this.argument
            as ({String universityId, String departmentId, String courseCode});
    return courseByCode(
      ref,
      universityId: argument.universityId,
      departmentId: argument.departmentId,
      courseCode: argument.courseCode,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is CourseByCodeProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$courseByCodeHash() => r'909601589a144583424b8ab2ae9c0acce3366a30';

final class CourseByCodeFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<Course?>,
          ({String universityId, String departmentId, String courseCode})
        > {
  CourseByCodeFamily._()
    : super(
        retry: null,
        name: r'courseByCodeProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  CourseByCodeProvider call({
    required String universityId,
    required String departmentId,
    required String courseCode,
  }) => CourseByCodeProvider._(
    argument: (
      universityId: universityId,
      departmentId: departmentId,
      courseCode: courseCode,
    ),
    from: this,
  );

  @override
  String toString() => r'courseByCodeProvider';
}

@ProviderFor(groupedCourses)
final groupedCoursesProvider = GroupedCoursesFamily._();

final class GroupedCoursesProvider
    extends
        $FunctionalProvider<
          AsyncValue<Map<String, List<Course>>>,
          Map<String, List<Course>>,
          FutureOr<Map<String, List<Course>>>
        >
    with
        $FutureModifier<Map<String, List<Course>>>,
        $FutureProvider<Map<String, List<Course>>> {
  GroupedCoursesProvider._({
    required GroupedCoursesFamily super.from,
    required ({
      String universityId,
      String departmentId,
      String? courseYear,
      String? batchId,
    })
    super.argument,
  }) : super(
         retry: null,
         name: r'groupedCoursesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$groupedCoursesHash();

  @override
  String toString() {
    return r'groupedCoursesProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<Map<String, List<Course>>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Map<String, List<Course>>> create(Ref ref) {
    final argument =
        this.argument
            as ({
              String universityId,
              String departmentId,
              String? courseYear,
              String? batchId,
            });
    return groupedCourses(
      ref,
      universityId: argument.universityId,
      departmentId: argument.departmentId,
      courseYear: argument.courseYear,
      batchId: argument.batchId,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is GroupedCoursesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$groupedCoursesHash() => r'52606ebccb8bb32378d045ac08fc512bc850447f';

final class GroupedCoursesFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<Map<String, List<Course>>>,
          ({
            String universityId,
            String departmentId,
            String? courseYear,
            String? batchId,
          })
        > {
  GroupedCoursesFamily._()
    : super(
        retry: null,
        name: r'groupedCoursesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  GroupedCoursesProvider call({
    required String universityId,
    required String departmentId,
    String? courseYear,
    String? batchId,
  }) => GroupedCoursesProvider._(
    argument: (
      universityId: universityId,
      departmentId: departmentId,
      courseYear: courseYear,
      batchId: batchId,
    ),
    from: this,
  );

  @override
  String toString() => r'groupedCoursesProvider';
}
