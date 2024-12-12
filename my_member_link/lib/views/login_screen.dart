import 'dart:convert';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:my_member_link/myconfig.dart';
import 'package:my_member_link/views/main_screen.dart';
import 'package:my_member_link/views/register_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool rememberMe = false;
  bool obscurePassword = true;

  @override
  void initState() {
    super.initState();
    loadPref();
  }

  @override
  Widget build(BuildContext context) {
    // Detect the height of the keyboard
    double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      body: Stack(
        children: [
          // Background Image with sliding effect
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            top: keyboardHeight > 0
                ? -MediaQuery.of(context).size.height * 0.5
                : -50,
            left: 0,
            right: 0,
            child: FractionallySizedBox(
              widthFactor: 1.0,
              child: Image.asset(
                'assets/images/login.png',
                fit: BoxFit.cover,
                height: MediaQuery.of(context).size.height * 0.5,
              ),
            ),
          ),
          // Content Section
          Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                top: keyboardHeight > 0
                    ? MediaQuery.of(context).size.height * 0.3
                    : MediaQuery.of(context).size.height * 0.35,
                bottom: keyboardHeight, // Adjust padding dynamically
              ),
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Welcome back to My Member Link!',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          foreground: Paint()
                            ..shader = ui.Gradient.linear(
                              const Offset(0, 20),
                              const Offset(300, 20),
                              <Color>[
                                const Color(0xFFFF0085),
                                const Color(0xFF13171A),
                                const Color(0xFFFF9F00),
                                const Color(0xFF0000FF),
                              ],
                              [0.0, 0.33, 0.66, 1.0],
                            ),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          hintText: "Email",
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                          if (!emailRegex.hasMatch(value)) {
                            return 'Please enter a valid email address';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        obscureText: obscurePassword,
                        controller: passwordController,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          hintText: "Password",
                          suffixIcon: IconButton(
                            icon: Icon(
                              obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: () {
                              setState(() {
                                obscurePassword = !obscurePassword;
                              });
                            },
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                      ),
                      Row(
                        children: [
                          const Text("Remember me"),
                          Checkbox(
                            value: rememberMe,
                            onChanged: (bool? value) {
                              setState(() {
                                rememberMe = value ?? false;
                              });
                            },
                          ),
                        ],
                      ),
                      MaterialButton(
                        elevation: 10,
                        onPressed: onLogin,
                        minWidth: 400,
                        height: 50,
                        color: Colors.deepOrange,
                        child: const Text(
                          "Login",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 20),
                      GestureDetector(
                        child: const Text(
                          "Forgot Password?",
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                      const SizedBox(height: 10),
                      GestureDetector(
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (content) => const RegisterScreen(),
                            ),
                          );
                          emailController.clear();
                          _formKey.currentState?.reset();
                        },
                        child: const Text(
                          "Create new account?",
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void onLogin() {
    if (_formKey.currentState?.validate() ?? false) {
      String email = emailController.text;
      String password = passwordController.text;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Logging in..."), backgroundColor: Colors.blue),
      );

      http.post(
        Uri.parse("${MyConfig.servername}/memberlink/login_user.php"),
        body: {"email": email, "password": password},
      ).then((response) {
        print("Status code: ${response.statusCode}");
        print("Response body: ${response.body}");

        if (response.statusCode == 200) {
          var data = jsonDecode(response.body);
          if (data['status'] == "success") {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Login Successful"),
              backgroundColor: Colors.green,
            ));
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (content) => const MainScreen()));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("Login Failed: ${data['message']}"),
              backgroundColor: Colors.red,
            ));
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text("Server Error"), backgroundColor: Colors.red),
          );
        }
      }).catchError((error) {
        print("Error: $error");
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Error: $error"),
          backgroundColor: Colors.red,
        ));
      });
    }
  }

  Future<void> loadPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    emailController.text = prefs.getString("email") ?? "";
    passwordController.text = prefs.getString("password") ?? "";
    rememberMe = prefs.getBool("rememberme") ?? false;
    setState(() {});
  }
}
