import 'package:flutter/material.dart';

class CartItem {
  final Map<String, dynamic> product; // Product data
  final String size; // Size of the product
  int quantity; // Quantity of the product in the cart

  CartItem({
    required this.product,
    required this.size,
    this.quantity = 1, // Default quantity is 1
  });
}

class Cart with ChangeNotifier {
  final List<CartItem> _items = []; // Internal list to store cart items

  // Getter to retrieve the list of items in the cart
  List<CartItem> get items {
    return _items;
  }

  // Method to add an item to the cart
  void addToCart(Map<String, dynamic> product, String size, int quantity) {
    // Check if the product with the same size already exists in the cart
    CartItem? existingItem = _items.firstWhere(
      (item) => item.product['id'] == product['id'] && item.size == size,
      orElse: () => CartItem(
          product: product,
          size: size,
          quantity: 0), // Return an empty item if not found
    );

    if (existingItem.quantity > 0) {
      // If the product exists, increase the quantity
      existingItem.quantity += quantity;
    } else {
      // If the product does not exist, add it to the cart
      _items.add(CartItem(
        product: product,
        size: size,
        quantity: quantity,
      ));
    }

    notifyListeners(); // Notify listeners to update the UI
  }

  // Getter to retrieve the total number of items in the cart
  int get itemCount {
    return _items.length;
  }

  // Method to clear all items from the cart
  void clearCart() {
    _items.clear();
    notifyListeners(); // Notify listeners to update the UI
  }
}
