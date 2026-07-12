// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chapter_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(chapterRemoteDataSource)
final chapterRemoteDataSourceProvider = ChapterRemoteDataSourceProvider._();

final class ChapterRemoteDataSourceProvider
    extends
        $FunctionalProvider<
          ChapterRemoteDataSource,
          ChapterRemoteDataSource,
          ChapterRemoteDataSource
        >
    with $Provider<ChapterRemoteDataSource> {
  ChapterRemoteDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'chapterRemoteDataSourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$chapterRemoteDataSourceHash();

  @$internal
  @override
  $ProviderElement<ChapterRemoteDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ChapterRemoteDataSource create(Ref ref) {
    return chapterRemoteDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ChapterRemoteDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ChapterRemoteDataSource>(value),
    );
  }
}

String _$chapterRemoteDataSourceHash() =>
    r'1a61116f38fc567343b5c9d95cd22dd93606396f';

@ProviderFor(chapterRepository)
final chapterRepositoryProvider = ChapterRepositoryProvider._();

final class ChapterRepositoryProvider
    extends
        $FunctionalProvider<
          ChapterRepository,
          ChapterRepository,
          ChapterRepository
        >
    with $Provider<ChapterRepository> {
  ChapterRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'chapterRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$chapterRepositoryHash();

  @$internal
  @override
  $ProviderElement<ChapterRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ChapterRepository create(Ref ref) {
    return chapterRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ChapterRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ChapterRepository>(value),
    );
  }
}

String _$chapterRepositoryHash() => r'ec119d098ff4205bfc6be82c7993a2ef0084bfd2';

@ProviderFor(chaptersForCourse)
final chaptersForCourseProvider = ChaptersForCourseFamily._();

final class ChaptersForCourseProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Chapter>>,
          List<Chapter>,
          FutureOr<List<Chapter>>
        >
    with $FutureModifier<List<Chapter>>, $FutureProvider<List<Chapter>> {
  ChaptersForCourseProvider._({
    required ChaptersForCourseFamily super.from,
    required ({
      String universityId,
      String departmentId,
      String courseCode,
      String? batchId,
    })
    super.argument,
  }) : super(
         retry: null,
         name: r'chaptersForCourseProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$chaptersForCourseHash();

  @override
  String toString() {
    return r'chaptersForCourseProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<List<Chapter>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Chapter>> create(Ref ref) {
    final argument =
        this.argument
            as ({
              String universityId,
              String departmentId,
              String courseCode,
              String? batchId,
            });
    return chaptersForCourse(
      ref,
      universityId: argument.universityId,
      departmentId: argument.departmentId,
      courseCode: argument.courseCode,
      batchId: argument.batchId,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ChaptersForCourseProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$chaptersForCourseHash() => r'1a2e5b5eedd7624a8812a3844ad2c0b0cb3fe566';

final class ChaptersForCourseFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<Chapter>>,
          ({
            String universityId,
            String departmentId,
            String courseCode,
            String? batchId,
          })
        > {
  ChaptersForCourseFamily._()
    : super(
        retry: null,
        name: r'chaptersForCourseProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ChaptersForCourseProvider call({
    required String universityId,
    required String departmentId,
    required String courseCode,
    String? batchId,
  }) => ChaptersForCourseProvider._(
    argument: (
      universityId: universityId,
      departmentId: departmentId,
      courseCode: courseCode,
      batchId: batchId,
    ),
    from: this,
  );

  @override
  String toString() => r'chaptersForCourseProvider';
}

@ProviderFor(chapterActions)
final chapterActionsProvider = ChapterActionsProvider._();

final class ChapterActionsProvider
    extends $FunctionalProvider<ChapterActions, ChapterActions, ChapterActions>
    with $Provider<ChapterActions> {
  ChapterActionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'chapterActionsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$chapterActionsHash();

  @$internal
  @override
  $ProviderElement<ChapterActions> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ChapterActions create(Ref ref) {
    return chapterActions(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ChapterActions value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ChapterActions>(value),
    );
  }
}

String _$chapterActionsHash() => r'd929e4382a918bdfe23efa9636f3240a45afe7e8';
