import 'package:flutter/material.dart';
import 'package:my_member_link/myconfig.dart';
import 'package:provider/provider.dart';
import 'package:my_member_link/models/cart.dart'; // Import Cart model
import 'package:cached_network_image/cached_network_image.dart'; // For displaying images from URLs

class DisplayProductScreen extends StatefulWidget {
  final Map<String, dynamic> product;

  const DisplayProductScreen({super.key, required this.product});

  @override
  _DisplayProductScreenState createState() => _DisplayProductScreenState();
}

class _DisplayProductScreenState extends State<DisplayProductScreen> {
  String? selectedSize;
  int quantity = 1; // Default quantity
  int stock = 0; // To store the product stock
  int _currentPage = 0; // To track the current page index
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(); // Initialize PageController

    // Set the stock value from the product data, ensuring it's an integer
    stock = int.tryParse(widget.product['stock'].toString()) ??
        0; // Get the available stock

    // Initialize selected size if available
    if (widget.product['sizes'] != null &&
        widget.product['sizes'] is List &&
        widget.product['sizes'].isNotEmpty) {
      List<String> availableSizes = List<String>.from(widget.product['sizes']
          .map<String>((sizeData) => sizeData['size'] as String));
      selectedSize = availableSizes.isNotEmpty ? availableSizes[0] : null;
    } else {
      selectedSize = null;
    }
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  // Show bottom sheet to select quantity
  void _showQuantityBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Select Quantity',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () {
                          if (quantity > 1) {
                            setState(() {
                              quantity--;
                            });
                          }
                        },
                      ),
                      Text(
                        '$quantity',
                        style: const TextStyle(fontSize: 18),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          if (quantity < stock) {
                            setState(() {
                              quantity++;
                            });
                          } else {
                            // Show an alert if the quantity exceeds available stock
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content:
                                    Text('Maximum available quantity: $stock'),
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // Close the bottom sheet
                      addToCart(); // Add product to cart
                    },
                    child: const Text('Add to Cart'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // Add to Cart function
  void addToCart() {
    final cart = Provider.of<Cart>(context, listen: false);
    cart.addToCart(widget.product, selectedSize ?? "", quantity);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Product added to cart')),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Extract images from product data
    List<String> images = [];
    if (widget.product['image_url'] is String) {
      images = [widget.product['image_url']];
    } else if (widget.product['image_url'] is List) {
      images = List<String>.from(widget.product['image_url']);
    }

    // Extract available sizes from product data
    List<String> availableSizes = widget.product['sizes'] != null
        ? List<String>.from(widget.product['sizes']
            .map<String>((sizeData) => sizeData['size'] as String))
        : [];

    return Scaffold(
      appBar: AppBar(title: Text(widget.product['name'])),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display product images in a PageView
            images.isNotEmpty
                ? Column(
                    children: [
                      SizedBox(
                        height: 400,
                        child: PageView.builder(
                          controller: _pageController,
                          itemCount: images.length,
                          onPageChanged: _onPageChanged,
                          itemBuilder: (context, index) {
                            String imageUrl =
                                "${MyConfig.servername}/${images[index]}";
                            return CachedNetworkImage(
                              imageUrl: imageUrl,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => const Center(
                                child: CircularProgressIndicator(),
                              ),
                              errorWidget: (context, url, error) => const Icon(
                                Icons.error,
                                size: 100,
                                color: Colors.red,
                              ),
                            );
                          },
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(images.length, (index) {
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _currentPage == index
                                  ? Colors.blue
                                  : Colors.grey,
                            ),
                          );
                        }),
                      ),
                    ],
                  )
                : const Icon(Icons.image, size: 200, color: Colors.grey),
            const SizedBox(height: 20),
            // Row with product name and add to cart icon
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.product['name'],
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.add_shopping_cart),
                  onPressed: _showQuantityBottomSheet, // Show the bottom sheet
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Product price
            Text(
              '\$${widget.product['price']}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 20),
            // Product description
            Text(
              widget.product['description'] ?? 'No description available.',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            // Size selection dropdown
            availableSizes.isNotEmpty
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Choose Size:',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      DropdownButton<String>(
                        value: selectedSize,
                        onChanged: (String? newSize) {
                          setState(() {
                            selectedSize = newSize;
                          });
                        },
                        items: availableSizes
                            .map<DropdownMenuItem<String>>((size) {
                          return DropdownMenuItem<String>(
                            value: size,
                            child: Text(size),
                          );
                        }).toList(),
                      ),
                    ],
                  )
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
