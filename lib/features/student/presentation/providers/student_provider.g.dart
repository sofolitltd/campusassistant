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

String _$studentRepositoryHash() => r'0da05bbea6ee99fd197ff024101745d0484bd415';

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

String _$studentsByBatchHash() => r'14dc6ebb12008fcf46847c9a65aa29da5cb5443e';

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
         isAutoDispose: true,
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

String _$studentByUserIdHash() => r'284f25cf513719d0e65ec6c92f2602d56954b856';

final class StudentByUserIdFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Student?>, String> {
  StudentByUserIdFamily._()
    : super(
        retry: null,
        name: r'studentByUserIdProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
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
        isAutoDispose: true,
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

String _$studentProfileHash() => r'df3af14a7f3e3e7e84e22fc7d7c5d86bb5ed3b41';

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

String _$allStudentsHash() => r'a5f0707808b27d023d1bfba1f34a2304ce7bd0ad';

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
