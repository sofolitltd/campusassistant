import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '/bkash/apis/bkash_apis.dart';
import 'models/create_payment_response.dart';
import 'models/execute_payment_response.dart';
import 'models/grant_token_response.dart';
import 'views/bkash_payment_success.dart';
import 'views/bkash_web_view.dart';

class Bkash {
  /// Initiates and executes the bKash payment process
  static Future<void> payment(
    BuildContext context, {
    required bool isProduction,
    required String amount,
    required String subscriptionPlan,
  }) async {
    try {
      //  step 1
      final grantTokenResponse = await BkashApis(isProduction).grantToken();

      //step 2
      final createPaymentResponse = await BkashApis(isProduction).createPayment(
        idToken: grantTokenResponse.idToken,
        amount: amount,
        invoiceNumber: DateTime.now().millisecondsSinceEpoch.toString(),
      );

      //step 3
      final paymentResult = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BkashWebView(
            url: createPaymentResponse.bkashURL,
            successURL: createPaymentResponse.successCallbackURL,
            failureURL: createPaymentResponse.failureCallbackURL,
            cancelURL: createPaymentResponse.cancelledCallbackURL,
          ),
        ),
      );

      //step 4
      if (paymentResult == "success") {
        // step 4-1
        final executePaymentResponse =
            await BkashApis(isProduction).executePayment(
          idToken: grantTokenResponse.idToken,
          paymentID: createPaymentResponse.paymentID,
        );

        // step 4-2
        if (executePaymentResponse.transactionStatus == "Completed") {
          // add to firebase
          final user = FirebaseAuth.instance.currentUser;
          if (user == null) return;

          final now = DateTime.now();
          DateTime? endDate;

          // selectedPlan
          switch (subscriptionPlan) {
            case "1 Year":
              endDate = DateTime(now.year + 1, now.month, now.day);
              break;
            case "2 Year":
              endDate = DateTime(now.year + 2, now.month, now.day);
              break;
            case "3 Year":
              endDate = DateTime(now.year + 3, now.month, now.day);
              break;
            case "Lifetime":
              endDate = null; //
              break;
            default:
              endDate = DateTime(now.year, now.month, now.day);
          }

          // 1️⃣ Update user subscriber status
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .update({
            'information.status.subscriber': 'pro',
          });

          // 2️⃣ Add / update subscription in subscriptions collection
          await FirebaseFirestore.instance
              .collection('subscriptions')
              .doc(user.uid)
              .set({
            'subscription': subscriptionPlan,
            'amount': amount,
            'startDate': Timestamp.fromDate(now),
            'endDate': endDate != null ? Timestamp.fromDate(endDate) : null,
          }, SetOptions(merge: true)).then((v) {});

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text("$subscriptionPlan subscription activated!")),
          );

          //todo:  send notification to admin

          // go to success page
          await Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => PaymentSuccessPage(
                  paymentID: executePaymentResponse.trxID,
                ),
              ),
              (route) => false);
        } else {
          Fluttertoast.showToast(msg: "Payment Execution Failed!");
        }

        //
      } else {
        Fluttertoast.showToast(msg: "Payment Failed or Cancelled");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Payment Error: $e');
      debugPrint('Payment Error: $e');
    }
  }
}
