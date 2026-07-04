// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'teacher_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(teacherRemoteDataSource)
final teacherRemoteDataSourceProvider = TeacherRemoteDataSourceProvider._();

final class TeacherRemoteDataSourceProvider
    extends
        $FunctionalProvider<
          TeacherRemoteDataSource,
          TeacherRemoteDataSource,
          TeacherRemoteDataSource
        >
    with $Provider<TeacherRemoteDataSource> {
  TeacherRemoteDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'teacherRemoteDataSourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$teacherRemoteDataSourceHash();

  @$internal
  @override
  $ProviderElement<TeacherRemoteDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  TeacherRemoteDataSource create(Ref ref) {
    return teacherRemoteDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TeacherRemoteDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TeacherRemoteDataSource>(value),
    );
  }
}

String _$teacherRemoteDataSourceHash() =>
    r'7e90c52c6664ca9ad80b2905ba1a1ba711331816';

@ProviderFor(teacherRepository)
final teacherRepositoryProvider = TeacherRepositoryProvider._();

final class TeacherRepositoryProvider
    extends
        $FunctionalProvider<
          TeacherRepository,
          TeacherRepository,
          TeacherRepository
        >
    with $Provider<TeacherRepository> {
  TeacherRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'teacherRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$teacherRepositoryHash();

  @$internal
  @override
  $ProviderElement<TeacherRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  TeacherRepository create(Ref ref) {
    return teacherRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TeacherRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TeacherRepository>(value),
    );
  }
}

String _$teacherRepositoryHash() => r'53a6bc1a6603ed9fc00ae0bf4267a9038d0423e7';

@ProviderFor(getTeachers)
final getTeachersProvider = GetTeachersProvider._();

final class GetTeachersProvider
    extends $FunctionalProvider<GetTeachers, GetTeachers, GetTeachers>
    with $Provider<GetTeachers> {
  GetTeachersProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getTeachersProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getTeachersHash();

  @$internal
  @override
  $ProviderElement<GetTeachers> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GetTeachers create(Ref ref) {
    return getTeachers(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetTeachers value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GetTeachers>(value),
    );
  }
}

String _$getTeachersHash() => r'45ca62e0ad23f4248d2aa4a7741c07302700bb07';

@ProviderFor(teachersList)
final teachersListProvider = TeachersListFamily._();

