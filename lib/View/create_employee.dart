import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:wHRMS/ThemeColor/theme.dart';
import 'package:wHRMS/View/home_screen.dart';
import 'package:wHRMS/apiHandlar/baseUrl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wHRMS/textfieldController/createTextField.dart';

class CreateEmployee extends StatefulWidget {
  const CreateEmployee({Key? key}) : super(key: key);

  @override
  _CreateEmployeeState createState() => _CreateEmployeeState();
}

class _CreateEmployeeState extends State<CreateEmployee> {
  // final TextEditingController idController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController employeeIdController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController dojController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Define other variables needed for dropdowns
  String? selectedRole;
  String? selectedDepartment;
  String? selectedDesignation;
  String? selectedenrollType;
  String? selectedenrollStatus;
  String? selectedsourceHire;

  // final Logger _logger = Logger();

  // Other dropdown lists
  List<Map<String, dynamic>> roleList = [];
  List<Map<String, dynamic>> departmentList = [];
  List<Map<String, dynamic>> desList = [];
  List<Map<String, dynamic>> enrollTypeList = [];
  List<Map<String, dynamic>> enrollStatusList = [];
  List<Map<String, dynamic>> sourceHireList = [];

  // bool _isDisposed = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Fetch dropdown data
    fetchAllData();
  }

  // Future<void> _fetchDropdownData() async {
  //   // Fetch data for all dropdowns
  //   await _fetchRoles();
  //   await _fetchDepartments();
  //   await _fetchDesignations();
  //   await _fetchEnrollmentTypes();
  //   await _fetchEnrollmentStatuses();
  //   await _fetchSourceHires();
  // }

  Future<void> fetchAllData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? '';

    try {
      await Future.wait([
        _fetchRoles(token),
        _fetchDepartments(token),
        _fetchDesignations(token),
        _fetchEnrollmentTypes(token),
        _fetchEnrollmentStatuses(token),
        _fetchSourceHires(token),
      ]);
    } catch (e) {
      _handleError(e);
    }
  }

  Future<void> _createEmployee() async {
    const String apiUrl = '${URLConstants.baseUrl}/api/register';

    final name = usernameController.text;
    final email = emailController.text;
    final emails = _constructEmailAddress(email);
    final phoneNumber = phoneController.text;
    final DOJ = dojController.text;
    final password = passwordController.text;
    final empID = employeeIdController.text;
    final role =
        roleList.firstWhere((role) => role['name'] == selectedRole)['id'];
    final department = departmentList
        .firstWhere((dept) => dept['name'] == selectedDepartment)['id'];
    final designation =
        desList.firstWhere((des) => des['name'] == selectedDesignation)['id'];
    final enTy = enrollTypeList
        .firstWhere((enTY) => enTY['name'] == selectedenrollType)['id'];
    final enSt = enrollStatusList
        .firstWhere((enSt) => enSt['name'] == selectedenrollStatus)['id'];
    final hire = sourceHireList
        .firstWhere((hir) => hir['name'] == selectedsourceHire)['id'];

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: {
          'username': name,
          'email': emails,
          'phone_number': phoneNumber,
          'date_of_joining': DOJ,
          'password': password,
          'employee_id': empID,
          'role': role.toString(),
          'department': department.toString(),
          'designation': designation.toString(),
          'enrollment_type': enTy.toString(),
          'enrollment_status': enSt.toString(),
          'source_hire': hire.toString(),
        },
      );
      print('Testing StatusCode: ${response.statusCode}');
      print('Testing StatusCode: ${response.body}');
      // _logger.d(
      //     'Test Name: $name,Email: $email,Ph: $phoneNumber,DOJ: $DOJ,Password: $password,empID: $empID,Role: $role,Department: $department,Designation: $designation,EnrollType: $enTy,EnrollStatus: $enSt,Hire: $hire');

      // Check if form is not valid, return
      if (!_formKey.currentState!.validate()) {
        return;
      }

      if (response.statusCode == 201 || response.statusCode == 200) {
        final employeeData = json.decode(response.body);
        print('Employee created successfully: $employeeData');

        // Fetch dropdown data again after successful creation
        // _fetchDropdownData();

        // Navigate to HomeScreen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.green,
            content: Text('Employee Successfully Created.Thank You.'),
          ),
        );
      } else if (response.statusCode == 400) {
        print('Response body: ${response.body}');
        print('Response body: $empID');

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text('Bad Request: Error Creating Employee.'),
          ),
        );
        // print('Response Body: ${response.body}');
      } else if (response.statusCode == 401) {
        // _logger.d('Testing StatusCode: ${response.statusCode}');
        // _logger.d('Testing StatusCode: ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text('Unauthorized. Please Login again.'),
          ),
        );
      } else if (response.statusCode == 500) {
        // print('Testing StatusCode: ${response.statusCode}');
        // print('Testing StatusCode: ${response.body}');
        print('Response body: $empID');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text('Internal Server Error.Please try again later.'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text('Error creating employee'),
          ),
        );
      }
    } catch (e) {
      _handleError(e);
    }
  }

  Future<void> _fetchRoles(String token) async {
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
        final List<dynamic> roles = json.decode(response.body);

        setState(() {
          roleList.clear();
          // Store both name and id
          roleList.addAll(roles.map((role) => {
                'id': role['id'].toString(),
                'name': role['name'].toString(),
              }));
        });
        // print('Body: ${response.body}');
      } else if (response.statusCode == 401) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text('Invalid Token. Please Try again.'),
          ),
        );
        // print('Error fetching roles. Status code: ${response.statusCode}');
        // print('Roles Response body: ${response.body}');
      }
    } catch (e) {
      _handleError(e);
    }
  }

  Future<void> _fetchDepartments(String token) async {
    const String roleApiUrl = '${URLConstants.baseUrl}/api/department';

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
        // _logger.d('Department fetched successfully');

        final List<dynamic> department = json.decode(response.body);

        setState(() {
          departmentList.clear();
          departmentList.addAll(department.map((dep) => {
                'id': dep['id'].toString(),
                'name': dep['name'].toString(),
              }));
        });
      } else {
        // print('Error fetching Department. Status code: ${response.statusCode}');
        // print('Department Response body: ${response.body}');
      }
    } catch (e) {
      // _handleError(e);
    }
  }

  Future<void> _fetchDesignations(String token) async {
    const String roleApiUrl = '${URLConstants.baseUrl}/api/designation';

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
        // _logger.d('Designation fetched successfully');

        final List<dynamic> desig = json.decode(response.body);

        setState(() {
          desList.clear();
          desList.addAll(desig.map((de) => {
                'id': de['id'].toString(),
                'name': de['name'].toString(),
              }));
        });
      } else {
        // print(
        //     'Error fetching Designation. Status code: ${response.statusCode}');
        // print('Designation Response body: ${response.body}');
      }
    } catch (e) {
      // _handleError(e);
    }
  }

  Future<void> _fetchEnrollmentTypes(String token) async {
    const String roleApiUrl = '${URLConstants.baseUrl}/api/enrollment_type';

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
        // _logger.d('EnrollType fetched successfully');

        final List<dynamic> enType = json.decode(response.body);

        setState(() {
          enrollTypeList.clear();
          enrollTypeList.addAll(enType.map((eTy) => {
                'id': eTy['id'].toString(),
                'name': eTy['name'].toString(),
              }));
        });
      } else {
        // print('Error fetching EnrollType. Status code: ${response.statusCode}');
        // print('EnrollType Response body: ${response.body}');
      }
    } catch (e) {
      // _handleError(e);
    }
  }

  Future<void> _fetchEnrollmentStatuses(String token) async {
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
        // _logger.d('EnrollStatus fetched successfully');

        final List<dynamic> enStatus = json.decode(response.body);

        setState(() {
          enrollStatusList.clear();
          enrollStatusList.addAll(enStatus.map((eSt) => {
                'id': eSt['id'].toString(),
                'name': eSt['name'].toString(),
                'is_active': eSt['is_active'].toString(),
              }));
        });
      } else {
        // print(
        //     'Error fetching EnrollStatus. Status code: ${response.statusCode}');
        // print('EnrollStatus Response body: ${response.body}');
      }
    } catch (e) {
      // _handleError(e);
    }
  }

  Future<void> _fetchSourceHires(String token) async {
    const String roleApiUrl = '${URLConstants.baseUrl}/api/source_hire';

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
        // _logger.d('SourceHire fetched successfully');

        final List<dynamic> sourceHire = json.decode(response.body);

        setState(() {
          sourceHireList.clear();
          sourceHireList.addAll(sourceHire.map((hir) => {
                'id': hir['id'].toString(),
                'name': hir['name'].toString(),
              }));
        });
      } else {
        // print('Error fetching SourceHire. Status code: ${response.statusCode}');
        // print('SourceHire Response body: ${response.body}');
      }
    } catch (e) {
      // _handleError(e);
    }
  }

  void _handleError(dynamic e) {
    // _logger.e('Error: $e');
    print('Error: $e');
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

  String _constructEmailAddress(String email) {
    return '$email@gmail.com';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Employee',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: ThemeColor.app_bar,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 8.0),
        child: Center(
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.disabled,
            child: Column(
              children: [
                const SizedBox(height: 20),
                const Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Create Employee',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    createText.buildTextFields(
                      controller: usernameController,
                      hintText: 'UserName',
                      prefixIconData: Icons.person,
                      // fieldName: 'UserName',
                    ),
                    createText.buildEmployeeText(
                      controller: employeeIdController,
                      hintText: 'WEMP ',
                      prefixIconData: Icons.phone_android,
                      // fieldName: 'Emp ID',
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                createText.buildEmailTextField(
                  controller: emailController,
                  hintText: 'Email Address',
                  prefixIconData: Icons.email,
                  fieldName: 'Email Address',
                ),
                const SizedBox(height: 15),
                createText.buildTextField(
                  controller: phoneController,
                  hintText: 'PhoneNumber',
                  prefixIconData: Icons.phone,
                  fieldName: 'PhoneNumber',
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    createText.buildDropdowns(
                      selectedValue: selectedRole,
                      hintText: 'Role',
                      items: roleList.map((Map<String, dynamic> role) {
                        return DropdownMenuItem<String>(
                          value: role['name'],
                          child: Text(role['name']),
                        );
                      }).toList(),
                      onChanged: (String? value) {
                        setState(() {
                          selectedRole = value;
                        });
                      },
                      fieldName: 'Role',
                      prefixIconData: Icons.person,
                    ),
                    createText.buildDropdowns(
                      items: desList.map((Map<String, dynamic> dep) {
                        return DropdownMenuItem<String>(
                          value: dep['name'],
                          child: Text(dep['name']),
                        );
                      }).toList(),
                      selectedValue: selectedDesignation?.toString(),
                      hintText: 'Designation',
                      onChanged: (String? value) {
                        setState(() {
                          selectedDesignation = value;
                        });
                      },
                      fieldName: 'Designation',
                      prefixIconData: Icons.local_fire_department,
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                createText.buildDropdown(
                  items: departmentList.map((Map<String, dynamic> dept) {
                    return DropdownMenuItem<String>(
                      value: dept['name'],
                      child: Text(dept['name']),
                    );
                  }).toList(),
                  selectedValue: selectedDepartment?.toString(),
                  hintText: 'Select Department',
                  onChanged: (String? value) {
                    setState(() {
                      selectedDepartment = value;
                    });
                  },
                  fieldName: 'Select Department',
                  prefixIconData: Icons.local_fire_department,
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    createText.buildDropdowns(
                      items: enrollTypeList.map((Map<String, dynamic> enTY) {
                        return DropdownMenuItem<String>(
                          value: enTY['name'],
                          child: Text(enTY['name']),
                        );
                      }).toList(),
                      selectedValue: selectedenrollType?.toString(),
                      hintText: 'EnrollType',
                      onChanged: (String? value) {
                        setState(() {
                          selectedenrollType = value;
                        });
                      },
                      fieldName: 'EnrollType',
                      prefixIconData: Icons.local_fire_department,
                    ),
                    createText.buildDropdowns(
                      items: enrollStatusList.map((Map<String, dynamic> enSt) {
                        return DropdownMenuItem<String>(
                          value: enSt['name'],
                          child: Text(enSt['name']),
                        );
                      }).toList(),
                      selectedValue: selectedenrollStatus?.toString(),
                      hintText: 'EnrollStatus',
                      onChanged: (String? value) {
                        setState(() {
                          selectedenrollStatus = value;
                        });
                      },
                      fieldName: 'EnrollStatus',
                      prefixIconData: Icons.star_outline_sharp,
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    createText.buildDropdowns(
                      items: sourceHireList.map((Map<String, dynamic> source) {
                        return DropdownMenuItem<String>(
                          value: source['name'],
                          child: Text(source['name']),
                        );
                      }).toList(),
                      selectedValue: selectedsourceHire?.toString(),
                      hintText: 'Select SourceHire',
                      onChanged: (String? value) {
                        setState(() {
                          selectedsourceHire = value;
                        });
                      },
                      fieldName: 'Select SourceHire',
                      prefixIconData: Icons.local_fire_department,
                    ),
                    _buildDateField(
                      'Date of Joining',
                      dojController,
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                createText.buildTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  prefixIconData: Icons.password,
                  fieldName: 'Employee ID',
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
                          _createEmployee();
                          // _fetchRoles(token);
                          // _fetchDepartments();
                          // _fetchDesignations();
                          // _fetchEnrollmentTypes();
                          // _fetchEnrollmentStatuses();
                          // _fetchSourceHires();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6.0),
                        ),
                        backgroundColor:
                            ThemeColor.app_bar, // Replace with your app's color
                      ),
                      child: const Text(
                        'CREATE',
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
              ],
            ),
          ),
        ),
      ),
      // backgroundColor: ThemeColor.log_background,
    );
  }

  //Date of Joining Method
  Widget _buildDateField(String hintText, TextEditingController controller) {
    return SizedBox(
      width: 150,
      child: TextFormField(
        controller: controller,
        readOnly: true,
        decoration: InputDecoration(
          prefixIcon: const Icon(
            Icons.date_range,
            // color: Colors.blue,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Colors.grey,
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(7.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Colors.grey,
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(7.0),
          ),
          hintText: hintText,
          labelStyle: const TextStyle(fontSize: 10),
          border: const OutlineInputBorder(),
          filled: true,
          fillColor: ThemeColor.TextFieldColor,
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please select a date';
          }
          return null;
        },
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1),
            lastDate: DateTime(2101),
          );

          if (pickedDate != null) {
            String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
            controller.text = formattedDate;
          }
        },
      ),
    );
  }
}
