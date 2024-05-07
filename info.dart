import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:japfood/ConvertedApi.dart';
import 'package:japfood/ProductDetailsPage.dart';
import 'dart:convert';

class Info extends StatefulWidget {
  final ConvertedApi apiList;

  const Info({
    Key? key,
    required this.apiList,
  }) : super(key: key);

  @override
  _InfoState createState() => _InfoState();
}

class _InfoState extends State<Info> {
  late List<ConvertedApi> itemList = [];

  @override
  void initState() {
    super.initState();
    getItemsByCategory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.apiList.CategoryName ?? ''),
        backgroundColor: Color.fromARGB(255, 30, 197, 234),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "CatsssssssssssssZZegory: ${widget.apiList.CategoryName}",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 20),
            itemList.isEmpty
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: itemList.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ProductDetailsPage(product: itemList[index]),
                            ),
                          );
                        },
                        child: Card(
                          elevation: 4,
                          margin:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                          child: ListTile(
                            title: Text(
                              itemList[index].name ?? '',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                itemList[index].Image ?? '',
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                              ),
                            ),
                            subtitle:
                                Text('Price: ${itemList[index].price ?? 0}'),
                            trailing: Icon(Icons.arrow_forward),
                          ),
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }

  Future<void> getItemsByCategory() async {
    String url =
        "http://localhost:3000/product?CategoryName=${widget.apiList.CategoryName}";
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      List<ConvertedApi> tempItemList = [];
      (jsonDecode(response.body) as List).forEach((item) {
        ConvertedApi newItem = ConvertedApi.fromJson(item);
        if (newItem.CategoryName == widget.apiList.CategoryName) {
          tempItemList.add(newItem);
        }
      });
      setState(() {
        itemList = tempItemList;
      });
    } else {
      print("Failed to fetch data: ${response.statusCode}");
    }
  }
}
