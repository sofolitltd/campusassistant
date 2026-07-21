// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contributor_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(contributors)
final contributorsProvider = ContributorsProvider._();

final class ContributorsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ContributorModel>>,
          List<ContributorModel>,
          FutureOr<List<ContributorModel>>
        >
    with
        $FutureModifier<List<ContributorModel>>,
        $FutureProvider<List<ContributorModel>> {
  ContributorsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'contributorsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$contributorsHash();

  @$internal
  @override
  $FutureProviderElement<List<ContributorModel>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<ContributorModel>> create(Ref ref) {
    return contributors(ref);
  }
}

String _$contributorsHash() => r'4c990a09b6a97a4e35ac1d2fced779301277acb8';
