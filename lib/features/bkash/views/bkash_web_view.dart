import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

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
  InAppWebViewController? webViewController;
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
    webViewController?.loadUrl(
      urlRequest: URLRequest(url: WebUri(widget.url)),
    );
  }

  @override
  void initState() {
    super.initState();
    _startTimeoutTimer();
  }

  @override
  void dispose() {
    _timeoutTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(centerTitle: true, title: const Text("Payment")),
      body: Stack(
        children: [
          /// WebView Full Screen
          SizedBox.expand(
            child: InAppWebView(
              initialUrlRequest: URLRequest(url: WebUri(widget.url)),
              onWebViewCreated: (controller) {
                webViewController = controller;
              },
              onLoadStart: (controller, url) {
                if (url == null) return;
                String urlStr = url.toString();

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
              },
              onLoadStop: (controller, url) {
                _timeoutTimer?.cancel();
                if (!mounted) return;
                setState(() {
                  isLoading = false;
                });
              },
              onReceivedError: (controller, request, error) {
                if (!(request.isForMainFrame ?? true) || !mounted) return;
                _timeoutTimer?.cancel();
                setState(() {
                  isLoading = false;
                  hasError = true;
                  errorMessage = 'Could not load the bKash payment page.';
                });
              },
              onReceivedHttpError: (controller, request, errorResponse) {
                if (!(request.isForMainFrame ?? true) || !mounted) return;
                _timeoutTimer?.cancel();
                setState(() {
                  isLoading = false;
                  hasError = true;
                  errorMessage = 'Could not load the bKash payment page.';
                });
              },
            ),
          ),

          /// Loading Overlay
          if (isLoading)
            Container(
              color: Colors.white.withValues(alpha: 0.8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Please Wait',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const CupertinoActivityIndicator(radius: 20),
                  const SizedBox(height: 12),
                  Text(
                    'Redirecting....',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),

          /// Error Overlay
          if (hasError)
            Container(
              color: Colors.white,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.wifi_off_rounded,
                        size: 56,
                        color: Colors.grey,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        errorMessage,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          OutlinedButton(
                            onPressed: () => context.pop('cancel'),
                            child: const Text('Cancel'),
                          ),
                          const SizedBox(width: 12),
                          FilledButton(
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
