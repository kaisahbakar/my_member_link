import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:my_member_link/views/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _topAnimation;
  late Animation<Offset> _bottomAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize animation controller
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    // Set up animations for top and bottom images
    _topAnimation = Tween<Offset>(
      begin: const Offset(0, -1.5),
      end: const Offset(0, -0.2), // Stop just before reaching the text
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _bottomAnimation = Tween<Offset>(
      begin: const Offset(0, 1.5),
      end: const Offset(0, 0.2), // Stop just before reaching the text
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    // Start the animations
    _controller.forward();

    // Navigate to login screen after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const LoginScreen()));
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Animated top image
          SlideTransition(
            position: _topAnimation,
            child: Align(
              alignment: Alignment.topCenter,
              child: Image.asset(
                'assets/images/login.png',
                fit: BoxFit.cover,
                height: MediaQuery.of(context).size.height * 0.5,
              ),
            ),
          ),

          // Animated bottom image with rotation
          SlideTransition(
            position: _bottomAnimation,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Transform.rotate(
                angle: 3.14159, // Rotate 180 degrees
                child: Image.asset(
                  'assets/images/login.png',
                  fit: BoxFit.cover,
                  height: MediaQuery.of(context).size.height * 0.5,
                ),
              ),
            ),
          ),

          // Center text with gradient effect
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "MyMemberLink",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    foreground: Paint()
                      ..shader = ui.Gradient.linear(
                        const Offset(0, 0),
                        const Offset(200, 0),
                        [
                          const Color(0xFFFF0085),
                          const Color(0xFF13171A),
                          const Color(0xFFFF9F00),
                          const Color(0xFF0000FF),
                        ],
                        [0.0, 0.33, 0.66, 1.0],
                      ),
                  ),
                ),
                const SizedBox(height: 20),
                const CircularProgressIndicator(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
