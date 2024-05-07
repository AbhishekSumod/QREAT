import 'package:flutter/material.dart';
import 'package:japfood/ConvertedApi.dart';

class BillPage extends StatelessWidget {
  final String username;
  final List<ConvertedApi> orderedItems;

  const BillPage({
    Key? key,
    required this.username,
    required this.orderedItems,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bill'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text('Username: $username'),
          ),
          Divider(),
          for (var item in orderedItems)
            ListTile(
              title: Text(item.name ?? ''),
              subtitle: Text('Price: ₹${item.price ?? 0}'),
              trailing: Text('Quantity: ${item.count ?? 1}'),
            ),
        ],
      ),
    );
  }
}
