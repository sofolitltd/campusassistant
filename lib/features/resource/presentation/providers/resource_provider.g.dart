// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resource_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(resourceRepository)
final resourceRepositoryProvider = ResourceRepositoryProvider._();

final class ResourceRepositoryProvider
    extends
        $FunctionalProvider<
          ResourceRepository,
          ResourceRepository,
          ResourceRepository
        >
    with $Provider<ResourceRepository> {
  ResourceRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'resourceRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$resourceRepositoryHash();

  @$internal
  @override
  $ProviderElement<ResourceRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ResourceRepository create(Ref ref) {
    return resourceRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ResourceRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ResourceRepository>(value),
    );
  }
}

String _$resourceRepositoryHash() =>
    r'1f6161fd29c0aa34c2d2fba43b8a4ac27ffe7e3e';

@ProviderFor(resourcesList)
final resourcesListProvider = ResourcesListFamily._();

final class ResourcesListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Resource>>,
          List<Resource>,
          FutureOr<List<Resource>>
        >
    with $FutureModifier<List<Resource>>, $FutureProvider<List<Resource>> {
  ResourcesListProvider._({
    required ResourcesListFamily super.from,
    required ({
      String universityId,
      String departmentId,
      String? type,
      String? courseCode,
      String? batch,
      String? batchId,
      int? lessonNo,
      String? uploaderUid,
      String? status,
      int? limit,
      int? offset,
    })
    super.argument,
  }) : super(
         retry: null,
         name: r'resourcesListProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$resourcesListHash();

  @override
  String toString() {
    return r'resourcesListProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<List<Resource>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Resource>> create(Ref ref) {
    final argument =
        this.argument
            as ({
              String universityId,
              String departmentId,
              String? type,
              String? courseCode,
              String? batch,
              String? batchId,
              int? lessonNo,
              String? uploaderUid,
              String? status,
              int? limit,
              int? offset,
            });
    return resourcesList(
      ref,
      universityId: argument.universityId,
      departmentId: argument.departmentId,
      type: argument.type,
      courseCode: argument.courseCode,
      batch: argument.batch,
      batchId: argument.batchId,
      lessonNo: argument.lessonNo,
      uploaderUid: argument.uploaderUid,
      status: argument.status,
      limit: argument.limit,
      offset: argument.offset,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ResourcesListProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$resourcesListHash() => r'e7d1c88dc282e9c13f60623e0a881c478b27d6e3';

final class ResourcesListFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<Resource>>,
          ({
            String universityId,
            String departmentId,
            String? type,
            String? courseCode,
            String? batch,
            String? batchId,
            int? lessonNo,
            String? uploaderUid,
            String? status,
            int? limit,
            int? offset,
          })
        > {
  ResourcesListFamily._()
    : super(
        retry: null,
        name: r'resourcesListProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ResourcesListProvider call({
    required String universityId,
    required String departmentId,
    String? type,
    String? courseCode,
    String? batch,
    String? batchId,
    int? lessonNo,
    String? uploaderUid,
    String? status,
    int? limit,
    int? offset,
  }) => ResourcesListProvider._(
    argument: (
      universityId: universityId,
      departmentId: departmentId,
      type: type,
      courseCode: courseCode,
      batch: batch,
      batchId: batchId,
      lessonNo: lessonNo,
      uploaderUid: uploaderUid,
      status: status,
      limit: limit,
      offset: offset,
    ),
    from: this,
  );

  @override
  String toString() => r'resourcesListProvider';
}

@ProviderFor(createResource)
final createResourceProvider = CreateResourceProvider._();

final class CreateResourceProvider
    extends
        $FunctionalProvider<
          Future<Resource> Function(Resource),
          Future<Resource> Function(Resource),
          Future<Resource> Function(Resource)
        >
    with $Provider<Future<Resource> Function(Resource)> {
  CreateResourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'createResourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$createResourceHash();

  @$internal
  @override
  $ProviderElement<Future<Resource> Function(Resource)> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  Future<Resource> Function(Resource) create(Ref ref) {
    return createResource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Future<Resource> Function(Resource) value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Future<Resource> Function(Resource)>(
        value,
      ),
    );
  }
}

String _$createResourceHash() => r'744b09d140f3bfe7193afe16745c1fcd131ce5ea';

@ProviderFor(updateResource)
final updateResourceProvider = UpdateResourceProvider._();

final class UpdateResourceProvider
    extends
        $FunctionalProvider<
          Future<Resource> Function(Resource),
          Future<Resource> Function(Resource),
          Future<Resource> Function(Resource)
        >
    with $Provider<Future<Resource> Function(Resource)> {
  UpdateResourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'updateResourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$updateResourceHash();

  @$internal
  @override
  $ProviderElement<Future<Resource> Function(Resource)> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  Future<Resource> Function(Resource) create(Ref ref) {
    return updateResource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Future<Resource> Function(Resource) value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Future<Resource> Function(Resource)>(
        value,
      ),
    );
  }
}

String _$updateResourceHash() => r'0f00f946c5d14636d83ad825afdf26ef8366d277';
