import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_member_link/myconfig.dart';
import 'dart:convert';
import 'package:my_member_link/payment_service.dart';

class PaymentScreen extends StatefulWidget {
  final String productName;
  final String productDescription;
  final double totalPrice;

  const PaymentScreen(
      {super.key,
      required this.productName,
      required this.productDescription,
      required this.totalPrice});

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String selectedPaymentMethod = 'Credit Card';
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _cardHolderNameController =
      TextEditingController();
  final TextEditingController _expirationDateController =
      TextEditingController();
  final TextEditingController _cvvController = TextEditingController();
  final TextEditingController _paypalEmailController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _bankAccountController = TextEditingController();
  final TextEditingController _bankNameController = TextEditingController();
  bool otpSent = false;

  Future<void> _submitPayment() async {
    final response = await http.post(
      Uri.parse('${MyConfig.servername}/memberlink/api/store_payment.php'),
      body: {
        'user_id': '1', // Replace with actual user ID
        'membership_type': 'Basic', // Replace with actual membership type
        'payment_method': selectedPaymentMethod,
        'amount': widget.totalPrice.toString(),
        'transaction_status': 'Pending',
        'card_number': _cardNumberController.text,
        'bank_account_number': _bankAccountController.text,
        'paypal_email': _paypalEmailController.text,
      },
    );

    // Check if the response status code is 200 (OK)
    if (response.statusCode == 200) {
      try {
        final responseData = json.decode(response.body);
        if (responseData['status'] == 'success') {
          // Handle success
          print('Payment stored successfully.');
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Success'),
                content: const Text('Payment information stored successfully.'),
                actions: <Widget>[
                  TextButton(
                    child: const Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        } else {
          // Handle error
          print('Error: ${responseData['message']}');
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Error'),
                content: Text(
                    'Failed to store payment information: ${responseData['message']}'),
                actions: <Widget>[
                  TextButton(
                    child: const Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        }
      } catch (e) {
        print('Error decoding response: $e');
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error'),
              content: const Text('Failed to decode response from server.'),
              actions: <Widget>[
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    } else {
      print(
          'Failed to connect to the server. Status code: ${response.statusCode}');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: Text(
                'Failed to connect to the server. Status code: ${response.statusCode}'),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.productName,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(widget.productDescription),
            const SizedBox(height: 16),
            Text('Total Price: \$${widget.totalPrice.toStringAsFixed(2)}'),
            const SizedBox(height: 16),
            DropdownButton<String>(
              value: selectedPaymentMethod,
              items: <String>['Credit Card', 'PayPal', 'Bank Transfer']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedPaymentMethod = newValue!;
                  otpSent =
                      false; // Reset OTP sent status on payment method change
                });
              },
            ),
            if (selectedPaymentMethod == 'Credit Card') ...[
              TextField(
                controller: _cardNumberController,
                decoration: const InputDecoration(labelText: 'Card Number'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _cardHolderNameController,
                decoration: const InputDecoration(labelText: 'Cardholder Name'),
              ),
              TextField(
                controller: _expirationDateController,
                decoration:
                    const InputDecoration(labelText: 'Expiration Date (MM/YY)'),
                keyboardType: TextInputType.datetime,
              ),
              TextField(
                controller: _cvvController,
                decoration: const InputDecoration(labelText: 'CVV'),
                keyboardType: TextInputType.number,
              ),
            ],
            if (selectedPaymentMethod == 'PayPal') ...[
              TextField(
                controller: _paypalEmailController,
                decoration: const InputDecoration(labelText: 'PayPal Email'),
              ),
              if (otpSent) ...[
                TextField(
                  controller: _otpController,
                  decoration: const InputDecoration(labelText: 'Enter OTP'),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    // Verify OTP logic here
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('OTP Verification'),
                          content: const Text('OTP verified successfully!'),
                          actions: <Widget>[
                            TextButton(
                              child: const Text('OK'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: const Text('Verify OTP'),
                ),
              ] else ...[
                ElevatedButton(
                  onPressed: () {
                    // Logic to send OTP to PayPal email
                    setState(() {
                      otpSent = true;
                    });
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('OTP Sent'),
                          content: Text(
                              'An OTP has been sent to ${_paypalEmailController.text}. Please check your email.'),
                          actions: <Widget>[
                            TextButton(
                              child: const Text('OK'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: const Text('Send OTP'),
                ),
              ],
            ],
            if (selectedPaymentMethod == 'Bank Transfer') ...[
              TextField(
                controller: _bankAccountController,
                decoration: const InputDecoration(labelText: 'Bank Account Number'),
              ),
              TextField(
                controller: _bankNameController,
                decoration: const InputDecoration(labelText: 'Bank Name'),
              ),
            ],
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _submitPayment,
              child: const Text('Pay Now'),
            ),
          ],
        ),
      ),
    );
  }
}
