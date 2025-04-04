import 'package:esewa_flutter_sdk/esewa_config.dart';
import 'package:esewa_flutter_sdk/esewa_flutter_sdk.dart';
import 'package:esewa_flutter_sdk/esewa_payment.dart';
import 'package:esewa_flutter_sdk/esewa_payment_success_result.dart';
import 'package:flutter/material.dart';

class EsewaPaymentScreen extends StatelessWidget {
  final double amount;
  final String productId;
  final String productName;

  EsewaPaymentScreen({
    required this.amount,
    required this.productId,
    required this.productName,
  });

  void _payWithEsewa(BuildContext context) {
    try {
      EsewaFlutterSdk.initPayment(
        esewaConfig: EsewaConfig(
          environment:
              Environment.test, // Change to Environment.live for production
          clientId: "JB0BBQ4aD0UqIThFJwAKBgAXEUkEGQUBBAwdOgABHD4DChwUAB0R",
          secretId: "BhwIWQQADhIYSxILExMcAgFXFhcOBwAKBgAXEQ==",
        ),
        esewaPayment: EsewaPayment(
          productId: productId,
          productName: productName,
          productPrice: amount.toString(),
          callbackUrl: '',
        ),
        onPaymentSuccess: (EsewaPaymentSuccessResult data) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Payment Successful: ${data.refId}")),
          );
        },
        onPaymentFailure: (data) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Payment Failed: ${data.message}")),
          );
        },
        onPaymentCancellation: (data) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Payment Cancelled: ${data.message}")),
          );
        },
      );
    } on Exception catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("eSewa Payment")),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _payWithEsewa(context),
          child: Text("Proceed to Pay"),
        ),
      ),
    );
  }
}
