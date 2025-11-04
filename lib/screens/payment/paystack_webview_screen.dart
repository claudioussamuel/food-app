import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../services/paystack_payment_service.dart';

class PaystackWebViewScreen extends StatefulWidget {
  final String paymentUrl;
  final String reference;

  const PaystackWebViewScreen({
    super.key,
    required this.paymentUrl,
    required this.reference,
  });

  @override
  State<PaystackWebViewScreen> createState() => _PaystackWebViewScreenState();
}

class _PaystackWebViewScreenState extends State<PaystackWebViewScreen> {
  final PaystackPaymentService _paymentService = PaystackPaymentService();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
              Navigator.of(context).pop();
              return NavigationDecision.navigate;
            }
            
            // Detect payment completion
            if (request.url.startsWith('https://ghig-web.github.io')) {
              await _paymentService.verifyPayment(widget.reference);

              if (context.mounted) {
                Navigator.of(context).pop();
              }
            }

            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(
        Uri.parse(widget.paymentUrl),
      );
      print('widget.paymentUrl ${widget.paymentUrl}');
    return SafeArea(
      child: Scaffold(
        // appBar: AppBar(title: const Text('Complete Payment')),
        body: WebViewWidget(controller: controller),
      ),
    );
  }
}
