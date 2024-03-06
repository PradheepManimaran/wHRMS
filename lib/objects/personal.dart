import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wHRMS/apiHandlar/baseUrl.dart';

class EmployeeModel {
  static List<EmployeeName> employeeData = [];

  static Future<List<EmployeeName>> fetchEmployeeProfile(
      BuildContext context) async {
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

      // print('Employee Response Body: ${response.body}');
      // print('Status Code: ${response.statusCode}');

      if (response.statusCode == 200) {
        final dynamic data = jsonDecode(response.body);

        if (data is List) {
          employeeData = data
              .map((item) => EmployeeName.fromJson(item))
              .toList(); // Update the employee list
          printAllEmployeeNames(); // Call printAllEmployeeNames after updating the list
          return employeeData;
        } else if (data is Map<String, dynamic>) {
          employeeData = [EmployeeName.fromJson(data)];
          printAllEmployeeNames();
          return employeeData;
        }
      } else if (response.statusCode == 401) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text('Invalid Token. Please Try again.'),
          ),
        );
        // print('Failed Response Body: ${response.body}');
        // print('Failed Status Code: ${response.statusCode}');
        throw Exception(
            'Failed to load employee data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // print('Error loading employee data: $e');
      // throw Exception('Error loading employee data: $e');
    }
    return []; // Return empty list if no data is fetched
  }

  static void printAllEmployeeNames() {
    // for (var EmployeeName in employee) {
    //   // print('Employee Name: ${EmployeeName.firstname}');
    //   // print('Employee Name: ${EmployeeName.lastname}');
    //   // print('Employee uan: ${EmployeeName.uan}');
    //   // print('Employee pan: ${EmployeeName.pan}');
    //   // print('Employee workNumber: ${EmployeeName.workNumber}');
    //   // print('Employee address: ${EmployeeName.address}');
    // }
  }
}

class EmployeeName {
  final String firstname;
  final String lastname;
  final String uan;
  final String pan;
  final int age;
  final String date;
  final String workNumber;
  final String personalNumber;
  final String personalEmail;
  final String address;

  EmployeeName({
    required this.firstname,
    required this.lastname,
    required this.uan,
    required this.pan,
    required this.age,
    required this.date,
    required this.workNumber,
    required this.personalNumber,
    required this.personalEmail,
    required this.address,
  });

  factory EmployeeName.fromJson(Map<String, dynamic> json) {
    return EmployeeName(
      firstname: json['first_name'] as String? ?? '',
      lastname: json['last_name'] as String? ?? '',
      uan: json['uan'] as String? ?? '',
      pan: json['pan'] as String? ?? '',
      age: json['age'] as int? ?? 0,
      date: json['date_of_birth'] as String? ?? '',
      workNumber: json['working_phone'] as String? ?? '',
      personalNumber: json['personal_phone'] as String? ?? '',
      personalEmail: json['personal_email'] as String? ?? '',
      address: json['address'] as String? ?? '',
    );
  }
}
