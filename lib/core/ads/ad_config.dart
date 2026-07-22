import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Ad unit / app IDs for AdMob. Every getter here defaults to Google's
/// official PUBLIC TEST IDs — safe to build and run with, never counted as
/// real impressions/clicks. A real ID is only used if the matching ADMOB_*
/// key is explicitly set in `.env`.
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
      dotenv.env['ADMOB_ANDROID_APP_ID'] ?? _testAndroidAppId;

  static String get bannerAdUnitId =>
      dotenv.env['ADMOB_BANNER_AD_UNIT_ID_ANDROID'] ?? _testAndroidBannerUnitId;

  static String get rewardedAdUnitId =>
      dotenv.env['ADMOB_REWARDED_AD_UNIT_ID_ANDROID'] ??
      _testAndroidRewardedUnitId;
}
