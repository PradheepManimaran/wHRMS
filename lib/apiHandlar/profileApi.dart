import 'dart:convert';

import 'package:logger/logger.dart';
import 'package:wHRMS/apiHandlar/baseUrl.dart';
import 'package:wHRMS/objects/education.dart';
import 'package:wHRMS/objects/personal.dart';
import 'package:wHRMS/objects/profile_field.dart';
import 'package:wHRMS/objects/work_experience.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

Logger _logger = Logger();

class apiHandler {
  // Define variables to hold data fetched from API
  List<EmployeeName> employee = [];
  List<Employe> daage = [];
  List<EmployeesField> employeeProfile = [];
  List<WorkExperience> work = [];
  List<EducationDetails> education = [];
  String profile_picture = '';

  // Method to fetch employee profile
  Future<void> fetchEmployeeProfile() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token') ?? '';

      final response = await http.get(
        Uri.parse('${URLConstants.baseUrl}/api/employee'),
        headers: {
          'Authorization': 'token $token',
          'Content-Type': 'application/json',
        },
      );

      _logger.d('Employee Status Code : ${response.statusCode}');
      _logger.d('Testing Employee Body : ${response.body}');

      if (response.statusCode == 200) {
        final dynamic data = jsonDecode(response.body);

        if (data is List) {
          employee = data.map((item) => EmployeeName.fromJson(item)).toList();
          daage = data.map((item) => Employe.fromJson(item)).toList();
        } else if (data is Map<String, dynamic>) {
          employee = [EmployeeName.fromJson(data)];
          daage = [Employe.fromJson(data)];
        } else {
          print('Unexpected response format');
        }
      } else {
        print(
            'Failed to load Employee data. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error loading employee data: $e');
    }
  }

  // Method to fetch employee
  Future<void> fetchEmployee() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token') ?? '';

      final response = await http.get(
        Uri.parse('${URLConstants.baseUrl}/api/user'),
        headers: {
          'Authorization': 'token $token',
          'Content-Type': 'application/json',
        },
      );

      _logger.d('User Status Code : ${response.statusCode}');
      _logger.d('Testing User Body : ${response.body}');

      if (response.statusCode == 200) {
        final dynamic data = jsonDecode(response.body);

        if (data is List) {
          employeeProfile =
              data.map((item) => EmployeesField.fromJson(item)).toList();
        } else if (data is Map<String, dynamic>) {
          employeeProfile = [EmployeesField.fromJson(data)];
        } else {
          print('Unexpected response format');
        }
      } else {
        print('Failed to load User data. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error loading employee data: $e');
    }
  }

  // Method to fetch work experience
  Future<void> fetchWorkExperience() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token') ?? '';

      final response = await http.get(
        Uri.parse('${URLConstants.baseUrl}/api/work_experiences'),
        headers: {
          'Authorization': 'token $token',
          'Content-Type': 'application/json',
        },
      );

      print('Response token: $token');

      _logger.d('Work_Experience Status Code : ${response.statusCode}');
      _logger.d('Testing Work_Experience Body : ${response.body}');

      if (response.statusCode == 200) {
        final dynamic data = jsonDecode(response.body);

        if (data is List) {
          work = data.map((item) => WorkExperience.fromJson(item)).toList();
        } else if (data is Map<String, dynamic>) {
          work = [WorkExperience.fromJson(data)];
        } else {
          print('Unexpected response format');
        }
      } else {
        print(
            'Failed to load Work_experience data. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error loading Work_Experience data: $e');
    }
  }

  // Method to fetch education
  Future<void> fetchEducation() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token') ?? '';

      final response = await http.get(
        Uri.parse('${URLConstants.baseUrl}/api/education'),
        headers: {
          'Authorization': 'token $token',
          'Content-Type': 'application/json',
        },
      );

      _logger.d('Education Status Code : ${response.statusCode}');
      _logger.d('Testing Education Body : ${response.body}');

      if (response.statusCode == 200) {
        final dynamic data = jsonDecode(response.body);

        if (data is List) {
          education =
              data.map((item) => EducationDetails.fromJson(item)).toList();
        } else if (data is Map<String, dynamic>) {
          work = [WorkExperience.fromJson(data)];
        } else {
          print('Unexpected response format');
        }
      } else {
        print(
            'Failed to load Education data. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error loading Education data: $e');
    }
  }

  // Method to fetch image
  Future<void> fetchImage() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token') ?? '';

      final response = await http.get(
        Uri.parse('${URLConstants.baseUrl}/api/profileimg'),
        headers: {
          'Authorization': 'token $token',
          'Content-Type': 'application/json',
        },
      );

      _logger.d('User Status Code: ${response.statusCode}');
      _logger.d('Testing User Body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        if (data.isNotEmpty) {
          // Assuming there's only one item in the array
          final Map<String, dynamic> firstItem = data.first;
          profile_picture = firstItem['profile_picture'] ?? '';
          _logger.d('Testing User: $firstItem');
        } else {
          print('Empty response');
        }
      } else {
        print('Failed to load Image data. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error loading image data: $e');
    }
  }
}
