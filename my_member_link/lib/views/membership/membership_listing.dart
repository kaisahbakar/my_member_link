import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'membership_details.dart';

class MembershipListing extends StatefulWidget {
  const MembershipListing({super.key});

  @override
  _MembershipListingState createState() => _MembershipListingState();
}

class _MembershipListingState extends State<MembershipListing>
    with SingleTickerProviderStateMixin {
  final List<Map<String, dynamic>> monthlyMemberships = [
    {
      'id': 'monthly_basic_1',
      'name': 'Basic Membership',
      'description': 'Access to basic features',
      'price': 'MYR 10/month',
      'features': [
        'Basic Support',
        'Access to Basic Content',
        'Community Access',
      ],
    },
    {
      'id': 'monthly_premium_2',
      'name': 'Premium Membership',
      'description': 'Access to all features',
      'price': 'MYR 20/month',
      'features': [
        'Priority Support',
        'Access to Premium Content',
        'Exclusive Community Access',
        'Monthly Webinars',
      ],
    },
    {
      'id': 'monthly_vip_3',
      'name': 'VIP Membership',
      'description': 'Exclusive access and benefits',
      'price': 'MYR 30/month',
      'features': [
        '24/7 Support',
        'All Content Access',
        'VIP Community Access',
        'Personalized Coaching',
        'Special Discounts',
      ],
    },
  ];

  late List<Map<String, dynamic>> memberships;
  late PageController _pageController;
  late AnimationController _gradientController;
  late Animation<double> _gradientAnimation;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();

    memberships = monthlyMemberships; // Default to monthly memberships

    _pageController = PageController(viewportFraction: 0.85);

    _gradientController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _gradientAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _gradientController,
        curve: Curves.linear,
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _gradientController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Membership'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: AnimatedBuilder(
                animation: _gradientAnimation,
                builder: (context, child) {
                  return ShaderMask(
                    shaderCallback: (Rect bounds) {
                      return LinearGradient(
                        colors: const [
                          Colors.blue,
                          Colors.purple,
                          Colors.red,
                          Colors.orange,
                          Colors.yellow,
                        ],
                        stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        transform: GradientRotation(
                            _gradientAnimation.value * 2 * 3.1416),
                      ).createShader(bounds);
                    },
                    child: Text(
                      'Join Us Today!',
                      style: GoogleFonts.lato(
                        fontSize: 65,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        color: Colors.white,
                        letterSpacing: -1.5,
                        height: 1.0,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 450,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: memberships.length,
                      onPageChanged: (index) {
                        setState(() {
                          _currentIndex = index;
                        });
                      },
                      itemBuilder: (context, index) {
                        double value = 1.0;

                        if (_pageController.hasClients && _pageController.position.hasPixels) {
                          value = (_pageController.page ?? 0.0) - index;
                          value = (1 - (value.abs() * 0.3)).clamp(0.0, 1.0);
                        }

                        return Transform.scale(
                          scale: value,
                          child: buildCard(index),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(memberships.length, (index) {
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        height: 10,
                        width: _currentIndex == index ? 10 : 8,
                        decoration: BoxDecoration(
                          color: _currentIndex == index
                              ? Colors.blue
                              : Colors.grey,
                          borderRadius: BorderRadius.circular(5),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCard(int index) {
    return Center(
      child: SizedBox(
        height: 400,
        width: MediaQuery.of(context).size.width * 0.9,
        child: Card(
          elevation: 8,
          margin: const EdgeInsets.symmetric(horizontal: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  memberships[index]['name']!,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  memberships[index]['description']!,
                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  memberships[index]['price']!,
                  style: const TextStyle(
                    color: Colors.green,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: (memberships[index]['features'] as List<String>)
                      .map((feature) => Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.check_circle,
                                  color: Colors.blue, size: 18),
                              const SizedBox(width: 10),
                              Text(
                                feature,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ))
                      .toList(),
                ),
                const SizedBox(height: 20),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MembershipDetails(
                          membership: memberships[index],
                        ),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Colors.blue, Colors.purple],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Choose Plan',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.arrow_forward,
                            color: Colors.white, size: 18),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
