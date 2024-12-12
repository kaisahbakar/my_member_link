import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My APP',
      theme: ThemeData.light(),
      home: Scaffold(
          appBar: AppBar(
            title: const Text('My APP'),
            backgroundColor: Colors.yellow,
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Hello World"),
                const Text("Hello Flutter"),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(onPressed: () {}, icon: const Icon(Icons.home)),
                    IconButton(
                        onPressed: () {}, icon: const Icon(Icons.abc_outlined)),
                    IconButton(
                        onPressed: () {}, icon: const Icon(Icons.search)),
                    IconButton(
                        onPressed: () {}, icon: const Icon(Icons.delete)),
                    IconButton(
                        onPressed: () {}, icon: const Icon(Icons.data_array)),
                  ],
                )
              ],
            ),
          )),
    );
  }
}
