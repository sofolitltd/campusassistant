import 'dart:async';

import '/routes/app_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/features/bkash/bkash_payment.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/core/widgets/custom_header_layout.dart';

class PaymentPage extends ConsumerStatefulWidget {
  const PaymentPage({
    super.key,
    required this.planId,
    required this.planTitle,
    required this.amount,
  });

  final String planId;
  final String planTitle;
  final String amount;

  @override
  ConsumerState<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends ConsumerState<PaymentPage> {
  bool _isProcessing = true;
  bool _isSuccess = false;
  String _statusMessage = 'Initializing Payment...';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _handleOnLoad());
  }

  Future<void> _handleOnLoad() async {
    // Web only: bKash redirects the browser back here with its own
    // ?status=...&paymentID=... — that's only ever a *signal* to verify,
    // never trusted directly (the backend re-checks with bKash before
    // granting anything).
    final uri = Uri.base;
    final status = uri.queryParameters['status'];
    final paymentId = uri.queryParameters['paymentID'];

    if (status != null && paymentId != null) {
      await _processWebCallback(status, paymentId);
    } else {
      await _startPaymentProcess();
    }
  }

  Future<void> _startPaymentProcess() async {
    if (!mounted) return;
    setState(() {
      _isProcessing = true;
      _isSuccess = false;
      _statusMessage = 'Redirecting to bKash...';
    });

    final result = await Bkash.payment(context, ref, planId: widget.planId);
    if (!mounted) return;

    switch (result.status) {
      case 'success':
        setState(() {
          _isProcessing = false;
          _isSuccess = true;
          _statusMessage = 'Payment Successful!';
        });
      case 'redirecting':
        // Web: the browser is navigating to bKash's checkout page — leave
        // the spinner up, this page is about to unload.
        break;
      case 'cancel':
        setState(() {
          _isProcessing = false;
          _statusMessage = 'Payment Cancelled';
        });
      case 'failure':
        setState(() {
          _isProcessing = false;
          _statusMessage = 'Payment Failed';
        });
      default:
        setState(() {
          _isProcessing = false;
          _statusMessage = 'Payment failed to start.';
        });
    }
  }

  Future<void> _processWebCallback(String status, String paymentId) async {
    if (status != 'success') {
      setState(() {
        _isProcessing = false;
        _isSuccess = false;
        _statusMessage = status == 'cancel'
            ? 'Payment Cancelled'
            : 'Payment Failed';
      });
      return;
    }

    setState(() {
      _isProcessing = true;
      _statusMessage = 'Verifying your payment...';
    });

    try {
      await Bkash.executePayment(ref, paymentId: paymentId);
      if (!mounted) return;
      setState(() {
        _isProcessing = false;
        _isSuccess = true;
        _statusMessage = 'Payment Successful!';
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isProcessing = false;
        _isSuccess = false;
        _statusMessage = 'Verification Failed';
      });
      Fluttertoast.showToast(msg: 'Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomHeaderLayout(
      title: 'bKash Payment',
      showSearchBar: false,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: _isProcessing
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CupertinoActivityIndicator(),
                    const SizedBox(height: 20),
                    Text(
                      _statusMessage,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _isSuccess
                          ? LucideIcons.circleCheck
                          : (_statusMessage.contains('Cancelled')
                                ? LucideIcons.circleX
                                : LucideIcons.circleAlert),
                      size: 80,
                      color: _isSuccess ? Colors.green : Colors.red,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      _statusMessage,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: _isSuccess ? Colors.green : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(RadiusToken.md),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'Plan: ${widget.planTitle}',
                            style: const TextStyle(fontSize: 18),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Amount: ${widget.amount} BDT',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                    if (!_isSuccess) ...[
                      ElevatedButton.icon(
                        onPressed: _startPaymentProcess,
                        icon: const Icon(LucideIcons.refreshCw),
                        label: const Text('Try Again'),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(200, 50),
                        ),
                      ),
                      const SizedBox(height: Spacing.lg),
                    ],
                    ElevatedButton(
                      onPressed: () => context.goNamed(AppRoute.home.name),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isSuccess ? Colors.green : null,
                        foregroundColor: _isSuccess ? Colors.white : null,
                        minimumSize: const Size(200, 50),
                      ),
                      child: Text(
                        _isSuccess ? 'Go to Home' : 'Cancel & Return',
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
