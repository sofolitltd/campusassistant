// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'association_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// All associations (district- and sub-district-scoped alike) for the
/// current user's own university — one flat list, no type split. Skips the
/// repository/usecase/dartz/cache layer entirely (no offline fallback for
/// this feature), matching the lighter pattern already used for club
/// sub-resources (events/posts/members).

@ProviderFor(associationsList)
final associationsListProvider = AssociationsListProvider._();

/// All associations (district- and sub-district-scoped alike) for the
/// current user's own university — one flat list, no type split. Skips the
/// repository/usecase/dartz/cache layer entirely (no offline fallback for
/// this feature), matching the lighter pattern already used for club
/// sub-resources (events/posts/members).

final class AssociationsListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Association>>,
          List<Association>,
          FutureOr<List<Association>>
        >
    with
        $FutureModifier<List<Association>>,
        $FutureProvider<List<Association>> {
  /// All associations (district- and sub-district-scoped alike) for the
  /// current user's own university — one flat list, no type split. Skips the
  /// repository/usecase/dartz/cache layer entirely (no offline fallback for
  /// this feature), matching the lighter pattern already used for club
  /// sub-resources (events/posts/members).
  AssociationsListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'associationsListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$associationsListHash();

  @$internal
  @override
  $FutureProviderElement<List<Association>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Association>> create(Ref ref) {
    return associationsList(ref);
  }
}

String _$associationsListHash() => r'fe9e70e75d8ab92c407f116446ab53afd66450d0';

/// Fetches a single association by ID — used when
/// AssociationDetailsPage is reached via a deep link (e.g. an association
/// event push notification) with no Association object already in hand.

@ProviderFor(associationById)
final associationByIdProvider = AssociationByIdFamily._();

/// Fetches a single association by ID — used when
/// AssociationDetailsPage is reached via a deep link (e.g. an association
/// event push notification) with no Association object already in hand.

final class AssociationByIdProvider
    extends
        $FunctionalProvider<
          AsyncValue<Association>,
          Association,
          FutureOr<Association>
        >
    with $FutureModifier<Association>, $FutureProvider<Association> {
  /// Fetches a single association by ID — used when
  /// AssociationDetailsPage is reached via a deep link (e.g. an association
  /// event push notification) with no Association object already in hand.
  AssociationByIdProvider._({
    required AssociationByIdFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'associationByIdProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$associationByIdHash();

  @override
  String toString() {
    return r'associationByIdProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Association> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Association> create(Ref ref) {
    final argument = this.argument as String;
    return associationById(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is AssociationByIdProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$associationByIdHash() => r'09978515ea56854dbe60372fb941406f3fd205e2';

/// Fetches a single association by ID — used when
/// AssociationDetailsPage is reached via a deep link (e.g. an association
/// event push notification) with no Association object already in hand.

final class AssociationByIdFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Association>, String> {
  AssociationByIdFamily._()
    : super(
        retry: null,
        name: r'associationByIdProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Fetches a single association by ID — used when
  /// AssociationDetailsPage is reached via a deep link (e.g. an association
  /// event push notification) with no Association object already in hand.

  AssociationByIdProvider call(String associationId) =>
      AssociationByIdProvider._(argument: associationId, from: this);

  @override
  String toString() => r'associationByIdProvider';
}
