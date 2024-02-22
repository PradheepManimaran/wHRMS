import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:wHRMS/ThemeColor/theme.dart';
import 'package:wHRMS/View/home_screen.dart';
import 'package:wHRMS/apiHandlar/baseUrl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

class AdminLeaveListScreen extends StatefulWidget {
  const AdminLeaveListScreen({super.key});

  @override
  State<AdminLeaveListScreen> createState() => _AdminLeaveListScreenState();
}

class _AdminLeaveListScreenState extends State<AdminLeaveListScreen> {
  List<Employees> employee = [];
  List<ImageEmployee> image = [];

  final Logger _logger = Logger();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchLeaveList();
    _fetchEmployees();
  }

  @override
  void dispose() {
    super.dispose();
    // Dispose any resources here if needed
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
        final List<dynamic> jsonData = jsonDecode(response.body);
        List<ImageEmployee> fetchedEmployees = [];
        for (var item in jsonData) {
          fetchedEmployees.add(ImageEmployee.fromJson(item));
        }
        setState(() {
          image = fetchedEmployees;
          isLoading = false;
        });
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

  Future<void> _fetchLeaveList() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token') ?? '';

      final response = await http.get(
        Uri.parse('${URLConstants.baseUrl}/api/approved_leave'),
        headers: {
          'Authorization': 'token $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final dynamic data = jsonDecode(response.body);

        if (mounted) {
          // Check if the widget is still mounted before calling setState
          setState(() {
            List<Employees> fetchedEmployees = [];
            for (var item in data) {
              fetchedEmployees.add(Employees.fromJson(item));
            }
            employee = fetchedEmployees;
            isLoading = false;
          });
        }
        print('Leave Response body: ${response.body}');
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
            const Row(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Leaves',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
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
                            i < min(employee.length, image.length);
                            i++)
                          EmployeeListItemCard(
                            employee: employee[i],
                            image: image[i],
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
  final int tableId;
  final String name;
  final String leave;
  final String startDate;
  final String endDate;
  final String reason;
  final String message;
  final String userID;

  Employees({
    required this.tableId,
    required this.name,
    required this.leave,
    required this.startDate,
    required this.endDate,
    required this.reason,
    required this.message,
    required this.userID,
  });

  factory Employees.fromJson(Map<String, dynamic> json) {
    int tableId = json['id'] != null ? json['id'] as int : 0;
    return Employees(
      tableId: tableId,
      name: json['user_username'].toString(),
      leave: json['approved'].toString(),
      startDate: json['start_date'].toString(),
      endDate: json['end_date'].toString(),
      reason: json['reason_type'].toString(),
      message: json['message'].toString(),
      userID: json['user'].toString(),
    );
  }
}

class ImageEmployee {
  final List<UserProfilePicture> userProfilePicture;
  ImageEmployee({
    required this.userProfilePicture,
  });
  factory ImageEmployee.fromJson(Map<String, dynamic> json) {
    return ImageEmployee(
      userProfilePicture: json['user_profile_picture'] != null
          ? List<UserProfilePicture>.from(json['user_profile_picture']
              .map((x) => UserProfilePicture.fromJson(x)))
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

class EmployeeListItemCard extends StatefulWidget {
  final Employees employee;
  final ImageEmployee image;

  const EmployeeListItemCard({
    required this.employee,
    required this.image,
  });

  @override
  _EmployeeListItemCardState createState() => _EmployeeListItemCardState();
}

class _EmployeeListItemCardState extends State<EmployeeListItemCard> {
  String _prependBaseUrl(String url) {
    return '$url';
  }

  Future<void> _updateLeaveStatus(
      bool isApproved, int tableId, String rejectionReason) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? '';

    try {
      final response = await http.put(
        Uri.parse('${URLConstants.baseUrl}/api/approved_leave'),
        headers: {
          'Authorization': 'token $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'approved': isApproved,
          'table_id': tableId,
          'message': rejectionReason,
        }),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
      );

      if (response.statusCode == 200) {
        print('Leave status updated successfully');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.green,
            content: Text('Leave approved Successfully.'),
            duration: Duration(seconds: 2),
          ),
        );
        setState(() {});
        print('Response body: ${response.body}');
      } else {
        print(
            'Failed to update leave status. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        print('Table ID: $tableId');
        print('Reaject Reason: $rejectionReason');
      }
    } catch (e) {
      print('Error updating leave status: $e');
    }
  }

  Future<void> _showRejectionReasonDialog(
      BuildContext context, int tableId) async {
    String rejectionReason = ''; // Store the rejection reason

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter Rejection Reason'),
          content: TextField(
            onChanged: (value) {
              rejectionReason =
                  value; // Update the rejection reason as the user types
            },
            decoration: InputDecoration(
              hintText: 'Enter reason...',
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Submit'),
              onPressed: () {
                if (rejectionReason.isNotEmpty) {
                  print('Rejection Reason: $rejectionReason'); // Debugging
                  Navigator.of(context).pop(); // Close the dialog
                  _updateLeaveStatus(false, tableId,
                      rejectionReason); // Call method to update leave status with rejection reason
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      backgroundColor: Colors.red,
                      content: Text('Please enter a rejection reason.'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    print('Testing User ID: ${widget.employee.userID}');
    print('Testing Table ID: ${widget.employee.tableId}');
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageTransition(
            type: PageTransitionType.rightToLeft,
            duration: const Duration(milliseconds: 200),
            child: Column(
                //
                ),
          ),
        );
      },
      child: Card(
        elevation: 1,
        margin: const EdgeInsets.symmetric(vertical: 5),
        child: Column(
          children: [
            SizedBox(
              child: Row(
                children: [
                  SizedBox(
                    width: 120,
                    child: CircleAvatar(
                      backgroundColor: Colors.blue,
                      radius: 40,
                      backgroundImage:
                          widget.image.userProfilePicture.isNotEmpty
                              ? NetworkImage(_prependBaseUrl(widget
                                  .image.userProfilePicture[0].profilePicture))
                              : null,
                    ),
                  ),
                  Expanded(
                    child: ListTile(
                      title: Row(
                        children: [
                          const Text(
                            'Name:',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 15),
                          Text(
                            '${widget.employee.name}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'StartDate: ${widget.employee.startDate}',
                            style: const TextStyle(fontSize: 16),
                          ),
                          Text(
                            'EndDate: ${widget.employee.endDate}',
                            style: const TextStyle(fontSize: 16),
                          ),
                          Text(
                            'Reason: ${widget.employee.reason}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            'Message: ${widget.employee.message}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                // const SizedBox(width: 20),
                Align(
                  alignment: Alignment.centerLeft,
                  child: SizedBox(
                    width: 150.0,
                    height: 30.0,
                    child: ElevatedButton(
                      onPressed: () {
                        _updateLeaveStatus(true, widget.employee.tableId, '');
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6.0),
                        ),
                        backgroundColor: ThemeColor.btn_color,
                      ),
                      child: const Text(
                        'Approve',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Align(
                  alignment: Alignment.centerRight,
                  child: SizedBox(
                    width: 150.0,
                    height: 30.0,
                    child: ElevatedButton(
                      onPressed: () {
                        _showRejectionReasonDialog(
                            context, widget.employee.tableId);
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6.0),
                        ),
                        backgroundColor: Colors.red,
                      ),
                      child: const Text(
                        'Reject',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
