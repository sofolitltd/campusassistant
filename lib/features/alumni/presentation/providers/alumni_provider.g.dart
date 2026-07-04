// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alumni_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(alumniRepository)
final alumniRepositoryProvider = AlumniRepositoryProvider._();

final class AlumniRepositoryProvider
    extends
        $FunctionalProvider<
          AlumniRepository,
          AlumniRepository,
          AlumniRepository
        >
    with $Provider<AlumniRepository> {
  AlumniRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'alumniRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$alumniRepositoryHash();

  @$internal
  @override
  $ProviderElement<AlumniRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AlumniRepository create(Ref ref) {
    return alumniRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AlumniRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AlumniRepository>(value),
    );
  }
}

String _$alumniRepositoryHash() => r'f1e9b244914d7353f17e5e00162634d95cead183';

@ProviderFor(AlumniSearchQuery)
final alumniSearchQueryProvider = AlumniSearchQueryProvider._();

final class AlumniSearchQueryProvider
    extends $NotifierProvider<AlumniSearchQuery, String> {
  AlumniSearchQueryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'alumniSearchQueryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$alumniSearchQueryHash();

  @$internal
  @override
  AlumniSearchQuery create() => AlumniSearchQuery();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$alumniSearchQueryHash() => r'e88e5a6dbfddfb2352784a684cf0e782851ec9b0';

abstract class _$AlumniSearchQuery extends $Notifier<String> {
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

@ProviderFor(AlumniScope)
final alumniScopeProvider = AlumniScopeProvider._();

final class AlumniScopeProvider extends $NotifierProvider<AlumniScope, int> {
  AlumniScopeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'alumniScopeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$alumniScopeHash();

  @$internal
  @override
  AlumniScope create() => AlumniScope();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$alumniScopeHash() => r'50319f31fe661bc20e20f44b4f0bd4671e90c1ee';

abstract class _$AlumniScope extends $Notifier<int> {
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

@ProviderFor(AlumniSelectedOrganization)
final alumniSelectedOrganizationProvider =
    AlumniSelectedOrganizationProvider._();

final class AlumniSelectedOrganizationProvider
    extends $NotifierProvider<AlumniSelectedOrganization, AlumniOrganization?> {
  AlumniSelectedOrganizationProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'alumniSelectedOrganizationProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$alumniSelectedOrganizationHash();

  @$internal
  @override
  AlumniSelectedOrganization create() => AlumniSelectedOrganization();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AlumniOrganization? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AlumniOrganization?>(value),
    );
  }
}

String _$alumniSelectedOrganizationHash() =>
    r'786821db7fbfd66d9a6ec3c1dde9f77264d02677';

abstract class _$AlumniSelectedOrganization
    extends $Notifier<AlumniOrganization?> {
  AlumniOrganization? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AlumniOrganization?, AlumniOrganization?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AlumniOrganization?, AlumniOrganization?>,
              AlumniOrganization?,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(AlumniPagination)
final alumniPaginationProvider = AlumniPaginationProvider._();

final class AlumniPaginationProvider
    extends $AsyncNotifierProvider<AlumniPagination, AlumniState> {
  AlumniPaginationProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'alumniPaginationProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$alumniPaginationHash();

  @$internal
  @override
  AlumniPagination create() => AlumniPagination();
}

String _$alumniPaginationHash() => r'c3f7ff459e2f07980601bd61b83ab7d7416fa236';

abstract class _$AlumniPagination extends $AsyncNotifier<AlumniState> {
  FutureOr<AlumniState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<AlumniState>, AlumniState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<AlumniState>, AlumniState>,
              AsyncValue<AlumniState>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(alumniOrganizations)
final alumniOrganizationsProvider = AlumniOrganizationsFamily._();

final class AlumniOrganizationsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<AlumniOrganization>>,
          List<AlumniOrganization>,
          FutureOr<List<AlumniOrganization>>
        >
    with
        $FutureModifier<List<AlumniOrganization>>,
        $FutureProvider<List<AlumniOrganization>> {
  AlumniOrganizationsProvider._({
    required AlumniOrganizationsFamily super.from,
    required String? super.argument,
  }) : super(
         retry: null,
         name: r'alumniOrganizationsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$alumniOrganizationsHash();

  @override
  String toString() {
    return r'alumniOrganizationsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<AlumniOrganization>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<AlumniOrganization>> create(Ref ref) {
    final argument = this.argument as String?;
    return alumniOrganizations(ref, search: argument);
  }

  @override
  bool operator ==(Object other) {
    return other is AlumniOrganizationsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$alumniOrganizationsHash() =>
    r'45e6f8618a35548429fd62cf3f2ee3cdccf900cb';

final class AlumniOrganizationsFamily extends $Family
    with
        $FunctionalFamilyOverride<FutureOr<List<AlumniOrganization>>, String?> {
  AlumniOrganizationsFamily._()
    : super(
        retry: null,
        name: r'alumniOrganizationsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  AlumniOrganizationsProvider call({String? search}) =>
      AlumniOrganizationsProvider._(argument: search, from: this);

  @override
  String toString() => r'alumniOrganizationsProvider';
}

@ProviderFor(alumniDetail)
final alumniDetailProvider = AlumniDetailFamily._();

final class AlumniDetailProvider
    extends $FunctionalProvider<AsyncValue<Alumni>, Alumni, FutureOr<Alumni>>
    with $FutureModifier<Alumni>, $FutureProvider<Alumni> {
  AlumniDetailProvider._({
    required AlumniDetailFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'alumniDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$alumniDetailHash();

  @override
  String toString() {
    return r'alumniDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Alumni> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Alumni> create(Ref ref) {
    final argument = this.argument as String;
    return alumniDetail(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is AlumniDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$alumniDetailHash() => r'aa91fec129ca2806e68703af6e80cb351e5a9ef4';

final class AlumniDetailFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Alumni>, String> {
  AlumniDetailFamily._()
    : super(
        retry: null,
        name: r'alumniDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  AlumniDetailProvider call(String id) =>
      AlumniDetailProvider._(argument: id, from: this);

  @override
  String toString() => r'alumniDetailProvider';
}
