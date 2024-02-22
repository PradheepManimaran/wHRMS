import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wHRMS/Components/employees.dart';
import 'package:wHRMS/ThemeColor/theme.dart';
import 'package:wHRMS/View/adminleavelist.dart';
import 'package:wHRMS/View/attenance.dart';
import 'package:wHRMS/View/customnav.dart';
import 'package:wHRMS/View/dashboard.dart';
import 'package:wHRMS/View/employee_form.dart';
import 'package:wHRMS/View/employee_profile.dart';
import 'package:wHRMS/View/leave_list.dart';
import 'package:wHRMS/apiHandlar/baseUrl.dart';
import 'package:wHRMS/login/login.dart';
import 'package:http/http.dart' as http;
import 'package:wHRMS/pages/departmentScreen.dart';
import 'package:wHRMS/pages/designation.dart';
import 'package:wHRMS/pages/enroll_status.dart';
import 'package:wHRMS/pages/enroll_type.dart';
import 'package:wHRMS/pages/roleScreen.dart';
import 'package:wHRMS/pages/skills.dart';
import 'package:wHRMS/pages/sourceHire.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreen createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  int _selectedIndex = 0;
  bool _isSuperuser = false;
  EmployeeScreen employeForm = EmployeeScreen();

  // late List<Widget> _widgetOptions;

  // final List<Widget> _widgetOptions = <Widget>[
  //   const Dashboard(),
  //   if (_isSuperuser) const EmployeeScreen(),
  //   const LeaveList(),
  //   const EmployeeProfile(),
  //   if (!_isSuperuser) const AttendanceScreen(),
  // ];

  void _onItemTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadIsSuperuser();

    //  _loadIsSuperuser();

    // _widgetOptions = [
    //   const Dashboard(),
    //   if {(_isSuperuser) const EmployeeScreen(),}
    //   else { const AttendanceScreen(),}
    //   const LeaveList(),
    //   const EmployeeProfile(),
    //   // if (!_isSuperuser) const AttendanceScreen(),
    // ];
  }

  List<Widget> _widgetOptions(bool isSuperuser) {
    if (isSuperuser) {
      return const [
        Dashboard(),
        EmployeeScreen(),
        AdminLeaveListScreen(),
        EmployeeProfile(),
      ];
    } else {
      return const [
        Dashboard(),
        AttendanceScreen(),
        LeaveList(),
        EmployeeProfile(),
      ];
    }
  }

  void _loadIsSuperuser() async {
    Map<String, dynamic> tokenInfo = await _getToken();
    setState(() {
      _isSuperuser = tokenInfo['is_superuser'] ?? false;
    });
  }

  Future<Map<String, dynamic>> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return {
      'token': prefs.getString('token'),
      'is_superuser': prefs.getBool('is_superuser') ?? false,
    };
  }

  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    print('Token before logout: $token');

    try {
      final response = await http.post(
        Uri.parse('${URLConstants.baseUrl}/api/logout'),
      );

      if (response.statusCode == 200) {
        prefs.remove('token');
        print('Logged out');
        print('Token after logout: ${prefs.getString('token')}');

        // Show SnackBar for successful logout
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.green,
            content: Text('Logged out successfully.'),
            duration: Duration(seconds: 2),
          ),
        );

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const UserLoginScreen(),
          ),
        );
      } else {
        // Handle errors or unexpected responses here
        print('Failed to logout. Status code: ${response.statusCode}');

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.green,
            content: Text('Logged out successfully.'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (error) {
      // Handle network errors or exceptions here
      print('Error during logout: $error');
    }
  }

  void remove() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.remove('token');

    print('Logged out');
    print('Token after logout: ${prefs.getString('token')}');

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const UserLoginScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = _widgetOptions(_isSuperuser);

    List<String> appBarTitles = [];
    if (_isSuperuser) {
      appBarTitles = [
        'Dashboard',
        'Employee List',
        'Leave List',
        'Profile',
      ];
    } else {
      appBarTitles = [
        'Dashboard',
        'Attendance',
        'Leave',
        'Profile',
      ];
    }
    return Scaffold(
      appBar: AppBar(
        // centerTitle: true,
        title: Text(
          appBarTitles[_selectedIndex],
          style: GoogleFonts.heebo(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        backgroundColor: ThemeColor.app_bar,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Padding(
                padding: const EdgeInsets.only(left: 2, bottom: 0, top: 30),
                child: Text(
                  'wEmployeeManager',
                  style: GoogleFonts.heebo(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
              accountEmail: Padding(
                padding: const EdgeInsets.only(left: 4, top: 0, bottom: 0),
                child: Text(
                  '@Welcom wEmployeeManager',
                  style: GoogleFonts.heebo(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
              ),
              currentAccountPicture: const CircleAvatar(
                backgroundImage:
                    AssetImage('assets/ic_launcher_adaptive_fore.png'),
              ),
              decoration: const BoxDecoration(
                color: ThemeColor.app_bar,
              ),
              margin: const EdgeInsets.all(0),
              currentAccountPictureSize: const Size(80, 80),
              otherAccountsPictures: const [
                // Add other accounts pictures if needed
              ],
            ),
            ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              title: const Row(
                children: <Widget>[
                  SizedBox(width: 15),
                  Icon(Icons.home),
                  SizedBox(width: 20),
                  Text(
                    'Dashboard',
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              onTap: () {
                _onItemTap(0);
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 10),
            ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              title: Row(
                children: <Widget>[
                  const SizedBox(width: 15),
                  Icon(_isSuperuser
                      ? Icons.task_sharp
                      : Icons.calendar_today_outlined),
                  const SizedBox(width: 20),
                  Text(
                    _isSuperuser ? 'Employee List' : 'Attendance',
                    style: const TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 16,
                    ),
                  )
                ],
              ),
              onTap: () {
                if (_isSuperuser) {
                  _onItemTap(1);
                } else {
                  _onItemTap(1);
                }
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 10),
            ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              title: Row(
                children: <Widget>[
                  const SizedBox(width: 15),
                  Icon(_isSuperuser
                      ? Icons.task_sharp
                      : Icons.calendar_today_outlined),
                  const SizedBox(width: 20),
                  Text(
                    _isSuperuser ? 'Leave List' : 'Leave',
                    style: const TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 16,
                    ),
                  )
                ],
              ),
              onTap: () {
                if (_isSuperuser) {
                  _onItemTap(2);
                } else {
                  _onItemTap(2);
                }
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 10),
            ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              title: const Row(
                children: <Widget>[
                  SizedBox(width: 15),
                  Icon(Icons.people),
                  SizedBox(width: 20),
                  Text(
                    'Profile',
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 16,
                    ),
                  )
                ],
              ),
              onTap: () {
                _onItemTap(3);
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 10),
            ExpansionTile(
              title: const Row(
                children: <Widget>[
                  Icon(Icons.settings),
                  SizedBox(width: 20),
                  Text(
                    'Settings',
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              children: <Widget>[
                ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  title: const Row(
                    children: <Widget>[
                      SizedBox(width: 15),
                      Icon(Icons.gesture_outlined),
                      SizedBox(width: 20),
                      Text(
                        'General',
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: ((context) => const RoleScreen()),
                    //   ),
                    // );
                  },
                ),
                if (_isSuperuser)
                  ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    title: const Row(
                      children: <Widget>[
                        SizedBox(width: 15),
                        Icon(Icons.roller_shades),
                        SizedBox(width: 20),
                        Text(
                          'Role',
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: ((context) => const RoleScreen()),
                        ),
                      );
                    },
                  ),
                if (_isSuperuser) // Show only for superuser
                  ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    title: const Row(
                      children: <Widget>[
                        SizedBox(width: 15),
                        Icon(Icons.description),
                        SizedBox(width: 20),
                        Text(
                          'Department',
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: ((context) => const DepartmentScreen()),
                        ),
                      );
                    },
                  ),
                if (_isSuperuser) // Show only for superuser
                  ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    title: const Row(
                      children: <Widget>[
                        SizedBox(width: 15),
                        Icon(Icons.travel_explore_outlined),
                        SizedBox(width: 20),
                        Text(
                          'Enrollment Type',
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: ((context) => const EnrollTypeScreen()),
                        ),
                      );
                    },
                  ),
                if (_isSuperuser) // Show only for superuser
                  ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    title: const Row(
                      children: <Widget>[
                        SizedBox(width: 15),
                        Icon(Icons.sentiment_very_dissatisfied_rounded),
                        SizedBox(width: 20),
                        Text(
                          'Enrollment Status',
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: ((context) => const EnrollStatusScreen()),
                        ),
                      );
                    },
                  ),
                if (_isSuperuser) // Show only for superuser
                  ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    title: const Row(
                      children: <Widget>[
                        SizedBox(width: 15),
                        Icon(Icons.enhance_photo_translate_outlined),
                        SizedBox(width: 20),
                        Text(
                          'Designation',
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: ((context) => const DesignationScreen()),
                        ),
                      );
                    },
                  ),
                if (_isSuperuser) // Show only for superuser
                  ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    title: const Row(
                      children: <Widget>[
                        SizedBox(width: 15),
                        Icon(Icons.hive_rounded),
                        SizedBox(width: 20),
                        Text(
                          'Source Hire',
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: ((context) => const SourceHireScreen()),
                        ),
                      );
                    },
                  ),
                if (_isSuperuser) // Show only for superuser
                  ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    title: const Row(
                      children: <Widget>[
                        SizedBox(width: 15),
                        Icon(Icons.skateboarding_outlined),
                        SizedBox(width: 20),
                        Text(
                          'Skills',
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: ((context) => const SkillsScreen()),
                        ),
                      );
                    },
                  ),
                // Add more settings options as needed
                // if (!_isSuperuser) // Show only for non-superusers
                //   ListTile(
                //     dense: true,
                //     contentPadding: EdgeInsets.zero,
                //     title: const Text(
                //       'Access restricted. Only administrators have access to Settings.',
                //       style: TextStyle(
                //         color: Colors.red,
                //         fontWeight: FontWeight.normal,
                //         fontSize: 16,
                //       ),
                //     ),
                //     onTap: () {
                //       // Display a message indicating access is restricted for non-superusers
                //       ScaffoldMessenger.of(context).showSnackBar(
                //         const SnackBar(
                //           content: Text(
                //               'Access restricted. Only administrators have access to Settings.'),
                //           duration: Duration(seconds: 2),
                //         ),
                //       );
                //     },
                //   ),
              ],
            ),
            const SizedBox(height: 10),
            ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              title: const Row(
                children: <Widget>[
                  SizedBox(width: 15),
                  Icon(Icons.exit_to_app),
                  SizedBox(width: 20),
                  Text(
                    'Log out',
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 16,
                    ),
                  )
                ],
              ),
              onTap: () {
                _logout();
                remove();
                Navigator.pop(context);
              },
            ),
            const Divider(height: 100.0),
            ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              title: Row(
                children: <Widget>[
                  const SizedBox(width: 15),
                  Text(
                    'Copyright©2024 wEmployeeManager',
                    style: GoogleFonts.heebo(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Container(
        // color: ThemeColor.log_background,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              widgets[_selectedIndex],
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _selectedIndex,
        onItemSelected: (index) {
          _onItemTap(index);
        },
        items: _isSuperuser
            ? const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.dashboard),
                  label: 'Dashboard',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.task),
                  label: 'Employees',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.calendar_today_outlined),
                  label: 'Leave List',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'Profile',
                ),
              ]
            : const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.dashboard),
                  label: 'Dashboard',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.calendar_today_outlined),
                  label: 'Attendance',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.calendar_today_outlined),
                  label: 'Leave',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'Profile',
                ),
              ],
        iconColor: Colors.white,
      ),
    );
  }
}
