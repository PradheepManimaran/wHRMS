// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:wHRMS/apiHandlar/baseUrl.dart';

// class Role {
//   final String id;
//   final String name;

//   Role({required this.id, required this.name});

//   factory Role.fromJson(Map<String, dynamic> json) {
//     return Role(
//       id: json['id'].toString(),
//       name: json['name'].toString(),
//     );
//   }
// }

// class RoleApiHandler {
//   static Future<List<Role>> fetchRoles() async {
//     const String roleApiUrl = '${URLConstants.baseUrl}/api/role';

//     try {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       String token = prefs.getString('token') ?? '';

//       final response = await http.get(
//         Uri.parse(roleApiUrl),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'token $token',
//         },
//       );

//       if (response.statusCode == 200) {
//         final List<dynamic> rolesData = json.decode(response.body);
//         List<Role> roles =
//             rolesData.map((role) => Role.fromJson(role)).toList();
//         return roles;
//       } else {
//         throw Exception('Failed to fetch roles: ${response.statusCode}');
//       }
//     } catch (e) {
//       throw Exception('Error fetching roles: $e');
//     }
//   }
// }
