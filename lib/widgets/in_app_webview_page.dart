import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '/core/theme/tokens/app_font_size.dart';

class InAppWebViewPage extends StatefulWidget {
  final String url;

  const InAppWebViewPage({super.key, required this.url});

  @override
  State<InAppWebViewPage> createState() => _InAppWebViewPageState();
}

class _InAppWebViewPageState extends State<InAppWebViewPage> {
  late final WebViewController _controller;
  double progress = 0;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (value) {
            if (!mounted) return;
            setState(() => progress = value / 100);
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          Uri.parse(widget.url).host,
          style: const TextStyle(fontSize: FontSizeToken.lg),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _controller.reload(),
          ),
        ],
        bottom: progress < 1.0
            ? PreferredSize(
                preferredSize: const Size.fromHeight(3.0),
                child: LinearProgressIndicator(value: progress),
              )
            : null,
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}
