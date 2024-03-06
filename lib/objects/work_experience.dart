import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:wHRMS/apiHandlar/baseUrl.dart';
import 'package:http/http.dart' as http;

class WorkExperience {
  final int id;
  final String companyName;
  final String designation;
  final String fromDate;
  final String toDate;
  final String description;
  final bool relevant; // Change type to bool
  final String personName;
  final String personContact;

  WorkExperience({
    required this.id,
    required this.companyName,
    required this.designation,
    required this.fromDate,
    required this.toDate,
    required this.description,
    required this.relevant,
    required this.personName,
    required this.personContact,
  });

  factory WorkExperience.fromJson(Map<String, dynamic> json) {
    return WorkExperience(
      id: json['id'] as int,
      companyName: json['company_name'] as String? ?? '',
      designation: json['designation'] as String? ?? '',
      fromDate: json['from_date'] as String? ?? '',
      toDate: json['to_date'] as String? ?? '',
      description: json['description'] as String? ?? '',
      relevant: json['relevant'] as bool? ??
          false, // Parse as bool, default to false if null
      personName: json['verify_person_name'] as String? ?? '',
      personContact: json['verify_person_contact'] as String? ?? '',
    );
  }
}

class workProfile {
  static Future<List<WorkExperience>> fetchWorkExperience() async {
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

      // print(' Response Body: ${response.body}');
      // print(' Status Code: ${response.statusCode}');

      if (response.statusCode == 200) {
        final dynamic data = jsonDecode(response.body);

        if (data is List) {
          return data.map((item) => WorkExperience.fromJson(item)).toList();
        } else if (data is Map<String, dynamic>) {
          // Single employee case
          return [WorkExperience.fromJson(data)];
        } else {
          // print('Failed Response Body: ${response.body}');
          // print('Failed Status Code: ${response.statusCode}');
          // Unexpected response format
          return [];
        }
      } else {
        // print('Failed Response Body: ${response.body}');
        // print('Failed Status Code: ${response.statusCode}');
        // Failed to load work experience data
        return [];
      }
    } catch (e) {
      // Error loading work experience data
      return [];
    }
  }
}
