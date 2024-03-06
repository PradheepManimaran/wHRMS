// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:wHRMS/apiHandlar/baseUrl.dart';

// class ImageFetch {
//   static Future<String?> fetchImage() async {
//     try {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       String token = prefs.getString('token') ?? '';

//       final response = await http.get(
//         Uri.parse('${URLConstants.baseUrl}/api/profileimg'),
//         headers: {
//           'Authorization': 'token $token',
//           'Content-Type': 'application/json',
//         },
//       );

//       if (response.statusCode == 200) {
//         final List<dynamic> data = jsonDecode(response.body);

//         if (data.isNotEmpty) {
//           // Assuming there's only one item in the array
//           final Map<String, dynamic> firstItem = data.first;
//           String? profilePicture = firstItem['profile_picture'] ?? '';
//           return profilePicture;
//         } else {
//           // Return null if no image data is available
//           return null;
//         }
//       } else {
//         // Handle HTTP error response
//         return null;
//       }
//     } catch (e) {
//       // Handle other errors, such as network issues or parsing errors
//       return null;
//     }
//   }
// }
