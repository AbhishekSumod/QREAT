import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:japfood/CartProvider.dart';
import 'package:japfood/ConvertedApi.dart';
import 'package:japfood/BillPage.dart'; // Import the BillPage
import 'package:provider/provider.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final String apiUrl = "http://localhost:3000/order";
  late TextEditingController _usernameController;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      body: Consumer<CartProvider>(
        builder: (context, cartProvider, child) {
          Map<String?, List<ConvertedApi>> groupedItems = {};
          for (var item in cartProvider.cartItems) {
            if (!groupedItems.containsKey(item.CategoryName)) {
              groupedItems[item.CategoryName] = [];
            }
            groupedItems[item.CategoryName]?.add(item);
          }

          double totalPrice = 0;

          // Calculate total price
          for (var item in cartProvider.cartItems) {
            totalPrice += (item.price ?? 0) * (item.count ?? 1);
          }

          return ListView.builder(
            itemCount: groupedItems.length + 1,
            itemBuilder: (context, index) {
              if (index < groupedItems.length) {
                var categoryName = groupedItems.keys.toList()[index] ?? '';
                var items = groupedItems[categoryName]!;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        categoryName,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        var item = items[index];
                        return CartItemWidget(
                          item: item,
                          onCountChanged: (count) {
                            setState(() {
                              item.count = count;
                            });
                          },
                        );
                      },
                    ),
                  ],
                );
              } else {
                return ListTile(
                  title: Text(
                    'Total Price:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    '₹${totalPrice.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }
            },
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Enter Username',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(width: 16),
            ElevatedButton(
              onPressed: () {
                final cartProvider =
                    Provider.of<CartProvider>(context, listen: false);
                placeOrder(context, cartProvider.cartItems);
              },
              child: Text('Order'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> placeOrder(
    BuildContext context,
    List<ConvertedApi> cartItems,
  ) async {
    try {
      var username = _usernameController.text;
      var requestBody = jsonEncode(<String, dynamic>{
        'username': username,
        'cartItems': cartItems.map((item) => item.toJson()).toList(),
      });

      var response = await http.post(
        Uri.parse('$apiUrl'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: requestBody,
      );

      if (response.statusCode == 307) {
        // Handle redirect
        var redirectUrl = response.headers['location'];
        if (redirectUrl != null) {
          // Perform another request to the redirect URL
          response = await http.post(
            Uri.parse(redirectUrl),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: requestBody,
          );
        }
      }

      if (response.statusCode == 201) {
        print('Order placed successfully');
        Provider.of<CartProvider>(context, listen: false).clearCart();

        // Navigate to the bill page
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BillPage(
              username: username,
              orderedItems: cartItems,
            ),
          ),
        );
      } else {
        print('Failed to place order: ${response.statusCode}');
      }
    } catch (error) {
      print('Error placing order: $error');
    }
  }
}

class CartItemWidget extends StatefulWidget {
  final ConvertedApi item;
  final Function(int) onCountChanged;

  const CartItemWidget({
    Key? key,
    required this.item,
    required this.onCountChanged,
  }) : super(key: key);

  @override
  _CartItemWidgetState createState() => _CartItemWidgetState();
}

class _CartItemWidgetState extends State<CartItemWidget> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        children: [
          Expanded(
            child: Text(widget.item.name ?? ''),
          ),
          IconButton(
            icon: Icon(Icons.remove),
            onPressed: () {
              if (widget.item.count! > 1) {
                setState(() {
                  widget.onCountChanged(widget.item.count! - 1);
                });
              }
            },
          ),
          Text(widget.item.count?.toString() ??
              '1'), // Display '1' if count is null
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              setState(() {
                widget.onCountChanged(
                    (widget.item.count ?? 0) + 1); // Increment count
              });
            },
          ),
        ],
      ),
      subtitle: Text(
        'Price: ₹${(widget.item.price ?? 0) * (widget.item.count ?? 1)}',
      ),
    );
  }
}
