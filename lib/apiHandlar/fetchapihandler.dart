// import 'dart:async';
// import 'dart:convert';

// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:wHRMS/apiHandlar/baseUrl.dart';
// import 'package:wHRMS/pages/roleScreen.dart';

// class DataService {
//   static Future<List<Role>> fetchRoles() async {
//     List<Role> roles = [];
//     try {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       String token = prefs.getString('token') ?? '';
//       const String roleApiUrl = '${URLConstants.baseUrl}/api/role';

//       final response = await http.get(
//         Uri.parse(roleApiUrl),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'token $token',
//         },
//       );

//       if (response.statusCode == 200) {
//         final dynamic enrollData = json.decode(response.body);

//         if (enrollData is List) {
//           roles = enrollData.map<Role>((roleData) {
//             return Role(roleData['id'].toString(), roleData['name']);
//           }).toList();
//         } else {
//           print('Invalid Roles data format: $enrollData');
//         }
//       } else {
//         print('Error fetching Roles. Status code: ${response.statusCode}');
//         print('Roles Response body: ${response.body}');
//       }
//     } catch (e) {
//       print('Error fetching Roles: $e');
//     }
//     return roles;
//   }
// }
