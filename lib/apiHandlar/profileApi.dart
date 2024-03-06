// import 'dart:convert';

// import 'package:flutter/foundation.dart';
// import 'package:http/http.dart' as http;
// import 'package:logger/logger.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:wHRMS/apiHandlar/baseUrl.dart';
// import 'package:wHRMS/objects/education.dart';
// import 'package:wHRMS/objects/familyObject.dart';
// import 'package:wHRMS/objects/personal.dart';
// import 'package:wHRMS/objects/profile_field.dart';
// import 'package:wHRMS/objects/work_experience.dart';

// class employeeProfileApi {
//   List<EmployeesField> employeeProfile = [];
//   // bool isFirstTap = true;
//   final Logger _logger = Logger();
//   List<EmployeeName> employee = [];
//   List<WorkExperience> work = [];
//   List<EducationDetails> education = [];
//   List<Employe> daage = [];
//   List<FamilyDetails> familyDetails = [];
//   // Timer? _timer;

//   String? profile_picture;

//    Future<void> _fetchEmployeeProfile() async {
//     try {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       String token = prefs.getString('token') ?? '';

//       final response = await http.get(
//         Uri.parse('${URLConstants.baseUrl}/api/employee'),
//         headers: {
//           'Authorization': 'token $token',
//           'Content-Type': 'application/json',
//         },
//       );

//       _logger.d('Employee Status Code : ${response.statusCode}');
//       _logger.d('Testing Employee Body : ${response.body}');

//       if (response.statusCode == 200) {
//         final dynamic data = jsonDecode(response.body);

//         if (data is List) {
//           setState(() {
//             employee = data.map((item) => EmployeeName.fromJson(item)).toList();
//             daage = data.map((item) => Employe.fromJson(item)).toList();
//           });
//         } else if (data is Map<String, dynamic>) {
//           // Single employee case
//           setState(() {
//             employee = [EmployeeName.fromJson(data)];
//             daage = [Employe.fromJson(data)];
//           });
//         } else {
//           if (kDebugMode) {
//             print('Unexpected response format');
//           }
//         }
//       } else {
//         if (kDebugMode) {
//           print(
//               'Failed to load Employee data. Status code: ${response.statusCode}');
//         }
//         if (kDebugMode) {
//           print('Response body: ${response.body}');
//         }
//       }
//     } catch (e) {
//       if (kDebugMode) {
//         print('Error loading employee data: $e');
//       }
//     }
//   }

//   Future<void> _fetchEmployee() async {
//     try {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       String token = prefs.getString('token') ?? '';

//       final response = await http.get(
//         Uri.parse('${URLConstants.baseUrl}/api/user'),
//         headers: {
//           'Authorization': 'token $token',
//           'Content-Type': 'application/json',
//         },
//       );

//       _logger.d('User Status Code : ${response.statusCode}');
//       _logger.d('Testing User Body : ${response.body}');

//       if (response.statusCode == 200) {
//         final dynamic data = jsonDecode(response.body);

//         if (data is List) {
//           setState(() {
//             employeeProfile =
//                 data.map((item) => EmployeesField.fromJson(item)).toList();
//           });
//         } else if (data is Map<String, dynamic>) {
//           // Single employee case
//           setState(() {
//             employeeProfile = [EmployeesField.fromJson(data)];
//           });
//         } else {
//           if (kDebugMode) {
//             print('Unexpected response format');
//           }
//         }
//       } else {
//         if (kDebugMode) {
//           print(
//               'Failed to load User data. Status code: ${response.statusCode}');
//         }
//         if (kDebugMode) {
//           print('Response body: ${response.body}');
//         }
//       }
//     } catch (e) {
//       if (kDebugMode) {
//         print('Error loading employee data: $e');
//       }
//     }
//   }

//   Future<void> _fetchWorkExperience() async {
//     try {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       String token = prefs.getString('token') ?? '';

//       final response = await http.get(
//         Uri.parse('${URLConstants.baseUrl}/api/work_experiences'),
//         headers: {
//           'Authorization': 'token $token',
//           'Content-Type': 'application/json',
//         },
//       );

//       if (kDebugMode) {
//         print('Response token: $token');
//       }

//       _logger.d('Work_Experience Status Code : ${response.statusCode}');
//       _logger.d('Testing Work_Experience Body : ${response.body}');

//       if (response.statusCode == 200) {
//         final dynamic data = jsonDecode(response.body);

//         if (data is List) {
//           setState(() {
//             work = data.map((item) => WorkExperience.fromJson(item)).toList();
//           });
//         } else if (data is Map<String, dynamic>) {
//           // Single employee case
//           setState(() {
//             work = [WorkExperience.fromJson(data)];
//           });
//         } else {
//           if (kDebugMode) {
//             print('Unexpected response format');
//           }
//         }
//       } else {
//         if (kDebugMode) {
//           print(
//               'Failed to load Work_experience data. Status code: ${response.statusCode}');
//         }
//         if (kDebugMode) {
//           print('Response body: ${response.body}');
//         }
//       }
//     } catch (e) {
//       if (kDebugMode) {
//         print('Error loading Work_Experience data: $e');
//       }
//     }
//   }

//   Future<void> _fetchEducation() async {
//     try {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       String token = prefs.getString('token') ?? '';

//       final response = await http.get(
//         Uri.parse('${URLConstants.baseUrl}/api/education'),
//         headers: {
//           'Authorization': 'token $token',
//           'Content-Type': 'application/json',
//         },
//       );

