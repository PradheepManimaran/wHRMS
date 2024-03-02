import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:wHRMS/ThemeColor/theme.dart';
import 'package:wHRMS/apiHandlar/baseUrl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EnrollStatusScreen extends StatefulWidget {
  const EnrollStatusScreen({super.key});

  @override
  State<EnrollStatusScreen> createState() => _EnrollStatusScreenState();
}

class EnrollStatus {
  final String id;
  final String name;

  EnrollStatus(this.id, this.name);
}

class _EnrollStatusScreenState extends State<EnrollStatusScreen> {
  // final Logger _logger = Logger();

  final List<EnrollStatus> enrollStatus = [];
  TextEditingController nameController = TextEditingController();
  List<String> enrollStatusData = [];
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _initAuthToken();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _initAuthToken() async {
    // String token = await getAuthToken() as String;
    _fetchEnrollStatus();

    _timer ??= Timer.periodic(const Duration(seconds: 1), (timer) {
      _fetchEnrollStatus();
    });
  }

  Future<String?> getAuthToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<void> _fetchEnrollStatus() async {
    const String roleApiUrl = '${URLConstants.baseUrl}/api/enrollment_status';

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token') ?? '';
      final response = await http.get(
        Uri.parse(roleApiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'token $token',
        },
      );

      if (response.statusCode == 200) {
        // _logger.d('EnrollStatus Status Code : ${response.statusCode}');
        // _logger.d('EnrollStatus fetched successfully');
        // _logger.d('EnrollStatus response Body: ${response.body}');

        final dynamic enrollData = json.decode(response.body);

        if (enrollData is List) {
          final List<EnrollStatus> statusList =
              enrollData.map<EnrollStatus>((roleData) {
            return EnrollStatus(roleData['id'].toString(), roleData['name']);
          }).toList();

          setState(() {
            enrollStatus.clear();
            enrollStatus.addAll(statusList);
          });
        } else {
          // print('Invalid EnrollStatus data format: $enrollData');
          _showSnackBar('Invalid EnrollStatus data format');
        }
      } else {
        // print(
        //     'Error fetching EnrollStatus. Status code: ${response.statusCode}');
        // print('EnrollStatus Response body: ${response.body}');
        // print('Token : $token');
      }
    } catch (e) {
      _handleError(e);
    }
  }

  Future<void> _fetchpostEnrollStatus() async {
    const String roleApiUrl = '${URLConstants.baseUrl}/api/enrollment_status';

    try {
      String? token = await getAuthToken();

      if (token == null) {
        // print('Token not found in shared preferences');
        return;
      }
      final name = nameController.text;
      final response = await http.post(
        Uri.parse(roleApiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'token $token',
        },
        body: json.encode({
          'name': name,
        }),
      );

      if (response.statusCode == 201) {
        // _logger.d('EnrollStatus Status Code : ${response.statusCode}');
        // _logger.d('EnrollStatus fetched successfully');

        // Parse the response body as a Map
        final Map<String, dynamic> responseBody = json.decode(response.body);

        // Check if the 'results' key exists and is not null
        if (responseBody.containsKey('results') &&
            responseBody['results'] != null) {
          // Extract the list of roles from 'results', including both id and name
          final List<Map<String, dynamic>> nameController =
              List<Map<String, dynamic>>.from(
            responseBody['results'].map(
                (role) => {'id': role['id'], 'name': role['name'].toString()}),
          );

          setState(() {
            nameController.clear();
            nameController.addAll(nameController);
          });
        }
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.green,
            content: Text('Enrollment status add Successfuly'),
            duration: Duration(seconds: 2),
          ),
        );
      } else if (response.statusCode == 400) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text('Bad Request'),
            duration: Duration(seconds: 2),
          ),
        );
        // print(
        //     'Post Error fetching EnrollStatus. Status code: ${response.statusCode}');
        // print('Post EnrollStatus Response body: ${response.body}');
      } else if (response.statusCode == 500) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text('Internal Server Error'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      _handleError(e);
    }
  }

  void _handleError(dynamic e) {
    // _logger.e('Error: $e');
    // print('Error: $e');
    if (e is SocketException) {
      _showSnackBar('No Internet Connection');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        action: SnackBarAction(
          label: 'OK',
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Enroll Status',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: ThemeColor.app_bar,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
            child: Column(
              children: [
                const SizedBox(height: 30),
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    // labelText: 'Department Name',
                    hintText: 'Enter EnrollStatus name',
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey,
                        width: 2.0,
                      ),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey,
                        width: 2.0,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(
                        width: 2.0,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    _fetchpostEnrollStatus();
                    await _initAuthToken();
                    final selectedenrollStatus = enrollStatus.firstWhere(
                      (en_Status) => en_Status.name == nameController,
                      orElse: () => EnrollStatus('', ''),
                    );
                    final roleId = selectedenrollStatus.id;
                    final roleName = selectedenrollStatus.name;

                    setState(() {
                      enrollStatusData
                          .add('Role ID: $roleId, Role Name: $roleName');
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                    elevation: 0,
                    side: const BorderSide(
                      color: Colors.black,
                    ),
                    fixedSize: const Size(200, 50),
                  ),
                  child: Ink(
                    decoration: BoxDecoration(
                      color: ThemeColor.app_bar,
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        'SUBMIT',
                        style: GoogleFonts.changa(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 600,
                  child: ListView.builder(
                    itemCount: enrollStatus.length,
                    itemBuilder: (BuildContext context, int index) {
                      final role = enrollStatus[index];
                      return ListTile(
                        title: Row(
                          children: [
                            Text(
                              role.id,
                              style: GoogleFonts.heebo(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(width: 15),
                            Text(
                              role.name,
                              style: GoogleFonts.heebo(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(width: 20),
                            GestureDetector(
                              onTap: () async {
                                Navigator.push(
                                  context,
                                  PageTransition(
                                    type: PageTransitionType.rightToLeft,
                                    duration: const Duration(milliseconds: 300),
                                    child: const EnrollStatusScreen(),
                                  ),
                                );
                              },
                              child: const Icon(
                                Icons.edit,
                                color: ThemeColor.app_bar,
                                size: 18,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}
