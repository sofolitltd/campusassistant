// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'university_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(universityRemoteDataSource)
final universityRemoteDataSourceProvider =
    UniversityRemoteDataSourceProvider._();

final class UniversityRemoteDataSourceProvider
    extends
        $FunctionalProvider<
          UniversityRemoteDataSource,
          UniversityRemoteDataSource,
          UniversityRemoteDataSource
        >
    with $Provider<UniversityRemoteDataSource> {
  UniversityRemoteDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'universityRemoteDataSourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$universityRemoteDataSourceHash();

  @$internal
  @override
  $ProviderElement<UniversityRemoteDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  UniversityRemoteDataSource create(Ref ref) {
    return universityRemoteDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UniversityRemoteDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UniversityRemoteDataSource>(value),
    );
  }
}

String _$universityRemoteDataSourceHash() =>
    r'723ac86d2b252cf027e76b05aa580c0ad31e498c';

@ProviderFor(universityRepository)
final universityRepositoryProvider = UniversityRepositoryProvider._();

final class UniversityRepositoryProvider
    extends
        $FunctionalProvider<
          UniversityRepository,
          UniversityRepository,
          UniversityRepository
        >
    with $Provider<UniversityRepository> {
  UniversityRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'universityRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$universityRepositoryHash();

  @$internal
  @override
  $ProviderElement<UniversityRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  UniversityRepository create(Ref ref) {
    return universityRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UniversityRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UniversityRepository>(value),
    );
  }
}

String _$universityRepositoryHash() =>
    r'ac092824340958b6207c49d29fc89c878d92dfd0';

@ProviderFor(allUniversities)
final allUniversitiesProvider = AllUniversitiesProvider._();

final class AllUniversitiesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<University>>,
          List<University>,
          FutureOr<List<University>>
        >
    with $FutureModifier<List<University>>, $FutureProvider<List<University>> {
  AllUniversitiesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'allUniversitiesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$allUniversitiesHash();

  @$internal
  @override
  $FutureProviderElement<List<University>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<University>> create(Ref ref) {
    return allUniversities(ref);
  }
}

String _$allUniversitiesHash() => r'ea12d1c2cd68e40268e0e20210bab4f7a1f2b2cf';

@ProviderFor(myUniversity)
final myUniversityProvider = MyUniversityProvider._();

final class MyUniversityProvider
    extends
        $FunctionalProvider<
          AsyncValue<University>,
          University,
          FutureOr<University>
        >
    with $FutureModifier<University>, $FutureProvider<University> {
  MyUniversityProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'myUniversityProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$myUniversityHash();

  @$internal
  @override
  $FutureProviderElement<University> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<University> create(Ref ref) {
    return myUniversity(ref);
  }
}

String _$myUniversityHash() => r'e086fd5b457190bcfa7c71ac4f05e6f687f08df7';

@ProviderFor(halls)
final hallsProvider = HallsProvider._();

final class HallsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<String>>,
          List<String>,
          FutureOr<List<String>>
        >
    with $FutureModifier<List<String>>, $FutureProvider<List<String>> {
  HallsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'hallsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$hallsHash();

  @$internal
  @override
  $FutureProviderElement<List<String>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<String>> create(Ref ref) {
    return halls(ref);
  }
}

String _$hallsHash() => r'dbcd09238edf785ad3a0f9728277ffc8e31f5d60';

@ProviderFor(universityById)
final universityByIdProvider = UniversityByIdFamily._();

final class UniversityByIdProvider
    extends
        $FunctionalProvider<
          AsyncValue<University?>,
          University?,
          FutureOr<University?>
        >
    with $FutureModifier<University?>, $FutureProvider<University?> {
  UniversityByIdProvider._({
    required UniversityByIdFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'universityByIdProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$universityByIdHash();

  @override
  String toString() {
    return r'universityByIdProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<University?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<University?> create(Ref ref) {
    final argument = this.argument as String;
    return universityById(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is UniversityByIdProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$universityByIdHash() => r'd1dfbbf244bef6d1770b851ab22c1b85b7c6bfb6';

final class UniversityByIdFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<University?>, String> {
  UniversityByIdFamily._()
    : super(
        retry: null,
        name: r'universityByIdProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  UniversityByIdProvider call(String id) =>
      UniversityByIdProvider._(argument: id, from: this);

  @override
  String toString() => r'universityByIdProvider';
}

@ProviderFor(universityName)
final universityNameProvider = UniversityNameFamily._();

final class UniversityNameProvider
    extends $FunctionalProvider<String, String, String>
    with $Provider<String> {
  UniversityNameProvider._({
    required UniversityNameFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'universityNameProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$universityNameHash();

  @override
  String toString() {
    return r'universityNameProvider'
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
    return universityName(ref, argument);
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
    return other is UniversityNameProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$universityNameHash() => r'05233d69d42fced5e6592a4a3188bdb7d1f6460a';

final class UniversityNameFamily extends $Family
    with $FunctionalFamilyOverride<String, String> {
  UniversityNameFamily._()
    : super(
        retry: null,
        name: r'universityNameProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  UniversityNameProvider call(String id) =>
      UniversityNameProvider._(argument: id, from: this);

  @override
  String toString() => r'universityNameProvider';
}

@ProviderFor(hallsByUniversity)
final hallsByUniversityProvider = HallsByUniversityFamily._();

final class HallsByUniversityProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Hall>>,
          List<Hall>,
          FutureOr<List<Hall>>
        >
    with $FutureModifier<List<Hall>>, $FutureProvider<List<Hall>> {
  HallsByUniversityProvider._({
    required HallsByUniversityFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'hallsByUniversityProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$hallsByUniversityHash();

  @override
  String toString() {
    return r'hallsByUniversityProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<Hall>> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<Hall>> create(Ref ref) {
    final argument = this.argument as String;
    return hallsByUniversity(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is HallsByUniversityProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$hallsByUniversityHash() => r'f34515ca153f97fbd998c2e890671c107b001b8f';

final class HallsByUniversityFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<Hall>>, String> {
  HallsByUniversityFamily._()
    : super(
        retry: null,
        name: r'hallsByUniversityProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  HallsByUniversityProvider call(String universityId) =>
      HallsByUniversityProvider._(argument: universityId, from: this);

  @override
  String toString() => r'hallsByUniversityProvider';
}

@ProviderFor(hallName)
final hallNameProvider = HallNameFamily._();

final class HallNameProvider extends $FunctionalProvider<String, String, String>
    with $Provider<String> {
  HallNameProvider._({
    required HallNameFamily super.from,
    required ({String universityId, String hallId}) super.argument,
  }) : super(
         retry: null,
         name: r'hallNameProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$hallNameHash();

  @override
  String toString() {
    return r'hallNameProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $ProviderElement<String> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String create(Ref ref) {
    final argument = this.argument as ({String universityId, String hallId});
    return hallName(
      ref,
      universityId: argument.universityId,
      hallId: argument.hallId,
    );
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
    return other is HallNameProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$hallNameHash() => r'e7c7460711fed0a2c45a7eaaa2691d53f19c0641';

final class HallNameFamily extends $Family
    with
        $FunctionalFamilyOverride<
          String,
          ({String universityId, String hallId})
        > {
  HallNameFamily._()
    : super(
        retry: null,
        name: r'hallNameProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  HallNameProvider call({
    required String universityId,
    required String hallId,
  }) => HallNameProvider._(
    argument: (universityId: universityId, hallId: hallId),
    from: this,
  );

  @override
  String toString() => r'hallNameProvider';
}
