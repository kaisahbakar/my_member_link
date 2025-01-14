import 'package:flutter/material.dart';

class PaymentList extends StatelessWidget {
  final List<Map<String, dynamic>> payments = [
    {'membership': 'Basic Membership', 'date': '2025-01-10', 'amount': '\$10', 'status': 'Paid'},
    {'membership': 'Premium Membership', 'date': '2025-01-11', 'amount': '\$20', 'status': 'Pending'},
  ];

  PaymentList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Payment Summary')), 
      body: ListView.builder(
        itemCount: payments.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text(payments[index]['membership']!),
              subtitle: Text('Purchase Date: ${payments[index]['date']}'),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Amount: ${payments[index]['amount']}'),
                  Text('Status: ${payments[index]['status']}'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
