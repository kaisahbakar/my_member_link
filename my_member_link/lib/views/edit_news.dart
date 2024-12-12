import 'package:flutter/material.dart';
import 'package:my_member_link/models/news.dart';

class EditNewsScreen extends StatefulWidget {
  final News news;
  final bool isDarkMode; // Add a parameter to accept the theme mode

  const EditNewsScreen(
      {super.key, required this.news, required this.isDarkMode});

  @override
  State<EditNewsScreen> createState() => _EditNewsState();
}

class _EditNewsState extends State<EditNewsScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController detailsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    titleController.text = widget.news.newsTitle.toString();
    detailsController.text = widget.news.newsDetails.toString();
  }

  late double screenWidth, screenHeight;

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return MaterialApp(
      theme: widget.isDarkMode
          ? ThemeData.dark()
          : ThemeData.light(), // Apply the theme
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Edit Newsletter"),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                    controller: titleController,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      hintText: "News Title",
                      filled: true,
                      fillColor: widget.isDarkMode
                          ? Colors.grey[800]
                          : Colors.grey[
                              200], // Change the background color based on the mode
                    )),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: screenHeight * 0.7,
                  child: TextField(
                    controller: detailsController,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      hintText: "News Details",
                      filled: true,
                      fillColor: widget.isDarkMode
                          ? Colors.grey[800]
                          : Colors.grey[
                              200], // Change the background color based on the mode
                    ),
                    maxLines: screenHeight ~/ 35,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                MaterialButton(
                  elevation: 10,
                  onPressed: onUpdateNewsDialog,
                  minWidth: screenWidth,
                  height: 50,
                  color: widget.isDarkMode
                      ? Colors.blueAccent
                      : Colors.blue, // Adjust button color based on theme
                  child: const Text(
                    "Update News",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onUpdateNewsDialog() {
    // Handle your update logic here
  }
}
