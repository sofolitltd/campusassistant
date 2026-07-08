// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'emergency_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(emergencyRemoteDataSource)
final emergencyRemoteDataSourceProvider = EmergencyRemoteDataSourceProvider._();

final class EmergencyRemoteDataSourceProvider
    extends
        $FunctionalProvider<
          EmergencyRemoteDataSource,
          EmergencyRemoteDataSource,
          EmergencyRemoteDataSource
        >
    with $Provider<EmergencyRemoteDataSource> {
  EmergencyRemoteDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'emergencyRemoteDataSourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$emergencyRemoteDataSourceHash();

  @$internal
  @override
  $ProviderElement<EmergencyRemoteDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  EmergencyRemoteDataSource create(Ref ref) {
    return emergencyRemoteDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(EmergencyRemoteDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<EmergencyRemoteDataSource>(value),
    );
  }
}

String _$emergencyRemoteDataSourceHash() =>
    r'bb434a7a8d64809bdc77649098503ab78595add5';

@ProviderFor(emergencyRepository)
final emergencyRepositoryProvider = EmergencyRepositoryProvider._();

final class EmergencyRepositoryProvider
    extends
        $FunctionalProvider<
          EmergencyRepository,
          EmergencyRepository,
          EmergencyRepository
        >
    with $Provider<EmergencyRepository> {
  EmergencyRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'emergencyRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$emergencyRepositoryHash();

  @$internal
  @override
  $ProviderElement<EmergencyRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  EmergencyRepository create(Ref ref) {
    return emergencyRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(EmergencyRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<EmergencyRepository>(value),
    );
  }
}

String _$emergencyRepositoryHash() =>
    r'6f253f907e00d098c904b86fde739675ed6bf489';

@ProviderFor(getEmergencyContacts)
final getEmergencyContactsProvider = GetEmergencyContactsProvider._();

final class GetEmergencyContactsProvider
    extends
        $FunctionalProvider<
          GetEmergencyContacts,
          GetEmergencyContacts,
          GetEmergencyContacts
        >
    with $Provider<GetEmergencyContacts> {
  GetEmergencyContactsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getEmergencyContactsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getEmergencyContactsHash();

  @$internal
  @override
  $ProviderElement<GetEmergencyContacts> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  GetEmergencyContacts create(Ref ref) {
    return getEmergencyContacts(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetEmergencyContacts value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GetEmergencyContacts>(value),
    );
  }
}

String _$getEmergencyContactsHash() =>
    r'abb2decd718bc20f41528400d5a0d099727b4a75';

@ProviderFor(EmergencySearchQuery)
final emergencySearchQueryProvider = EmergencySearchQueryProvider._();

final class EmergencySearchQueryProvider
    extends $NotifierProvider<EmergencySearchQuery, String> {
  EmergencySearchQueryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'emergencySearchQueryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$emergencySearchQueryHash();

  @$internal
  @override
  EmergencySearchQuery create() => EmergencySearchQuery();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$emergencySearchQueryHash() =>
    r'2fc8ca57165fbd5440d19a29450754a1e57356f7';

abstract class _$EmergencySearchQuery extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<String, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String, String>,
              String,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(EmergencyScope)
final emergencyScopeProvider = EmergencyScopeProvider._();

final class EmergencyScopeProvider
    extends $NotifierProvider<EmergencyScope, int> {
  EmergencyScopeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'emergencyScopeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$emergencyScopeHash();

  @$internal
  @override
  EmergencyScope create() => EmergencyScope();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$emergencyScopeHash() => r'234df756b427c6ae33bbae4b357911a5da7c3327';

abstract class _$EmergencyScope extends $Notifier<int> {
  int build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<int, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int, int>,
              int,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(EmergencyPagination)
final emergencyPaginationProvider = EmergencyPaginationFamily._();

final class EmergencyPaginationProvider
    extends $AsyncNotifierProvider<EmergencyPagination, EmergencyState> {
  EmergencyPaginationProvider._({
    required EmergencyPaginationFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'emergencyPaginationProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$emergencyPaginationHash();

  @override
  String toString() {
    return r'emergencyPaginationProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  EmergencyPagination create() => EmergencyPagination();

  @override
  bool operator ==(Object other) {
    return other is EmergencyPaginationProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$emergencyPaginationHash() =>
    r'575c1d71e5a75cc9846528d185d8bd23fe4d8428';

final class EmergencyPaginationFamily extends $Family
    with
        $ClassFamilyOverride<
          EmergencyPagination,
          AsyncValue<EmergencyState>,
          EmergencyState,
          FutureOr<EmergencyState>,
          int
        > {
  EmergencyPaginationFamily._()
    : super(
        retry: null,
        name: r'emergencyPaginationProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  EmergencyPaginationProvider call(int scopeIndex) =>
      EmergencyPaginationProvider._(argument: scopeIndex, from: this);

  @override
  String toString() => r'emergencyPaginationProvider';
}

abstract class _$EmergencyPagination extends $AsyncNotifier<EmergencyState> {
  late final _$args = ref.$arg as int;
  int get scopeIndex => _$args;

  FutureOr<EmergencyState> build(int scopeIndex);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<EmergencyState>, EmergencyState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<EmergencyState>, EmergencyState>,
              AsyncValue<EmergencyState>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}
