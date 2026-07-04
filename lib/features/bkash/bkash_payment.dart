import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:go_router/go_router.dart';
import 'package:campusassistant/routes/app_route.dart';
import 'apis/bkash_apis.dart';

class Bkash {
  /// Initiates and executes the bKash payment process
  /// Returns 'success' / 'cancel' for mobile, and null for web (handled via redirect)
  static Future<String?> payment(
    BuildContext context, {
    required bool isProduction,
    required String amount,
    required String subscriptionPlan,
  }) async {
    try {
      // Step 1: Grant token
      final grantTokenResponse = await BkashApis(isProduction).grantToken();

      // Step 2: Create payment session
      final createPaymentResponse = await BkashApis(isProduction).createPayment(
        idToken: grantTokenResponse.idToken,
        subscriptionPlan: subscriptionPlan,
        amount: amount,
        invoiceNumber: DateTime.now().millisecondsSinceEpoch.toString(),
      );

      if (kIsWeb) {
        // Step 3: Web — redirect to bKash directly in same tab
        final paymentUrl = Uri.parse(createPaymentResponse.bkashURL);

        if (await canLaunchUrl(paymentUrl)) {
          await launchUrl(
            paymentUrl,
            mode: LaunchMode.platformDefault,
            webOnlyWindowName: "_self", // open in current tab
          );
          // After redirect back to callback URL, PaymentPage handles it
          return null;
        } else {
          Fluttertoast.showToast(msg: "Could not open payment page.");
          return 'cancel';
        }
      } else {
        // Step 3 (Mobile): In-app WebView payment flow
        if (!context.mounted) return null;
        final result = await context.push<String?>(
          AppRoute.bkashWebView.path,
          extra: {
            'url': createPaymentResponse.bkashURL,
            'successURL': createPaymentResponse.successCallbackURL,
            'failureURL': createPaymentResponse.failureCallbackURL,
            'cancelURL': createPaymentResponse.cancelledCallbackURL,
          },
        );
        return result;
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Payment Error: $e');
      debugPrint('Bkash Payment Error: $e');
      return 'cancel';
    }
  }

  /// Finalizes a successful transaction by confirming it with bKash
  /// and updating subscription data.
  static Future<void> executePaymentAndFinalize(
    BuildContext context, {
    required String userId, // Changed from Firebase user
    required String paymentID,
    required String subscriptionPlan,
    required String amount,
    bool isProduction = false,
  }) async {
    final grantTokenResponse = await BkashApis(isProduction).grantToken();
    final executePaymentResponse = await BkashApis(
      isProduction,
    ).executePayment(idToken: grantTokenResponse.idToken, paymentID: paymentID);

    if (executePaymentResponse.transactionStatus != "Completed") {
      throw Exception("Payment execution failed");
    }

    // final now = DateTime.now();
    // DateTime? endDate;

    // switch (subscriptionPlan) {
    //   case "1 Year":
    //     endDate = DateTime(now.year + 1, now.month, now.day);
    //     break;
    //   case "2 Year":
    //     endDate = DateTime(now.year + 2, now.month, now.day);
    //     break;
    //   case "3 Year":
    //     endDate = DateTime(now.year + 3, now.month, now.day);
    //     break;
    //   case "Lifetime":
    //     endDate = null;
    //     break;
    //   default:
    //     endDate = DateTime(now.year, now.month, now.day);
    // }

    // TODO: Implement subscription update in Go backend
    // This should send the transaction details to the backend to verify and update the user status

    // log('Subscription Plan: $subscriptionPlan');
    // log('Amount: $amount');

    Fluttertoast.showToast(
      msg: "$subscriptionPlan subscription activated! (Pending backend sync)",
    );
  }
}
