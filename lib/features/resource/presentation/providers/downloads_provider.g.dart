// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'downloads_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(DownloadedFiles)
final downloadedFilesProvider = DownloadedFilesProvider._();

final class DownloadedFilesProvider
    extends $AsyncNotifierProvider<DownloadedFiles, List<DownloadedFile>> {
  DownloadedFilesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'downloadedFilesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$downloadedFilesHash();

  @$internal
  @override
  DownloadedFiles create() => DownloadedFiles();
}

String _$downloadedFilesHash() => r'b29b259052c61bc2780f39f42dcea79aec3755e5';

abstract class _$DownloadedFiles extends $AsyncNotifier<List<DownloadedFile>> {
  FutureOr<List<DownloadedFile>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<AsyncValue<List<DownloadedFile>>, List<DownloadedFile>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<DownloadedFile>>,
                List<DownloadedFile>
              >,
              AsyncValue<List<DownloadedFile>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
