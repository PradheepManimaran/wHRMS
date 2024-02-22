import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:wHRMS/ThemeColor/theme.dart';
import 'package:wHRMS/apiHandlar/baseUrl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EmployeeSkills extends StatefulWidget {
  const EmployeeSkills({Key? key}) : super(key: key);

  @override
  State<EmployeeSkills> createState() => _EmployeeSkillsState();
}

class _EmployeeSkillsState extends State<EmployeeSkills> {
  final Logger _logger = Logger();

  List<String> selectedSkills = [];
  List<Map<String, dynamic>> skillList = [];
  int? userId; // Variable to store user ID
  int? tableId; // Variable to store table ID

  @override
  void initState() {
    super.initState();
    _fetchSkills();
  }

  Future<void> _fetchSkills() async {
    const String skillsApiUrl = '${URLConstants.baseUrl}/api/skills';

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token') ?? '';

      final response = await http.get(
        Uri.parse(skillsApiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'token $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = json.decode(response.body);

        // Retrieve user ID and table ID from the response body
        userId = responseBody['user'];
        tableId = responseBody['table_id'];

        // Save user ID and table ID in SharedPreferences
        prefs.setInt('userId', userId ?? 0);
        prefs.setInt('tableId', tableId ?? 0);

        final List<dynamic> skills = responseBody['skills'];

        setState(() {
          skillList.clear();
          skillList.addAll(skills.map((skill) => {
                'id': skill['id'].toString(),
                'name': skill['name'].toString(),
              }));
        });

        print('Skills Response Body: ${response.body}');
      } else {
        print('Error fetching Skills. Status code: ${response.statusCode}');
        print('Skills Response Body: ${response.body}');
      }
    } catch (e) {
      _handleError(e);
    }
  }

  Future<void> _submitSkills(List<String> selectedSkills) async {
    const String submitSkillsApiUrl = '${URLConstants.baseUrl}/api/skills';

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token') ?? '';

      final response = await http.post(
        Uri.parse(submitSkillsApiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'token $token',
        },
        body: jsonEncode(
            {'name': selectedSkills}), // Sending only the selected skill names
      );

      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        // Handle success
        print('Skills submitted successfully');
      } else {
        print('Error submitting Skills. Status code: ${response.statusCode}');
        // Retrieve user ID and table ID from SharedPreferences
        print(
            'User ID: ${prefs.getInt('userId')}, Table ID: ${prefs.getInt('tableId')}');
        print('Skills Response Body: ${response.body}');
      }
    } catch (e) {
      _handleError(e);
    }
  }

  void _handleError(dynamic e) {
    _logger.e('Error: $e');
    print('Error: $e');
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
          'Skills',
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildDropdowns(
              items: skillList.map((skill) {
                return MultiSelectItem<String>(
                    skill['id'].toString(), skill['name'] as String);
              }).toList(),
              selectedValues: selectedSkills,
              hintText: 'Select Skills',
              onChanged: (List<String> values) {
                setState(() {
                  selectedSkills = values;
                });
              },
              fieldName: 'Skills',
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.center,
              child: SizedBox(
                width: double.infinity,
                height: 60.0,
                child: ElevatedButton(
                  onPressed: () {
                    _submitSkills(selectedSkills);
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
    );
  }

  Widget _buildDropdowns({
    required List<MultiSelectItem<String>> items,
    required List<String> selectedValues,
    required String hintText,
    required void Function(List<String>) onChanged,
    required String fieldName,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: MultiSelectDialogField(
        items: items,
        initialValue: selectedValues,
        title: Text(hintText),
        buttonText: const Text('Select Your Skills'),
        searchIcon: const Icon(Icons.abc, color: Colors.white),
        chipDisplay: MultiSelectChipDisplay(
          chipColor: Colors.white.withOpacity(0.2),
          textStyle: const TextStyle(color: Colors.black),
        ),
        onConfirm: (List<dynamic> values) {
          List<String> selectedValues =
              values.map((value) => value.toString()).toList();
          onChanged(selectedValues);
        },
      ),
    );
  }
}
