import '../config/env.dart';

/// Ad unit / app IDs for AdMob. Every getter here defaults to Google's
/// official PUBLIC TEST IDs — safe to build and run with, never counted as
/// real impressions/clicks. A real ID is only used if the matching ADMOB_*
/// key is explicitly set in `env.json` (see `BUILD_AND_DEPLOY.md`).
///
/// Never hardcode a production ad unit ID here, and never interact with
/// (tap/click) real ads on your own devices once production IDs are set —
/// both count as invalid traffic and risk the AdMob account.
class AdConfig {
  AdConfig._();

  static const _testAndroidAppId = 'ca-app-pub-3940256099942544~3347511713';
  static const _testAndroidBannerUnitId =
      'ca-app-pub-3940256099942544/6300978111';
  static const _testAndroidRewardedUnitId =
      'ca-app-pub-3940256099942544/5224354917';

  static String get androidAppId =>
      Env.admobAndroidAppId.isNotEmpty ? Env.admobAndroidAppId : _testAndroidAppId;

  static String get bannerAdUnitId => Env.admobBannerAdUnitIdAndroid.isNotEmpty
      ? Env.admobBannerAdUnitIdAndroid
      : _testAndroidBannerUnitId;

  static String get rewardedAdUnitId => Env.admobRewardedAdUnitIdAndroid.isNotEmpty
      ? Env.admobRewardedAdUnitIdAndroid
      : _testAndroidRewardedUnitId;
}
