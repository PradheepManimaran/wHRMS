import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:wHRMS/ThemeColor/theme.dart';
import 'package:wHRMS/apiHandlar/baseUrl.dart';
import 'package:wHRMS/pages/textwidget.dart';

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

  // final Logger _logger = Logger();

  static Future<String?> getAuthToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<void> _fetchAttendance(BuildContext context) async {
    const String apiUrlAttendance = '${URLConstants.baseUrl}/api/attendance';

    try {
      String? token = await getAuthToken();

      // if (token == null) {
      //   print('Token not found in shared preferences');
      //   return;
      // }

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
        // final employeeData = json.decode(response.body);
        // print('Attendance successfully: $employeeData');

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
        // if (kDebugMode) {
        //   print('Error: Unexpected status code ${response.statusCode}');
        // }
        // if (kDebugMode) {
        //   print('Response body: ${response.body}');
        // }
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
    // _logger.e('Error: $e');
    // if (kDebugMode) {
    //   print('Error: $e');
    // }
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
                const SizedBox(height: 10),
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
                const SizedBox(height: 15),
                TextWidget.buildTextFields(
                  hintText: 'Date',
                  controller: dateController,
                  prefixIconData: Icons.date_range_outlined,
                  fieldName: 'Date',
                  isDateField: true,
                  context: context,
                ),
                const SizedBox(height: 20),
                TextWidget.buildTextFieldss(
                  hintText: 'Check In',
                  controller: checkinController,
                  prefixIconData: Icons.timelapse,
                  fieldName: 'Check In',
                  isDateField: true,
                  context: context,
                ),
                const SizedBox(height: 20),
                TextWidget.buildTextField(
                  hintText: 'Status',
                  controller: statusController,
                  prefixIconData: Icons.star_outline_sharp,
                  fieldName: 'Status',
                ),
                const SizedBox(height: 15),
                Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: double.infinity,
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
                CalendarWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CalendarWidget extends StatefulWidget {
  @override
  _CalendarWidgetState createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  late List<Appointment> _appointments = [];
  // final Logger _logger = Logger();
  Timer? _timer;
  // late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    // _selectedDate = DateTime.now();
    // _fetchAppointments();
    _timer ??= Timer.periodic(const Duration(seconds: 1), (timer) {
      _fetchAppointments();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  static Future<String?> getAuthToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<void> _fetchAppointments() async {
    const apiUrl = '${URLConstants.baseUrl}/api/attendance';

    try {
      String? token = await getAuthToken();
      var headers = {
        'Authorization': 'token $token',
        'Content-Type': 'application/json',
      };
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: headers,
      );

      // _logger.d('Response status code: ${response.statusCode}');
      // _logger.d('Response body: ${response.body}');
      if (response.statusCode == 200) {
        final dynamic responseData = json.decode(response.body);
        if (responseData != null && responseData is List<dynamic>) {
          setState(() {
            _appointments = _parseAppointments(responseData);
          });
        } else {
          // if (kDebugMode) {
          //   print('Response data is not in the expected format');
          // }
        }
      } else if (response.statusCode == 400) {
        // if (kDebugMode) {
        //   print('Failed to fetch Attendance');
        // }
        // if (kDebugMode) {
        //   print('Error Status Code: ${response.statusCode}');
        // }
        // if (kDebugMode) {
        //   print('Failed to fetch Attendance: ${response.body}');
        // }
      } else if (response.statusCode == 500) {
        // if (kDebugMode) {
        //   print('Failed to fetch Attendance');
        // }
        // if (kDebugMode) {
        //   print('Error Status Code: ${response.statusCode}');
        // }
        // if (kDebugMode) {
        //   print('Failed to fetch Attendance: ${response.body}');
        // }
      }
    } catch (e) {
      // if (kDebugMode) {
      //   print('Error fetching Attendance: $e');
      // }
      // Handle error
    }
  }

  List<Appointment> _parseAppointments(List<dynamic> responseData) {
    // Map the response data to Appointment objects
    return responseData.map((data) {
      DateTime startTime = data['check_in'] != null
          ? DateTime.parse(data['check_in'])
          : DateTime.now();
      Color color = _getColorForStatus(data['status']);
      return Appointment(
        startTime: startTime,
        endTime: startTime.add(const Duration(hours: 1)),
        subject: data['status'] ?? 'No status',
        color: color, // Set color based on status
      );
    }).toList();
  }

  Color _getColorForStatus(String? status) {
    switch (status) {
      case 'present':
        return Colors.green;
      case 'absent':
        return Colors.red;
      default:
        return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SfCalendar(
      view: CalendarView.month,
      dataSource: _getCalendarDataSource(),
      onTap: (CalendarTapDetails details) {
        if (details.targetElement == CalendarElement.calendarCell) {
          setState(() {
            //
          });
        }
      },
      monthCellBuilder: (BuildContext context, MonthCellDetails details) {
        bool hasAppointments = _hasAppointments(details.date);

        // Get color for the date
        Color cellColor = hasAppointments
            ? _getAppointmentColorForDate(details.date)
            : Colors.white;

        // Check if the day is Sunday
        if (details.date.weekday == DateTime.sunday) {
          cellColor = Colors.blue;
        }

        return DecoratedBox(
          decoration: BoxDecoration(
            color: cellColor,
            border: Border.all(color: Colors.grey.withOpacity(0.3)),
          ),
          child: Center(
            child: Text(
              '${details.date.day}',
              style: const TextStyle(color: Colors.black),
            ),
          ),
        );
      },
      backgroundColor: Colors.grey.withOpacity(0.5),
      cellBorderColor: Colors.yellow,
    );
  }

  bool _hasAppointments(DateTime date) {
    return _appointments.any((appointment) =>
        appointment.startTime.year == date.year &&
        appointment.startTime.month == date.month &&
        appointment.startTime.day == date.day);
  }

  Color _getAppointmentColorForDate(DateTime date) {
    // Find appointments for the date
    var appointmentsForDate = _appointments.where((appointment) =>
        appointment.startTime.year == date.year &&
        appointment.startTime.month == date.month &&
        appointment.startTime.day == date.day);

    return appointmentsForDate.isNotEmpty
        ? appointmentsForDate.first.color
        : Colors.black;
  }

  _DataSource _getCalendarDataSource() {
    return _DataSource(_appointments);
  }
}

class _DataSource extends CalendarDataSource {
  _DataSource(List<Appointment> source) {
    appointments = source;
  }
}
