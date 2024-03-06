import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:wHRMS/apiHandlar/baseUrl.dart';

class FamilyDetails {
  final int id;
  final String name;
  final String relation;
  final String phoneNumber;
  final String address;

  final String tableId; // Add tableId property

  FamilyDetails(
      {required this.id,
      required this.name,
      required this.relation,
      required this.phoneNumber,
      required this.address,
      required this.tableId});

  factory FamilyDetails.fromJson(Map<String, dynamic> json) {
    return FamilyDetails(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      relation: json['relationship'] as String? ?? '',
      phoneNumber: json['phone_number'] as String? ?? '',
      address: json['address'] as String? ?? '',
      tableId: json['table_id'] as String? ?? '',
    );
  }
}

class FamilyApiHandler {
  static Future<List<FamilyDetails>> fetchFamily() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token') ?? '';

      final response = await http.get(
        Uri.parse('${URLConstants.baseUrl}/api/familyinfo'),
        headers: {
          'Authorization': 'token $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final dynamic data = jsonDecode(response.body);

        if (data is List) {
          List<FamilyDetails> familyDetails =
              data.map((item) => FamilyDetails.fromJson(item)).toList();
          return familyDetails;
        } else if (data is Map<String, dynamic>) {
          // Single family member case
          return [FamilyDetails.fromJson(data)];
        } else {
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
}