//       _logger.d('Education Status Code : ${response.statusCode}');
//       _logger.d('Testing Education Body : ${response.body}');

//       if (response.statusCode == 200) {
//         final dynamic data = jsonDecode(response.body);

//         if (data is List) {
//           setState(() {
//             education =
//                 data.map((item) => EducationDetails.fromJson(item)).toList();
//           });
//         } else if (data is Map<String, dynamic>) {
//           // Single employee case
//           setState(() {
//             work = [WorkExperience.fromJson(data)];
//           });
//         } else {
//           if (kDebugMode) {
//             print('Unexpected response format');
//           }
//         }
//       } else {
//         if (kDebugMode) {
//           print(
//               'Failed to load Education data. Status code: ${response.statusCode}');
//         }
//         if (kDebugMode) {
//           print('Response body: ${response.body}');
//         }
//       }
//     } catch (e) {
//       if (kDebugMode) {
//         print('Error loading Education data: $e');
//       }
//     }
//   }

//   Future<void> _fetchImage() async {
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

//       _logger.d('User Status Code: ${response.statusCode}');
//       _logger.d('Testing User Body: ${response.body}');

//       if (response.statusCode == 200) {
//         final List<dynamic> data = jsonDecode(response.body);

//         if (data.isNotEmpty) {
//           // Assuming there's only one item in the array
//           final Map<String, dynamic> firstItem = data.first;
//           setState(() {
//             // Assuming profile_picture_url is the key in your API response
//             profile_picture = firstItem['profile_picture'] ?? '';
//             _logger.d('Testing User: $firstItem');
//           });
//         } else {
//           if (kDebugMode) {
//             print('Empty response');
//           }
//         }
//       } else {
//         if (kDebugMode) {
//           print(
//               'Failed to load Image data. Status code: ${response.statusCode}');
//         }
//         if (kDebugMode) {
//           print('Response body: ${response.body}');
//         }
//       }
//     } catch (e) {
//       if (kDebugMode) {
//         print('Error loading image data: $e');
//       }
//     }
//   }

//   Future<void> _fetchFamily() async {
//     try {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       String token = prefs.getString('token') ?? '';

//       final response = await http.get(
//         Uri.parse('${URLConstants.baseUrl}/api/familyinfo'),
//         headers: {
//           'Authorization': 'token $token',
//           'Content-Type': 'application/json',
//         },
//       );

//       _logger.d('Family Status Code : ${response.statusCode}');
//       _logger.d('Testing Family Body : ${response.body}');

//       if (response.statusCode == 200) {
//         final dynamic data = jsonDecode(response.body);

//         if (data is List) {
//           setState(() {
//             familyDetails =
//                 data.map((item) => FamilyDetails.fromJson(item)).toList();
//           });
//         } else if (data is Map<String, dynamic>) {
//           // Single employee case
//           setState(() {
//             work = [WorkExperience.fromJson(data)];
//           });
//         } else {
//           if (kDebugMode) {
//             print('Unexpected response format');
//           }
//         }
//       } else {
//         if (kDebugMode) {
//           print(
//               'Failed to load Family data. Status code: ${response.statusCode}');
//         }
//         if (kDebugMode) {
//           print('Response body: ${response.body}');
//         }
//       }
//     } catch (e) {
//       if (kDebugMode) {
//         print('Error loading Family data: $e');
//       }
//     }
//   }
// }

import 'package:flutter/material.dart';
import 'package:wHRMS/objects/education.dart';
import 'package:wHRMS/objects/familyObject.dart';
import 'package:wHRMS/objects/personal.dart';
import 'package:wHRMS/objects/profile_field.dart';
import 'package:wHRMS/objects/work_experience.dart';

class DataInitializer {
  static Future<List<EmployeeName>> fetchEmployeeData(
      BuildContext context) async {
    try {
      List<EmployeeName> data =
          await EmployeeModel.fetchEmployeeProfile(context);
      print('Employee data: $data');
      return data;
    } catch (e) {
      print('Error fetching employee data: $e');
      return [];
    }
  }

  static Future<List<EmployeesField>> fetchEmployeeProfile() async {
    try {
      List<EmployeesField> profile = await EmployeeApiProfile.fetchEmployee();
      print('Employee profile: $profile');
      return profile;
    } catch (e) {
      print('Error fetching employee profile: $e');
      return [];
    }
  }

  // static Future<List<Employe>> fetchEmployeeAge() async {
  //   try {

  //     print('Employee age: $age');
  //     return age;
  //   } catch (e) {
  //     print('Error fetching employee age: $e');
  //     return [];
  //   }
  // }

  static Future<List<WorkExperience>> fetchWorkData() async {
    try {
      List<WorkExperience> workData = await workProfile.fetchWorkExperience();
      print('Work data: $workData');
      print('Response : $WorkExperience');
      return workData;
    } catch (e) {
      print('Error fetching work data: $e');
      return [];
    }
  }

  static Future<List<FamilyDetails>> fetchFamilyDetails() async {
    try {
      List<FamilyDetails> familyDetails = await FamilyApiHandler.fetchFamily();
      print('Family details: $familyDetails');
      return familyDetails;
    } catch (e) {
      print('Error fetching family details: $e');
      return [];
    }
  }

  static Future<List<EducationDetails>> fetchEducationData() async {
    try {
      List<EducationDetails> educationData =
          await EducationProfile.fetchEducationData();
      print('Education data: $educationData');
      return educationData;
    } catch (e) {
      print('Error fetching education data: $e');
      return [];
    }
  }
}
