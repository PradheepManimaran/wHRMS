import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:wHRMS/ThemeColor/theme.dart';
import 'package:wHRMS/apiHandlar/baseUrl.dart';
import 'package:wHRMS/objects/dash_obj.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:wHRMS/objects/personal.dart';
import 'package:wHRMS/objects/profile_field.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late DateTime _focusedDay = DateTime.now();
  final CalendarFormat _calendarFormat = CalendarFormat.month;
  // final Logger _logger = Logger();
  DateTime? _selectedDay;

  List<Employe> daage = [];
  List<EmployeeName> employee = [];
  List<EventData> eventData = [];

  String? _newEventTitle;
  String? _newEventDescription;

  DateTime? _newEventDate;
  TimeOfDay? _newEventTime;

  @override
  void initState() {
    super.initState();

    _fetchEvents();
    _fetchEmployeeProfile();
  }

  Future<void> _fetchEmployeeProfile() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token') ?? '';

      final response = await http.get(
        Uri.parse('${URLConstants.baseUrl}/api/employee'),
        headers: {
          'Authorization': 'token $token',
          'Content-Type': 'application/json',
        },
      );

      // _logger.d('Employee Status Code : ${response.statusCode}');
      // _logger.d('Testing Employee Body : ${response.body}');

      if (response.statusCode == 200) {
        final dynamic data = jsonDecode(response.body);

        if (data is List) {
          setState(() {
            employee = data.map((item) => EmployeeName.fromJson(item)).toList();
            daage = data.map((item) => Employe.fromJson(item)).toList();
          });
        } else if (data is Map<String, dynamic>) {
          // Single employee case
          setState(() {
            employee = [EmployeeName.fromJson(data)];
            daage = [Employe.fromJson(data)];
          });
        } else {
          // if (kDebugMode) {
          //   print('Unexpected response format');
          // }
        }
      } else {
        // if (kDebugMode) {
        //   print(
        //       'Failed to load Employee data. Status code: ${response.statusCode}');
        // }
        // if (kDebugMode) {
        //   print('Response body: ${response.body}');
        // }
      }
    } catch (e) {
      // if (kDebugMode) {
      //   print('Error loading employee data: $e');
      // }
    }
  }

  Future<void> _fetchEvents() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token') ?? '';

      final response = await http.get(
        Uri.parse('${URLConstants.baseUrl}/api/events'),
        headers: <String, String>{
          'Authorization': 'token $token',
        },
      );

      if (response.statusCode == 200) {
        // Parse the response body and update the eventData list
        setState(() {
          eventData = parseEvents(response.body);
        });
        // if (kDebugMode) {
        //   print('Failed to fetch events. Status code: ${response.statusCode}');
        // }
        // if (kDebugMode) {
        //   print('Failed to fetch events. Body: ${response.body}');
        // }
      } else if (response.statusCode == 400) {
        // Handle the error accordingly
        // if (kDebugMode) {
        //   print('Failed to fetch events. Status code: ${response.statusCode}');
        // }
      } else if (response.statusCode == 500) {
        // if (kDebugMode) {
        //   print('Failed to fetch events. Status code: ${response.statusCode}');
        // }
        // if (kDebugMode) {
        //   print('Failed to fetch events. Body: ${response.body}');
        // }
      }
    } catch (e) {
      // Exception occurred
      // if (kDebugMode) {
      //   print('Exception while fetching events: $e');
      // }
      // Handle the exception accordingly
    }
  }

  List<EventData> parseEvents(String responseBody) {
    // Parse the JSON response and convert it to a list of EventData objects
    List<dynamic> jsonData = jsonDecode(responseBody);
    List<EventData> events = [];
    DateTime currentDate = DateTime.now();

    for (var item in jsonData) {
      DateTime eventDate = DateTime.parse(item['date']);
      events.add(
        EventData(
          title: item['title'],
          description: item['description'],
          date: eventDate,
        ),
      );
    }

    // Filter events to include today's and future events
    List<EventData> filteredEvents = events.where((event) {
      return event.date.isAfter(currentDate) ||
          isSameDay(event.date, currentDate);
    }).toList();

    // Sort events based on their dates
    filteredEvents.sort((a, b) => a.date.compareTo(b.date));

    return filteredEvents;
  }

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: ThemeColor.card_color,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                const Text(
                  'Welcome,',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(width: 5),
                Text(
                  employee.isNotEmpty ? employee[0].firstname : '',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.left,
                ),
              ],
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildCard('Title 1', '55'),
                // const SizedBox(width: 5),
                _buildCard('Total Leave', '5 days'),
                // const SizedBox(width: 5),
                _buildCard('Title 2', '55'),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Events',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: _buildEventCard(eventData: eventData),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Divider(thickness: 0.5),
            TableCalendar(
              firstDay: DateTime.utc(2024, 1, 1),
              lastDay: DateTime.utc(3000, 12, 31),
              focusedDay: _focusedDay,
              calendarFormat: _calendarFormat,
              selectedDayPredicate: (day) {
                return _selectedDay != null
                    ? isSameDay(_selectedDay!, day)
                    : false;
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                  _showEventInput();
                });
              },
              calendarStyle: CalendarStyle(
                todayDecoration: const BoxDecoration(
                  color: Colors.blueAccent,
                  shape: BoxShape.circle,
                ),
                selectedDecoration: const BoxDecoration(
                  color: Color.fromARGB(255, 166, 61, 96),
                  shape: BoxShape.circle,
                ),
                defaultDecoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white,
                    width: 5.0,
                  ),
                  shape: BoxShape.circle,
                ),
              ),
              headerStyle: const HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _showEventInput() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Event'),
          content: SizedBox(
            height: 250,
            child: Column(
              children: [
                TextField(
                  decoration: const InputDecoration(labelText: 'Event Name'),
                  onChanged: (value) {
                    _newEventTitle = value;
                  },
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'Description'),
                  onChanged: (value) {
                    _newEventDescription = value;
                  },
                ),
                Row(
                  children: [
                    Text('Date: ${DateFormat.yMMMd().format(_selectedDay!)}'),
                    IconButton(
                      icon: const Icon(Icons.calendar_today),
                      onPressed: () => _selectDate(context),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text('Time: ${_newEventTime?.format(context) ?? ''}'),
                    IconButton(
                      icon: const Icon(Icons.access_time),
                      onPressed: () => _selectTime(context),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (_newEventTitle != null &&
                    _newEventDate != null &&
                    _newEventTime != null) {
                  _addNewEvent(
                    _newEventTitle!,
                    _newEventDescription!,
                    _newEventDate!,
                    _newEventTime!,
                  );

                  // Add the new event to eventData list and update UI
                  // setState(() {
                  //   eventData.add(
                  //     EventData(
                  //       title: _newEventTitle!,
                  //       description: _newEventDescription!,
                  //       date: _newEventDate!,
                  //     ),
                  //   );
                  // });
                }
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDay ?? DateTime.now(),
      firstDate: DateTime.utc(1900, 12, 31),
      lastDate: DateTime.utc(3000, 12, 31),
    );

    if (pickedDate != null && pickedDate != _selectedDay) {
      setState(() {
        _newEventDate = pickedDate;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _newEventTime ?? TimeOfDay.now(),
    );

    if (pickedTime != null && pickedTime != _newEventTime) {
      setState(() {
        _newEventTime = pickedTime;
      });
    }
  }

  Widget _buildEventCard({required List<EventData> eventData}) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: eventData.isEmpty
          ? Container(
              // Render a default card when no data is available
              height: 80,
              width: 200,
              decoration: BoxDecoration(
                color: ThemeColor.card_color,
                borderRadius: BorderRadius.circular(7),
              ),
              child: const Center(
                child: Text(
                  '',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
            )
          : Row(
              children: List.generate(
                eventData.length,
                (index) {
                  final event = eventData[index];
                  return Padding(
                    padding: const EdgeInsets.all(1.0),
                    // child: Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: ThemeColor.card_color,
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 5),
                          Text(
                            event.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            event.description,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 10, width: 10.0),
                          Text(
                            'Date: ${DateFormat.yMMMd().format(event.date)}',
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 5),
                        ],
                      ),
                    ),
                    // ),
                  );
                },
              ),
            ),
    );
  }

  Widget _buildCard(String title, String value) {
    // return Expanded(
    return Container(
      width: 100,
      height: 60,
      // margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: ThemeColor.card_color,
        borderRadius: BorderRadius.circular(7),
      ),
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 5),
          Align(
            alignment: Alignment.center,
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      // ),
    );
  }

  void _addNewEvent(
    String title,
    String description,
    DateTime? date,
    TimeOfDay time,
  ) async {
    try {
      // Check the user's role here
      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool isSuperUser = prefs.getBool('is_superuser') ?? false;

      if (!isSuperUser) {
        // If the user is not a superuser, throw an error indicating they are not authorized to add events
        throw Exception('Only superusers are authorized to add events.');
      }

      // Convert TimeOfDay to DateTime
      DateTime eventDateTime = DateTime(
        date!.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );

      // Prepare the request body
      Map<String, dynamic> requestBody = {
        "title": title,
        "date": DateFormat('yyyy-MM-dd').format(eventDateTime),
        "description": description,
      };

      // Make the POST request
      String token = prefs.getString('token') ?? '';

      final response = await http.post(
        Uri.parse('${URLConstants.baseUrl}/api/events'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'token $token',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 201) {
        // Event added successfully
        // if (kDebugMode) {
        //   print('Event added successfully');
        // }
        // Update your local data or UI if necessary
        setState(() {
          eventData.add(
            EventData(
              title: title,
              description: description,
              date: eventDateTime,
              // time: time,
            ),
          );
        });
        // if (kDebugMode) {
        //   print('Successfully add event. Status code: ${response.statusCode}');
        // }
        // if (kDebugMode) {
        //   print('Success Response Body: ${response.body}');
        // }
      } else if (response.statusCode == 400) {
        // Error occurred while adding the event
        // if (kDebugMode) {
        //   print('Failed to add event. Status code: ${response.statusCode}');
        // }
        // if (kDebugMode) {
        //   print('Error Response Body: ${response.body}');
        // }
        // Handle the error accordingly
      } else if (response.statusCode == 500) {
        // Error occurred while adding the event
        // if (kDebugMode) {
        //   print('Failed to add event. Status code: ${response.statusCode}');
        // }
        // if (kDebugMode) {
        //   print('Error Response Body: ${response.body}');
        // }
        // Handle the error accordingly
      }
    } catch (e) {
      // Exception occurred
      // if (kDebugMode) {
      //   print('Exception while adding event: $e');
      // }
      // Handle the exception accordingly
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text('Error: $e'),
          duration: const Duration(seconds: 5),
        ),
      );
    }
  }
}
