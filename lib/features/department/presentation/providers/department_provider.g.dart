// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'department_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(departmentRemoteDataSource)
final departmentRemoteDataSourceProvider =
    DepartmentRemoteDataSourceProvider._();

final class DepartmentRemoteDataSourceProvider
    extends
        $FunctionalProvider<
          DepartmentRemoteDataSource,
          DepartmentRemoteDataSource,
          DepartmentRemoteDataSource
        >
    with $Provider<DepartmentRemoteDataSource> {
  DepartmentRemoteDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'departmentRemoteDataSourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$departmentRemoteDataSourceHash();

  @$internal
  @override
  $ProviderElement<DepartmentRemoteDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  DepartmentRemoteDataSource create(Ref ref) {
    return departmentRemoteDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DepartmentRemoteDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DepartmentRemoteDataSource>(value),
    );
  }
}

String _$departmentRemoteDataSourceHash() =>
    r'0be1085a269a4bfca3cf8032041f08d508e357ee';

@ProviderFor(departmentRepository)
final departmentRepositoryProvider = DepartmentRepositoryProvider._();

final class DepartmentRepositoryProvider
    extends
        $FunctionalProvider<
          DepartmentRepository,
          DepartmentRepository,
          DepartmentRepository
        >
    with $Provider<DepartmentRepository> {
  DepartmentRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'departmentRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$departmentRepositoryHash();

  @$internal
  @override
  $ProviderElement<DepartmentRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  DepartmentRepository create(Ref ref) {
    return departmentRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DepartmentRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DepartmentRepository>(value),
    );
  }
}

String _$departmentRepositoryHash() =>
    r'dc93d8e56d3cdc2edb3cba9df9ca54b009b2c03e';

@ProviderFor(getDepartments)
final getDepartmentsProvider = GetDepartmentsProvider._();

final class GetDepartmentsProvider
    extends $FunctionalProvider<GetDepartments, GetDepartments, GetDepartments>
    with $Provider<GetDepartments> {
  GetDepartmentsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getDepartmentsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getDepartmentsHash();

  @$internal
  @override
  $ProviderElement<GetDepartments> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GetDepartments create(Ref ref) {
    return getDepartments(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetDepartments value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GetDepartments>(value),
    );
  }
}

String _$getDepartmentsHash() => r'45d64a46843174eccc85d1a55bc295484bd113a7';

@ProviderFor(createDepartment)
final createDepartmentProvider = CreateDepartmentProvider._();

final class CreateDepartmentProvider
    extends
        $FunctionalProvider<
          CreateDepartment,
          CreateDepartment,
          CreateDepartment
        >
    with $Provider<CreateDepartment> {
  CreateDepartmentProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'createDepartmentProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$createDepartmentHash();

  @$internal
  @override
  $ProviderElement<CreateDepartment> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  CreateDepartment create(Ref ref) {
    return createDepartment(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CreateDepartment value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CreateDepartment>(value),
    );
  }
}

String _$createDepartmentHash() => r'fa317cc60f71486db7600e228b06da57fb48f037';

@ProviderFor(uploadDepartmentLogo)
final uploadDepartmentLogoProvider = UploadDepartmentLogoProvider._();

final class UploadDepartmentLogoProvider
    extends
        $FunctionalProvider<
          UploadDepartmentLogo,
          UploadDepartmentLogo,
          UploadDepartmentLogo
        >
    with $Provider<UploadDepartmentLogo> {
  UploadDepartmentLogoProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'uploadDepartmentLogoProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$uploadDepartmentLogoHash();

  @$internal
  @override
  $ProviderElement<UploadDepartmentLogo> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  UploadDepartmentLogo create(Ref ref) {
    return uploadDepartmentLogo(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UploadDepartmentLogo value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UploadDepartmentLogo>(value),
    );
  }
}

String _$uploadDepartmentLogoHash() =>
    r'6b26c87914623e598498ea0cef210182ec064817';

@ProviderFor(departmentsByUniversity)
final departmentsByUniversityProvider = DepartmentsByUniversityFamily._();

