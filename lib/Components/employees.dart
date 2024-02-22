import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:wHRMS/View/create_employee.dart';
import 'package:wHRMS/View/userList.dart';
import 'package:wHRMS/apiHandlar/baseUrl.dart';
import 'package:wHRMS/objects/education.dart';
import 'package:wHRMS/objects/work_experience.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

class EmployeeScreen extends StatefulWidget {
  const EmployeeScreen({Key? key}) : super(key: key);

  @override
  State<EmployeeScreen> createState() => _EmployeeScreenState();
}

class _EmployeeScreenState extends State<EmployeeScreen> {
  List<Employee> employees = [];
  bool isLoading = true;
  final Logger _logger = Logger();

  @override
  void initState() {
    super.initState();
    _fetchEmployees();
    init();
  }

  Future init() async {
    await _fetchEmployees();
  }

  Future<void> _fetchEmployees() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token') ?? '';

      final response = await http.get(
        Uri.parse('${URLConstants.baseUrl}/api/users'),
        headers: {
          'Authorization': 'token $token',
          'Content-Type': 'application/json',
        },
      );

      _logger.d('Testing Response Body: ${response.body}');
      if (response.statusCode == 200) {
        final dynamic data = jsonDecode(response.body);

        if (data is List) {
          setState(() {
            employees = data.map((item) => Employee.fromJson(item)).toList();
            isLoading = false;
          });
        } else if (data is Map<String, dynamic>) {
          setState(() {
            employees = [Employee.fromJson(data)];
            isLoading = false;
          });
        } else {
          print('Unexpected response format');
          _logger.d('Error ResponseBody: ${response.body}');
        }
      } else {
        print(
            'Failed to load employee data. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        _logger.d('Error Response Body: ${response.body}');
      }
    } catch (e) {
      print('Error loading employee data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const SizedBox(height: 15),
            Row(
              children: [
                const Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Employee',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                // const SizedBox(width: 210),
                const Spacer(),
                Align(
                  alignment: Alignment.topRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: ((context) => const CreateEmployee()),
                        ),
                      );
                    },
                    child: const Text(
                      'Add',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
              ],
            ),
            const SizedBox(height: 10),
            isLoading
                ? _buildShimmerLoading()
                : Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 10.0),
                        for (var i = 0; i < employees.length; i++)
                          EmployeeListItemCard(employee: employees[i]),
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      period: const Duration(seconds: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 120,
            child: Card(
              elevation: 1,
              margin: const EdgeInsets.symmetric(vertical: 5),
              child: Row(
                children: [
                  SizedBox(
                    width: 120,
                    child: CircleAvatar(
                      backgroundColor: Colors.blue,
                      radius: 40,
                    ),
                  ),
                  Expanded(
                    child: ListTile(
                      title: Container(
                        color: Colors.white,
                        height: 16,
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            color: Colors.white,
                            height: 16,
                          ),
                          Container(
                            color: Colors.white,
                            height: 14,
                          ),
                          Container(
                            color: Colors.white,
                            height: 14,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Employee {
  final int id;
  final String username;
  final String email;
  final String employeeId;
  final String phoneNumber;
  final String role;
  final String department;
  final String designation;
  final String enrollmentType;
  final String enrollmentStatus;
  final String sourceHire;
  final String dateOfJoining;
  final List<UserProfilePicture> userProfilePicture;
  final List<WorkExperience> workExperience;
  final List<EducationDetails> education;

  Employee({
    required this.id,
    required this.username,
    required this.email,
    required this.employeeId,
    required this.phoneNumber,
    required this.role,
    required this.department,
    required this.designation,
    required this.enrollmentType,
    required this.enrollmentStatus,
    required this.sourceHire,
    required this.dateOfJoining,
    required this.userProfilePicture,
    required this.workExperience,
    required this.education,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      employeeId: json['employee_id'],
      phoneNumber: json['phone_number'],
      role: json['role']['name'],
      department: json['department']['name'],
      designation: json['designation']['name'],
      enrollmentType: json['enrollment_type']['name'],
      enrollmentStatus: json['enrollment_status']['name'],
      sourceHire: json['source_hire']['name'],
      dateOfJoining: json['date_of_joining'],
      userProfilePicture: json['user_profile_picture'] != null
          ? List<UserProfilePicture>.from(json['user_profile_picture']
              .map((x) => UserProfilePicture.fromJson(x)))
          : [],
      workExperience: json['work_experience'] != null
          ? List<WorkExperience>.from(
              json['work_experience'].map((x) => WorkExperience.fromJson(x)))
          : [],
      education: json['education'] != null
          ? List<EducationDetails>.from(
              json['education'].map((x) => EducationDetails.fromJson(x)))
          : [],
    );
  }
}

class UserProfilePicture {
  final int id;
  final int user;
  final String profilePicture;

  UserProfilePicture({
    required this.id,
    required this.user,
    required this.profilePicture,
  });

  factory UserProfilePicture.fromJson(Map<String, dynamic> json) {
    return UserProfilePicture(
      id: json['id'],
      user: json['user'],
      profilePicture:
          '${URLConstants.baseUrl}${json['profile_picture']}', // Prepend base URL to relative path
    );
  }
}

class EmployeeListItemCard extends StatelessWidget {
  final Employee employee;

  const EmployeeListItemCard({
    required this.employee,
  });

  @override
  Widget build(BuildContext context) {
    // Log profile picture URLs for debugging
    print(
        'Profile Picture URLs: ${employee.userProfilePicture.map((p) => p.profilePicture).toList()}');

    // Base URL of your server
    // final baseUrl = '${URLConstants.baseUrl}';

    // Function to prepend base URL to relative URLs
    String _prependBaseUrl(String url) {
      return '$url';
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageTransition(
            type: PageTransitionType.rightToLeft,
            duration: const Duration(milliseconds: 200),
            child: UserListScreen(
              employee: employee,
            ),
          ),
        );
      },
      child: Card(
        elevation: 1,
        margin: const EdgeInsets.symmetric(vertical: 5),
        child: SizedBox(
          child: Row(
            children: [
              SizedBox(
                width: 120,
                child: CircleAvatar(
                  backgroundColor: Colors.blue,
                  radius: 40,
                  backgroundImage: employee.userProfilePicture.isNotEmpty
                      ? NetworkImage(_prependBaseUrl(
                          employee.userProfilePicture[0].profilePicture))
                      : null,
                ),
              ),
              Expanded(
                child: ListTile(
                  title: Text(
                    employee.username,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        employee.email,
                        style: const TextStyle(fontSize: 16),
                      ),
                      Text(
                        'Role: ${employee.role}',
                        style: const TextStyle(fontSize: 14),
                      ),
                      Text(
                        'Date of Joining: ${employee.dateOfJoining}',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
