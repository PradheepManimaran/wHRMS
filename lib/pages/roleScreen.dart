import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:wHRMS/ThemeColor/theme.dart';
import 'package:wHRMS/apiHandlar/baseUrl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Role {
  final String id;
  final String name;

  Role(this.id, this.name);
}

class RoleScreen extends StatefulWidget {
  const RoleScreen({Key? key}) : super(key: key);

  @override
  State<RoleScreen> createState() => _RoleScreenState();
}

class _RoleScreenState extends State<RoleScreen> {
  // final Logger _logger = Logger();

  final List<Role> roleside = [];
  TextEditingController nameController = TextEditingController();
  List<String> roleData = [];
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    // _initAuthToken();

    _initAuthToken();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _initAuthToken() async {
    // String token = await getAuthToken() as String;
    _fetchRole();

    _timer ??= Timer.periodic(const Duration(seconds: 1), (timer) {
      _fetchRole();
    });
  }

  Future<String?> getAuthToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<void> _fetchRole() async {
    const String roleApiUrl = '${URLConstants.baseUrl}/api/role';

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
        // _logger.d('Roles Status Code : ${response.statusCode}');
        // _logger.d('Roles fetched successfully');
        // _logger.d('Roles response Body: ${response.body}');

        final dynamic enrollData = json.decode(response.body);

        if (enrollData is List) {
          final List<Role> rolesList = enrollData.map<Role>((roleData) {
            return Role(roleData['id'].toString(), roleData['name']);
          }).toList();

          setState(() {
            roleside.clear();
            roleside.addAll(rolesList);
          });
        } else {
          // if (kDebugMode) {
          //   print('Invalid Roles data format: $enrollData');
          // }
          _showSnackBar('Invalid Roles data format');
        }
      } else {
        // if (kDebugMode) {
        //   print('Error fetching Roles. Status code: ${response.statusCode}');
        // }
        // if (kDebugMode) {
        //   print('Roles Response body: ${response.body}');
        // }
        // if (kDebugMode) {
        //   print('Token : $token');
        // }
      }
    } catch (e) {
      _handleError(e);
    }
  }

  Future<void> _fetchpostRole() async {
    const String roleApiUrl = '${URLConstants.baseUrl}/api/role';

    try {
      String? token = await getAuthToken();

      if (token == null) {
        // if (kDebugMode) {
        //   print('Token not found in shared preferences');
        // }
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
        // _logger.d('Roles Status Code : ${response.statusCode}');
        // _logger.d('Roles fetched successfully');

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
            content: Text('Role add Successfully'),
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        // Handle HTTP errors 400, 401, 500

        if (response.statusCode == 401) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.red,
              content: Text('Invalid Token'),
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
        } else if (response.statusCode == 500) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.red,
              content: Text('Internal Server Error'),
              duration: Duration(seconds: 2),
            ),
          );
        } else {
          //   ScaffoldMessenger.of(context).showSnackBar(
          //   const SnackBar(
          //     backgroundColor: Colors.green,
          //     content: Text('Error fetching Roles. Status code: ${response.statusCode}'),
          //     duration: Duration(seconds: 2),
          //   ),
          // );
        }

        // if (kDebugMode) {
        //   print(
        //       'Post Error fetching Roles. Status code: ${response.statusCode}');
        // }
        // if (kDebugMode) {
        //   print('Post Roles Response body: ${response.body}');
        // }
      }
    } catch (e) {
      _handleError(e);
    }
  }

  void _handleError(dynamic e) {
    // _logger.e('Error: $e');
    // if (kDebugMode) {
    //   print('Error: $e');
    // }
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
          'Role',
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
                    hintText: 'Enter Role name',
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
                    _fetchpostRole();
                    await _initAuthToken();
                    final selectedRole = roleside.firstWhere(
                      (role) => role.name == nameController,
                      orElse: () => Role('', ''),
                    );
                    final roleId = selectedRole.id;
                    final roleName = selectedRole.name;

                    setState(() {
                      roleData.add('$roleId,$roleName');
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
                    itemCount: roleside.length,
                    itemBuilder: (BuildContext context, int index) {
                      final role = roleside[index];
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
                                    child: const RoleScreen(),
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
      backgroundColor: ThemeColor.log_background,
    );
  }
}
