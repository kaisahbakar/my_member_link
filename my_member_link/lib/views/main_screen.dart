import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_member_link/models/news.dart';
import 'package:my_member_link/myconfig.dart';
import 'package:http/http.dart' as http;
import 'package:my_member_link/views/mydrawer.dart';
import 'package:my_member_link/views/new_news.dart';
import 'package:my_member_link/views/edit_news.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<News> newsList = [];
  List<News> filteredNewsList = [];
  final df = DateFormat('yyyy-MM-dd HH:mm:ss');
  int currentPage = 1;
  int totalPages = 1;
  int itemsPerPage = 10;
  bool isLoading = false;
  bool isDarkMode = false;
  String searchQuery = "";

  final FocusNode searchFocusNode = FocusNode();

  final List<List<Color>> gradients = [
    [const Color(0xFFFF9F00), const Color(0xFFE70000)], // Orange to Red
    [const Color(0xFFE71E3F), const Color(0xFFED0BB9)], // Red to Pink
    [const Color(0xFFE81095), const Color(0xFF272CD3)], // Pink to Blue
    [const Color(0xFF1E30CD), const Color(0xFFE64E3C)], // Blue to Orange
  ];

  final List<List<Color>> lightModeGradients = [
    [
      const Color(0xFFFFE0B2),
      const Color(0xFFFFCDD2)
    ], // Light Orange to Light Red
    [
      const Color(0xFFFFCDD2),
      const Color.fromARGB(255, 228, 187, 248)
    ], // Light Red to Light Purple
    [
      const Color.fromARGB(255, 228, 187, 248),
      const Color.fromARGB(255, 179, 252, 241)
    ], // Light Purple to Light Blue
    [
      const Color.fromARGB(255, 179, 252, 241),
      const Color(0xFFFFE0B2)
    ], // Light Blue to Light Orange
  ];

  @override
  void initState() {
    super.initState();
    loadNewsData();
  }

  List<News> getCurrentPageItems() {
    int start = (currentPage - 1) * itemsPerPage;
    int end = start + itemsPerPage;

    end = end > filteredNewsList.length ? filteredNewsList.length : end;

    if (start >= filteredNewsList.length) {
      return [];
    }

    return filteredNewsList.sublist(start, end);
  }

  void changePage(int page) {
    if (page < 1 || page > totalPages) return;
    setState(() {
      currentPage = page;
    });
  }

  Future<void> loadNewsData() async {
    try {
      final response = await http.get(
        Uri.parse("${MyConfig.servername}/memberlink/api/load_news.php"),
      );
      log("Status code: ${response.statusCode}");
      log("Response body: ${response.body}");

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == "success") {
          var result = data['data']['news'];
          newsList.clear();
          for (var item in result) {
            log("Adding news item: ${item.toString()}");
            newsList.add(News.fromJson(item));
          }
          filterNews();
        }
      }
    } catch (error) {
      log("Error in loadNewsData: $error");
    }
  }

  void filterNews() {
    setState(() {
      filteredNewsList = newsList
          .where((news) =>
              news.newsTitle
                  .toLowerCase()
                  .contains(searchQuery.toLowerCase()) ||
              news.newsDetails
                  .toLowerCase()
                  .contains(searchQuery.toLowerCase()))
          .toList();
      totalPages = (filteredNewsList.length / itemsPerPage).ceil();
    });
  }

  String truncateString(String str, int length) {
    return (str.length > length) ? "${str.substring(0, length)}..." : str;
  }

  String _formatDate(String dateStr) {
    try {
      DateTime date = df.parse(dateStr);
      return DateFormat('dd/MM/yyyy hh:mm a').format(date);
    } catch (e) {
      log("Date parsing error: $e");
      return "Date not available";
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: Scaffold(
        resizeToAvoidBottomInset:
            false, // Prevents resizing when the keyboard appears
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: const IconThemeData(color: Color(0xFFFF0085)),
          title: const Text(
            "Newsletter",
            style: TextStyle(
              color: Color.fromARGB(255, 237, 20, 20),
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(
                isDarkMode
                    ? Icons.nightlight_round
                    : Icons.wb_sunny, // Icons for modes
                color: isDarkMode ? Colors.yellow : Colors.orange,
              ),
              onPressed: () {
                setState(() {
                  isDarkMode = !isDarkMode; // Toggle mode
                });
              },
            ),
            IconButton(
              icon: isLoading
                  ? const CircularProgressIndicator(
                      color: Colors.white,
                    )
                  : const Icon(Icons.refresh, color: Color(0xFFFF0085)),
              onPressed: isLoading ? null : _handleRefresh,
            ),
          ],
        ),
        drawer: const MyDrawer(),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      focusNode: searchFocusNode,
                      keyboardAppearance:
                          isDarkMode ? Brightness.dark : Brightness.light,
                      decoration: InputDecoration(
                        hintText: "Search by title or details...",
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          searchQuery = value;
                          filterNews();
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: getCurrentPageItems().isEmpty
                  ? Center(
                      child: Text(
                        "No news available at the moment.",
                        style: TextStyle(
                          color: isDarkMode ? Colors.white : Colors.black,
                          fontSize: 16,
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      itemCount: getCurrentPageItems().length,
                      itemBuilder: (context, index) {
                        List<News> currentItems = getCurrentPageItems();
                        List<Color> gradientColors = isDarkMode
                            ? gradients[index % gradients.length]
                            : lightModeGradients[
                                index % lightModeGradients.length];
                        final textColor =
                            isDarkMode ? Colors.white : Colors.black;

                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 3),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40),
                          ),
                          child: Container(
                            height: 110,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: gradientColors,
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: ListTile(
                              dense: true,
                              title: Text(
                                truncateString(
                                    currentItems[index].newsTitle, 30),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: textColor,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    _formatDate(currentItems[index].newsDate),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: textColor,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    truncateString(
                                        currentItems[index].newsDetails, 100),
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: textColor,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                              trailing: IconButton(
                                icon: Icon(
                                  Icons.arrow_forward,
                                  color:
                                      isDarkMode ? Colors.white : Colors.blue,
                                ),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text(
                                        currentItems[index].newsTitle,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
                                      ),
                                      content: Text(
                                        currentItems[index].newsDetails,
                                        style: const TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    EditNewsScreen(
                                                  news: currentItems[index],
                                                  isDarkMode:
                                                      isDarkMode, // Passing the isDarkMode value
                                                ),
                                              ),
                                            );
                                          },
                                          child: const Text("Edit"),
                                        ),
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: const Text("Close"),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
            if (totalPages > 1)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: currentPage > 1
                          ? () => changePage(currentPage - 1)
                          : null,
                    ),
                    Text("Page $currentPage of $totalPages"),
                    IconButton(
                      icon: const Icon(Icons.arrow_forward),
                      onPressed: currentPage < totalPages
                          ? () => changePage(currentPage + 1)
                          : null,
                    ),
                  ],
                ),
              ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: const Color.fromARGB(255, 187, 227, 29),
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    NewNewsScreen(isDarkMode: isDarkMode), // Passing isDarkMode
              ),
            ); // Added this closing parenthesis
            loadNewsData();
          },
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }

  Future<void> _handleRefresh() async {
    setState(() {
      isLoading = true;
    });
    await loadNewsData();
    setState(() {
      filterNews();
      totalPages = (filteredNewsList.length / itemsPerPage).ceil();
      isLoading = false;
    });
  }
}
