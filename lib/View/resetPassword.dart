import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wHRMS/ThemeColor/theme.dart';

import 'package:wHRMS/View/profile.dart';
import 'package:wHRMS/apiHandlar/baseUrl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ReserPasswordScreenState();
}

class _ReserPasswordScreenState extends State<ResetPasswordScreen> {
  TextEditingController resetPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  bool _obscureText = true;
  bool _obsecureText = true;

  Future<void> changePassword(
      String newPassword, String confirmPassword, BuildContext context) async {
    const String apiUrl = '${URLConstants.baseUrl}/api/reset-password-auth/';

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token') ?? '';

      final http.Response response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'token $token',
        },
        body: jsonEncode({
          'new_password': newPassword,
          'confirm_password': confirmPassword,
        }),
      );

      if (response.statusCode == 200) {
        print('Changed Password: $newPassword');
        print('Response Body: ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.green,
            content: Text('Password changed successfully.'),
          ),
        );
        // ignore: use_build_context_synchronously
        Navigator.push(
          context,
          PageTransition(
            type: PageTransitionType.fade,
            duration: const Duration(milliseconds: 500),
            child: const ProfileScreen(),
          ),
        );
      } else {
        handleErrorResponse(response, context);
        print('Changed Password: $newPassword');
        print('Response Body: ${response.body}');
      }
    } catch (e) {
      print('Error changing password: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text('Error changing password. Please try again later.'),
        ),
      );
    }
  }

  void handleErrorResponse(http.Response response, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.red,
        content: Text('Failed with status code ${response.statusCode}'),
      ),
    );
  }

  void toggleResetPasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void toggleConfirmPasswordVisibility() {
    setState(() {
      _obsecureText = !_obsecureText;
    });
  }

  void handleSubmit(BuildContext context) {
    final newPassword = resetPasswordController.text;
    final confirmPassword = confirmPasswordController.text;

    if (newPassword.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text('Please fill in both fields.'),
        ),
      );
      return;
    }

    if (newPassword != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text('Passwords do not match.'),
        ),
      );
      return;
    }

    // If passwords match, proceed with changing password
    changePassword(newPassword, confirmPassword, context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Reset Password',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        backgroundColor: ThemeColor.app_bar,
        iconTheme: const IconThemeData(color: Colors.white),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 8.0),
        child: Center(
          child: Column(
            children: [
              // const SizedBox(height: 15),
              Container(
                height: 80,
                width: 80,
                child: const CircleAvatar(
                  backgroundImage: AssetImage('assets/download.png'),
                ),
              ),
              const SizedBox(height: 20),
              const Align(
                alignment: Alignment.topCenter,
                child: Text(
                  'Enter Your New Password',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text('Enter New Password'),
              const SizedBox(height: 15),
              TextFormField(
                controller: resetPasswordController,
                obscureText: _obscureText,
                decoration: InputDecoration(
                  labelText: 'New Password',
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    color: Colors.grey,
                    icon: Icon(
                      _obscureText ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: toggleResetPasswordVisibility,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              const Text('Confirm New Password'),
              const SizedBox(height: 15),
              TextFormField(
                controller: confirmPasswordController,
                obscureText: _obsecureText,
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    color: Colors.grey,
                    icon: Icon(
                      _obsecureText ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: toggleConfirmPasswordVisibility,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // ElevatedButton(
              //   onPressed: () => handleSubmit(context),
              //   child: const Text('Submit'),
              // ),
              Align(
                alignment: Alignment.center,
                child: SizedBox(
                  width: 300,
                  height: 60.0,
                  child: ElevatedButton(
                    onPressed: () => handleSubmit(context),
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
    );
  }
}
