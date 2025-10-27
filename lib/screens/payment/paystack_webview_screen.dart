import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:foodu/utils/popups/loaders.dart';
import 'dart:async';

// Conditional imports
import 'package:webview_flutter/webview_flutter.dart'
    if (dart.library.html) 'paystack_webview_stub.dart';

// Web-specific imports - only imported on web
import 'dart:html' as html show IFrameElement, window;
import 'dart:ui_web' as ui_web show platformViewRegistry;

class PaystackWebViewScreen extends StatefulWidget {
  final String paymentUrl;
  final String reference;
  final Function(bool success, String? message) onPaymentComplete;

  const PaystackWebViewScreen({
    super.key,
    required this.paymentUrl,
    required this.reference,
    required this.onPaymentComplete,
  });

  @override
  State<PaystackWebViewScreen> createState() => _PaystackWebViewScreenState();
}

class _PaystackWebViewScreenState extends State<PaystackWebViewScreen> {
  WebViewController? _controller;
  bool _isLoading = true;
  bool _paymentCompleted = false;

  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      _handleWebPayment();
    } else {
      _initializeWebView();
    }
  }

  // Handle payment on web using iframe (smooth UX)
  void _handleWebPayment() {
    if (!kIsWeb) return;
    
    // Create unique view ID
    final viewId = 'paystack-iframe-${widget.reference}';
    String src = widget.paymentUrl;
    // Register iframe view factory
    ui_web.platformViewRegistry.registerViewFactory(
      viewId,
      (int viewId) {
        final iframe = html.IFrameElement()
          ..src = widget.paymentUrl
          ..style.border = 'none'
          ..style.width = '100%'
          ..style.height = '100%';
        
        // Listen for iframe load
        iframe.onLoad.listen((_) {
          if (mounted) {
            setState(() {
              _isLoading = false;
            });
          }
        });

      // iframe.baseUri;

      src = iframe.src ?? "";
        
        return iframe;
      },
    );
    
    // Monitor for payment completion via postMessage events
    _startPaymentMonitoring(src);
  }
  
  void _startPaymentMonitoring(String origin) {
    // Listen for postMessage events from the callback page
    html.window.onMessage.listen((event) {
      if (!mounted || _paymentCompleted) return;
      
      try {
        // Check if message is from our callback page
        if (origin == 'https://ghig-web.github.io' || 
            origin == 'https://claudioussamuel.github.io') {
          
          final data = event.data;
          
          // Handle payment success
          if (data is Map && data['status'] == 'success') {
            _paymentCompleted = true;
            widget.onPaymentComplete(true, 'Payment completed successfully');
            Get.back();
          }
          
          // Handle payment failure/cancellation
          if (data is Map && data['status'] == 'failed') {
            _paymentCompleted = true;
            widget.onPaymentComplete(false, data['message'] ?? 'Payment failed');
            Get.back();
          }
        }
      } catch (e) {
        // Ignore invalid messages
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  // Initialize WebView for mobile (ghig-app approach)
  void _initializeWebView() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar
          },
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false;
            });
          },
          onWebResourceError: (WebResourceError error) {
            setState(() {
              _isLoading = false;
            });
            TLoaders.errorSnackBar(
              title: 'Error',
              message: 'Failed to load payment page: ${error.description}',
            );
          },
          onNavigationRequest: (NavigationRequest request) async {
            // Check if payment was cancelled
            if (request.url.startsWith('https://standard.paystack.co/close')) {
              if (!_paymentCompleted) {
                _paymentCompleted = true;
                widget.onPaymentComplete(false, 'Payment was cancelled');
                Get.back();
              }
            }
            
            // Check if payment was successful
            if (request.url.startsWith('https://ghig-web.github.io')) {
              if (!_paymentCompleted) {
                _paymentCompleted = true;
                widget.onPaymentComplete(true, 'Payment completed successfully');
                Get.back();
              }
            }
            
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.paymentUrl));
  }

  @override
  Widget build(BuildContext context) {
    // On web, show iframe with payment form
    if (kIsWeb) {
      final viewId = 'paystack-iframe-${widget.reference}';
      
      return Scaffold(
        appBar: AppBar(
          title: const Text('Complete Payment'),
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              widget.onPaymentComplete(false, 'Payment cancelled by user');
              Get.back();
            },
          ),
        ),
        body: Stack(
          children: [
            // Iframe for payment
            HtmlElementView(viewType: viewId),
            
            // Loading indicator
            if (_isLoading)
              Container(
                color: Colors.white,
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text('Loading payment page...'),
                    ],
                  ),
                ),
              ),
          ],
        ),
      );
    }

    // On mobile, show WebView
    return Scaffold(
      appBar: AppBar(
        title: const Text('Complete Payment'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            widget.onPaymentComplete(false, 'Payment cancelled by user');
            Get.back();
          },
        ),
      ),
      body: Stack(
        children: [
          if (_controller != null) WebViewWidget(controller: _controller!),
          if (_isLoading)
            const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Loading payment page...'),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
