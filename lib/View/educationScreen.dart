import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wHRMS/ThemeColor/theme.dart';
import 'package:wHRMS/apiHandlar/baseUrl.dart';

class EducationScreen extends StatefulWidget {
  const EducationScreen({Key? key}) : super(key: key);

  @override
  State<EducationScreen> createState() => _EducationScreenState();
}

class _EducationScreenState extends State<EducationScreen> {
  TextEditingController collegeController = TextEditingController();
  TextEditingController degController = TextEditingController();
  TextEditingController specController = TextEditingController();
  TextEditingController cgpaController = TextEditingController();
  TextEditingController completeYearController = TextEditingController();

  Future<void> postData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) {
        throw Exception('Token is null');
      }

      const url = '${URLConstants.baseUrl}/api/education';
      final response = await http.post(
        Uri.parse(url),
        body: jsonEncode({
          'institute_name': collegeController.text,
          'degree_diploma': degController.text,
          'specialization': specController.text,
          'cgpa': cgpaController.text,
          'date_of_completion': completeYearController.text,
        }),
        headers: {
          'Authorization': 'token $token',
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 201) {
        print('Post successful');
        print('Successfully Data Post: ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.green,
            content: Text('Education add Successfully...'),
          ),
        );
      } else if (response.statusCode == 400) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text('Bad Request: Education Details.'),
          ),
        );
        print('Failed to post data: ${response.statusCode}');
        print('Failed to post data: ${response.body}');
      } else if (response.statusCode == 500) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text('Internal Server Error. Please try again...'),
          ),
        );
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Education',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        backgroundColor: ThemeColor.app_bar,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
          child: Column(
            children: [
              buildTextField(
                controller: collegeController,
                hintText: 'Enter College Name',
                prefixIconData: Icons.school_outlined,
                fieldName: 'College Name',
              ),
              const SizedBox(height: 10),
              buildTextField(
                controller: degController,
                hintText: 'Enter Degree',
                prefixIconData: Icons.school,
                fieldName: 'Degree',
              ),
              const SizedBox(height: 10),
              buildTextField(
                controller: specController,
                hintText: 'Enter Specialization',
                prefixIconData: Icons.school,
                fieldName: 'Specialization',
              ),
              const SizedBox(height: 10),
              buildTextField(
                controller: cgpaController,
                hintText: 'Enter CGPA',
                prefixIconData: Icons.numbers,
                fieldName: 'CGPA',
              ),
              const SizedBox(height: 10),
              buildTextField(
                controller: completeYearController,
                hintText: 'Enter Complete Year',
                prefixIconData: Icons.youtube_searched_for,
                fieldName: 'year',
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.center,
                child: SizedBox(
                  width: double.infinity,
                  height: 60.0,
                  child: ElevatedButton(
                    onPressed: () {
                      postData();
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6.0),
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

  //Normal TextField Method's
  Widget buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData prefixIconData,
    required String fieldName,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(7.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(7.0),
        ),
        hintText: hintText,
        prefixIcon: Icon(prefixIconData),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7),
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
