import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_member_link/payment_service.dart';
import 'package:my_member_link/views/membership/payment_confirmation_page.dart';
import 'package:my_member_link/views/membership/payment_screen.dart';

class MembershipDetails extends StatelessWidget {
  final Map<String, dynamic> membership;
  final PaymentService _paymentService = PaymentService();

  MembershipDetails({super.key, required this.membership});

  @override
  Widget build(BuildContext context) {
    // Define additional details based on membership name
    final additionalDetails = {
      'Basic Membership': {
        'benefits': [
          'Networking opportunities within the community',
          'Access to basic content',
          'Community discussions',
        ],
        'features': [
          'Basic Support',
          'Access to Basic Content',
          'Community Access',
        ],
        'duration': '1 Month',
        'terms': [
          'Cancel anytime with no penalties',
          'Content restricted to basic access',
        ],
      },
      'Premium Membership': {
        'benefits': [
          'Advanced networking opportunities',
          'Participation in monthly webinars',
          'Access to exclusive premium content',
        ],
        'features': [
          'Priority Support',
          'Access to Premium Content',
          'Exclusive Community Access',
          'Monthly Webinars',
        ],
        'duration': '1 Month',
        'terms': [
          'Cancel anytime with 7 days’ notice',
          'No sharing of premium content',
        ],
      },
      'VIP Membership': {
        'benefits': [
          'Personalized coaching sessions',
          'Exclusive discounts on products/services',
          'VIP events and resources',
          'Priority community interaction',
        ],
        'features': [
          '24/7 Support',
          'All Content Access',
          'VIP Community Access',
          'Personalized Coaching',
          'Special Discounts',
        ],
        'duration': '1 Month',
        'terms': [
          '30-day cancellation policy',
          'Strict adherence to VIP guidelines',
        ],
      },
    };

    final details = additionalDetails[membership['name']]!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          membership['name']!,
          style: GoogleFonts.lato(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Membership Name
            Text(
              membership['name']!,
              style: GoogleFonts.lato(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            // Membership Details Card
            Card(
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Description
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.description, color: Colors.blue, size: 24),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            membership['description']!,
                            style: GoogleFonts.lato(
                              fontSize: 18,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),

                    // Price
                    Row(
                      children: [
                        const Icon(Icons.attach_money, color: Colors.green, size: 24),
                        const SizedBox(width: 10),
                        Text(
                          membership['price']!,
                          style: GoogleFonts.lato(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),

                    // Features
                    Text(
                      'Features:',
                      style: GoogleFonts.lato(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ...(details['features'] as List<dynamic>)
                        .map<Widget>((feature) {
                      return Row(
                        children: [
                          const Icon(Icons.check_circle, color: Colors.teal, size: 20),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              feature as String,
                              style: GoogleFonts.lato(
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
                    const SizedBox(height: 15),

                    // Benefits
                    Text(
                      'Benefits:',
                      style: GoogleFonts.lato(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ...(details['benefits'] as List<dynamic>)
                        .map<Widget>((benefit) {
                      return Row(
                        children: [
                          const Icon(Icons.check_circle, color: Colors.blue, size: 20),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              benefit,
                              style: GoogleFonts.lato(
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
                    const SizedBox(height: 15),

                    // Duration
                    Row(
                      children: [
                        const Icon(Icons.timer, color: Colors.orange, size: 24),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Duration: ${details['duration']}',
                            style: GoogleFonts.lato(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),

                    // Terms
                    Text(
                      'Terms:',
                      style: GoogleFonts.lato(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ...(details['terms'] as List<dynamic>).map<Widget>((term) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.rule, color: Colors.red, size: 20),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              term,
                              style: GoogleFonts.lato(
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PaymentScreen(
                      productName: membership['name'],
                      productDescription: membership['description'],
                      totalPrice: double.parse(membership['price']!.replaceAll(RegExp(r'[^0-9.]'), '')),
                    ),
                  ),
                );
              },
              child: const Text('Continue to Payment'),
            ),
          ],
        ),
      ),
    );
  }
}
