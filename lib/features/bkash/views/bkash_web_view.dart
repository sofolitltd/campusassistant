import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_spacing.dart';

/// How long to wait for the bKash page to finish loading before offering a
/// retry — a safety net on top of the backend's own request timeouts, for
/// when the page itself (not our API) is just slow or unreachable.
const _loadTimeout = Duration(seconds: 20);

class BkashWebView extends StatefulWidget {
  final String url;
  final String successURL;
  final String failureURL;
  final String cancelURL;

  const BkashWebView({
    super.key,
    required this.url,
    required this.successURL,
    required this.failureURL,
    required this.cancelURL,
  });

  @override
  State<BkashWebView> createState() => _BkashWebViewState();
}

class _BkashWebViewState extends State<BkashWebView> {
  late final WebViewController webViewController;
  bool isLoading = true;
  bool hasError = false;
  String errorMessage = 'Something went wrong while loading bKash.';
  Timer? _timeoutTimer;

  void _startTimeoutTimer() {
    _timeoutTimer?.cancel();
    _timeoutTimer = Timer(_loadTimeout, () {
      if (!mounted || !isLoading) return;
      setState(() {
        isLoading = false;
        hasError = true;
        errorMessage = 'This is taking longer than expected.';
      });
    });
  }

  void _retry() {
    setState(() {
      isLoading = true;
      hasError = false;
    });
    _startTimeoutTimer();
    webViewController.loadRequest(Uri.parse(widget.url));
  }

  @override
  void initState() {
    super.initState();
    webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: _onPageStarted,
          onPageFinished: _onPageFinished,
          onWebResourceError: (error) {
            if (error.isForMainFrame == false) return;
            _showLoadError();
          },
          onHttpError: (error) {
            if (error.request?.uri == null || !mounted) return;
            // Only the page we asked for matters; sub-resource 4xx/5xx is noise.
            if (error.request!.uri.toString() != widget.url) return;
            _showLoadError();
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
    _startTimeoutTimer();
  }

  void _onPageStarted(String urlStr) {
    if (urlStr.startsWith(widget.successURL)) {
      Fluttertoast.showToast(msg: "Payment Successful!");
      context.pop("success");
    } else if (urlStr.startsWith(widget.failureURL)) {
      Fluttertoast.showToast(msg: "Payment Failed!");
      context.pop("failure");
    } else if (urlStr.startsWith(widget.cancelURL)) {
      Fluttertoast.showToast(msg: "Payment Cancelled!");
      context.pop("cancel");
    }
  }

  void _onPageFinished(String url) {
    _timeoutTimer?.cancel();
    if (!mounted) return;
    setState(() {
      isLoading = false;
    });
  }

  void _showLoadError() {
    if (!mounted) return;
    _timeoutTimer?.cancel();
    setState(() {
      isLoading = false;
      hasError = true;
      errorMessage = 'Could not load the bKash payment page.';
    });
  }

  @override
  void dispose() {
    _timeoutTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.surface,
      appBar: AppBar(centerTitle: true, title: const Text("Payment")),
      body: Stack(
        children: [
          /// WebView Full Screen
          SizedBox.expand(child: WebViewWidget(controller: webViewController)),

          /// Loading Overlay
          if (isLoading)
            Container(
              color: context.colors.surface.withValues(alpha: 0.8),
              child: Column(
                crossAxisAlignment: .stretch,
                mainAxisAlignment: .center,
                children: [
                  Text(
                    'Please Wait',
                    textAlign: .center,
                    style: Theme.of(
                      context,
                    ).textTheme.titleLarge!.copyWith(fontWeight: .bold),
                  ),
                  const SizedBox(height: Spacing.xxl),
                  const CupertinoActivityIndicator(radius: 20),
                  const SizedBox(height: Spacing.md),
                  Text(
                    'Redirecting....',
                    textAlign: .center,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontWeight: .bold,
                      color: context.colors.textSubtle,
                    ),
                  ),
                ],
              ),
            ),

          /// Error Overlay
          if (hasError)
            Container(
              color: context.colors.surface,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(Spacing.xxl),
                  child: Column(
                    mainAxisAlignment: .center,
                    children: [
                      Icon(
                        Icons.wifi_off_rounded,
                        size: 56,
                        color: context.colors.textSubtle,
                      ),
                      const SizedBox(height: Spacing.lg),
                      Text(
                        errorMessage,
                        textAlign: .center,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: Spacing.xxl),
                      Row(
                        mainAxisAlignment: .center,
                        children: [
                          OutlinedButton(
                            onPressed: () => context.pop('cancel'),
                            child: const Text('Cancel'),
                          ),
                          const SizedBox(width: Spacing.md),
                          ElevatedButton(
                            onPressed: _retry,
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
