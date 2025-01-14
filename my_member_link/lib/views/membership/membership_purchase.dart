import 'package:flutter/material.dart';

class MembershipPurchase extends StatelessWidget {
  final String membershipName;

  const MembershipPurchase({super.key, required this.membershipName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Purchase $membershipName')), 
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Simulate payment process
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Payment Successful'),
                content: Text('You have successfully purchased $membershipName!'),
                actions: <Widget>[
                  TextButton(
                    child: const Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                      // Update payment status in the membership list
                    },
                  ),
                ],
              ),
            );
          },
          child: const Text('Pay Now'),
        ),
      ),
    );
  }
}
