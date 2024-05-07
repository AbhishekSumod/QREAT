import 'package:flutter/material.dart';
import 'package:japfood/CartPage.dart';
import 'package:japfood/CartProvider.dart';
import 'package:japfood/ConvertedApi.dart';
import 'package:provider/provider.dart';

class ProductDetailsPage extends StatelessWidget {
  final ConvertedApi product;

  const ProductDetailsPage({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.name ?? ''),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey[300]!,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 200,
                width: double.infinity,
                child: product.Image is String && product.Image!.isNotEmpty
                    ? Image.network(
                        product.Image!,
                        fit: BoxFit.cover,
                      )
                    : Placeholder(),
              ),
              SizedBox(height: 16),
              Text(
                'Name:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                product.name ?? '',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Description:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                product.descrption ?? '',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Price:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '₹${product.price ?? "0"}',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        color: Colors.yellow,
                        size: 24,
                      ),
                      SizedBox(width: 4),
                      Text(
                        '₹${product.price ?? "0"}',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {
                      addToCart(context, product);
                    },
                    child: Text('Add to Cart'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void addToCart(BuildContext context, ConvertedApi product) {
    var cartProvider = Provider.of<CartProvider>(context, listen: false);
    cartProvider.addToCart(product);

    // Navigate to the cart page
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CartPage()),
    );
  }
}
