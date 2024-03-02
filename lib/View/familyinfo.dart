import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:wHRMS/ThemeColor/theme.dart';
import 'package:wHRMS/View/home_screen.dart';
import 'package:wHRMS/apiHandlar/baseUrl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FamilyScreen extends StatefulWidget {
  const FamilyScreen({super.key});

  @override
  State<FamilyScreen> createState() => _FamilyScreenState();
}

class _FamilyScreenState extends State<FamilyScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController relationshipController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  // final Logger _logger = Logger();

  Future<String?> getAuthToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<void> fetchfamily() async {
    const apiUrl = '${URLConstants.baseUrl}/api/familyinfo';

    final name = nameController.text;
    final relation = relationshipController.text;
    final phone = phoneController.text;
    final address = addressController.text;

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token') ?? '';
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'token $token',
        },
        body: jsonEncode({
          'name': name,
          'relationship': relation,
          'phone_number': phone,
          'address': address,
        }),
      );
      // _logger.d('Testing StatusCode: ${response.statusCode}');
      // _logger.d('Testing StatusCode: ${response.body}');
      // _logger.d('Test ');

      // Check if form is not valid, return
      // if (!_formKey.currentState!.validate()) {
      //   return;
      // }

      if (response.statusCode == 201 || response.statusCode == 200) {
        // final employeeData = json.decode(response.body);
        // _logger.d('Family Information add successfully: $employeeData');

        // Fetch dropdown data again after successful creation
        // _fetchDropdownData();

        // Navigate to HomeScreen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.green,
            content: Text('Family Information Successfully Created.Thank You.'),
          ),
        );
      } else if (response.statusCode == 400) {
        // print('Response body: ${response.body}');

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text('Bad Request: Error Creating Family.'),
          ),
        );
        // print('Response Body: ${response.body}');
      } else if (response.statusCode == 401) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text('Unauthorized. Please Login again.'),
          ),
        );
      } else if (response.statusCode == 500) {
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
            content: Text('Error creating Family'),
          ),
        );
      }
    } catch (e) {
      _handleError(e);
    }
  }

  void _handleError(dynamic e) {
    // _logger.e('Error: $e');
    // print('Error: $e');
    if (e is SocketException) {
      _showSnackBar('No Internet Connection');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        action: SnackBarAction(
          label: 'OK',
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'FamilyInformation',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        backgroundColor: ThemeColor.app_bar,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 8.0),
        child: Column(
          children: [
            const Text('Add Your Family Information'),
            const SizedBox(height: 20),
            _buildTextField(
              controller: nameController,
              hintText: 'Name',
              prefixIconData: Icons.person,
              fieldName: 'Name',
            ),
            const SizedBox(height: 15),
            _buildTextField(
              controller: relationshipController,
              hintText: 'Relationship',
              prefixIconData: Icons.account_box,
              fieldName: 'Relationship',
            ),
            const SizedBox(height: 15),
            _buildTextField(
              controller: phoneController,
              hintText: 'PhoneNumber',
              prefixIconData: Icons.phone_android_sharp,
              fieldName: 'PhoneNumber',
            ),
            const SizedBox(height: 15),
            _buildTextField(
              controller: addressController,
              hintText: 'Address',
              prefixIconData: Icons.location_on_outlined,
              fieldName: 'Address',
            ),
            const SizedBox(height: 15),
            Align(
              alignment: Alignment.center,
              child: SizedBox(
                width: double.infinity,
                height: 60.0,
                child: ElevatedButton(
                  onPressed: () => fetchfamily(),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    backgroundColor: ThemeColor.app_bar,
                  ),
                  child: const Text(
                    'CREATE',
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
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData prefixIconData,
    required String fieldName,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue),
        ),
        hintText: hintText,
        prefixIcon: Icon(prefixIconData),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(
            color: Colors.grey,
            width: 2.0,
          ),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $fieldName';
        }
        return null;
      },
    );
  }
}
