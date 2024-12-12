import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_member_link/myconfig.dart';

class NewNewsScreen extends StatefulWidget {
  final bool isDarkMode; // Accepting the theme mode value

  const NewNewsScreen({super.key, required this.isDarkMode});

  @override
  State<NewNewsScreen> createState() => _NewNewsScreenState();
}

class _NewNewsScreenState extends State<NewNewsScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController detailsController = TextEditingController();
  FocusNode detailsFocusNode = FocusNode();
  bool isDetailsFocused = false;

  late double screenWidth, screenHeight;

  @override
  void initState() {
    super.initState();

    // Listen for focus changes on the details text field
    detailsFocusNode.addListener(() {
      setState(() {
        isDetailsFocused = detailsFocusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    // Dispose focus node to avoid memory leaks
    detailsFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("New Newsletter"),
        backgroundColor: widget.isDarkMode ? Colors.black : Colors.white,
        foregroundColor: widget.isDarkMode ? Colors.white : Colors.black,
        elevation: 0,
        actions: isDetailsFocused
            ? [
                TextButton(
                  onPressed: () {
                    detailsFocusNode.unfocus(); // Dismiss keyboard
                  },
                  child: Text(
                    "Done",
                    style: TextStyle(
                      color: widget.isDarkMode ? Colors.white : Colors.black,
                      fontSize: 16,
                    ),
                  ),
                )
              ]
            : null,
      ),
      body: Stack(
        children: [
          // Background color
          Container(
            width: screenWidth,
            height: screenHeight,
            color: widget.isDarkMode ? Colors.black : Colors.white,
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 16, right: 16, top: 120, bottom: 16), // Adjusted padding
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header text with gradient color
                  ShaderMask(
                    shaderCallback: (bounds) {
                      return const LinearGradient(
                        colors: [Color(0xFFFF0085), Color(0xFFFF9F00)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ).createShader(
                          Rect.fromLTWH(0, 0, bounds.width, bounds.height));
                    },
                    child: const Text(
                      'Create a New News Article',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors
                            .white, // The text color will be overridden by the gradient
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  // Title TextField Container
                  Container(
                    decoration: BoxDecoration(
                      color:
                          widget.isDarkMode ? Colors.grey[800] : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 3,
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: titleController,
                      decoration: InputDecoration(
                        labelText: "News Title",
                        labelStyle: TextStyle(
                          color:
                              widget.isDarkMode ? Colors.white : Colors.black87,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 16.0, horizontal: 12.0),
                      ),
                      style: TextStyle(
                        color: widget.isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Details TextField Container
                  Container(
                    height: screenHeight * 0.5,
                    decoration: BoxDecoration(
                      color:
                          widget.isDarkMode ? Colors.grey[800] : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 3,
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: Scrollbar(
                      child: SingleChildScrollView(
                        child: TextField(
                          controller: detailsController,
                          focusNode: detailsFocusNode,
                          decoration: InputDecoration(
                            labelText: "News Details",
                            labelStyle: TextStyle(
                              color: widget.isDarkMode
                                  ? Colors.white
                                  : Colors.black87,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 16.0, horizontal: 12.0),
                          ),
                          style: TextStyle(
                            color:
                                widget.isDarkMode ? Colors.white : Colors.black,
                          ),
                          maxLines: null,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  // Insert News Button (Improved aesthetics)
                  Center(
                    child: SizedBox(
                      width: screenWidth * 0.8,
                      child: GestureDetector(
                        onTap: onInsertNewsDialog,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFFF0085), Color(0xFFFF9F00)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                spreadRadius: 3,
                                blurRadius: 8,
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Text(
                              "Insert News",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void onInsertNewsDialog() {
    if (titleController.text.isEmpty || detailsController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Please enter title and details"),
        backgroundColor: Colors.redAccent,
      ));
      return;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          title: const Text(
            "Insert this newsletter?",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent,
            ),
          ),
          content: const Text("Are you sure you want to add this news?"),
          actions: <Widget>[
            TextButton(
              child:
                  const Text("Yes", style: TextStyle(color: Colors.blueAccent)),
              onPressed: () {
                insertNews();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child:
                  const Text("No", style: TextStyle(color: Colors.blueAccent)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void insertNews() {
    String title = titleController.text;
    String details = detailsController.text;
    http.post(
        Uri.parse("${MyConfig.servername}/memberlink/api/insert_news.php"),
        body: {"title": title, "details": details}).then((response) {
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == "success") {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("News inserted successfully!"),
            backgroundColor: Colors.green,
          ));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Failed to insert news"),
            backgroundColor: Colors.redAccent,
          ));
        }
      }
    });
  }
}
