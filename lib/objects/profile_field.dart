import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:wHRMS/apiHandlar/baseUrl.dart';

class EmployeesField {
  final String id;
  final String username;
  final String emailid;

  EmployeesField(this.id, this.username, this.emailid);

  factory EmployeesField.fromJson(Map<String, dynamic> json) {
    return EmployeesField(
      json['employee_id'] as String? ?? '',
      json['username'] as String? ?? '',
      json['email'] as String? ?? '',
    );
  }
}

class EmployeeApiProfile {
  static List<EmployeesField> employee = [];
  static Future<List<EmployeesField>> fetchEmployee() async {
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
      // print('Response Body: ${response.body}');
      // print('Response Status Code: ${response.statusCode}');
      if (response.statusCode == 200) {
        final dynamic data = jsonDecode(response.body);

        if (data is List) {
          employee = data.map((item) => EmployeesField.fromJson(item)).toList();

          // Return a List containing both lists combined
          return employee;
        } else if (data is Map<String, dynamic>) {
          employee = [
            EmployeesField.fromJson(data)
          ]; // Update the employee list
          // printAllEmployeeNames(); // Call printAllEmployeeNames after updating the list
          return employee;
        } else {
          // print('Failed Response Body: ${response.body}');
          // print('failed Response Status Code: ${response.statusCode}');
          // Handle unexpected response format
          return [];
        }
      } else {
        // Handle HTTP error response
        return [];
      }
    } catch (e) {
      // Handle other errors, such as network issues or parsing errors
      return [];
    }
  }

  static void printAllEmployeeNames() {
    employee.forEach((employee) {
      print('Employee ID: ${employee.id}');
      print('Username: ${employee.username}');
      print('Email: ${employee.emailid}');
      print('-------------');
    });
  }
}
