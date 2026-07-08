// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notice_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(noticeRemoteDataSource)
final noticeRemoteDataSourceProvider = NoticeRemoteDataSourceProvider._();

final class NoticeRemoteDataSourceProvider
    extends
        $FunctionalProvider<
          NoticeRemoteDataSource,
          NoticeRemoteDataSource,
          NoticeRemoteDataSource
        >
    with $Provider<NoticeRemoteDataSource> {
  NoticeRemoteDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'noticeRemoteDataSourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$noticeRemoteDataSourceHash();

  @$internal
  @override
  $ProviderElement<NoticeRemoteDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  NoticeRemoteDataSource create(Ref ref) {
    return noticeRemoteDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NoticeRemoteDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NoticeRemoteDataSource>(value),
    );
  }
}

String _$noticeRemoteDataSourceHash() =>
    r'df82dfadaee6de998eeeb72a6bf8e0a899fc01c9';

@ProviderFor(noticeRepository)
final noticeRepositoryProvider = NoticeRepositoryProvider._();

final class NoticeRepositoryProvider
    extends
        $FunctionalProvider<
          NoticeRepository,
          NoticeRepository,
          NoticeRepository
        >
    with $Provider<NoticeRepository> {
  NoticeRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'noticeRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$noticeRepositoryHash();

  @$internal
  @override
  $ProviderElement<NoticeRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  NoticeRepository create(Ref ref) {
    return noticeRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NoticeRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NoticeRepository>(value),
    );
  }
}

String _$noticeRepositoryHash() => r'e86cf440333bbff6922f2dec1146ec9305d5541d';

@ProviderFor(departmentNotices)
final departmentNoticesProvider = DepartmentNoticesProvider._();

final class DepartmentNoticesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<NoticeModel>>,
          List<NoticeModel>,
          FutureOr<List<NoticeModel>>
        >
    with
        $FutureModifier<List<NoticeModel>>,
        $FutureProvider<List<NoticeModel>> {
  DepartmentNoticesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'departmentNoticesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$departmentNoticesHash();

  @$internal
  @override
  $FutureProviderElement<List<NoticeModel>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<NoticeModel>> create(Ref ref) {
    return departmentNotices(ref);
  }
}

String _$departmentNoticesHash() => r'd11f6e74b9f6c67c510cc4a2b38a6cad1d09f35b';
