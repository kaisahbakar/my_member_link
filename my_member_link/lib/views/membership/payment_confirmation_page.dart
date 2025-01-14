import 'package:flutter/material.dart';

class PaymentConfirmationPage extends StatelessWidget {
  const PaymentConfirmationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Confirmation'),
      ),
      body: const Center(
        child: Text(
          'Thank you for your purchase! Your membership is now active.',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
