/// Build-time configuration, injected via `--dart-define-from-file=env.json`
/// (see `env.example.json` and `BUILD_AND_DEPLOY.md`). Values are compiled
/// directly into the app — there is no runtime file to fetch, so nothing
/// here is ever served as a standalone asset the way `.env` used to be.
class Env {
  Env._();

  static const String baseUrl = String.fromEnvironment(
    'BASE_URL',
    defaultValue: 'http://10.0.2.2:8080/api/v1',
  );

  static const String apiKey = String.fromEnvironment('API_KEY');

  static const String fcmVapidKey = String.fromEnvironment('FCM_VAPID_KEY');

  static const String admobAndroidAppId = String.fromEnvironment(
    'ADMOB_ANDROID_APP_ID',
  );

  static const String admobBannerAdUnitIdAndroid = String.fromEnvironment(
    'ADMOB_BANNER_AD_UNIT_ID_ANDROID',
  );

  static const String admobRewardedAdUnitIdAndroid = String.fromEnvironment(
    'ADMOB_REWARDED_AD_UNIT_ID_ANDROID',
  );
}
