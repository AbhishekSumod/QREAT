import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:japfood/ConvertedApi.dart';
import 'package:japfood/info.dart';
import 'package:japfood/login.dart';
import 'dart:convert';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ConvertedApi> apiList = [];
  List<ConvertedApi> uniqueApiList = []; // List to store unique API elements

  @override
  void initState() {
    super.initState();
    getApiData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 13, 182, 187),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.restaurant_rounded),
            SizedBox(width: 20),
            Text('Food Menu'),
          ],
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => AboutPage()));
            },
            icon: Icon(Icons.info),
          ),
          SizedBox(width: 10),
          TextButton(
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => LoginScreen()));
            },
            child: Text(
              "Login",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              onChanged: (value) {
                // Implement search functionality
              },
            ),
          ),
          SizedBox(height: 20),
          Text(
            'Offer',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.tealAccent, Colors.teal],
                ),
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Image.network(
                    apiList
                            .firstWhere((element) =>
                                element.CategoryName?.toLowerCase() ==
                                "biriyani")
                            .CategoryImage ??
                        "",
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Special Offer:',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        '₹110',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          Text(
            'Popular',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Container(
              height: 150, // Fixed height for horizontal list
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: List.generate(
                  uniqueApiList.length > 10 ? 10 : uniqueApiList.length,
                  (index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              Info(apiList: uniqueApiList[index]),
                        ));
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Column(
                          children: [
                            Image.network(
                              uniqueApiList[index].Image ?? "",
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                            SizedBox(height: 5),
                            Text(
                              uniqueApiList[index].name ?? "",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(height: 5),
                            Row(
                              children: [
                                Icon(Icons.star, color: Colors.amber),
                                SizedBox(width: 5),
                                Text(uniqueApiList[index].star ?? ""),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(
                  uniqueApiList.length > 10 ? 10 : uniqueApiList.length,
                  (index) {
                    return Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  Info(apiList: uniqueApiList[index]),
                            ));
                          },
                          child: Container(
                            margin: EdgeInsets.all(10),
                            width: 150,
                            height: 200,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: Container(
                                    width: 150,
                                    height: 150,
                                    child: uniqueApiList[index].Image != null &&
                                            uniqueApiList[index]
                                                .Image!
                                                .isNotEmpty
                                        ? Image.network(
                                            "${uniqueApiList[index].Image}",
                                            width: 150,
                                            height: 150,
                                            fit: BoxFit.cover,
                                          )
                                        : Placeholder(),
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  uniqueApiList[index].CategoryName ?? "",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> getApiData() async {
    try {
      String url = "http://localhost:3000/product";
      var result = await http.get(Uri.parse(url));
      if (result.statusCode == 200) {
        setState(() {
          apiList = (jsonDecode(result.body) as List)
              .map((item) => ConvertedApi.fromJson(item))
              .toList();

          // Filter out duplicates based on category name
          uniqueApiList =
              apiList.fold([], (List<ConvertedApi> previousValue, element) {
            if (!previousValue
                .any((e) => e.CategoryName == element.CategoryName)) {
              previousValue.add(element);
            }
            return previousValue;
          });
        });
      } else {
        print("Failed to fetch data: ${result.statusCode}");
      }
    } catch (e) {
      print("Error fetching data: $e");
    }
  }
}

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About'),
      ),
      body: Center(
        child: Text(
          'Description about our project: QR Code Ordering',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    title: 'QR Code Demo',
    home: HomeScreen(),
  ));
}
