import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wHRMS/apiHandlar/baseUrl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wHRMS/View/forgotPassword.dart';
import 'package:wHRMS/View/resetPassword.dart';
import 'package:wHRMS/View/home_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:wHRMS/ThemeColor/theme.dart';

class UserLoginScreen extends StatefulWidget {
  const UserLoginScreen({Key? key}) : super(key: key);

  @override
  State<UserLoginScreen> createState() => _UserLoginScreenState();
}

class _UserLoginScreenState extends State<UserLoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  // final Logger _logger = Logger();

  bool _isPasswordVisible = false;

  Future<void> loginUser(BuildContext context) async {
    if (emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Email is required.'),
        ),
      );
      return;
    }

    if (passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password is required.'),
        ),
      );
      return;
    }

    const apiUrl = '${URLConstants.baseUrl}/api/login';
    final email = emailController.text;
    final password = passwordController.text;

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final token = responseData['token'];
        final isSuperuser = responseData['is_superuser'];

        final prefs = await SharedPreferences.getInstance();
        prefs.setString('token', token);
        prefs.setBool('is_superuser', isSuperuser);

        List<String> globalEmails = [];

        // Check if there are any previously stored emails
        final storedEmails = prefs.getStringList('emails');
        if (storedEmails != null) {
          // If there are, add them to the list of global emails
          globalEmails.addAll(storedEmails);
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.green,
            content: Text('Login Successfull.'),
          ),
        );

        // print('Login Response Body: ${response.body}');

        // Add the latest email to the list
        globalEmails.add(email);

        // Save the list of emails to SharedPreferences
        prefs.setStringList('emails', globalEmails);

        // Navigate to the appropriate screen based on whether the email is new or not
        if (storedEmails == null || !storedEmails.contains(email)) {
          // If the email is new, navigate to the reset password screen
          // ignore: use_build_context_synchronously
          Navigator.pushReplacement(
            context,
            PageTransition(
              type: PageTransitionType.fade,
              duration: const Duration(milliseconds: 500),
              child: const ResetPasswordScreen(),
            ),
          );
        } else {
          // If the email is not new, navigate to the home screen
          // ignore: use_build_context_synchronously
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const HomeScreen(),
            ),
          );
        }
      } else if (response.statusCode == 400) {
        // final errorMessage = json.decode(response.body)['message'];
        // print('Login failed: $errorMessage');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text('Bad Request: Invalid username or password.'),
          ),
        );
      } else if (response.statusCode == 500) {
        // print('Api url: $apiUrl');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text('Internal Server Error.Please try again later.'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text('Email ID or Password invalid'),
          ),
        );
      }
    } catch (e) {
      // _logger.e('Error during login: $e');
      // print('Error: $e');
      if (e is SocketException) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: const Text("No Internet Connection"),
            action: SnackBarAction(
              label: 'OK',
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              },
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColor.log_background,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 8.0),
          child: Column(
            children: [
              const SizedBox(height: 200),
              Image.asset(
                'assets/wesscosoft-logo.png',
                height: 130,
              ),
              const SizedBox(height: 40),
              Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    // BoxShadow(
                    //   color: Colors.grey.withOpacity(0.5),
                    //   spreadRadius: 0.1,
                    //   blurRadius: 0.1,
                    //   offset: const Offset(0, 0.5),
                    // ),
                  ],
                ),
                child: TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    // prefix: Padding(
                    //   padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    //   child: SizedBox(
                    //     width: 5,
                    //     child: Container(
                    //       color: Colors.black,
                    //     ),
                    //   ),
                    // ),
                    prefixIcon: const Icon(Icons.person),
                    hintText: 'Employee ID or Phone Number',
                    labelStyle: const TextStyle(fontSize: 10),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xFF9E9E9E)),
                      borderRadius: BorderRadius.circular(7),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(7),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    // BoxShadow(
                    //   color: Colors.grey.withOpacity(0.5),
                    //   spreadRadius: 0.1,
                    //   blurRadius: 0.1,
                    //   offset: const Offset(0, 0.5),
                    // ),
                  ],
                ),
                child: TextField(
                  controller: passwordController,
                  obscureText: !_isPasswordVisible,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xFF9E9E9E)),
                      borderRadius: BorderRadius.circular(7),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(7),
                    ),
                    // prefix: Padding(
                    //   padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    //   child: SizedBox(
                    //     width: 5,
                    //     child: Container(
                    //       color: Colors.black,
                    //     ),
                    //   ),
                    // ),
                    prefixIcon: const Icon(Icons.password),
                    suffixIcon: IconButton(
                      color: Colors.grey,
                      icon: _isPasswordVisible
                          ? Icon(Icons.visibility)
                          : Icon(Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                    hintText: 'Password',
                    labelStyle: const TextStyle(fontSize: 10),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.center,
                child: SizedBox(
                  width: double.infinity,
                  height: 60.0,
                  child: ElevatedButton(
                    onPressed: () => loginUser(context),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                      backgroundColor: ThemeColor.app_bar,
                    ),
                    child: const Text(
                      'LOGIN',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Having trouble with logged in?',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: forgotPassword,
                child: const Text(
                  'Forgot Password?',
                  style: TextStyle(
                    color: Colors.blue,
                  ),
                ),
              ),
              const SizedBox(height: 60),
              const Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.copyright,
                      size: 20,
                    ),
                    SizedBox(width: 5),
                    Text(
                      'Wesscosoft',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void forgotPassword() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ForgotPasswordScreen(),
      ),
    );
  }
}
