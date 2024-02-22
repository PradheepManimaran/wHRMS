import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:wHRMS/ThemeColor/theme.dart';
import 'package:wHRMS/View/home_screen.dart';
import 'package:wHRMS/apiHandlar/baseUrl.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({Key? key}) : super(key: key);

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  TextEditingController dateController = TextEditingController();
  TextEditingController checkinController = TextEditingController();
  TextEditingController statusController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final Logger _logger = Logger();

  static Future<String?> getAuthToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<void> _fetchAttendance(BuildContext context) async {
    const String apiUrlAttendance = '${URLConstants.baseUrl}/api/attendance';

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

      if (!_formKey.currentState!.validate()) {
        return;
      }

      Map<String, dynamic> requestBody = _buildRequestBody();

      final response = await http.post(
        Uri.parse(apiUrlAttendance),
        headers: headers,
        body: json.encode(requestBody),
      );

      if (response.statusCode == 201) {
        final employeeData = json.decode(response.body);
        _logger.d('Attendance successfully: $employeeData');

        // Handle success - navigate to home screen or show a success message
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.green,
            content: Text('Attendance added successfully.'),
          ),
        );
      } else if (response.statusCode == 400) {
        // Handle bad request error
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text('Error: Bad request. Please check your input.'),
          ),
        );
      } else if (response.statusCode >= 500) {
        // Handle server error
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text('Error: Server error. Please try again later.'),
          ),
        );
      } else {
        // Handle other errors
        print('Error: Unexpected status code ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      // Handle general errors
      _handleError(e);
    }
  }

  Map<String, String> _buildRequestBody() {
    return {
      'date': dateController.text,
      'check_in': checkinController.text,
      'status': statusController.text,
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

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                    'Attendance',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
                const SizedBox(height: 100),
                _buildTextFields(
                  hintText: 'Date',
                  controller: dateController,
                  prefixIconData: Icons.date_range_outlined,
                  fieldName: 'Date',
                  isDateField: true, // Set this to true for the date field
                ),
                const SizedBox(height: 20),
                _buildTextFieldss(
                  hintText: 'Check In',
                  controller: checkinController,
                  prefixIconData: Icons.timelapse,
                  fieldName: 'Check In',
                  isDateField: true,
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  hintText: 'Status',
                  controller: statusController,
                  prefixIconData: Icons.star_outline_sharp,
                  fieldName: 'Status',
                ),
                const SizedBox(height: 15),
                Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: 340.0,
                    height: 60.0,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _fetchAttendance(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(2.0),
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
                const SizedBox(height: 20),
                CalendarWidget(), // This will display the calendar below the Apply button
              ],
            ),
          ),
        ),
      ),
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

  Widget _buildTextFieldss({
    required TextEditingController controller,
    required String hintText,
    required IconData prefixIconData,
    required String fieldName,
    bool isDateField = false,
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
      onTap: () async {
        if (isDateField) {
          final DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2101),
          );
          if (pickedDate != null) {
            DateTime dateTime = DateTime(
              pickedDate.year,
              pickedDate.month,
              pickedDate.day,
              DateTime.now().hour,
              DateTime.now().minute,
            );
            String formattedDateTime =
                DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
            controller.text = formattedDateTime;
          }
        }
      },
    );
  }

  Widget _buildTextFields({
    required TextEditingController controller,
    required String hintText,
    required IconData prefixIconData,
    required String fieldName,
    bool isDateField = false,
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
      onTap: () async {
        if (isDateField) {
          final DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2101),
          );
          if (pickedDate != null && pickedDate != DateTime.now()) {
            String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
            controller.text = formattedDate;
          }
        }
      },
    );
  }
}

class CalendarWidget extends StatefulWidget {
  @override
  _CalendarWidgetState createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  late CalendarFormat _calendarFormat;
  late DateTime _focusedDay;
  late DateTime _selectedDay;
  List<Map<String, dynamic>> _attendanceData = [];

  @override
  void initState() {
    super.initState();
    _calendarFormat = CalendarFormat.month;
    _focusedDay = DateTime.now();
    _selectedDay = DateTime.now();
    _initializeAttendanceData();
    _fetchAttendance();
  }

  // Initialize default attendance data for the specified dates
  void _initializeAttendanceData() {
    _attendanceData = [
      {'date': DateTime(2024, 2, 10), 'status': 'present'},
      {'date': DateTime(2024, 2, 15), 'status': 'present'},
      {'date': DateTime(2024, 2, 18), 'status': 'present'},
    ];
  }

  static Future<String?> getAuthToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<void> _fetchAttendance() async {
    // Simulated API URL
    const String apiUrlAttendance = '${URLConstants.baseUrl}/api/attendance';

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
        Uri.parse(apiUrlAttendance),
        headers: headers,
      );

      if (response.statusCode == 200) {
        setState(() {
          _attendanceData = (json.decode(response.body) as List<dynamic>)
              .cast<Map<String, dynamic>>();
        });
        print('Attendance data: $_attendanceData');
        print('Response body: ${response.body}');
      } else {
        // Handle errors
        print('Error: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      // Handle general errors
      print('Error fetching attendance data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      firstDay: DateTime.utc(2020, 1, 1),
      lastDay: DateTime.utc(2030, 12, 31),
      focusedDay: _focusedDay,
      calendarFormat: _calendarFormat,
      selectedDayPredicate: (day) {
        return isSameDay(_selectedDay, day);
      },
      eventLoader: _getEventsForDay,
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _selectedDay = selectedDay;
          _focusedDay = focusedDay;
        });
      },
      calendarStyle: CalendarStyle(
        markersMaxCount: 1,
        markerDecoration: BoxDecoration(
          shape: BoxShape.circle,
        ),
        outsideDaysVisible: false, // Hide days outside the current month
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
        weekendStyle: TextStyle(color: Colors.red), // Weekends in red
      ),
    );
  }

  List<Widget> _getEventsForDay(DateTime day) {
    List<Widget> events = [];

    // Filter attendance data for the selected day
    final attendanceForDay = _attendanceData.firstWhere(
      (element) {
        // Ensure the date field is not null
        dynamic date = element['date'];
        if (date is String) {
          // Parse the date from String to DateTime
          DateTime parsedDate = DateTime.parse(date);
          return isSameDay(parsedDate, day);
        } else if (date is DateTime) {
          // Compare the date directly
          return isSameDay(date, day);
        } else {
          // Handle invalid date format
          return false;
        }
      },
      orElse: () => {},
    );

    // If there is attendance data for the selected day, display its status
    if (attendanceForDay != null) {
      String status = attendanceForDay['status'].toString().toLowerCase();
      Color markerColor = status == 'present' ? Colors.green : Colors.red;
      events.add(Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
          color: markerColor,
          shape: BoxShape.circle,
        ),
      ));
    }

    return events;
  }
}
