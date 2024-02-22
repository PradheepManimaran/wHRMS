// import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:table_calendar/table_calendar.dart';

class Task {
  String title;
  DateTime dateTime;

  Task({required this.title, required this.dateTime});
}

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late CalendarFormat _calendarFormat;
  late DateTime _focusedDay;
  late DateTime _selectedDay;
  late Map<DateTime, List<Task>> _events;

  late DateTime firstDay;
  late DateTime lastDay;

  @override
  void initState() {
    super.initState();
    _calendarFormat = CalendarFormat.month;
    _selectedDay = DateTime.now();
    _events = {};

    firstDay = DateTime.utc(2024, 1, 1);
    lastDay = DateTime.utc(2025, 12, 31);

    _focusedDay = DateTime.now();

    _focusedDay = _focusedDay.isBefore(firstDay) ? firstDay : _focusedDay;
    _focusedDay = _focusedDay.isAfter(lastDay) ? lastDay : _focusedDay;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Task Calendar',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.navigate_next_sharp),
            onPressed: () {
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: ((context) => const TaskListScreen())));
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 8.0),
        child: ListView(
          shrinkWrap: true,
          children: [
            TableCalendar(
              calendarFormat: _calendarFormat,
              focusedDay: _focusedDay,
              firstDay: firstDay,
              lastDay: lastDay,
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              eventLoader: (day) {
                return _events[day] ?? [];
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
                _showEventNames(selectedDay);
              },
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
              },
              onFormatChanged: (format) {
                setState(() {
                  _calendarFormat = format;
                });
                if (kDebugMode) {
                  print('Format changed to: $format');
                }
              },
              calendarStyle: const CalendarStyle(
                outsideDaysVisible: false,
                weekendTextStyle: TextStyle(color: Colors.red),
                holidayTextStyle: TextStyle(color: Colors.yellow),
                defaultTextStyle: TextStyle(color: Colors.black),
                todayTextStyle: TextStyle(color: Colors.white),
                selectedTextStyle: TextStyle(color: Colors.white),
                todayDecoration: BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                ),
                selectedDecoration: BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
              child: ListView(
                shrinkWrap: true,
                children: _buildTaskWidgets(),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTask,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showEventNames(DateTime selectedDay) {
    if (_events.containsKey(selectedDay)) {
      final List<Task> events = _events[selectedDay]!;
      String eventNames = '';

      for (final event in events) {
        eventNames += '${event.title}\n';
      }

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Events on ${DateFormat.yMMMd().format(selectedDay)}'),
            content: Text(eventNames),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Close'),
              ),
            ],
          );
        },
      );
    }
  }

  void _addTask() {
    DateTime selectedTime = DateTime.now();
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    String title = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Task'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Task'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a task';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    title = value!;
                  },
                ),
                const SizedBox(height: 10),
                InkWell(
                  onTap: () async {
                    final TimeOfDay? picked = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.fromDateTime(selectedTime),
                    );
                    if (picked != null) {
                      setState(() {
                        selectedTime = DateTime(
                          _selectedDay.year,
                          _selectedDay.month,
                          _selectedDay.day,
                          picked.hour,
                          picked.minute,
                        );
                      });
                    }
                  },
                  child: Text(
                    'Selected Time: ${DateFormat.jm().format(selectedTime)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Add'),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  final startTime = DateTime(
                    _selectedDay.year,
                    _selectedDay.month,
                    _selectedDay.day,
                    9,
                    30,
                  );
                  final endTime = DateTime(
                    _selectedDay.year,
                    _selectedDay.month,
                    _selectedDay.day,
                    17,
                    30,
                  );
                  if (!(selectedTime.isAfter(startTime) &&
                      selectedTime.isBefore(endTime))) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Please choose a time within working hours (9:30 AM - 5:30 PM).',
                        ),
                      ),
                    );
                  } else {
                    _addTaskToList(Task(title: title, dateTime: selectedTime));
                    Navigator.pop(context);
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _addTaskToList(Task task) {
    final selectedDayWithoutTime = DateTime(
      _selectedDay.year,
      _selectedDay.month,
      _selectedDay.day,
    );
    setState(() {
      if (_events.containsKey(selectedDayWithoutTime)) {
        _events[selectedDayWithoutTime]!.add(task);
      } else {
        _events[selectedDayWithoutTime] = [task];
      }
    });
  }

  List<Widget> _buildTaskWidgets() {
    List<Widget> taskWidgets = [];
    DateTime currentTime = DateTime.now();

    _events.forEach((day, tasks) {
      if (isSameDay(day, _focusedDay)) {
        for (final task in tasks) {
          if (task.dateTime.isBefore(currentTime) ||
              task.dateTime.isAtSameMomentAs(currentTime)) {
            // Show an alert if task time is equal to or before the current time
            taskWidgets.add(
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Card(
                  elevation: 3,
                  color: Colors.lightBlue,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Date: ${DateFormat.yMMMd().format(task.dateTime)}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Task Name: ${task.title}',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Time: ${DateFormat.jm().format(task.dateTime)}',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        const SizedBox(height: 10),
                        if (task.dateTime
                            .isBefore(currentTime)) // Check if time is over
                          const Text(
                            'Your Task Time Is Over.',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, color: Colors.red),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          } else {
            // Display the task as usual
            taskWidgets.add(
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Card(
                  elevation: 3,
                  color: Colors.lightBlue,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Date: ${DateFormat.yMMMd().format(task.dateTime)}',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              'Task Name: ${task.title}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              'Time: ${DateFormat.jm().format(task.dateTime)}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit),
                          color: Colors.white,
                          onPressed: () {
                            _editTask(task);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
        }
      }
    });
    return taskWidgets;
  }

  void _editTask(Task task) {
    DateTime editedDateTime = task.dateTime;
    String editedTaskName = task.title;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: const Text('Edit Task'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                          'Date: ${DateFormat.yMMMd().format(editedDateTime)}'),
                      IconButton(
                        onPressed: () async {
                          final pickedDate = await showDatePicker(
                            context: context,
                            initialDate: editedDateTime,
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2101),
                          );
                          if (pickedDate != null) {
                            setState(() {
                              editedDateTime = DateTime(
                                pickedDate.year,
                                pickedDate.month,
                                pickedDate.day,
                                editedDateTime.hour,
                                editedDateTime.minute,
                              );
                            });
                          }
                        },
                        icon: const Icon(Icons.calendar_today),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Time: ${DateFormat.jm().format(editedDateTime)}'),
                      IconButton(
                        onPressed: () async {
                          final pickedTime = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.fromDateTime(editedDateTime),
                          );
                          if (pickedTime != null) {
                            setState(() {
                              editedDateTime = DateTime(
                                editedDateTime.year,
                                editedDateTime.month,
                                editedDateTime.day,
                                pickedTime.hour,
                                pickedTime.minute,
                              );
                            });
                          }
                        },
                        icon: const Icon(Icons.access_time),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    initialValue: editedTaskName,
                    onChanged: (value) {
                      editedTaskName = value;
                    },
                    decoration: const InputDecoration(labelText: 'Task Name'),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      _updateTaskDetails(task, editedDateTime, editedTaskName);
                      Navigator.of(context).pop();
                    },
                    child: const Text('Save'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _updateTaskDetails(
      Task task, DateTime editedDateTime, String editedTaskName) {
    setState(() {
      task.dateTime = editedDateTime;
      task.title = editedTaskName;
    });
  }
}
