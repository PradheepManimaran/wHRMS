import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:wHRMS/ThemeColor/theme.dart';
import 'package:wHRMS/View/home_screen.dart';
import 'package:wHRMS/apiHandlar/baseUrl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApplyLeave extends StatefulWidget {
  const ApplyLeave({super.key});

  @override
  State<ApplyLeave> createState() => _ApplyLeaveState();
}

class _ApplyLeaveState extends State<ApplyLeave> {
  final Logger _logger = Logger();

  TextEditingController idController = TextEditingController();
  TextEditingController fromDateController = TextEditingController();
  TextEditingController toDateController = TextEditingController();
  TextEditingController leavetypeController = TextEditingController();
  TextEditingController leavereasonController = TextEditingController();
  // TextEditingController approveController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  static Future<String?> getAuthToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  @override
  void initState() {
    super.initState();
    // Fetch employee ID when the widget is initialized
    _fetchEmployeeId();
  }

  Future<void> _fetchEmployeeId() async {
    const String apiUrl = '${URLConstants.baseUrl}/api/user';

    try {
      String? token = await getAuthToken();

      if (token == null) {
        print('Token not found in shared preferences');
        return;
      }

      var headers = {
        'Authorization': 'token $token',
        'Content-Type': 'application/json',
      };

      final response = await http.get(
        Uri.parse(apiUrl),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final userData = json.decode(response.body);
        String employeeId = userData['employee_id'];
        idController.text =
            employeeId; // Set the fetched employee ID to the controller
      } else {
        print(
            'Error fetching employee ID. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching employee ID: $e');
    }
  }

  Future<void> _fetchApplyLeave(BuildContext context) async {
    const String apiUrl = '${URLConstants.baseUrl}/api/leave';

    try {
      String? token = await getAuthToken();

      if (token == null) {
        print('Token not found in shared preferences');
        return;
      }

      var headers = {
        'Authorization': 'token $token',
        'Content-Type': 'application/json', // Set content type to JSON
      };

      if (!_formKey.currentState!.validate()) {
        return;
      }

      // Calculate the difference between from and to dates
      DateTime from = DateTime.parse(fromDateController.text);
      DateTime to = DateTime.parse(toDateController.text);
      int daysDifference = to.difference(from).inDays;

      Map<String, String> requestBody = _buildRequestBody();

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: json.encode(requestBody), // Convert request body to JSON string
      );

      if (response.statusCode == 201) {
        final employeeData = json.decode(response.body);
        _logger.d('Apply Leave successfully: $employeeData');

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ),
        );
        // ignore: use_build_context_synchronously
        // _showSnackBar(context,
        //     'Employee Successfully apply leave for $daysDifference days. Thank you.');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            content: Text(
                'Employee Successfully apply leave for $daysDifference days. Thank you.'),
            duration: Duration(seconds: 2),
          ),
        );
      } else if (response.statusCode == 400) {
        print(
            'Error Leave apply employee. Status code: ${response.statusCode}');
        print('Register Response body: ${response.body}');
        _showSnackBar(context, 'Error: Bad request. Please check your input.');
      } else if (response.statusCode >= 500) {
        print(
            'Error Leave apply employee. Status code: ${response.statusCode}');
        print('Apply leave Response body: ${response.body}');
        _showSnackBar(context, 'Error: Server error. Please try again later.');
      } else {
        print(
            'Error Leave apply employee. Status code: ${response.statusCode}');
        print('Token : $token');
        print('Apply leave Response body: ${response.body}');
      }
    } catch (e) {
      _handleError(e);
    }
  }

  Map<String, String> _buildRequestBody() {
    return {
      'start_date': fromDateController.text,
      'end_date': toDateController.text,
      'reason': leavetypeController.text,
      'reason_type': leavereasonController.text,
      // 'approved': approveController.text,
    };
  }

  void _handleError(dynamic e) {
    _logger.e('Error: $e');
    print('Error: $e');
    if (e is SocketException) {
      _showSnackBar(context, 'No Internet Connection');
    }
  }

  void _showSnackBar(BuildContext context, String message) {
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

  int _durationDays = 0; // Add this variable to store the duration

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Apply Leave',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: ThemeColor.app_bar,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 8.0),
        child: SingleChildScrollView(
          child: Center(
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.disabled,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  const Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Apply Leave Form',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  const SizedBox(height: 100),
                  _buildTextFields(
                    controller: idController,
                    hintText: 'Employee ID',
                    prefixIconData: Icons.person,
                    fieldName: 'Employee ID',
                    enabled: false,
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    hintText: 'Leave Type',
                    controller: leavetypeController,
                    prefixIconData: Icons.leave_bags_at_home,
                    fieldName: 'Leave Type',
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildDateField('From Date', fromDateController),
                      _buildDateField('To Date', toDateController),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // _buildLeaveReasonField(),
                  _buildTextField(
                    hintText: 'Leave Reason',
                    controller: leavereasonController,
                    prefixIconData: Icons.time_to_leave,
                    fieldName: 'Leave Reason',
                  ),
                  // const SizedBox(height: 20),
                  const SizedBox(height: 15),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Duration: $_durationDays days',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: 340.0,
                      height: 60.0,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _fetchApplyLeave(context);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6.0),
                          ),
                          backgroundColor: ThemeColor.btn_color,
                        ),
                        child: const Text(
                          'APPLY',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      backgroundColor: ThemeColor.log_background,
    );
  }

  Widget _buildTextFields({
    required TextEditingController controller,
    required String hintText,
    required IconData prefixIconData,
    required String fieldName,
    bool enabled = true,
  }) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      decoration: InputDecoration(
        hintText: hintText,
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
        prefixIcon: Icon(prefixIconData),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(
            color: Colors.grey,
            width: 2.0,
          ),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $fieldName';
        }
        return null;
      },
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData prefixIconData,
    required String fieldName,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
        prefixIcon: Icon(prefixIconData),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(
            color: Colors.grey,
            width: 2.0,
          ),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $fieldName';
        }
        return null;
      },
    );
  }

  // Widget _buildLeaveReasonField() {
  //   return SizedBox(
  //     width: double.infinity,
  //     child: TextFormField(
  //       // controller: approveController,
  //       maxLines: null,
  //       validator: (value) {
  //         if (value == null || value.isEmpty) {
  //           return 'Please enter the reason for leave';
  //         }
  //         return null;
  //       },
  //       decoration: InputDecoration(
  //         prefix: Padding(
  //           padding: const EdgeInsets.symmetric(horizontal: 4.0),
  //           child: SizedBox(
  //             width: 5,
  //             child: Container(
  //               color: Colors.black,
  //             ),
  //           ),
  //         ),
  //         hintText: 'Reason',
  //         enabledBorder: const OutlineInputBorder(
  //           borderSide: BorderSide(color: Colors.grey),
  //         ),
  //         focusedBorder: const OutlineInputBorder(
  //           borderSide: BorderSide(color: Colors.grey),
  //         ),
  //         hintStyle: const TextStyle(
  //           fontSize: 15,
  //           fontWeight: FontWeight.bold,
  //         ),
  //         border: const OutlineInputBorder(),
  //         filled: true,
  //         fillColor: ThemeColor.TextFieldColor,
  //       ),
  //     ),
  //   );
  // }

  Widget _buildDateField(String hintText, TextEditingController controller) {
    return SizedBox(
      width: 150,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: controller,
            readOnly: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select a date';
              }
              return null;
            },
            decoration: InputDecoration(
              prefixIcon: const Icon(
                Icons.date_range,
              ),
              hintText: hintText,
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              labelStyle: const TextStyle(fontSize: 10),
              border: const OutlineInputBorder(),
              filled: true,
              fillColor: ThemeColor.TextFieldColor,
            ),
            onTap: () async {
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime(2101),
              );

              if (pickedDate != null) {
                String formattedDate =
                    DateFormat('yyyy-MM-dd').format(pickedDate);
                controller.text = formattedDate;

                // Calculate duration when date changes
                if (hintText == 'To Date') {
                  if (fromDateController.text.isNotEmpty) {
                    setState(() {
                      // Update the state to trigger a rebuild
                      _durationDays = _calculateDuration(
                        fromDateController.text,
                        controller.text,
                      );
                    });
                  }
                }
              }
            },
          ),
          // const SizedBox(height: 4),
          // if (hintText == 'To Date' && fromDateController.text.isNotEmpty)
          //   Text(
          //     'Duration: $_durationDays days',
          //     style: TextStyle(
          //       fontSize: 12,
          //       color: Colors.grey[600],
          //     ),
          //   ),
        ],
      ),
    );
  }

  int _calculateDuration(String from, String to) {
    try {
      DateTime fromDate = DateTime.parse(from);
      DateTime toDate = DateTime.parse(to);
      return toDate.difference(fromDate).inDays + 1;
    } catch (e) {
      print('Error parsing dates: $e');
      return 0;
    }
  }
}
