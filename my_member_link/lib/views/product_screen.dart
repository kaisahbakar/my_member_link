import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:my_member_link/myconfig.dart';
import 'display_product.dart'; // Import the ProductDetailScreen

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  List products = [];
  bool isLoading = true;
  int currentPage = 1;
  int totalPages = 1; // Total number of pages
  int itemsPerPage = 10; // Number of items per page

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  // Fetch products for the current page
  Future<void> fetchProducts() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.get(Uri.parse(
          "${MyConfig.servername}/memberlink/api/load_product.php?page=$currentPage&limit=$itemsPerPage"));

      if (response.statusCode == 200) {
        var data = json.decode(response.body);

        print('Decoded data: $data'); // Debugging response structure

        if (data is Map && data['products'] != null) {
          setState(() {
            products = data['products'];
            totalPages =
                data['totalPages']; // Set total pages from the response
            isLoading = false;
          });
        } else {
          setState(() {
            isLoading = false;
          });
        }
      } else {
        setState(() {
          isLoading = false;
        });
        print('Failed to load products: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e'); // Print any error encountered
      setState(() {
        isLoading = false;
      });
    }
  }

  // Handle the next page action
  void nextPage() {
    if (currentPage < totalPages) {
      setState(() {
        currentPage++;
      });
      fetchProducts();
    }
  }

  // Handle the previous page action
  void previousPage() {
    if (currentPage > 1) {
      setState(() {
        currentPage--;
      });
      fetchProducts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Shop')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : products.isEmpty
              ? const Center(child: Text('No products available'))
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Expanded(
                        child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 0.7,
                          ),
                          itemCount: products.length,
                          itemBuilder: (context, index) {
                            var product = products[index];

                            // Handle multiple images (single or array)
                            List<String> images = [];
                            if (product['image_url'] is String) {
                              images = [product['image_url']];
                            } else if (product['image_url'] is List) {
                              images = List<String>.from(product['image_url']);
                            }

                            return GestureDetector(
                              onTap: () {
                                // Navigate to the display product screen
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DisplayProductScreen(
                                      product:
                                          product, // Passing the product data
                                    ),
                                  ),
                                );
                              },
                              child: Card(
                                margin: const EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Column(
                                  children: [
                                    // Display first image from the images list
                                    images.isNotEmpty
                                        ? ClipRRect(
                                            borderRadius:
                                                const BorderRadius.only(
                                              topLeft: Radius.circular(15),
                                              topRight: Radius.circular(15),
                                            ),
                                            child: Container(
                                              width: double.infinity,
                                              height: 150.0,
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                  image: NetworkImage(
                                                    "${MyConfig.servername}/${images[0]}", // Display first image
                                                  ),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                          )
                                        : const Icon(Icons.image,
                                            size: 200, color: Colors.grey),
                                    Flexible(
                                      child: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment
                                              .start, // Align content to the left
                                          mainAxisSize:
                                              MainAxisSize.min, // Wrap tightly
                                          children: [
                                            Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                product['name'],
                                                style: const TextStyle(
                                                    fontSize: 13,
                                                    fontWeight:
                                                        FontWeight.bold),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                              ),
                                            ),
                                            const SizedBox(height: 5),
                                            Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                '\$${product['price']}',
                                                style: const TextStyle(
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      // Pagination Controls
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back),
                            onPressed: currentPage > 1
                                ? previousPage
                                : null, // Disable if on first page
                          ),
                          Text('Page $currentPage'),
                          IconButton(
                            icon: const Icon(Icons.arrow_forward),
                            onPressed: currentPage < totalPages
                                ? nextPage
                                : null, // Disable if on last page
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
    );
  }
}
