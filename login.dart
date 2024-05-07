import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UserApi {
  String? sId;
  String? UserName;
  String? Email;
  String? Password;
  String? createdAt;
  String? updatedAt;
  int? iV;

  UserApi({
    this.sId,
    this.UserName,
    this.Email,
    this.Password,
    this.createdAt,
    this.updatedAt,
    this.iV,
  });

  factory UserApi.fromJson(Map<String, dynamic> json) {
    return UserApi(
      sId: json['_id'],
      UserName: json['UserName'],
      Email: json['Email'],
      Password: json['Password'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      iV: json['__v'],
    );
  }
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> _loginOrRegisterUser() async {
    String username = usernameController.text;
    String email = emailController.text;
    String password = passwordController.text;

    // Send login data to the server
    final Map<String, dynamic> loginRequestBody = {
      "UserName": username,
      "Email": email,
      "Password": password,
    };

    try {
      final loginResponse = await http.post(
        Uri.parse("http://localhost:3000/login"),
        body: json.encode(loginRequestBody),
        headers: {
          "Content-Type": "application/json",
        },
      );

      print('Login Response: ${loginResponse.statusCode}');
      print('Login Response Body: ${loginResponse.body}');

      if (loginResponse.statusCode == 200 || loginResponse.statusCode == 201) {
        // Login successful, provide user feedback.
        print('Login successful');
        // Fetch user data after successful login
        //getUser();
      } else if (loginResponse.statusCode == 404) {
        // User does not exist in the login collection, proceed with registration
        await _registerUser();
        // Automatically login after registration
        await _loginOrRegisterUser();
      } else {
        // Handle login error and provide feedback.
        print('Login failed');
      }
    } catch (error) {
      // Handle network errors.
      print('Error: $error');
    }
  }

  Future<void> _postValuesToLoginCollection(
      String username, String email, String password) async {
    // Send the values to the login collection
    final Map<String, dynamic> loginValues = {
      "UserName": username,
      "Email": email,
      "Password": password,
    };

    try {
      final response = await http.post(
        Uri.parse("http://localhost:3000/login"), // Adjust the URL
        body: json.encode(loginValues),
        headers: {
          "Content-Type": "application/json",
        },
      );

      print('Post to login collection - Response: ${response.statusCode}');
      print('Post to login collection - Response Body: ${response.body}');

      if (response.statusCode == 201) {
        // Posting successful, provide feedback.
        print('Values posted to login collection');
      } else {
        // Handle posting error and provide feedback.
        print('Failed to post values to login collection');
      }
    } catch (error) {
      // Handle network errors.
      print('Error posting values to login collection: $error');
    }
  }

  Future<void> _registerUser() async {
    String username = usernameController.text;
    String email = emailController.text;
    String password = passwordController.text;

    // Send registration data to the server
    final Map<String, dynamic> registerRequestBody = {
      "UserName": username,
      "Email": email,
      "Password": password,
    };

    try {
      final response = await http.post(
        Uri.parse("http://localhost:3000/register"),
        body: json.encode(registerRequestBody),
        headers: {
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 201) {
        // Registration successful, provide user feedback.
        print('Registration successful');
      } else {
        // Handle registration error and provide feedback.
        print('Registration failed');
      }
    } catch (error) {
      // Handle network errors.
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Colors.green),
      title: 'Login',
      home: Scaffold(
        appBar: AppBar(
          title: Text('LOGIN'),
          backgroundColor: Colors.orange,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('USER NAME'),
              TextField(
                controller: usernameController,
                decoration: InputDecoration(
                  hintText: 'Enter The UserNAme',
                ),
              ),
              SizedBox(height: 20),
              Text('EMAIL'),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText: 'Enter The Email',
                ),
              ),
              SizedBox(height: 20),
              Text('PASSWORD'),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Enter The Password',
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _loginOrRegisterUser,
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      Colors.green,
                    ),
                  ),
                  child: Text('LOGIN'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: LoginScreen(),
  ));
}
