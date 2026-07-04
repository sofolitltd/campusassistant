// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'staff_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(staffRemoteDataSource)
final staffRemoteDataSourceProvider = StaffRemoteDataSourceProvider._();

final class StaffRemoteDataSourceProvider
    extends
        $FunctionalProvider<
          StaffRemoteDataSource,
          StaffRemoteDataSource,
          StaffRemoteDataSource
        >
    with $Provider<StaffRemoteDataSource> {
  StaffRemoteDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'staffRemoteDataSourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$staffRemoteDataSourceHash();

  @$internal
  @override
  $ProviderElement<StaffRemoteDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  StaffRemoteDataSource create(Ref ref) {
    return staffRemoteDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(StaffRemoteDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<StaffRemoteDataSource>(value),
    );
  }
}

String _$staffRemoteDataSourceHash() =>
    r'a25a8eefc1f84d74afcd05b3016010f441c6bfbc';

@ProviderFor(staffRepository)
final staffRepositoryProvider = StaffRepositoryProvider._();

final class StaffRepositoryProvider
    extends
        $FunctionalProvider<StaffRepository, StaffRepository, StaffRepository>
    with $Provider<StaffRepository> {
  StaffRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'staffRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$staffRepositoryHash();

  @$internal
  @override
  $ProviderElement<StaffRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  StaffRepository create(Ref ref) {
    return staffRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(StaffRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<StaffRepository>(value),
    );
  }
}

String _$staffRepositoryHash() => r'6fafde2ad036212ee7ecfc1f6d88e8a3455b3630';

@ProviderFor(staffList)
final staffListProvider = StaffListProvider._();

final class StaffListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Staff>>,
          List<Staff>,
          FutureOr<List<Staff>>
        >
    with $FutureModifier<List<Staff>>, $FutureProvider<List<Staff>> {
  StaffListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'staffListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$staffListHash();

  @$internal
  @override
  $FutureProviderElement<List<Staff>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Staff>> create(Ref ref) {
    return staffList(ref);
  }
}

String _$staffListHash() => r'948b3e74cf20d051a8404cb01bc5e99ab2be0e6a';

@ProviderFor(staffsByDepartment)
final staffsByDepartmentProvider = StaffsByDepartmentFamily._();

final class StaffsByDepartmentProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Staff>>,
          List<Staff>,
          FutureOr<List<Staff>>
        >
    with $FutureModifier<List<Staff>>, $FutureProvider<List<Staff>> {
  StaffsByDepartmentProvider._({
    required StaffsByDepartmentFamily super.from,
    required ({String universityId, String departmentId}) super.argument,
  }) : super(
         retry: null,
         name: r'staffsByDepartmentProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$staffsByDepartmentHash();

  @override
  String toString() {
    return r'staffsByDepartmentProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<List<Staff>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Staff>> create(Ref ref) {
    final argument =
        this.argument as ({String universityId, String departmentId});
    return staffsByDepartment(
      ref,
      universityId: argument.universityId,
      departmentId: argument.departmentId,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is StaffsByDepartmentProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$staffsByDepartmentHash() =>
    r'004351d04f88bd70f4104f97d08dbf79bd4e304d';

final class StaffsByDepartmentFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<Staff>>,
          ({String universityId, String departmentId})
        > {
  StaffsByDepartmentFamily._()
    : super(
        retry: null,
        name: r'staffsByDepartmentProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  StaffsByDepartmentProvider call({
    required String universityId,
    required String departmentId,
  }) => StaffsByDepartmentProvider._(
    argument: (universityId: universityId, departmentId: departmentId),
    from: this,
  );

  @override
  String toString() => r'staffsByDepartmentProvider';
}

@ProviderFor(createStaff)
final createStaffProvider = CreateStaffProvider._();

final class CreateStaffProvider
    extends
        $FunctionalProvider<
          Future<Staff> Function(Staff),
          Future<Staff> Function(Staff),
          Future<Staff> Function(Staff)
        >
    with $Provider<Future<Staff> Function(Staff)> {
  CreateStaffProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'createStaffProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$createStaffHash();

  @$internal
  @override
  $ProviderElement<Future<Staff> Function(Staff)> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  Future<Staff> Function(Staff) create(Ref ref) {
    return createStaff(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Future<Staff> Function(Staff) value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Future<Staff> Function(Staff)>(
        value,
      ),
    );
  }
}

String _$createStaffHash() => r'443d0c94d3da8484657012054e865a7ace14726a';

@ProviderFor(updateStaff)
final updateStaffProvider = UpdateStaffProvider._();

final class UpdateStaffProvider
    extends
        $FunctionalProvider<
          Future<Staff> Function(Staff),
          Future<Staff> Function(Staff),
          Future<Staff> Function(Staff)
        >
    with $Provider<Future<Staff> Function(Staff)> {
  UpdateStaffProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'updateStaffProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$updateStaffHash();

  @$internal
  @override
  $ProviderElement<Future<Staff> Function(Staff)> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  Future<Staff> Function(Staff) create(Ref ref) {
    return updateStaff(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Future<Staff> Function(Staff) value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Future<Staff> Function(Staff)>(
        value,
      ),
    );
  }
}

String _$updateStaffHash() => r'3bd757d31e5445e1af773143a2224408503d2b4f';

@ProviderFor(deleteStaff)
final deleteStaffProvider = DeleteStaffProvider._();

final class DeleteStaffProvider
    extends
        $FunctionalProvider<
          Future<void> Function(String),
          Future<void> Function(String),
          Future<void> Function(String)
        >
    with $Provider<Future<void> Function(String)> {
  DeleteStaffProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'deleteStaffProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$deleteStaffHash();

  @$internal
  @override
  $ProviderElement<Future<void> Function(String)> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  Future<void> Function(String) create(Ref ref) {
    return deleteStaff(ref);
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

String _$deleteStaffHash() => r'd2028dd40a03a00a96cef2314b09f2896fb860c8';
