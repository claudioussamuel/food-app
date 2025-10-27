// Stub file for web - provides dummy types when webview_flutter is not available
// This file is only used on web platform

import 'package:flutter/material.dart';

// Dummy classes to satisfy type checking on web
class WebViewController {
  WebViewController();
  
  void setJavaScriptMode(JavaScriptMode mode) {}
  void setNavigationDelegate(NavigationDelegate delegate) {}
  void loadRequest(Uri uri) {}
}

class WebViewWidget extends StatelessWidget {
  final WebViewController controller;
  
  const WebViewWidget({super.key, required this.controller});
  
  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}

enum JavaScriptMode {
  unrestricted,
  disabled,
}

class NavigationDelegate {
  final Function(int)? onProgress;
  final Function(String)? onPageStarted;
  final Function(String)? onPageFinished;
  final Function(WebResourceError)? onWebResourceError;
  final Future<NavigationDecision> Function(NavigationRequest)? onNavigationRequest;
  
  NavigationDelegate({
    this.onProgress,
    this.onPageStarted,
    this.onPageFinished,
    this.onWebResourceError,
    this.onNavigationRequest,
  });
}

class WebResourceError {
  final String description;
  
  WebResourceError({required this.description});
}

class NavigationRequest {
  final String url;
  
  NavigationRequest({required this.url});
}

enum NavigationDecision {
  navigate,
  prevent,
}
