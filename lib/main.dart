import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:logger/logger.dart';
import 'package:wHRMS/View/home_screen.dart';
import 'package:wHRMS/login/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Import your RegisterPage

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  await Future.delayed(const Duration(seconds: 2));
  // FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  FlutterNativeSplash.remove();

  final Logger logger = Logger();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('token');
  logger.d('Testing $token');

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: token != null && token.isNotEmpty
        ? const HomeScreen()
        : const UserLoginScreen(),
  ));
}
