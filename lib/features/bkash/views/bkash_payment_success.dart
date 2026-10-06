import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_font_size.dart';

class PaymentSuccessPage extends StatelessWidget {
  final String paymentID;

  const PaymentSuccessPage({super.key, required this.paymentID});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Payment Successful")),
      body: Padding(
        padding: const EdgeInsets.all(Spacing.lg),
        child: Center(
          child: Column(
            mainAxisAlignment: .center,
            crossAxisAlignment: .center,
            children: [
              Icon(Icons.check_circle, color: context.colors.success, size: 80),
              const SizedBox(height: Spacing.xl),
              const Text(
                "Payment Successful!",
                style: TextStyle(
                  fontSize: FontSizeToken.display,
                  fontWeight: .bold,
                ),
              ),
              const SizedBox(height: Spacing.md),
              Text(
                "Payment ID: $paymentID",
                style: const TextStyle(
                  fontSize: FontSizeToken.sm,
                  fontWeight: .w500,
                ),
              ),
              const SizedBox(height: Spacing.lg),
              const Text(
                "Check your subscription status on Profile page",
                style: TextStyle(fontWeight: .w500),
              ),
              const SizedBox(height: Spacing.xxxl),
              ElevatedButton(
                onPressed: () {
                  GoRouter.of(context).go('/'); // Navigate to home
                },
                child: const Text("Go To Home"),
              ),
              const SizedBox(height: Spacing.md),
            ],
          ),
        ),
      ),
    );
  }
}
