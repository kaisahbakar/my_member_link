import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),

          /// [CalculatorApp] widget.
          useMaterial3: true,
        ),
        home: const SPlashScreen());
  }
}

class SPlashScreen extends StatefulWidget {
  const SPlashScreen({super.key});

  @override
  State<SPlashScreen> createState() => _SPlashScreenState();
}

class _SPlashScreenState extends State<SPlashScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const CalculatorApp()));
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/calculator.png',
              height: 200,
              width: 200,
            ),
            const SizedBox(height: 10,),
            const Text(
              "MyCalculator",
              style: TextStyle(fontSize: 30),
            ),
          ],
        ),
      ),
    );
  }
}

class CalculatorApp extends StatefulWidget {
  const CalculatorApp({super.key});

  @override
  State<CalculatorApp> createState() => _CalculatorAppState();
}

class _CalculatorAppState extends State<CalculatorApp> {
  TextEditingController num1EditingController = TextEditingController();
  TextEditingController num2EditingController = TextEditingController();
  int result = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Basic IO"),
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24.0), // Modern card shape
              ),
              elevation: 8,
              shadowColor: Theme.of(context).colorScheme.shadow,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: num1EditingController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Enter First Number",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        filled: true,
                        fillColor: Theme.of(context)
                            .colorScheme
                            .surfaceContainerHighest,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: num2EditingController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Enter Second Number",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        filled: true,
                        fillColor: Theme.of(context)
                            .colorScheme
                            .surfaceContainerHighest,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Divider(
                      height: 24,
                      color: Theme.of(context).colorScheme.primary,
                      thickness: 2,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          onPressed: calculateMe,
                          icon: const Icon(Icons.calculate),
                          label: const Text("Calculate"),
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: clearScreen,
                          icon: const Icon(Icons.clear),
                          label: const Text("Clear"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context)
                                .colorScheme
                                .secondary, // Secondary action button
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "OUTPUT: $result",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  calculateMe() {
    if (num1EditingController.text == "" || num2EditingController.text == "") {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter both numbers')),
      );
      return;
    }
    setState(() {
      int num1 = int.parse(num1EditingController.text);
      int num2 = int.parse(num2EditingController.text);
      result = num1 + num2;
    });
  }

  void clearScreen() {
    num1EditingController.text = "";
    num2EditingController.text = "";
    setState(() {});
  }
}
