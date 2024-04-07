import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final String _url = 'https://flutter.dev';

  late final WebViewController _webViewController = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted) // WebView의 javascript 허용
    ..loadRequest(Uri.parse(_url)); //Uri 요청

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('나만의 웹브라우저'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.add),
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              _webViewController.loadRequest(Uri.parse(value));
            },
            itemBuilder: (context) => [
              const PopupMenuItem<String>(
                value: 'https://www.google.com',
                child: Text('구글'),
              ),
              const PopupMenuItem<String>(
                value: 'https://www.naver.com',
                child: Text('네이버'),
              ),
              const PopupMenuItem<String>(
                value: 'https://www.kakao.com',
                child: Text('카카오'),
              ),
            ],
          ),
        ],
      ),
      body: PopScope(
        canPop: false,
        onPopInvoked: (didPop) async {
          if (didPop) return;
          if (await _webViewController.canGoBack()) {
            await _webViewController.goBack();
            return;
          }
          SystemNavigator.pop();
        },
        child: WebViewWidget(
          controller: _webViewController,
        ),
      ),
    );
  }
}
