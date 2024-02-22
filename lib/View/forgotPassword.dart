import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:wHRMS/ThemeColor/theme.dart';
import 'package:wHRMS/apiHandlar/baseUrl.dart';
import 'package:wHRMS/login/login.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController tokenController = TextEditingController();

  final Logger _logger = Logger();

  Future<void> resetPassword() async {
    const String apiUrl = '${URLConstants.baseUrl}/api/password_reset/';
    final String email = emailController.text;

    try {
      final http.Response response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'email': email}),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.green,
            content: Text('Password reset email sent.'),
          ),
        );
        print('Status Code: ${response.statusCode}');
        _logger.d('Email Response Body: ${response.body}');
      } else {
        handleErrorResponse(response);
      }
    } catch (e) {
      print('Error sending password reset email: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text('Error sending password reset email.'),
        ),
      );
    }
  }

  Future<void> validateTokenAndProceed(String token) async {
    const String apiUrl =
        '${URLConstants.baseUrl}/api/password_reset/validate_token/';

    try {
      final http.Response response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'token': token}),
      );

      if (response.statusCode == 200) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PasswordChangeScreen(token: token),
          ),
        );
      } else {
        handleErrorResponse(response);
      }
    } catch (e) {
      print('Error validating token: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text('Error validating token.'),
        ),
      );
    }
  }

  void handleErrorResponse(http.Response response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.red,
        content: Text('Invalid Token ${response.statusCode}'),
      ),
    );
    print('Status Code: ${response.statusCode}');
    _logger.d('Error Response Body: ${response.body}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Forgot Password',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: ThemeColor.app_bar,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 80,
                  width: 80,
                  child: const CircleAvatar(
                    backgroundImage: AssetImage('assets/download.png'),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Forgot your Passoword?',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
                const SizedBox(height: 20),
                const Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Enter your email ',
                    style: TextStyle(fontSize: 18),
                  ),
                ),

                const SizedBox(height: 20),
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    // labelText: 'Email',
                    hintText: 'Email',
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Align(
                //   alignment: Alignment.center,
                //   child: ElevatedButton(
                //     onPressed: resetPassword,
                //     child: const Text('Send Email'),
                //   ),
                // ),
                Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: double.infinity,
                    height: 60.0,
                    child: ElevatedButton(
                      onPressed: resetPassword,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(1.0),
                        ),
                        backgroundColor: ThemeColor.app_bar,
                      ),
                      child: const Text(
                        'SEND EMAIL',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Enter the token received in the email:',
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: tokenController,
                  decoration: const InputDecoration(
                    // labelText: 'Enter Token',
                    hintText: 'Enter Token',
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Align(
                //   alignment: Alignment.center,
                //   child: ElevatedButton(
                //     onPressed: () =>
                //         validateTokenAndProceed(tokenController.text),
                //     child: const Text('Proceed'),
                //   ),
                // ),
                Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: double.infinity,
                    height: 60.0,
                    child: ElevatedButton(
                      onPressed: () =>
                          validateTokenAndProceed(tokenController.text),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(1.0),
                        ),
                        backgroundColor: ThemeColor.app_bar,
                      ),
                      child: const Text(
                        'PROCEED',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PasswordChangeScreen extends StatefulWidget {
  final String token;

  const PasswordChangeScreen({Key? key, required this.token}) : super(key: key);

  @override
  _PasswordChangeScreenState createState() => _PasswordChangeScreenState();
}

class _PasswordChangeScreenState extends State<PasswordChangeScreen> {
  TextEditingController newPasswordController = TextEditingController();

  // bool _isMounted = false;

  // @override
  // void initState() {
  //   super.initState();
  //   _isMounted = true;
  // }

  // @override
  // void dispose() {
  //   _isMounted = false;
  //   newPasswordController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Change Password',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: ThemeColor.app_bar,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Enter your new password',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: newPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    hintText: 'New Password',
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey,
                        width: 2.0,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey,
                        width: 2.0,
                      ),
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
                      onPressed: () {
                        String newPassword = newPasswordController.text;
                        if (newPassword.isNotEmpty) {
                          changePassword(widget.token, newPassword);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please enter a new password.'),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(1.0),
                        ),
                        backgroundColor: ThemeColor.app_bar,
                      ),
                      child: const Text(
                        'SUBMIT',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> changePassword(String token, String newPassword) async {
    const String apiUrl = '${URLConstants.baseUrl}/api/password_reset/confirm/';

    try {
      final http.Response response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'password': newPassword,
          'token': token,
        }),
      );

      if (mounted) {
        // Check if the widget is still mounted
        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.green,
              content: Text('Password changed successfully.'),
            ),
          );

          // Delay before navigating to success screen
          await Future.delayed(const Duration(seconds: 2));

          // Navigate to success screen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const PasswordChangeSuccessScreen(),
            ),
          );

          // Log to ensure navigation to success screen
          print('Navigated to PasswordChangeSuccessScreen');

          // Delay before navigating to login screen
          await Future.delayed(const Duration(seconds: 3));

          if (mounted) {
            // Check if the widget is still mounted before navigating
            // Navigate to login screen
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const UserLoginScreen(),
              ),
            );

            // Log to ensure navigation to login screen
            print('Navigated to UserLoginScreen');
          }
        } else {
          handleErrorResponse(response);
          print('Response Token : $token');
          print('Response Name: $newPassword');
          print('Response Body: ${response.body}');
        }
      }
    } catch (e) {
      print('Error changing password: $e');
      if (mounted) {
        // Check if the widget is still mounted
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text('Error changing password. Please try again later.'),
          ),
        );
      }
    }
  }

  void handleErrorResponse(http.Response response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.red,
        content: Text('Failed with status code ${response.statusCode}'),
      ),
    );
  }
}

class PasswordChangeSuccessScreen extends StatelessWidget {
  const PasswordChangeSuccessScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 100,
              ),
              const SizedBox(height: 20),
              const Text(
                'Password changed successfully!',
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 50),
              Align(
                alignment: Alignment.center,
                child: SizedBox(
                  width: 300,
                  height: 60.0,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const UserLoginScreen()));
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(1.0),
                      ),
                      backgroundColor: ThemeColor.app_bar,
                    ),
                    child: const Text(
                      'CLICK ME !',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: ThemeColor.app_bar,
    );
  }
}
