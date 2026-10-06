import 'dart:async';

import '/routes/app_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/core/di.dart';
import '/features/bkash/bkash_payment.dart';
import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/core/widgets/custom_header_layout.dart';
import '/core/theme/tokens/app_font_size.dart';
import '/core/theme/tokens/app_control.dart';

class PaymentPage extends ConsumerStatefulWidget {
  const PaymentPage({
    super.key,
    required this.planId,
    required this.planTitle,
    required this.amount,
    this.couponCode,
  });

  final String planId;
  final String planTitle;
  final String amount;
  final String? couponCode;

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

    final result = await Bkash.payment(
      context,
      ref,
      planId: widget.planId,
      couponCode: widget.couponCode,
    );
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
      // Notify backend so the transaction shows "Cancelled" rather than
      // dangling as "Pending" in the user's history.
      try {
        await ref
            .read(apiClientProvider)
            .post('/payments/bkash/cancel', data: {'payment_id': paymentId});
      } catch (_) {
        // Best-effort — the hourly sweeper will catch it.
      }
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
          padding: const EdgeInsets.all(Spacing.xxl),
          child: _isProcessing
              ? Column(
                  mainAxisAlignment: .center,
                  children: [
                    const CupertinoActivityIndicator(),
                    const SizedBox(height: Spacing.xl),
                    Text(
                      _statusMessage,
                      style: const TextStyle(
                        fontSize: FontSizeToken.lg,
                        fontWeight: .w500,
                      ),
                    ),
                  ],
                )
              : Column(
                  mainAxisAlignment: .center,
                  children: [
                    Icon(
                      _isSuccess
                          ? LucideIcons.circleCheck
                          : (_statusMessage.contains('Cancelled')
                                ? LucideIcons.circleX
                                : LucideIcons.circleAlert),
                      size: 80,
                      color: _isSuccess
                          ? context.colors.success
                          : context.colors.danger,
                    ),
                    const SizedBox(height: Spacing.xxl),
                    Text(
                      _statusMessage,
                      style: TextStyle(
                        fontSize: FontSizeToken.display,
                        fontWeight: .bold,
                        color: _isSuccess
                            ? context.colors.success
                            : context.colors.text,
                      ),
                    ),
                    const SizedBox(height: Spacing.md),
                    Container(
                      padding: const EdgeInsets.all(Spacing.lg),
                      decoration: BoxDecoration(
                        color: context.colors.surfaceAlt,
                        borderRadius: BorderRadius.circular(RadiusToken.lg),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'Plan: ${widget.planTitle}',
                            style: const TextStyle(fontSize: FontSizeToken.xl),
                          ),
                          const SizedBox(height: Spacing.xs),
                          Text(
                            'Amount: ${widget.amount} BDT',
                            style: const TextStyle(
                              fontSize: FontSizeToken.xl,
                              fontWeight: .bold,
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
                        label: const Text('Try again'),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(200, ControlToken.height),
                        ),
                      ),
                      const SizedBox(height: Spacing.lg),
                    ],
                    ElevatedButton(
                      onPressed: () => context.goNamed(AppRoute.home.name),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isSuccess
                            ? context.colors.success
                            : null,
                        foregroundColor: _isSuccess
                            ? context.colors.onSuccess
                            : null,
                        minimumSize: const Size(200, ControlToken.height),
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
