// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'club_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(clubRemoteDataSource)
final clubRemoteDataSourceProvider = ClubRemoteDataSourceProvider._();

final class ClubRemoteDataSourceProvider
    extends
        $FunctionalProvider<
          ClubRemoteDataSource,
          ClubRemoteDataSource,
          ClubRemoteDataSource
        >
    with $Provider<ClubRemoteDataSource> {
  ClubRemoteDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'clubRemoteDataSourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$clubRemoteDataSourceHash();

  @$internal
  @override
  $ProviderElement<ClubRemoteDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ClubRemoteDataSource create(Ref ref) {
    return clubRemoteDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ClubRemoteDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ClubRemoteDataSource>(value),
    );
  }
}

String _$clubRemoteDataSourceHash() =>
    r'befaac5030342710c94e58ec6bb6d0fb9620e795';

@ProviderFor(clubRepository)
final clubRepositoryProvider = ClubRepositoryProvider._();

final class ClubRepositoryProvider
    extends $FunctionalProvider<ClubRepository, ClubRepository, ClubRepository>
    with $Provider<ClubRepository> {
  ClubRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'clubRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$clubRepositoryHash();

  @$internal
  @override
  $ProviderElement<ClubRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ClubRepository create(Ref ref) {
    return clubRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ClubRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ClubRepository>(value),
    );
  }
}

String _$clubRepositoryHash() => r'706508e2ee02fedf44dbca5950bee439b50c817e';

@ProviderFor(getClubs)
final getClubsProvider = GetClubsProvider._();

final class GetClubsProvider
    extends $FunctionalProvider<GetClubs, GetClubs, GetClubs>
    with $Provider<GetClubs> {
  GetClubsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getClubsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getClubsHash();

  @$internal
  @override
  $ProviderElement<GetClubs> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GetClubs create(Ref ref) {
    return getClubs(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetClubs value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GetClubs>(value),
    );
  }
}

String _$getClubsHash() => r'ad8ceddd7417f1fa5872b7dae2e47bbd0d3634aa';

@ProviderFor(clubsList)
final clubsListProvider = ClubsListFamily._();

final class ClubsListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Club>>,
          List<Club>,
          FutureOr<List<Club>>
        >
    with $FutureModifier<List<Club>>, $FutureProvider<List<Club>> {
  ClubsListProvider._({
    required ClubsListFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'clubsListProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$clubsListHash();

  @override
  String toString() {
    return r'clubsListProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<Club>> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<Club>> create(Ref ref) {
    final argument = this.argument as String;
    return clubsList(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ClubsListProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$clubsListHash() => r'e1a08130ceb7bbbdaf965e2b23b9111232407df8';

final class ClubsListFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<Club>>, String> {
  ClubsListFamily._()
    : super(
        retry: null,
        name: r'clubsListProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ClubsListProvider call(String type) =>
      ClubsListProvider._(argument: type, from: this);

  @override
  String toString() => r'clubsListProvider';
}
