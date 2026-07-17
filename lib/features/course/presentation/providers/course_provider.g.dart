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

String _$courseRepositoryHash() => r'32e108d810cddf7689d2f11faec5d688e34b5ffe';

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
      String? semesterId,
      String? batchId,
    })
    super.argument,
  }) : super(
         retry: null,
         name: r'coursesProvider',
         isAutoDispose: false,
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
              String? semesterId,
              String? batchId,
            });
    return courses(
      ref,
      universityId: argument.universityId,
      departmentId: argument.departmentId,
      semesterId: argument.semesterId,
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

String _$coursesHash() => r'3ac4b2139d8a79518336ae66e7e49074bc36fa86';

final class CoursesFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<Course>>,
          ({
            String universityId,
            String departmentId,
            String? semesterId,
            String? batchId,
          })
        > {
  CoursesFamily._()
    : super(
        retry: null,
        name: r'coursesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
      );

  CoursesProvider call({
    required String universityId,
    required String departmentId,
    String? semesterId,
    String? batchId,
  }) => CoursesProvider._(
    argument: (
      universityId: universityId,
      departmentId: departmentId,
      semesterId: semesterId,
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
    required ({
      String universityId,
      String departmentId,
      String courseCode,
      String? batchId,
      String? semesterId,
    })
    super.argument,
  }) : super(
         retry: null,
         name: r'courseByCodeProvider',
         isAutoDispose: false,
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
            as ({
              String universityId,
              String departmentId,
              String courseCode,
              String? batchId,
              String? semesterId,
            });
    return courseByCode(
      ref,
      universityId: argument.universityId,
      departmentId: argument.departmentId,
      courseCode: argument.courseCode,
      batchId: argument.batchId,
      semesterId: argument.semesterId,
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

String _$courseByCodeHash() => r'd27c3c319a459aa7094465e211765862b25e4f39';

final class CourseByCodeFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<Course?>,
          ({
            String universityId,
            String departmentId,
            String courseCode,
            String? batchId,
            String? semesterId,
          })
        > {
  CourseByCodeFamily._()
    : super(
        retry: null,
        name: r'courseByCodeProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
      );

  CourseByCodeProvider call({
    required String universityId,
    required String departmentId,
    required String courseCode,
    String? batchId,
    String? semesterId,
  }) => CourseByCodeProvider._(
    argument: (
      universityId: universityId,
      departmentId: departmentId,
      courseCode: courseCode,
      batchId: batchId,
      semesterId: semesterId,
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
      String? semesterId,
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
              String? semesterId,
              String? batchId,
            });
    return groupedCourses(
      ref,
      universityId: argument.universityId,
      departmentId: argument.departmentId,
      semesterId: argument.semesterId,
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

String _$groupedCoursesHash() => r'b74047c17be9fa22be622618625e26f761a7be34';

final class GroupedCoursesFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<Map<String, List<Course>>>,
          ({
            String universityId,
            String departmentId,
            String? semesterId,
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
    String? semesterId,
    String? batchId,
  }) => GroupedCoursesProvider._(
    argument: (
      universityId: universityId,
      departmentId: departmentId,
      semesterId: semesterId,
      batchId: batchId,
    ),
    from: this,
  );

  @override
  String toString() => r'groupedCoursesProvider';
}