final class DepartmentsByUniversityProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Department>>,
          List<Department>,
          FutureOr<List<Department>>
        >
    with $FutureModifier<List<Department>>, $FutureProvider<List<Department>> {
  DepartmentsByUniversityProvider._({
    required DepartmentsByUniversityFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'departmentsByUniversityProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$departmentsByUniversityHash();

  @override
  String toString() {
    return r'departmentsByUniversityProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<Department>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Department>> create(Ref ref) {
    final argument = this.argument as String;
    return departmentsByUniversity(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is DepartmentsByUniversityProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$departmentsByUniversityHash() =>
    r'32bc1589d57d986123694bc6fcee7e84438e5827';

final class DepartmentsByUniversityFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<Department>>, String> {
  DepartmentsByUniversityFamily._()
    : super(
        retry: null,
        name: r'departmentsByUniversityProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  DepartmentsByUniversityProvider call(String universityId) =>
      DepartmentsByUniversityProvider._(argument: universityId, from: this);

  @override
  String toString() => r'departmentsByUniversityProvider';
}

@ProviderFor(myDepartments)
final myDepartmentsProvider = MyDepartmentsProvider._();

final class MyDepartmentsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Department>>,
          List<Department>,
          FutureOr<List<Department>>
        >
    with $FutureModifier<List<Department>>, $FutureProvider<List<Department>> {
  MyDepartmentsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'myDepartmentsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$myDepartmentsHash();

  @$internal
  @override
  $FutureProviderElement<List<Department>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Department>> create(Ref ref) {
    return myDepartments(ref);
  }
}

String _$myDepartmentsHash() => r'b06afebe68e8ffa8bf9e5c226034a349b81755dc';

@ProviderFor(myDepartment)
final myDepartmentProvider = MyDepartmentProvider._();

final class MyDepartmentProvider
    extends
        $FunctionalProvider<
          AsyncValue<Department>,
          Department,
          FutureOr<Department>
        >
    with $FutureModifier<Department>, $FutureProvider<Department> {
  MyDepartmentProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'myDepartmentProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$myDepartmentHash();

  @$internal
  @override
  $FutureProviderElement<Department> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Department> create(Ref ref) {
    return myDepartment(ref);
  }
}

String _$myDepartmentHash() => r'bfeb4a1b8b862a8ac9454b7a82de49ead9849826';

@ProviderFor(departmentById)
final departmentByIdProvider = DepartmentByIdFamily._();

final class DepartmentByIdProvider
    extends
        $FunctionalProvider<
          AsyncValue<Department?>,
          Department?,
          FutureOr<Department?>
        >
    with $FutureModifier<Department?>, $FutureProvider<Department?> {
  DepartmentByIdProvider._({
    required DepartmentByIdFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'departmentByIdProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$departmentByIdHash();

  @override
  String toString() {
    return r'departmentByIdProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Department?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Department?> create(Ref ref) {
    final argument = this.argument as String;
    return departmentById(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is DepartmentByIdProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$departmentByIdHash() => r'e69b5cb515e0ee7f130b80fad6f8b5e042155e83';

final class DepartmentByIdFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Department?>, String> {
  DepartmentByIdFamily._()
    : super(
        retry: null,
        name: r'departmentByIdProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  DepartmentByIdProvider call(String arg) =>
      DepartmentByIdProvider._(argument: arg, from: this);

  @override
  String toString() => r'departmentByIdProvider';
}

@ProviderFor(departmentName)
final departmentNameProvider = DepartmentNameFamily._();

final class DepartmentNameProvider
    extends $FunctionalProvider<String, String, String>
    with $Provider<String> {
  DepartmentNameProvider._({
    required DepartmentNameFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'departmentNameProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$departmentNameHash();

  @override
  String toString() {
    return r'departmentNameProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<String> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String create(Ref ref) {
    final argument = this.argument as String;
    return departmentName(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is DepartmentNameProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$departmentNameHash() => r'e8534560edfe0871015041e0ead5393d7b6deef6';

final class DepartmentNameFamily extends $Family
    with $FunctionalFamilyOverride<String, String> {
  DepartmentNameFamily._()
    : super(
        retry: null,
        name: r'departmentNameProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  DepartmentNameProvider call(String arg) =>
      DepartmentNameProvider._(argument: arg, from: this);

  @override
  String toString() => r'departmentNameProvider';
}
