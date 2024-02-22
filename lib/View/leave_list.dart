import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:wHRMS/View/apply_leave.dart';
import 'package:http/http.dart' as http;
import 'package:wHRMS/apiHandlar/baseUrl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

class LeaveList extends StatefulWidget {
  const LeaveList({super.key});

  @override
  State<LeaveList> createState() => _LeaveListState();
}

class _LeaveListState extends State<LeaveList> {
  final Logger _logger = Logger();
  List<Employees> employees = [];

  bool isLoading = true;
  String? profile_picture;

  @override
  void initState() {
    super.initState();
    _fetchLeave();
    _fetchImage();
  }

  Future<void> _fetchImage() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token') ?? '';

      final response = await http.get(
        Uri.parse('${URLConstants.baseUrl}/api/profileimg'),
        headers: {
          'Authorization': 'token $token',
          'Content-Type': 'application/json',
        },
      );

      _logger.d('User Status Code: ${response.statusCode}');
      _logger.d('Testing User Body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        if (data.isNotEmpty) {
          // Assuming there's only one item in the array
          final Map<String, dynamic> firstItem = data.first;
          setState(() {
            // Assuming profile_picture_url is the key in your API response
            profile_picture = firstItem['profile_picture'] ?? '';
            _logger.d('Testing User: $firstItem');
          });
        } else {
          print('Empty response');
        }
      } else {
        print('Failed to load Image data. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error loading image data: $e');
    }
  }

  Future<void> _fetchLeave() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token') ?? '';

      final response = await http.get(
        Uri.parse('${URLConstants.baseUrl}/api/leave'),
        headers: {
          'Authorization': 'token $token',
          'Content-Type': 'application/json',
        },
      );

      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final dynamic data = jsonDecode(response.body);

        if (data is List) {
          setState(() {
            employees = data.map((item) => Employees.fromJson(item)).toList();
            isLoading = false; // Set isLoading to false after data is fetched
          });
          print('Testing : ${response.body}');
        } else if (data is Map<String, dynamic>) {
          // Single employee case
          setState(() {
            employees = [Employees.fromJson(data)];
            isLoading = false; // Set isLoading to false after data is fetched
          });
        } else {
          print('Unexpected response format');
        }
      } else {
        print(
            'Failed to load employee data. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 15),
            Row(
              children: [
                const Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Leaves',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                const SizedBox(width: 200),
                Align(
                  alignment: Alignment.topRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: ((context) => const ApplyLeave()),
                        ),
                      );
                    },
                    child: const Text(
                      'Apply',
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
                        for (var i = 0;
                            i <
                                min(employees.length,
                                    profile_picture?.length ?? 0);
                            i++)
                          EmployeeListItemCard(
                            employee: employees[i],
                            profile_picture: profile_picture,
                          ),
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
      period: Duration(seconds: 30),
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
                  const SizedBox(
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
                            height: 16,
                          ),
                          Container(
                            color: Colors.white,
                            height: 16,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Add more shimmer loading widgets as needed
        ],
      ),
    );
  }
}

class Employees {
  final String leave;
  final String startDate;
  final String endDate;
  final String reason;
  final String message;

  Employees(
      this.leave, this.startDate, this.endDate, this.reason, this.message);

  factory Employees.fromJson(Map<String, dynamic> json) {
    return Employees(
      json['leave_by_approved_status'].toString(),
      json['start_date'].toString(),
      json['end_date'].toString(),
      json['reason_type'].toString(),
      json['message'].toString(),
    );
  }
}

// ignore: must_be_immutable
class EmployeeListItemCard extends StatelessWidget {
  final Employees employee;
  String? profile_picture;

  EmployeeListItemCard({
    required this.employee,
    required this.profile_picture,
  });

  @override
  Widget build(BuildContext context) {
    String _prependBaseUrl(String url) {
      return '$url';
    }

    return Card(
      elevation: 1,
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: SizedBox(
        // height: 120,
        child: Row(
          children: [
            SizedBox(
              width: 120,
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.transparent,
                backgroundImage: profile_picture != null
                    ? NetworkImage('${URLConstants.baseUrl}/$profile_picture')
                    : null,
              ),
            ),
            Expanded(
              child: ListTile(
                title: Row(children: [
                  const Text(
                    'Status:',
                    style: TextStyle(
                        //
                        ),
                  ),
                  const SizedBox(width: 15),
                  Text(
                    '${employee.leave == 'true' ? 'Approved' : 'Rejected'}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ]),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'StartDate: ${employee.startDate}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text(
                      'EndDate: ${employee.endDate}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text(
                      'User Reason: ${employee.reason}',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    Text(
                      'Admin Reason: ${employee.message}',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
