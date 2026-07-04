import 'dart:async';

import 'package:campusassistant/routes/app_route.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/features/auth/presentation/providers/auth_provider.dart';
import '/features/bkash/bkash_payment.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/theme/tokens/app_spacing.dart';

class PaymentPage extends ConsumerStatefulWidget {
  const PaymentPage({super.key, required this.plan, required this.amount});

  final String amount;
  final String plan;

  @override
  ConsumerState<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends ConsumerState<PaymentPage> {
  bool _isProcessing = true;
  bool _isSuccess = false; // Added to track success state
  String _statusMessage = 'Initializing Payment...';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _handleOnLoad());
  }

  Future<void> _handleOnLoad() async {
    final uri = Uri.base;
    final status = uri.queryParameters['status'];
    final trxID =
        uri.queryParameters['paymentID'] ?? uri.queryParameters['trxID'];

    if (status != null) {
      await _processWebCallback(status, trxID);
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

    try {
      await Bkash.payment(
        context,
        isProduction: false,
        amount: widget.amount,
        subscriptionPlan: widget.plan,
      );
    } catch (e) {
      if (mounted) {
        setState(() {
          _isProcessing = false;
          _statusMessage = 'Payment failed to start.';
        });
      }
      Fluttertoast.showToast(msg: 'Payment initiation failed');
    }
  }

  Future<void> _processWebCallback(String status, String? trxID) async {
    if (status == 'success' && trxID != null) {
      setState(() {
        _isProcessing = true;
        _statusMessage = 'Verifying your payment...';
      });

      try {
        final user = await ref.read(currentUserProvider.future);
        final userId = user?.id ?? '';

        if (!mounted) return;
        await Bkash.executePaymentAndFinalize(
          context,
          userId: userId,
          paymentID: trxID,
          subscriptionPlan: widget.plan,
          amount: widget.amount,
        );

        if (!mounted) return;

        setState(() {
          _isProcessing = false;
          _isSuccess = true;
          _statusMessage = 'Payment Successful!';
        });

        // Optional: Auto-redirect after 3 seconds
        // Future.delayed(const Duration(seconds: 4), () {
        //   if (mounted && _isSuccess) {
        //     context.goNamed(AppRoute.home.name);
        //   }
        // });
      } catch (e) {
        setState(() {
          _isProcessing = false;
          _isSuccess = false;
          _statusMessage = 'Verification Failed';
        });
        Fluttertoast.showToast(msg: 'Error: $e');
      }
    } else {
      setState(() {
        _isProcessing = false;
        _isSuccess = false;
        _statusMessage = status == 'cancel'
            ? 'Payment Cancelled'
            : 'Payment Failed';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('bKash Payment'), centerTitle: true),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: _isProcessing
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(),
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
                            'Plan: ${widget.plan}',
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
