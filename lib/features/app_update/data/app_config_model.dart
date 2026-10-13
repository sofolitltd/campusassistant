class AppConfig {
  final int minSupportedVersionCode;
  final String updateMessage;
  final String playStoreUrl;

  const AppConfig({
    required this.minSupportedVersionCode,
    required this.updateMessage,
    required this.playStoreUrl,
  });

  factory AppConfig.fromJson(Map<String, dynamic> json) {
    return AppConfig(
      minSupportedVersionCode: json['min_supported_version_code'] as int? ?? 0,
      updateMessage: json['update_message'] as String? ?? '',
      playStoreUrl: json['play_store_url'] as String? ?? '',
    );
  }
}
