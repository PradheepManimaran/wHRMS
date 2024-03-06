import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wHRMS/apiHandlar/baseUrl.dart';

class EducationProfile {
  static Future<List<EducationDetails>> fetchEducationData() async {
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
      // print(' Response Body: ${response.body}');
      // print(' Status Code: ${response.statusCode}');
      if (response.statusCode == 200) {
        final dynamic data = jsonDecode(response.body);

        if (data is List) {
          return data.map((item) => EducationDetails.fromJson(item)).toList();
        } else if (data is Map<String, dynamic>) {
          return [EducationDetails.fromJson(data)];
        } else {
          // print('Failed Response Body: ${response.body}');
          // print('Failed Status Code: ${response.statusCode}');
          return [];
        }
      } else {
        // print('Failed Response Body: ${response.body}');
        // print('Failed Status Code: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      // Handle other errors, such as network issues or parsing errors
      return [];
    }
  }
}

class EducationDetails {
  final int id;
  final String universityName;
  final String degree;
  final String specialization;
  final String completeyear;
  final String cgpa;
  final String tableId; // Add tableId property

  EducationDetails(
      {required this.id,
      required this.universityName,
      required this.degree,
      required this.specialization,
      required this.completeyear,
      required this.cgpa,
      required this.tableId});

  factory EducationDetails.fromJson(Map<String, dynamic> json) {
    return EducationDetails(
      id: json['id'] as int,
      universityName: json['institute_name'] as String? ?? '',
      degree: json['degree_diploma'] as String? ?? '',
      specialization: json['specialization'] as String? ?? '',
      completeyear: json['date_of_completion'] as String? ?? '',
      cgpa: json['cgpa'] as String? ?? '',
      tableId: json['table_id'] as String? ?? '', // Map 'table_id' from JSON
    );
  }
}
