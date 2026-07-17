// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(studentRepository)
final studentRepositoryProvider = StudentRepositoryProvider._();

final class StudentRepositoryProvider
    extends
        $FunctionalProvider<
          StudentRepository,
          StudentRepository,
          StudentRepository
        >
    with $Provider<StudentRepository> {
  StudentRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'studentRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$studentRepositoryHash();

  @$internal
  @override
  $ProviderElement<StudentRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  StudentRepository create(Ref ref) {
    return studentRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(StudentRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<StudentRepository>(value),
    );
  }
}

String _$studentRepositoryHash() => r'6798ad12cab5031814f7dc33dadc5d7aaaf08d30';

@ProviderFor(studentCountByBatch)
final studentCountByBatchProvider = StudentCountByBatchFamily._();

final class StudentCountByBatchProvider
    extends $FunctionalProvider<AsyncValue<int>, int, FutureOr<int>>
    with $FutureModifier<int>, $FutureProvider<int> {
  StudentCountByBatchProvider._({
    required StudentCountByBatchFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'studentCountByBatchProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$studentCountByBatchHash();

  @override
  String toString() {
    return r'studentCountByBatchProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<int> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<int> create(Ref ref) {
    final argument = this.argument as String;
    return studentCountByBatch(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is StudentCountByBatchProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$studentCountByBatchHash() =>
    r'c5a092d8532e91e9d8ac0e4fc2ecf50fa1e93a8b';

final class StudentCountByBatchFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<int>, String> {
  StudentCountByBatchFamily._()
    : super(
        retry: null,
        name: r'studentCountByBatchProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  StudentCountByBatchProvider call(String batchId) =>
      StudentCountByBatchProvider._(argument: batchId, from: this);

  @override
  String toString() => r'studentCountByBatchProvider';
}

@ProviderFor(studentCountAll)
final studentCountAllProvider = StudentCountAllFamily._();

final class StudentCountAllProvider
    extends $FunctionalProvider<AsyncValue<int>, int, FutureOr<int>>
    with $FutureModifier<int>, $FutureProvider<int> {
  StudentCountAllProvider._({
    required StudentCountAllFamily super.from,
    required ({String? universityId, String? departmentId}) super.argument,
  }) : super(
         retry: null,
         name: r'studentCountAllProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$studentCountAllHash();

  @override
  String toString() {
    return r'studentCountAllProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<int> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<int> create(Ref ref) {
    final argument =
        this.argument as ({String? universityId, String? departmentId});
    return studentCountAll(
      ref,
      universityId: argument.universityId,
      departmentId: argument.departmentId,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is StudentCountAllProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$studentCountAllHash() => r'1176dd08f2fddfd368599a44ba90479ada786d5f';

final class StudentCountAllFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<int>,
          ({String? universityId, String? departmentId})
        > {
  StudentCountAllFamily._()
    : super(
        retry: null,
        name: r'studentCountAllProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  StudentCountAllProvider call({String? universityId, String? departmentId}) =>
      StudentCountAllProvider._(
        argument: (universityId: universityId, departmentId: departmentId),
        from: this,
      );

  @override
  String toString() => r'studentCountAllProvider';
}

@ProviderFor(studentsByBatchPaginated)
final studentsByBatchPaginatedProvider = StudentsByBatchPaginatedFamily._();

final class StudentsByBatchPaginatedProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Student>>,
          List<Student>,
          FutureOr<List<Student>>
        >
    with $FutureModifier<List<Student>>, $FutureProvider<List<Student>> {
  StudentsByBatchPaginatedProvider._({
    required StudentsByBatchPaginatedFamily super.from,
    required ({String batchId, int limit, int offset}) super.argument,
  }) : super(
         retry: null,
         name: r'studentsByBatchPaginatedProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$studentsByBatchPaginatedHash();

  @override
  String toString() {
    return r'studentsByBatchPaginatedProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<List<Student>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Student>> create(Ref ref) {
    final argument = this.argument as ({String batchId, int limit, int offset});
    return studentsByBatchPaginated(
      ref,
      batchId: argument.batchId,
      limit: argument.limit,
      offset: argument.offset,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is StudentsByBatchPaginatedProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$studentsByBatchPaginatedHash() =>
    r'225cd8866edb81d2ea77b721e10e150da0a6d6ab';

final class StudentsByBatchPaginatedFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<Student>>,
          ({String batchId, int limit, int offset})
        > {
  StudentsByBatchPaginatedFamily._()
    : super(
        retry: null,
        name: r'studentsByBatchPaginatedProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  StudentsByBatchPaginatedProvider call({
    required String batchId,
    required int limit,
    required int offset,
  }) => StudentsByBatchPaginatedProvider._(
    argument: (batchId: batchId, limit: limit, offset: offset),
    from: this,
  );

  @override
  String toString() => r'studentsByBatchPaginatedProvider';
}

@ProviderFor(studentsWithTotalByBatchPaginated)
final studentsWithTotalByBatchPaginatedProvider =
    StudentsWithTotalByBatchPaginatedFamily._();

final class StudentsWithTotalByBatchPaginatedProvider
    extends
        $FunctionalProvider<
          AsyncValue<PaginatedStudents>,
          PaginatedStudents,
          FutureOr<PaginatedStudents>
        >
    with
        $FutureModifier<PaginatedStudents>,
        $FutureProvider<PaginatedStudents> {
  StudentsWithTotalByBatchPaginatedProvider._({
    required StudentsWithTotalByBatchPaginatedFamily super.from,
    required ({String batchId, int limit, int offset}) super.argument,
  }) : super(
         retry: null,
         name: r'studentsWithTotalByBatchPaginatedProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() =>
      _$studentsWithTotalByBatchPaginatedHash();

  @override
  String toString() {
    return r'studentsWithTotalByBatchPaginatedProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<PaginatedStudents> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<PaginatedStudents> create(Ref ref) {
    final argument = this.argument as ({String batchId, int limit, int offset});
    return studentsWithTotalByBatchPaginated(
      ref,
      batchId: argument.batchId,
      limit: argument.limit,
      offset: argument.offset,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is StudentsWithTotalByBatchPaginatedProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$studentsWithTotalByBatchPaginatedHash() =>
    r'5b7cccda02aa6d28d41de4857a0e0b04886148fc';

final class StudentsWithTotalByBatchPaginatedFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<PaginatedStudents>,
          ({String batchId, int limit, int offset})
        > {
  StudentsWithTotalByBatchPaginatedFamily._()
    : super(
        retry: null,
        name: r'studentsWithTotalByBatchPaginatedProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  StudentsWithTotalByBatchPaginatedProvider call({
    required String batchId,
    required int limit,
    required int offset,
  }) => StudentsWithTotalByBatchPaginatedProvider._(
    argument: (batchId: batchId, limit: limit, offset: offset),
    from: this,
  );

  @override
  String toString() => r'studentsWithTotalByBatchPaginatedProvider';
}

@ProviderFor(studentsByBatch)
final studentsByBatchProvider = StudentsByBatchFamily._();

final class StudentsByBatchProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Student>>,
          List<Student>,
          FutureOr<List<Student>>
        >
    with $FutureModifier<List<Student>>, $FutureProvider<List<Student>> {
  StudentsByBatchProvider._({
    required StudentsByBatchFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'studentsByBatchProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$studentsByBatchHash();

  @override
  String toString() {
    return r'studentsByBatchProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<Student>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Student>> create(Ref ref) {
    final argument = this.argument as String;
    return studentsByBatch(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is StudentsByBatchProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$studentsByBatchHash() => r'4310942820f50c5fefa4719eae888f6758354d4d';

final class StudentsByBatchFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<Student>>, String> {
  StudentsByBatchFamily._()
    : super(
        retry: null,
        name: r'studentsByBatchProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  StudentsByBatchProvider call(String batchId) =>
      StudentsByBatchProvider._(argument: batchId, from: this);

  @override
  String toString() => r'studentsByBatchProvider';
}

@ProviderFor(studentByUserId)
final studentByUserIdProvider = StudentByUserIdFamily._();

final class StudentByUserIdProvider
    extends
        $FunctionalProvider<AsyncValue<Student?>, Student?, FutureOr<Student?>>
    with $FutureModifier<Student?>, $FutureProvider<Student?> {
  StudentByUserIdProvider._({
    required StudentByUserIdFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'studentByUserIdProvider',
         isAutoDispose: false,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$studentByUserIdHash();

  @override
  String toString() {
    return r'studentByUserIdProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Student?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Student?> create(Ref ref) {
    final argument = this.argument as String;
    return studentByUserId(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is StudentByUserIdProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$studentByUserIdHash() => r'ac1e7e4c3300017b15d31dec7b87827356ec1c4c';

final class StudentByUserIdFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Student?>, String> {
  StudentByUserIdFamily._()
    : super(
        retry: null,
        name: r'studentByUserIdProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
      );

  StudentByUserIdProvider call(String userId) =>
      StudentByUserIdProvider._(argument: userId, from: this);

  @override
  String toString() => r'studentByUserIdProvider';
}

@ProviderFor(studentByAcademicId)
final studentByAcademicIdProvider = StudentByAcademicIdFamily._();

final class StudentByAcademicIdProvider
    extends
        $FunctionalProvider<AsyncValue<Student?>, Student?, FutureOr<Student?>>
    with $FutureModifier<Student?>, $FutureProvider<Student?> {
  StudentByAcademicIdProvider._({
    required StudentByAcademicIdFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'studentByAcademicIdProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$studentByAcademicIdHash();

  @override
  String toString() {
    return r'studentByAcademicIdProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Student?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Student?> create(Ref ref) {
    final argument = this.argument as String;
    return studentByAcademicId(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is StudentByAcademicIdProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$studentByAcademicIdHash() =>
    r'a7f66069c06ad941950345c81d4927ac8dc83736';

final class StudentByAcademicIdFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Student?>, String> {
  StudentByAcademicIdFamily._()
    : super(
        retry: null,
        name: r'studentByAcademicIdProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  StudentByAcademicIdProvider call(String studentId) =>
      StudentByAcademicIdProvider._(argument: studentId, from: this);

  @override
  String toString() => r'studentByAcademicIdProvider';
}

@ProviderFor(studentProfile)
final studentProfileProvider = StudentProfileProvider._();

final class StudentProfileProvider
    extends
        $FunctionalProvider<AsyncValue<Student?>, Student?, FutureOr<Student?>>
    with $FutureModifier<Student?>, $FutureProvider<Student?> {
  StudentProfileProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'studentProfileProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$studentProfileHash();

  @$internal
  @override
  $FutureProviderElement<Student?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Student?> create(Ref ref) {
    return studentProfile(ref);
  }
}

String _$studentProfileHash() => r'b11df95cd482a24f827e99b1f258daf9006b6f77';

@ProviderFor(studentByCode)
final studentByCodeProvider = StudentByCodeFamily._();

final class StudentByCodeProvider
    extends $FunctionalProvider<AsyncValue<Student>, Student, FutureOr<Student>>
    with $FutureModifier<Student>, $FutureProvider<Student> {
  StudentByCodeProvider._({
    required StudentByCodeFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'studentByCodeProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$studentByCodeHash();

  @override
  String toString() {
    return r'studentByCodeProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Student> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Student> create(Ref ref) {
    final argument = this.argument as String;
    return studentByCode(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is StudentByCodeProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$studentByCodeHash() => r'36124f334288d4b38e14416e174dbeb8a8ac5ea1';

final class StudentByCodeFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Student>, String> {
  StudentByCodeFamily._()
    : super(
        retry: null,
        name: r'studentByCodeProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  StudentByCodeProvider call(String code) =>
      StudentByCodeProvider._(argument: code, from: this);

  @override
  String toString() => r'studentByCodeProvider';
}

@ProviderFor(allStudents)
final allStudentsProvider = AllStudentsFamily._();

final class AllStudentsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Student>>,
          List<Student>,
          FutureOr<List<Student>>
        >
    with $FutureModifier<List<Student>>, $FutureProvider<List<Student>> {
  AllStudentsProvider._({
    required AllStudentsFamily super.from,
    required ({String? universityId, String? departmentId}) super.argument,
  }) : super(
         retry: null,
         name: r'allStudentsProvider',
         isAutoDispose: false,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$allStudentsHash();

  @override
  String toString() {
    return r'allStudentsProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<List<Student>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Student>> create(Ref ref) {
    final argument =
        this.argument as ({String? universityId, String? departmentId});
    return allStudents(
      ref,
      universityId: argument.universityId,
      departmentId: argument.departmentId,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is AllStudentsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$allStudentsHash() => r'01319833812169e739bf2cce9dff63f15850a7db';

final class AllStudentsFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<Student>>,
          ({String? universityId, String? departmentId})
        > {
  AllStudentsFamily._()
    : super(
        retry: null,
        name: r'allStudentsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
      );

  AllStudentsProvider call({String? universityId, String? departmentId}) =>
      AllStudentsProvider._(
        argument: (universityId: universityId, departmentId: departmentId),
        from: this,
      );

  @override
  String toString() => r'allStudentsProvider';
}

@ProviderFor(studentsWithTotalAllPaginated)
final studentsWithTotalAllPaginatedProvider =
    StudentsWithTotalAllPaginatedFamily._();

final class StudentsWithTotalAllPaginatedProvider
    extends
        $FunctionalProvider<
          AsyncValue<PaginatedStudents>,
          PaginatedStudents,
          FutureOr<PaginatedStudents>
        >
    with
        $FutureModifier<PaginatedStudents>,
        $FutureProvider<PaginatedStudents> {
  StudentsWithTotalAllPaginatedProvider._({
    required StudentsWithTotalAllPaginatedFamily super.from,
    required ({
      String? universityId,
      String? departmentId,
      int limit,
      int offset,
    })
    super.argument,
  }) : super(
         retry: null,
         name: r'studentsWithTotalAllPaginatedProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$studentsWithTotalAllPaginatedHash();

  @override
  String toString() {
    return r'studentsWithTotalAllPaginatedProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<PaginatedStudents> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<PaginatedStudents> create(Ref ref) {
    final argument =
        this.argument
            as ({
              String? universityId,
              String? departmentId,
              int limit,
              int offset,
            });
    return studentsWithTotalAllPaginated(
      ref,
      universityId: argument.universityId,
      departmentId: argument.departmentId,
      limit: argument.limit,
      offset: argument.offset,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is StudentsWithTotalAllPaginatedProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$studentsWithTotalAllPaginatedHash() =>
    r'ef35462b47360fefcccfbbabe21aee20be7f592a';

final class StudentsWithTotalAllPaginatedFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<PaginatedStudents>,
          ({String? universityId, String? departmentId, int limit, int offset})
        > {
  StudentsWithTotalAllPaginatedFamily._()
    : super(
        retry: null,
        name: r'studentsWithTotalAllPaginatedProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  StudentsWithTotalAllPaginatedProvider call({
    required String? universityId,
    required String? departmentId,
    required int limit,
    required int offset,
  }) => StudentsWithTotalAllPaginatedProvider._(
    argument: (
      universityId: universityId,
      departmentId: departmentId,
      limit: limit,
      offset: offset,
    ),
    from: this,
  );

  @override
  String toString() => r'studentsWithTotalAllPaginatedProvider';
}
