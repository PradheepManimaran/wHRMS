import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wHRMS/ThemeColor/theme.dart';
import 'package:wHRMS/apiHandlar/baseUrl.dart';

class WorkScreen extends StatefulWidget {
  const WorkScreen({super.key});

  @override
  State<WorkScreen> createState() => _WorkScreenState();
}

class _WorkScreenState extends State<WorkScreen> {
  TextEditingController companyNameController = TextEditingController();
  TextEditingController designationController = TextEditingController();
  TextEditingController fromDateController = TextEditingController();
  TextEditingController toDateController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController personNameController = TextEditingController();
  TextEditingController personContactController = TextEditingController();
  TextEditingController workNumberController = TextEditingController();
  TextEditingController personEmailController = TextEditingController();

  bool? selectedRelevant;
  List<bool> relevant = [false, true];

  Future<void> postData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) {
        throw Exception('Token is null');
      }

      const url = '${URLConstants.baseUrl}/api/work_experiences';

      int serverValue =
          selectedRelevant != null ? (selectedRelevant! ? 1 : 0) : 0;
      print('Relevant Value: $serverValue');

      final response = await http.post(
        Uri.parse(url),
        body: jsonEncode({
          'company_name': companyNameController.text,
          'designation': designationController.text,
          'from_date': fromDateController.text,
          'to_date': toDateController.text,
          'description': descriptionController.text,
          'verify_person_name': personNameController.text,
          'verify_person_contact': personContactController.text,
          'verify_working_phone': workNumberController.text,
          'verify_personal_email': personEmailController.text,
          'relavent': serverValue,
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
            content: Text('Work Experience add Successfully...'),
          ),
        );
      } else if (response.statusCode == 400) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text('Bad Request: Work Experience Details.'),
          ),
        );
        print('Failed to post data: ${response.statusCode}');
        print('Failed to post data: ${response.body}');
      } else if (response.statusCode == 500) {
        print('Failed to post data: ${response.statusCode}');
        print('Failed to post data: ${response.body}');
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
          'Work',
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
                controller: companyNameController,
                hintText: 'Enter Company Name',
                prefixIconData: Icons.school_outlined,
                fieldName: 'Company Name',
              ),
              const SizedBox(height: 10),
              buildTextField(
                controller: designationController,
                hintText: 'Enter Designation Name',
                prefixIconData: Icons.school_outlined,
                fieldName: 'Designation',
              ),
              const SizedBox(height: 10),
              _buildDateFields('From Date', fromDateController),
              const SizedBox(height: 10),
              _buildDateFields('To Date', toDateController),
              const SizedBox(height: 10),
              buildTextField(
                controller: descriptionController,
                hintText: 'Enter Description',
                prefixIconData: Icons.school_outlined,
                fieldName: 'Description',
              ),
              const SizedBox(height: 10),
              buildTextField(
                controller: personNameController,
                hintText: 'Enter Person Name',
                prefixIconData: Icons.school_outlined,
                fieldName: 'Person Name',
              ),
              const SizedBox(height: 10),
              buildphoneNumber(
                controller: personContactController,
                hintText: 'Enter Contact Number',
                prefixIconData: Icons.school_outlined,
                fieldName: 'Contact Number',
              ),
              const SizedBox(height: 10),
              buildphoneNumber(
                controller: workNumberController,
                hintText: 'Enter Work Number',
                prefixIconData: Icons.school_outlined,
                fieldName: 'Work Number',
              ),
              const SizedBox(height: 10),
              buildTextField(
                controller: personEmailController,
                hintText: 'Enter person Email',
                prefixIconData: Icons.school_outlined,
                fieldName: 'Person Email',
              ),
              const SizedBox(height: 10),
              buildDropdownFormFieldss(
                items: relevant, // Pass the relevant list
                selectedValue: selectedRelevant,
                hintText: 'Select relevant',
                onChanged: (value) {
                  // Ensure the selected value is parsed into an integer before assigning
                  selectedRelevant = value;
                },
                prefixIconData: Icons.check,
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
          borderSide: BorderSide(color: Colors.grey.withOpacity(0.5)),
          borderRadius: BorderRadius.circular(7.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.withOpacity(0.5)),
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

  buildDropdownFormFieldss({
    required List<bool> items,
    required bool? selectedValue,
    required String hintText,
    required Function(bool?) onChanged,
    required IconData prefixIconData,
  }) {
    return DropdownButtonFormField<bool>(
      value: selectedValue,
      items: items.map((bool value) {
        return DropdownMenuItem<bool>(
          value: value,
          child: Text(value ? 'True' : 'False'),
        );
      }).toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.withOpacity(0.5)),
          borderRadius: BorderRadius.circular(7),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.withOpacity(0.5)),
          borderRadius: BorderRadius.circular(7),
        ),
        hintText: hintText,
        prefixIcon: Icon(prefixIconData),
        border: OutlineInputBorder(),
      ),
    );
  }

  //Date method in From Date, To Date
  Widget _buildDateFields(String hintText, TextEditingController controller) {
    return SizedBox(
      // width: 160,
      child: TextField(
        controller: controller,
        readOnly: true, // Make the field read-only
        decoration: InputDecoration(
          prefixIcon: const Icon(
            Icons.date_range,
            // color: Colors.blue,
          ),
          hintText: hintText,
          labelStyle: const TextStyle(fontSize: 10),
          border: const OutlineInputBorder(),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.withOpacity(0.5)),
            borderRadius: BorderRadius.circular(7),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.withOpacity(0.5)),
            borderRadius: BorderRadius.circular(7),
          ),
          filled: true,
          fillColor: ThemeColor.TextFieldColor,
        ),
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(3000),
          );

          if (pickedDate != null) {
            String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
            controller.text = formattedDate;
          }
        },
      ),
    );
  }

  //Phone Number Method
  Widget buildphoneNumber({
    TextEditingController? controller,
    String hintText = 'Enter text here',
    IconData? prefixIconData,
    required String fieldName,
    // bool readOnly = false, // Add this line
  }) {
    return Center(
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.number,
        inputFormatters: [LengthLimitingTextInputFormatter(10)],
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.withOpacity(0.5)),
            borderRadius: BorderRadius.circular(7),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.withOpacity(0.5)),
            borderRadius: BorderRadius.circular(7),
          ),
          hintText: hintText,
          prefixIcon: Icon(prefixIconData),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(7),
            borderSide: const BorderSide(
              // color: Colors.black,
              width: 1.0,
            ),
          ),
          filled: true,
          fillColor: ThemeColor.TextFieldColor,
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $fieldName';
          }
          return null;
        },
      ),
    );
  }
}
