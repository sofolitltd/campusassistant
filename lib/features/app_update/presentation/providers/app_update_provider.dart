import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '/core/di.dart';
import '../../data/app_config_model.dart';
import '../../data/app_update_remote_data_source.dart';

/// The installed build's version info, read once per app session. Compared
/// against `AppConfig.minSupportedVersionCode` in the router redirect.
final packageInfoProvider = FutureProvider<PackageInfo>((ref) {
  return PackageInfo.fromPlatform();
});

final appUpdateRemoteDataSourceProvider = Provider<AppUpdateRemoteDataSource>((
  ref,
) {
  final apiClient = ref.watch(apiClientProvider);
  return AppUpdateRemoteDataSourceImpl(apiClient: apiClient);
});

/// The force-update gate must never lock out the whole user base over a
/// backend hiccup, so any fetch/parse failure resolves to `null` (meaning
/// "don't force") instead of propagating as an error.
final appUpdateConfigProvider = FutureProvider<AppConfig?>((ref) async {
  try {
    return await ref.watch(appUpdateRemoteDataSourceProvider).getAppConfig();
  } catch (e) {
    if (kDebugMode) debugPrint('[app_update] config fetch failed, failing open: $e');
    return null;
  }
});
