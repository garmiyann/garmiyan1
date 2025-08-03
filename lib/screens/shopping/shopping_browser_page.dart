import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ShoppingBrowserPage extends StatefulWidget {
  final String url;

  const ShoppingBrowserPage({Key? key, required this.url}) : super(key: key);

  @override
  State<ShoppingBrowserPage> createState() => _ShoppingBrowserPageState();
}

class _ShoppingBrowserPageState extends State<ShoppingBrowserPage> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Shop View")),
      body: WebViewWidget(controller: _controller),
    );
  }
}
