import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/cupertino.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Payment",
          style: TextStyle(color: Colors.pink),
        ),
      ),
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
                  Navigator.pop(context, "success");
                } else if (urlStr.startsWith(widget.failureURL)) {
                  Fluttertoast.showToast(msg: "Payment Failed!");
                  Navigator.pop(context, "failure");
                } else if (urlStr.startsWith(widget.cancelURL)) {
                  Fluttertoast.showToast(msg: "Payment Cancelled!");
                  Navigator.pop(context, "cancel");
                }
              },
              onLoadStop: (controller, url) {
                setState(() {
                  isLoading = false;
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
                          color: Colors.red,
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
        ],
      ),
    );
  }
}
