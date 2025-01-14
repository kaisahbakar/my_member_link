import 'package:flutter/material.dart';

class PaymentListScreen extends StatelessWidget {
  const PaymentListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment History'),
      ),
      body: const Center(
        child: Text('This is the payment history screen.'),
      ),
    );
  }
}
