import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';

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
  Timer? _pollTimer;

  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      _launchPaymentInBrowser();
    }
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    super.dispose();
  }

  // Launch payment in browser for web platform
  Future<void> _launchPaymentInBrowser() async {
    final Uri url = Uri.parse(widget.paymentUrl);
    
    if (await canLaunchUrl(url)) {
      await launchUrl(
        url,
        mode: LaunchMode.externalApplication, // Opens in new tab
      );
      
      // Start polling or show manual verification
      _showPaymentPendingDialog();
    } else {
      widget.onPaymentComplete(false, 'Could not launch payment page');
      Navigator.of(context).pop();
    }
  }

  void _showPaymentPendingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Payment in Progress'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Please complete your payment in the opened tab.'),
            SizedBox(height: 8),
            Text('Click "Done" when payment is complete.'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
              widget.onPaymentComplete(true, 'Payment completed');
              Navigator.of(context).pop(); // Close payment screen
            },
            child: const Text('Done'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
              widget.onPaymentComplete(false, 'Payment cancelled');
              Navigator.of(context).pop(); // Close payment screen
            },
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // On web, show loading (payment opens in new tab)
    if (kIsWeb) {
      return Scaffold(
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Opening payment page...'),
            ],
          ),
        ),
      );
    }

    // On mobile, use WebView (ghig-app approach)
    WebViewController controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onHttpError: (HttpResponseError error) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) async {
            // Detect payment cancellation
            if (request.url.startsWith('https://standard.paystack.co/close')) {
              widget.onPaymentComplete(false, 'Payment was cancelled');
              Navigator.of(context).pop();
              return NavigationDecision.navigate;
            }
            
            // Detect payment completion (ghig-app approach)
            // Paystack redirects to receipt page or includes transaction reference in URL
            if (request.url.contains('https://ghig-web.github.io') ||
                request.url.contains('trxref=') ||
                request.url.contains('reference=')) {
              widget.onPaymentComplete(true, 'Payment completed successfully');

              if (context.mounted) {
                Navigator.of(context).pop();
              }
              return NavigationDecision.navigate;
            }

            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(
        Uri.parse(widget.paymentUrl),
      );
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Complete Payment'),
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              // Show confirmation dialog before cancelling payment
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Cancel Payment?'),
                  content: const Text('Are you sure you want to cancel this payment?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('No'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Close dialog
                        widget.onPaymentComplete(false, 'Payment cancelled by user');
                        Navigator.of(context).pop(); // Close payment screen
                      },
                      child: const Text('Yes, Cancel'),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        body: WebViewWidget(controller: controller),
      ),
    );
  }
}
