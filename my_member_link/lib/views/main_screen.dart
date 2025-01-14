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

  void _handleRefresh() {
    loadNewsData();
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
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
          elevation: 1,
          iconTheme: IconThemeData(
            color: isDarkMode
                ? const Color.fromARGB(255, 213, 223, 243)
                : Colors.black,
          ),
          title: Text(
            "Newsletter",
            style: TextStyle(
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(
                isDarkMode ? Icons.nightlight_round : Icons.wb_sunny,
                color: isDarkMode ? Colors.yellow : Colors.orange,
              ),
              onPressed: () {
                setState(() {
                  isDarkMode = !isDarkMode;
                });
              },
            ),
            IconButton(
              icon: isLoading
                  ? const CircularProgressIndicator()
                  : const Icon(Icons.refresh),
              onPressed: isLoading ? null : _handleRefresh,
            ),
          ],
        ),
        drawer:  const MyDrawer(),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                focusNode: searchFocusNode,
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

                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          color: isDarkMode
                              ? Colors.grey[800]
                              : const Color.fromARGB(
                                  255, 255, 255, 255), // Adjust card color
                          child: SizedBox(
                            height: 120, // Fixed height for all cards
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text(
                                          truncateString(
                                              currentItems[index].newsTitle,
                                              30),
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: isDarkMode
                                                ? Colors.white
                                                : Colors.black,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          _formatDate(
                                              currentItems[index].newsDate),
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: isDarkMode
                                                ? Colors.grey[400]
                                                : Colors.grey[600],
                                          ),
                                        ),
                                        Text(
                                          truncateString(
                                              currentItems[index].newsDetails,
                                              100),
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: isDarkMode
                                                ? Colors.grey[300]
                                                : Colors.grey[700],
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.arrow_forward,
                                      color: isDarkMode
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: Text(
                                              currentItems[index].newsTitle),
                                          content: Text(
                                              currentItems[index].newsDetails),
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
                                                      isDarkMode: isDarkMode,
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
                                ],
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
          backgroundColor: const Color(0xFF6200EE),
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NewNewsScreen(isDarkMode: isDarkMode),
              ),
            );
            loadNewsData();
          },
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }
}