final class TeachersListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Teacher>>,
          List<Teacher>,
          FutureOr<List<Teacher>>
        >
    with $FutureModifier<List<Teacher>>, $FutureProvider<List<Teacher>> {
  TeachersListProvider._({
    required TeachersListFamily super.from,
    required bool? super.argument,
  }) : super(
         retry: null,
         name: r'teachersListProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$teachersListHash();

  @override
  String toString() {
    return r'teachersListProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<Teacher>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Teacher>> create(Ref ref) {
    final argument = this.argument as bool?;
    return teachersList(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is TeachersListProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$teachersListHash() => r'c6850d56fac9dd50d84ee33fe06e23f2fa5bd525';

final class TeachersListFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<Teacher>>, bool?> {
  TeachersListFamily._()
    : super(
        retry: null,
        name: r'teachersListProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  TeachersListProvider call(bool? isPresent) =>
      TeachersListProvider._(argument: isPresent, from: this);

  @override
  String toString() => r'teachersListProvider';
}

@ProviderFor(singleTeacher)
final singleTeacherProvider = SingleTeacherFamily._();

final class SingleTeacherProvider
    extends $FunctionalProvider<AsyncValue<Teacher>, Teacher, FutureOr<Teacher>>
    with $FutureModifier<Teacher>, $FutureProvider<Teacher> {
  SingleTeacherProvider._({
    required SingleTeacherFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'singleTeacherProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$singleTeacherHash();

  @override
  String toString() {
    return r'singleTeacherProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Teacher> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Teacher> create(Ref ref) {
    final argument = this.argument as String;
    return singleTeacher(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is SingleTeacherProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$singleTeacherHash() => r'7f0634a85b330dfacf662dbd0ac4f5c55851d914';

final class SingleTeacherFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Teacher>, String> {
  SingleTeacherFamily._()
    : super(
        retry: null,
        name: r'singleTeacherProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  SingleTeacherProvider call(String teacherId) =>
      SingleTeacherProvider._(argument: teacherId, from: this);

  @override
  String toString() => r'singleTeacherProvider';
}

@ProviderFor(createTeacher)
final createTeacherProvider = CreateTeacherProvider._();

final class CreateTeacherProvider
    extends
        $FunctionalProvider<
          Future<Teacher> Function(Teacher),
          Future<Teacher> Function(Teacher),
          Future<Teacher> Function(Teacher)
        >
    with $Provider<Future<Teacher> Function(Teacher)> {
  CreateTeacherProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'createTeacherProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$createTeacherHash();

  @$internal
  @override
  $ProviderElement<Future<Teacher> Function(Teacher)> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  Future<Teacher> Function(Teacher) create(Ref ref) {
    return createTeacher(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Future<Teacher> Function(Teacher) value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Future<Teacher> Function(Teacher)>(
        value,
      ),
    );
  }
}

String _$createTeacherHash() => r'd23a6da9543285c036708c661763fa27bdb8b21a';

@ProviderFor(updateTeacher)
final updateTeacherProvider = UpdateTeacherProvider._();

final class UpdateTeacherProvider
    extends
        $FunctionalProvider<
          Future<Teacher> Function(Teacher),
          Future<Teacher> Function(Teacher),
          Future<Teacher> Function(Teacher)
        >
    with $Provider<Future<Teacher> Function(Teacher)> {
  UpdateTeacherProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'updateTeacherProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$updateTeacherHash();

  @$internal
  @override
  $ProviderElement<Future<Teacher> Function(Teacher)> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  Future<Teacher> Function(Teacher) create(Ref ref) {
    return updateTeacher(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Future<Teacher> Function(Teacher) value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Future<Teacher> Function(Teacher)>(
        value,
      ),
    );
  }
}

String _$updateTeacherHash() => r'11a5048f3fdfc6c8237ca5db693e7b3cfe62ac76';

@ProviderFor(deleteTeacher)
final deleteTeacherProvider = DeleteTeacherProvider._();

final class DeleteTeacherProvider
    extends
        $FunctionalProvider<
          Future<void> Function(String),
          Future<void> Function(String),
          Future<void> Function(String)
        >
    with $Provider<Future<void> Function(String)> {
  DeleteTeacherProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'deleteTeacherProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$deleteTeacherHash();

  @$internal
  @override
  $ProviderElement<Future<void> Function(String)> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  Future<void> Function(String) create(Ref ref) {
    return deleteTeacher(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Future<void> Function(String) value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Future<void> Function(String)>(
        value,
      ),
    );
  }
}

String _$deleteTeacherHash() => r'8deadd16506a69ce1c844fa88f44a75208fe6898';

@ProviderFor(teachersByDepartment)
final teachersByDepartmentProvider = TeachersByDepartmentFamily._();

final class TeachersByDepartmentProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Teacher>>,
          List<Teacher>,
          FutureOr<List<Teacher>>
        >
    with $FutureModifier<List<Teacher>>, $FutureProvider<List<Teacher>> {
  TeachersByDepartmentProvider._({
    required TeachersByDepartmentFamily super.from,
    required ({String universityId, String departmentId}) super.argument,
  }) : super(
         retry: null,
         name: r'teachersByDepartmentProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$teachersByDepartmentHash();

  @override
  String toString() {
    return r'teachersByDepartmentProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<List<Teacher>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Teacher>> create(Ref ref) {
    final argument =
        this.argument as ({String universityId, String departmentId});
    return teachersByDepartment(
      ref,
      universityId: argument.universityId,
      departmentId: argument.departmentId,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is TeachersByDepartmentProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$teachersByDepartmentHash() =>
    r'8f19e48713896112ccc8fdbfa494ccbec60277ce';

final class TeachersByDepartmentFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<Teacher>>,
          ({String universityId, String departmentId})
        > {
  TeachersByDepartmentFamily._()
    : super(
        retry: null,
        name: r'teachersByDepartmentProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  TeachersByDepartmentProvider call({
    required String universityId,
    required String departmentId,
  }) => TeachersByDepartmentProvider._(
    argument: (universityId: universityId, departmentId: departmentId),
    from: this,
  );

  @override
  String toString() => r'teachersByDepartmentProvider';
}
