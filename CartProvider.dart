import 'package:flutter/material.dart';
import 'package:japfood/ConvertedApi.dart';

class CartProvider extends ChangeNotifier {
  List<ConvertedApi> _cartItems = [];

  List<ConvertedApi> get cartItems => _cartItems;

  void addToCart(ConvertedApi item) {
    _cartItems.add(item);
    notifyListeners();
  }

  void removeFromCart(ConvertedApi item) {
    _cartItems.remove(item);
    notifyListeners();
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }
}
