import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:foodu/utils/popups/loaders.dart'; 
import 'package:foodu/screens/payment/paystack_webview_screen.dart';

class PaystackPaymentService extends GetxController {
  static PaystackPaymentService get instance => Get.find();

  // Paystack configuration - Replace with your actual keys
  static const String _secretKey =
      'sk_test_d1bb10a3feb64d3168d3828ab067c5072d1db982'; 
  static const String _baseUrl = 'https://api.paystack.co';

  /// Initialize payment with Paystack
  Future<PaymentResult> initializePayment({
    required String email,
    required double amount,
    required String reference,
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? callbackUrl,
  }) async {
    try {
      // Convert amount to kobo (Paystack uses kobo as the smallest currency unit)
      final amountInKobo = (amount * 100).round();

      // Prepare payment data
      final paymentData = {
        'email': email,
        'amount': amountInKobo,
        'reference': reference,
        'currency': 'GHS', // Ghana Cedi
        'callback_url': callbackUrl ?? 'https://ghig-web.github.io', 
        'metadata': {
          'custom_fields': [
            if (firstName != null)
              {
                'display_name': 'First Name',
                'variable_name': 'first_name',
                'value': firstName
              },
            if (lastName != null)
              {
                'display_name': 'Last Name',
                'variable_name': 'last_name',
                'value': lastName
              },
            if (phoneNumber != null)
              {
                'display_name': 'Phone Number',
                'variable_name': 'phone_number',
                'value': phoneNumber
              },
          ]
        }
      };

      // Show loading indicator
      TLoaders.customToast(message: 'Initializing payment...');

      // Make HTTP request to Paystack
      final response = await http.post(
        Uri.parse('$_baseUrl/transaction/initialize'),
        headers: {
          'Authorization': 'Bearer $_secretKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(paymentData),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        if (responseData['status'] == true) {
          final authorizationUrl = responseData['data']['authorization_url'];

          // Launch the payment URL using WebView
          final paymentResult =
              await _launchPaymentWebView(authorizationUrl, reference);

          return paymentResult;
        } else {
          return PaymentResult.failure(
              message:
                  responseData['message'] ?? 'Payment initialization failed');
        }
      } else {
        final errorData = jsonDecode(response.body);
        return PaymentResult.failure(
            message: errorData['message'] ?? 'Payment initialization failed');
      }
    } catch (e) {
      TLoaders.errorSnackBar(
        title: 'Payment Error',
        message: 'An error occurred while initializing payment: $e',
      );
      return PaymentResult.failure(message: e.toString());
    }
  }

  /// Launch payment URL using WebView
  Future<PaymentResult> _launchPaymentWebView(
      String url, String reference) async {
    try {
      bool paymentSuccess = false;
      String? paymentMessage;

      // Show WebView for payment
      await Get.to(
        () => PaystackWebViewScreen(
          paymentUrl: url,
          reference: reference,
          onPaymentComplete: (success, message) {
            paymentSuccess = success;
            paymentMessage = message;
          },
        ),
      );

      if (paymentSuccess) {
        // Verify the payment with Paystack
        final verificationResult = await verifyPayment(reference);
        return verificationResult;
      } else {
        return PaymentResult.failure(
          message: paymentMessage ?? 'Payment was cancelled or failed',
        );
      }
    } catch (e) {
      return PaymentResult.failure(message: e.toString());
    }
  }

  /// Verify payment with Paystack
  Future<PaymentResult> verifyPayment(String reference) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/transaction/verify/$reference'),
        headers: {
          'Authorization': 'Bearer $_secretKey',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        if (responseData['status'] == true) {
          final data = responseData['data'];

          if (data['status'] == 'success') {
            TLoaders.successSnackBar(
              title: 'Payment Successful',
              message: 'Your payment has been verified successfully',
            );
            return PaymentResult.success(
              reference: reference,
              message: 'Payment verified successfully',
            );
          } else {
            TLoaders.errorSnackBar(
              title: 'Payment Failed',
              message: 'Payment was not successful',
            );
            return PaymentResult.failure(message: 'Payment was not successful');
          }
        } else {
          return PaymentResult.failure(
              message:
                  responseData['message'] ?? 'Payment verification failed');
        }
      } else {
        final errorData = jsonDecode(response.body);
        return PaymentResult.failure(
            message: errorData['message'] ?? 'Payment verification failed');
      }
    } catch (e) {
      TLoaders.errorSnackBar(
        title: 'Verification Error',
        message: 'An error occurred while verifying payment: $e',
      );
      return PaymentResult.failure(message: e.toString());
    }
  }

  /// Generate a unique reference for the payment
  String generateReference() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = (timestamp % 10000).toString().padLeft(4, '0');
    return 'FOODU_${timestamp}_$random';
  }
}

/// Payment result class
class PaymentResult {
  final bool isSuccess;
  final String message;
  final String? reference;

  PaymentResult._({
    required this.isSuccess,
    required this.message,
    this.reference,
  });

  factory PaymentResult.success({
    required String reference,
    required String message,
  }) {
    return PaymentResult._(
      isSuccess: true,
      message: message,
      reference: reference,
    );
  }

  factory PaymentResult.failure({
    required String message,
  }) {
    return PaymentResult._(
      isSuccess: false,
      message: message,
    );
  }
}
