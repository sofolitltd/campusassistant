import 'package:flutter/foundation.dart' show kIsWeb, debugPrint;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:go_router/go_router.dart';
import '/core/di.dart';
import '/features/auth/presentation/providers/auth_provider.dart';
import '/features/subscription/data/models/subscription_model.dart';
import '/features/subscription/domain/entities/subscription.dart';
import '/routes/app_route.dart';

/// Outcome of a bKash payment attempt.
///
/// `status` is one of:
/// - `success`   — payment was verified and a subscription was granted
/// - `redirecting` — web only: the browser is navigating to bKash's hosted
///   checkout page; the eventual result is picked up by [Bkash.executePayment]
///   from [PaymentPage] after bKash redirects back
/// - `cancel` / `failure` — the user backed out or bKash reported a failure
/// - `error` — starting the payment itself failed (network, bad plan, etc.)
typedef BkashResult = ({String status, Subscription? subscription});

class Bkash {
  /// Starts a bKash checkout session for [planId] via our backend — the
  /// backend owns all bKash credentials and computes the charge from the
  /// plan server-side, so nothing sensitive or price-related ever lives in
  /// this client. On mobile, also finalizes the payment immediately after
  /// the in-app WebView reports success.
  static Future<BkashResult> payment(
    BuildContext context,
    WidgetRef ref, {
    required String planId,
  }) async {
    try {
      final apiClient = ref.read(apiClientProvider);
      final response = await apiClient.post(
        '/payments/bkash/create',
        data: {'plan_id': planId},
      );
      final data = response.data as Map<String, dynamic>;
      final paymentId = data['payment_id'] as String;
      final bkashUrl = data['bkash_url'] as String;

      if (kIsWeb) {
        final paymentUrl = Uri.parse(bkashUrl);
        if (await canLaunchUrl(paymentUrl)) {
          await launchUrl(
            paymentUrl,
            mode: LaunchMode.platformDefault,
            webOnlyWindowName: "_self", // same tab
          );
        } else {
          Fluttertoast.showToast(msg: "Could not open payment page.");
        }
        return (status: 'redirecting', subscription: null);
      }

      if (!context.mounted) return (status: 'error', subscription: null);
      final webViewResult = await context.push<String?>(
        AppRoute.bkashWebView.path,
        extra: {
          'url': bkashUrl,
          'successURL': data['success_url'] as String? ?? '',
          'failureURL': data['failure_url'] as String? ?? '',
          'cancelURL': data['cancel_url'] as String? ?? '',
        },
      );

      if (webViewResult != 'success') {
        return (status: webViewResult ?? 'cancel', subscription: null);
      }

      final subscription = await executePayment(ref, paymentId: paymentId);
      return (status: 'success', subscription: subscription);
    } catch (e) {
      Fluttertoast.showToast(msg: 'Payment Error: $e');
      debugPrint('Bkash Payment Error: $e');
      return (status: 'error', subscription: null);
    }
  }

  /// Finalizes a payment with our backend, which re-verifies with bKash
  /// directly — this is the only step that actually grants a subscription.
  /// A client-forged "success" only ever triggers a real re-verification
  /// here, which bKash will reject if the payment never actually completed.
  static Future<Subscription> executePayment(
    WidgetRef ref, {
    required String paymentId,
  }) async {
    final apiClient = ref.read(apiClientProvider);
    final response = await apiClient.post(
      '/payments/bkash/execute',
      data: {'payment_id': paymentId},
    );
    final subscription = SubscriptionModel.fromJson(
      response.data as Map<String, dynamic>,
    ).toEntity();

    // Reflects the new Pro status app-wide immediately (isProUserProvider
    // etc.) instead of requiring a manual refresh/re-login.
    ref.invalidate(currentUserProvider);

    return subscription;
  }
}
