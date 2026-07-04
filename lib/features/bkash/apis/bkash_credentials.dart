import 'package:flutter_dotenv/flutter_dotenv.dart';

class BkashCredentialsSandbox {
  static String get username =>
      dotenv.env['BKASH_SANDBOX_USERNAME'] ?? "sandboxTokenizedUser02";
  static String get password =>
      dotenv.env['BKASH_SANDBOX_PASSWORD'] ?? "sandboxTokenizedUser02@12345";
  static String get appKey =>
      dotenv.env['BKASH_SANDBOX_APP_KEY'] ?? "4f6o0cjiki2rfm34kfdadl1eqq";
  static String get appSecret =>
      dotenv.env['BKASH_SANDBOX_APP_SECRET'] ??
      "2is7hdktrekvrbljjh44ll3d9l1dtjo4pasmjvs5vl5qr3fug4b";
}

class BkashCredentialsProduction {
  static String get username =>
      dotenv.env['BKASH_PROD_USERNAME'] ?? '';
  static String get password =>
      dotenv.env['BKASH_PROD_PASSWORD'] ?? '';
  static String get appKey =>
      dotenv.env['BKASH_PROD_APP_KEY'] ?? '';
  static String get appSecret =>
      dotenv.env['BKASH_PROD_APP_SECRET'] ?? '';
}

//https://medium.com/@Coder-pranav/fix-xmlhttprequest-error-for-the-3rd-party-api-with-cloudflare-7a00e90ae744
