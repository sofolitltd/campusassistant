// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'syllabus_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(syllabusRepository)
final syllabusRepositoryProvider = SyllabusRepositoryProvider._();

final class SyllabusRepositoryProvider
    extends
        $FunctionalProvider<
          SyllabusRepository,
          SyllabusRepository,
          SyllabusRepository
        >
    with $Provider<SyllabusRepository> {
  SyllabusRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'syllabusRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$syllabusRepositoryHash();

  @$internal
  @override
  $ProviderElement<SyllabusRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SyllabusRepository create(Ref ref) {
    return syllabusRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SyllabusRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SyllabusRepository>(value),
    );
  }
}

String _$syllabusRepositoryHash() =>
    r'5845e22b92a3a1654bd6013552ae375454c3b4db';

@ProviderFor(SyllabusSearchQuery)
final syllabusSearchQueryProvider = SyllabusSearchQueryProvider._();

final class SyllabusSearchQueryProvider
    extends $NotifierProvider<SyllabusSearchQuery, String> {
  SyllabusSearchQueryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'syllabusSearchQueryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$syllabusSearchQueryHash();

  @$internal
  @override
  SyllabusSearchQuery create() => SyllabusSearchQuery();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$syllabusSearchQueryHash() =>
    r'd999648f50321c4b30b6ea4cd6a71e547a05be6e';

abstract class _$SyllabusSearchQuery extends $Notifier<String> {
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

@ProviderFor(SyllabusPagination)
final syllabusPaginationProvider = SyllabusPaginationProvider._();

final class SyllabusPaginationProvider
    extends $AsyncNotifierProvider<SyllabusPagination, SyllabusState> {
  SyllabusPaginationProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'syllabusPaginationProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$syllabusPaginationHash();

  @$internal
  @override
  SyllabusPagination create() => SyllabusPagination();
}

String _$syllabusPaginationHash() =>
    r'd6445c7285baa16abc9e5d4fcc53d80a62120786';

abstract class _$SyllabusPagination extends $AsyncNotifier<SyllabusState> {
  FutureOr<SyllabusState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<SyllabusState>, SyllabusState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<SyllabusState>, SyllabusState>,
              AsyncValue<SyllabusState>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
