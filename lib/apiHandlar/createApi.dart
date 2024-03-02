// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:logger/logger.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:wHRMS/apiHandlar/baseUrl.dart';

// class createApiHandler extends StatefulWidget {
//   const createApiHandler({super.key});

//   @override
//   State<createApiHandler> createState() => _createApiHandlerState();
// }

// class _createApiHandlerState extends State<createApiHandler> {
//   List<Map<String, dynamic>> roleList = [];
//   List<Map<String, dynamic>> departmentList = [];
//   List<Map<String, dynamic>> desList = [];
//   List<Map<String, dynamic>> enrollTypeList = [];
//   List<Map<String, dynamic>> enrollStatusList = [];
//   List<Map<String, dynamic>> sourceHireList = [];

//   final Logger _logger = Logger();

//   @override
//   void initState() {
//     super.initState();
//     fetchData();
//   }

//   Future<void> fetchData() async {
//     await fetchRoles();
//     await fetchDepartments();
//     await fetchDesignations();
//     await fetchEnrollmentTypes();
//     await fetchEnrollmentStatuses();
//     await fetchSourceHires();
//   }

//   // final Logger _logger = Logger();

//   Future<void> fetchRoles() async {
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
//         final List<dynamic> roles = json.decode(response.body);

//         setState(() {
//           roleList.clear();
//           // Store both name and id
//           roleList.addAll(roles.map((role) => {
//                 'id': role['id'].toString(),
//                 'name': role['name'].toString(),
//               }));
//         });
//         print('Body: ${response.body}');
//       } else {
//         print('Error fetching roles. Status code: ${response.statusCode}');
//         print('Roles Response body: ${response.body}');
//       }
//     } catch (e) {
//       _handleError(e);
//     }
//   }

//   Future<void> fetchDepartments() async {
//     const String roleApiUrl = '${URLConstants.baseUrl}/api/department';

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
//         _logger.d('Department fetched successfully');

//         final List<dynamic> department = json.decode(response.body);

//         setState(() {
//           departmentList.clear();
//           departmentList.addAll(department.map((dep) => {
//                 'id': dep['id'].toString(),
//                 'name': dep['name'].toString(),
//               }));
//         });
//       } else {
//         print('Error fetching Department. Status code: ${response.statusCode}');
//         print('Department Response body: ${response.body}');
//       }
//     } catch (e) {
//       _handleError(e);
//     }
//   }

//   Future<void> fetchDesignations() async {
//     const String roleApiUrl = '${URLConstants.baseUrl}/api/designation';

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
//         _logger.d('Designation fetched successfully');

//         final List<dynamic> desig = json.decode(response.body);

//         setState(() {
//           desList.clear();
//           desList.addAll(desig.map((de) => {
//                 'id': de['id'].toString(),
//                 'name': de['name'].toString(),
//               }));
//         });
//       } else {
//         print(
//             'Error fetching Designation. Status code: ${response.statusCode}');
//         print('Designation Response body: ${response.body}');
//       }
//     } catch (e) {
//       _handleError(e);
//     }
//   }

//   Future<void> fetchEnrollmentTypes() async {
//     const String roleApiUrl = '${URLConstants.baseUrl}/api/enrollment_type';

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
//         _logger.d('EnrollType fetched successfully');

//         final List<dynamic> enType = json.decode(response.body);

//         setState(() {
//           enrollTypeList.clear();
//           enrollTypeList.addAll(enType.map((eTy) => {
//                 'id': eTy['id'].toString(),
//                 'name': eTy['name'].toString(),
//               }));
//         });
//       } else {
//         print('Error fetching EnrollType. Status code: ${response.statusCode}');
//         print('EnrollType Response body: ${response.body}');
//       }
//     } catch (e) {
//       _handleError(e);
//     }
//   }

//   Future<void> fetchEnrollmentStatuses() async {
//     const String roleApiUrl = '${URLConstants.baseUrl}/api/enrollment_status';

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
//         _logger.d('EnrollStatus fetched successfully');

//         final List<dynamic> enStatus = json.decode(response.body);

//         setState(() {
//           enrollStatusList.clear();
//           enrollStatusList.addAll(enStatus.map((eSt) => {
//                 'id': eSt['id'].toString(),
//                 'name': eSt['name'].toString(),
//                 'is_active': eSt['is_active'].toString(),
//               }));
//         });
//       } else {
//         print(
//             'Error fetching EnrollStatus. Status code: ${response.statusCode}');
//         print('EnrollStatus Response body: ${response.body}');
//       }
//     } catch (e) {
//       _handleError(e);
//     }
//   }

//   Future<void> fetchSourceHires() async {
//     const String roleApiUrl = '${URLConstants.baseUrl}/api/source_hire';

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
//         _logger.d('SourceHire fetched successfully');

//         final List<dynamic> sourceHire = json.decode(response.body);

//         setState(() {
//           sourceHireList.clear();
//           sourceHireList.addAll(sourceHire.map((hir) => {
//                 'id': hir['id'].toString(),
//                 'name': hir['name'].toString(),
//               }));
//         });
//       } else {
//         print('Error fetching SourceHire. Status code: ${response.statusCode}');
//         print('SourceHire Response body: ${response.body}');
//       }
//     } catch (e) {
//       _handleError(e);
//     }
//   }

//   void _handleError(dynamic e) {
//     _logger.e('Error: $e');
//     print('Error: $e');
//     if (e is SocketException) {
//       _showSnackBar('No Internet Connection', context);
//     }
//   }

//   void _showSnackBar(String message, BuildContext context) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         action: SnackBarAction(
//           label: 'OK',
//           onPressed: () {
//             ScaffoldMessenger.of(context).hideCurrentSnackBar();
//           },
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return const Placeholder();
//   }
// }
