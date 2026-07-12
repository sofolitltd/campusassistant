// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'batch_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(batchRemoteDataSource)
final batchRemoteDataSourceProvider = BatchRemoteDataSourceProvider._();

final class BatchRemoteDataSourceProvider
    extends
        $FunctionalProvider<
          BatchRemoteDataSource,
          BatchRemoteDataSource,
          BatchRemoteDataSource
        >
    with $Provider<BatchRemoteDataSource> {
  BatchRemoteDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'batchRemoteDataSourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$batchRemoteDataSourceHash();

  @$internal
  @override
  $ProviderElement<BatchRemoteDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  BatchRemoteDataSource create(Ref ref) {
    return batchRemoteDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BatchRemoteDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BatchRemoteDataSource>(value),
    );
  }
}

String _$batchRemoteDataSourceHash() =>
    r'eca8c8fac9c699e40a62765612de1d98b76f9a45';

@ProviderFor(batchRepository)
final batchRepositoryProvider = BatchRepositoryProvider._();

final class BatchRepositoryProvider
    extends
        $FunctionalProvider<BatchRepository, BatchRepository, BatchRepository>
    with $Provider<BatchRepository> {
  BatchRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'batchRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$batchRepositoryHash();

  @$internal
  @override
  $ProviderElement<BatchRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  BatchRepository create(Ref ref) {
    return batchRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BatchRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BatchRepository>(value),
    );
  }
}

String _$batchRepositoryHash() => r'a9b8c6d2592c11abed8faa0967513e552295ccc7';

@ProviderFor(createBatch)
final createBatchProvider = CreateBatchProvider._();

final class CreateBatchProvider
    extends $FunctionalProvider<CreateBatch, CreateBatch, CreateBatch>
    with $Provider<CreateBatch> {
  CreateBatchProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'createBatchProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$createBatchHash();

  @$internal
  @override
  $ProviderElement<CreateBatch> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  CreateBatch create(Ref ref) {
    return createBatch(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CreateBatch value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CreateBatch>(value),
    );
  }
}

String _$createBatchHash() => r'23b92dc5bd9587eb4c2603af409764494f3bca8e';

@ProviderFor(batchesByDepartment)
final batchesByDepartmentProvider = BatchesByDepartmentFamily._();

final class BatchesByDepartmentProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Batch>>,
          List<Batch>,
          FutureOr<List<Batch>>
        >
    with $FutureModifier<List<Batch>>, $FutureProvider<List<Batch>> {
  BatchesByDepartmentProvider._({
    required BatchesByDepartmentFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'batchesByDepartmentProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$batchesByDepartmentHash();

  @override
  String toString() {
    return r'batchesByDepartmentProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<Batch>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Batch>> create(Ref ref) {
    final argument = this.argument as String;
    return batchesByDepartment(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is BatchesByDepartmentProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$batchesByDepartmentHash() =>
    r'fcbd6247d1bac68474c8ce37a15b3b55387379a1';

final class BatchesByDepartmentFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<Batch>>, String> {
  BatchesByDepartmentFamily._()
    : super(
        retry: null,
        name: r'batchesByDepartmentProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  BatchesByDepartmentProvider call(String departmentId) =>
      BatchesByDepartmentProvider._(argument: departmentId, from: this);

  @override
  String toString() => r'batchesByDepartmentProvider';
}

@ProviderFor(batchById)
final batchByIdProvider = BatchByIdFamily._();

final class BatchByIdProvider
    extends $FunctionalProvider<AsyncValue<Batch?>, Batch?, FutureOr<Batch?>>
    with $FutureModifier<Batch?>, $FutureProvider<Batch?> {
  BatchByIdProvider._({
    required BatchByIdFamily super.from,
    required ({String departmentId, String id}) super.argument,
  }) : super(
         retry: null,
         name: r'batchByIdProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$batchByIdHash();

  @override
  String toString() {
    return r'batchByIdProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<Batch?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Batch?> create(Ref ref) {
    final argument = this.argument as ({String departmentId, String id});
    return batchById(ref, departmentId: argument.departmentId, id: argument.id);
  }

  @override
  bool operator ==(Object other) {
    return other is BatchByIdProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$batchByIdHash() => r'4401eec9d3a66175cc70cecdf996cab3104b0ca8';

final class BatchByIdFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<Batch?>,
          ({String departmentId, String id})
        > {
  BatchByIdFamily._()
    : super(
        retry: null,
        name: r'batchByIdProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  BatchByIdProvider call({required String departmentId, required String id}) =>
      BatchByIdProvider._(
        argument: (departmentId: departmentId, id: id),
        from: this,
      );

  @override
  String toString() => r'batchByIdProvider';
}

@ProviderFor(batchName)
final batchNameProvider = BatchNameFamily._();

final class BatchNameProvider
    extends $FunctionalProvider<String, String, String>
    with $Provider<String> {
  BatchNameProvider._({
    required BatchNameFamily super.from,
    required ({String departmentId, String id}) super.argument,
  }) : super(
         retry: null,
         name: r'batchNameProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$batchNameHash();

  @override
  String toString() {
    return r'batchNameProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $ProviderElement<String> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String create(Ref ref) {
    final argument = this.argument as ({String departmentId, String id});
    return batchName(ref, departmentId: argument.departmentId, id: argument.id);
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
    return other is BatchNameProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$batchNameHash() => r'bf17977956c022409794d48bfbf4f66feb3dbd75';

final class BatchNameFamily extends $Family
    with $FunctionalFamilyOverride<String, ({String departmentId, String id})> {
  BatchNameFamily._()
    : super(
        retry: null,
        name: r'batchNameProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  BatchNameProvider call({required String departmentId, required String id}) =>
      BatchNameProvider._(
        argument: (departmentId: departmentId, id: id),
        from: this,
      );

  @override
  String toString() => r'batchNameProvider';
}
