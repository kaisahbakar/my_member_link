import 'package:flutter/material.dart';
import 'package:my_member_link/views/main_screen.dart';
import 'package:my_member_link/views/product_screen.dart'; // Import ProductScreen

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              image: DecorationImage(
                image:
                    AssetImage('assets/images/mydrawer.gif'), // Path to the GIF
                fit: BoxFit.cover, // Cover the entire header area
                alignment: Alignment
                    .bottomCenter, // Focus on the bottom part of the GIF
              ),
            ),
            child: Align(
              alignment: Alignment.topCenter, // Place text at the bottom
              child: Text(
                'Welcome to My Member Link!',
                style: TextStyle(
                  fontSize: 16, // Font size
                  fontWeight: FontWeight.bold, // Bold text
                  color: Colors.black, // Black text color
                ),
                textAlign: TextAlign.center, // Center-align the text
              ),
            ),
          ),
          // Newsletter ListTile
          ListTile(
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      const MainScreen(),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    const begin = Offset(1.0, 0.0); // Slide in from the right
                    const end = Offset.zero;
                    const curve = Curves.ease;

                    var tween = Tween(begin: begin, end: end)
                        .chain(CurveTween(curve: curve));
                    var offsetAnimation = animation.drive(tween);

                    return SlideTransition(
                      position: offsetAnimation,
                      child: child,
                    );
                  },
                ),
              );
            },
            title: const Text("Newsletter"),
          ),
          // Removed Events ListTile
          // Members ListTile
          const ListTile(
            title: Text("Members"),
          ),
          // Payments ListTile
          const ListTile(
            title: Text("Payments"),
          ),
          // Products ListTile (Updated navigation to ProductScreen)
          ListTile(
            title: const Text("Products"),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProductScreen(),
                ),
              );
            },
          ),
          // Vetting ListTile
          const ListTile(
            title: Text("Vetting"),
          ),
          // Settings ListTile
          const ListTile(
            title: Text("Settings"),
          ),
          // Logout ListTile
          const ListTile(
            title: Text("Logout"),
          ),
        ],
      ),
    );
  }
}
