import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:wHRMS/Components/information_widget.dart';
import 'package:wHRMS/Edit_Page/educationEdit.dart';
import 'package:wHRMS/Edit_Page/identity.dart';
import 'package:wHRMS/Edit_Page/personalEdit.dart';
import 'package:wHRMS/Edit_Page/workEdit.dart';
import 'package:wHRMS/ThemeColor/theme.dart';
import 'package:wHRMS/View/UserSkills.dart';
import 'package:wHRMS/View/certificates.dart';
import 'package:wHRMS/View/familyinfo.dart';
import 'package:wHRMS/apiHandlar/baseUrl.dart';

import 'package:wHRMS/objects/education.dart';
import 'package:wHRMS/objects/familyObject.dart';
import 'package:wHRMS/objects/personal.dart';
import 'package:wHRMS/objects/profile_field.dart';
import 'package:wHRMS/objects/work_experience.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EmployeeProfile extends StatefulWidget {
  const EmployeeProfile({Key? key}) : super(key: key);

  @override
  State<EmployeeProfile> createState() => _EmployeeProfileState();
}

class _EmployeeProfileState extends State<EmployeeProfile> {
  List<EmployeesField> employeeProfile = [];
  // bool isFirstTap = true;
  final Logger _logger = Logger();
  List<EmployeeName> employee = [];
  List<WorkExperience> work = [];
  List<EducationDetails> education = [];
  List<Employe> daage = [];
  List<FamilyDetails> familyDetails = [];

  String? profile_picture;

  @override
  void initState() {
    super.initState();
    _fetchEmployeeProfile();
    _fetchEmployee();
    _fetchWorkExperience();
    _fetchEducation();
    _fetchImage();
    _fetchFamily();
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

      _logger.d('Employee Status Code : ${response.statusCode}');
      _logger.d('Testing Employee Body : ${response.body}');

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
          print('Unexpected response format');
        }
      } else {
        print(
            'Failed to load Employee data. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error loading employee data: $e');
    }
  }

  Future<void> _fetchEmployee() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token') ?? '';

      final response = await http.get(
        Uri.parse('${URLConstants.baseUrl}/api/user'),
        headers: {
          'Authorization': 'token $token',
          'Content-Type': 'application/json',
        },
      );

      _logger.d('User Status Code : ${response.statusCode}');
      _logger.d('Testing User Body : ${response.body}');

      if (response.statusCode == 200) {
        final dynamic data = jsonDecode(response.body);

        if (data is List) {
          setState(() {
            employeeProfile =
                data.map((item) => EmployeesField.fromJson(item)).toList();
          });
        } else if (data is Map<String, dynamic>) {
          // Single employee case
          setState(() {
            employeeProfile = [EmployeesField.fromJson(data)];
          });
        } else {
          print('Unexpected response format');
        }
      } else {
        print('Failed to load User data. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error loading employee data: $e');
    }
  }

  Future<void> _fetchWorkExperience() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token') ?? '';

      final response = await http.get(
        Uri.parse('${URLConstants.baseUrl}/api/work_experiences'),
        headers: {
          'Authorization': 'token $token',
          'Content-Type': 'application/json',
        },
      );

      print('Response token: $token');

      _logger.d('Work_Experience Status Code : ${response.statusCode}');
      _logger.d('Testing Work_Experience Body : ${response.body}');

      if (response.statusCode == 200) {
        final dynamic data = jsonDecode(response.body);

        if (data is List) {
          setState(() {
            work = data.map((item) => WorkExperience.fromJson(item)).toList();
          });
        } else if (data is Map<String, dynamic>) {
          // Single employee case
          setState(() {
            work = [WorkExperience.fromJson(data)];
          });
        } else {
          print('Unexpected response format');
        }
      } else {
        print(
            'Failed to load Work_experience data. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error loading Work_Experience data: $e');
    }
  }

  Future<void> _fetchEducation() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token') ?? '';

      final response = await http.get(
        Uri.parse('${URLConstants.baseUrl}/api/education'),
        headers: {
          'Authorization': 'token $token',
          'Content-Type': 'application/json',
        },
      );

      _logger.d('Education Status Code : ${response.statusCode}');
      _logger.d('Testing Education Body : ${response.body}');

      if (response.statusCode == 200) {
        final dynamic data = jsonDecode(response.body);

        if (data is List) {
          setState(() {
            education =
                data.map((item) => EducationDetails.fromJson(item)).toList();
          });
        } else if (data is Map<String, dynamic>) {
          // Single employee case
          setState(() {
            work = [WorkExperience.fromJson(data)];
          });
        } else {
          print('Unexpected response format');
        }
      } else {
        print(
            'Failed to load Education data. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error loading Education data: $e');
    }
  }

  Future<void> _fetchImage() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token') ?? '';

      final response = await http.get(
        Uri.parse('${URLConstants.baseUrl}/api/profileimg'),
        headers: {
          'Authorization': 'token $token',
          'Content-Type': 'application/json',
        },
      );

      _logger.d('User Status Code: ${response.statusCode}');
      _logger.d('Testing User Body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        if (data.isNotEmpty) {
          // Assuming there's only one item in the array
          final Map<String, dynamic> firstItem = data.first;
          setState(() {
            // Assuming profile_picture_url is the key in your API response
            profile_picture = firstItem['profile_picture'] ?? '';
            _logger.d('Testing User: $firstItem');
          });
        } else {
          print('Empty response');
        }
      } else {
        print('Failed to load Image data. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error loading image data: $e');
    }
  }

  Future<void> _fetchFamily() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token') ?? '';

      final response = await http.get(
        Uri.parse('${URLConstants.baseUrl}/api/familyinfo'),
        headers: {
          'Authorization': 'token $token',
          'Content-Type': 'application/json',
        },
      );

      _logger.d('Family Status Code : ${response.statusCode}');
      _logger.d('Testing Family Body : ${response.body}');

      if (response.statusCode == 200) {
        final dynamic data = jsonDecode(response.body);

        if (data is List) {
          setState(() {
            familyDetails =
                data.map((item) => FamilyDetails.fromJson(item)).toList();
          });
        } else if (data is Map<String, dynamic>) {
          // Single employee case
          setState(() {
            work = [WorkExperience.fromJson(data)];
          });
        } else {
          print('Unexpected response format');
        }
      } else {
        print(
            'Failed to load Family data. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error loading Family data: $e');
    }
  }

  final double cover = 130.0;
  final double img = 130.0;

  @override
  Widget build(BuildContext context) {
    final double top = cover - img / 2;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              height: cover,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: ThemeColor.app_bar,
              ),
            ),
            // Profile picture
            Positioned(
              top: top,
              left: MediaQuery.of(context).size.width / 2 - 65,
              child: Container(
                width: 130,
                height: img,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 5,
                  ),
                ),
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.transparent,
                  backgroundImage: profile_picture != null
                      ? NetworkImage('${URLConstants.baseUrl}/$profile_picture')
                      : null,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 70),
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                employee.isNotEmpty ? employee[0].firstname : 'Null',
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              const SizedBox(width: 10.0),
              Text(
                employee.isNotEmpty ? employee[0].lastname : 'Null',
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 2.0),
        const Align(
          alignment: Alignment.center,
          child: Text(
            'Software Developer',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20.0,
            ),
          ),
        ),
        const SizedBox(height: 10.0),
        Container(
          // padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 8.0),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Row(
                children: [
                  const SizedBox(
                    height: 15,
                    width: 20,
                  ),
                  const Text(
                    'Personal Info',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  // const SizedBox(width: 200),
                  const Spacer(),
                  GestureDetector(
                    onTap: () async {
                      // ignore: use_build_context_synchronously
                      Navigator.push(
                        context,
                        PageTransition(
                          type: PageTransitionType.rightToLeft,
                          duration: const Duration(milliseconds: 300),
                          child: const PersonalEditScreen(),
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
              const SizedBox(
                // height: 2,
                width: 20,
              ),
              // Iterate through the list of Employee profiles
              for (int i = 0; i < employee.length; i++)
                if (i < employeeProfile.length)
                  if (i < daage.length)
                    Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),
                          TextWithPadding(
                            label: 'Employee Id',
                            value: employeeProfile[i].id.toString(),
                          ),
                          const SizedBox(height: 15),
                          TextWithPadding(
                            label: 'User Name',
                            value: employeeProfile[i].username,
                          ),
                          const SizedBox(height: 15),
                          TextWithPadding(
                            label: 'Age',
                            value: daage[i].age.toString(),
                          ),
                          const SizedBox(height: 10),
                          TextWithPadding(
                            label: 'Date of Birth',
                            value: daage[i].date.toString(),
                          ),
                          const SizedBox(height: 10),
                          TextWithPadding(
                            label: 'Email Id',
                            value: employeeProfile[i].emailid,
                          ),
                          const SizedBox(height: 15),
                        ],
                      ),
                    ),
            ],
          ),
          // ),
        ),
        const SizedBox(height: 15),
        SizedBox(
          width: double.infinity,
          // child: Card(
          //   color: Colors.white,
          //   elevation: 1.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Row(
                children: [
                  const SizedBox(
                    height: 15,
                    width: 20,
                  ),
                  const Text(
                    'Identy Information',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  // const SizedBox(width: 170),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        PageTransition(
                          type: PageTransitionType.rightToLeft,
                          duration: const Duration(milliseconds: 300),
                          child: const IdentityScreen(),
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
              const SizedBox(
                // height: 2,
                width: 20,
              ),
              for (int i = 0; i < employee.length; i++)
                if (i < employeeProfile.length)
                  Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        TextWithPadding(
                          label: 'UAN',
                          value: employee[i].uan.toString(),
                        ),
                        const SizedBox(height: 15),
                        TextWithPadding(
                          label: 'PAN',
                          value: employee[i].pan,
                        ),
                        const SizedBox(height: 15),
                        TextWithPadding(
                          label: 'Work Number',
                          value: employee[i].workNumber,
                        ),
                        const SizedBox(height: 15),
                        TextWithPadding(
                          label: 'Personal Number',
                          value: employee[i].personalNumber,
                        ),
                        const SizedBox(height: 15),
                        TextWithPadding(
                          label: 'Personal Email',
                          value: employee[i].personalEmail,
                        ),
                        const SizedBox(height: 15),
                        TextWithPadding(
                          label: 'Address',
                          value: employee[i].address,
                        ),
                        const SizedBox(height: 15),
                      ],
                    ),
                  ),
            ],
          ),
        ),
        // const SizedBox(height: 15),
        Container(
          constraints: const BoxConstraints(maxHeight: 140.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Row(
                children: [
                  SizedBox(width: 20),
                  Text(
                    'Education Details',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(width: 170),
                ],
              ),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: education.length,
                  itemBuilder: (context, index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Card(
                          color: Colors.white,
                          elevation: 1.0,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 18.0, vertical: 8.0),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Stack(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      education.isNotEmpty
                                          ? education[index]
                                              .universityName
                                              .toString()
                                          : 'Null',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Row(
                                      children: [
                                        Text(
                                          education.isNotEmpty
                                              ? education[index].completeyear
                                              : 'Null',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            // fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                          education.isNotEmpty
                                              ? education[index].degree
                                              : 'Null',
                                          style: const TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                          education.isNotEmpty
                                              ? education[index].specialization
                                              : 'Null',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            // fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Positioned(
                                  top: 0,
                                  right: 0,
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.edit,
                                      size: 18,
                                      color: ThemeColor.app_bar,
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        PageTransition(
                                          type: PageTransitionType.rightToLeft,
                                          duration:
                                              const Duration(milliseconds: 300),
                                          child: EducationEditScreen(
                                            educationData: {
                                              'id': education[index].id,
                                              'institute_name': education[index]
                                                  .universityName,
                                              'degree_diploma':
                                                  education[index].degree,
                                              'specialization': education[index]
                                                  .specialization,
                                              'date_of_completion':
                                                  education[index].completeyear,
                                              'cgpa': education[index].cgpa,
                                              // 'table_id':
                                              //     education[index].tableId,
                                              // Add other fields here
                                            },
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 15),
        Row(
          children: [
            const SizedBox(
              height: 15,
              width: 20,
            ),
            const Text(
              'Add Your Skills',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            // const SizedBox(
            //   width: 200,
            // ),
            Spacer(),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EmployeeSkills(),
                  ),
                );
              },
              child: const Icon(
                Icons.library_add_check_outlined,
                color: Colors.blue,
              ),
            ),
          ],
        ),

        const SizedBox(height: 25),
        Row(
          children: [
            const SizedBox(
              height: 15,
              width: 20,
            ),
            const Text(
              'Add Your Certificates',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            // const SizedBox(
            //   width: 150,
            // ),
            Spacer(),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CertificateScreen(),
                  ),
                );
              },
              child: const Icon(
                Icons.library_add_check_outlined,
                color: Colors.blue,
              ),
            ),
          ],
        ),

        const SizedBox(height: 25),
        Row(
          children: [
            const SizedBox(
              height: 15,
              width: 20,
            ),
            const Text(
              'Add Your Family Info',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            // const SizedBox(
            //   width: 155,
            // ),
            Spacer(),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FamilyScreen(),
                  ),
                );
              },
              child: const Icon(
                Icons.library_add_check_outlined,
                color: Colors.blue,
              ),
            ),
          ],
        ),

        Container(
          constraints: const BoxConstraints(maxHeight: 90.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // const SizedBox(height: 20),
              // const Row(
              //   children: [
              //     SizedBox(width: 20),
              //     Text(
              //       'Family Information',
              //       style: TextStyle(
              //         color: Colors.black,
              //         fontWeight: FontWeight.bold,
              //         fontSize: 18,
              //       ),
              //     ),
              //     SizedBox(width: 170),
              //   ],
              // ),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: familyDetails.length,
                  itemBuilder: (context, index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Card(
                          color: Colors.white,
                          elevation: 1.0,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 18.0, vertical: 8.0),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Stack(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      familyDetails.isNotEmpty
                                          ? familyDetails[index].name.toString()
                                          : 'Null',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Row(
                                      children: [
                                        Text(
                                          familyDetails.isNotEmpty
                                              ? familyDetails[index].relation
                                              : 'Null',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            // fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                          familyDetails.isNotEmpty
                                              ? familyDetails[index].phoneNumber
                                              : 'Null',
                                          style: const TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                          familyDetails.isNotEmpty
                                              ? familyDetails[index].address
                                              : 'Null',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            // fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Positioned(
                                  top: 0,
                                  right: 0,
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.edit,
                                      size: 18,
                                      color: ThemeColor.app_bar,
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        PageTransition(
                                          type: PageTransitionType.rightToLeft,
                                          duration:
                                              const Duration(milliseconds: 300),
                                          child: EducationEditScreen(
                                            educationData: {
                                              'id': education[index].id,
                                              'institute_name': education[index]
                                                  .universityName,
                                              'degree_diploma':
                                                  education[index].degree,
                                              'specialization': education[index]
                                                  .specialization,
                                              'date_of_completion':
                                                  education[index].completeyear,
                                              'cgpa': education[index].cgpa,
                                              // 'table_id':
                                              //     education[index].tableId,
                                              // Add other fields here
                                            },
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        // const SizedBox(height: 15),
        Container(
          constraints: const BoxConstraints(maxHeight: 160.0),
          // padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Row(
                children: [
                  SizedBox(width: 20),
                  Text(
                    'Work Experience',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(width: 170),
                ],
              ),
              // const SizedBox(height: 10),
              // Use ListView.builder to dynamically build the list
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: work.length,
                  itemBuilder: (context, index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Card(
                          color: Colors.white,
                          elevation: 1.0,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 18.0, vertical: 8.0),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Stack(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      work.isNotEmpty
                                          ? work[index].designation
                                          : 'Null',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                work.isNotEmpty
                                                    ? work[index]
                                                        .companyName
                                                        .toString()
                                                    : 'Null',
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  // fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(height: 5),
                                              Row(
                                                children: [
                                                  Text(
                                                    work.isNotEmpty
                                                        ? work[index].fromDate
                                                        : 'Null',
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 10),
                                                  Text(
                                                    work.isNotEmpty
                                                        ? work[index].toDate
                                                        : 'Null',
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                      // fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Positioned(
                                  top: 0,
                                  right: 0,
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.edit,
                                      size: 18,
                                      color: ThemeColor.app_bar,
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        PageTransition(
                                          type: PageTransitionType.rightToLeft,
                                          duration:
                                              const Duration(milliseconds: 300),
                                          child: WorkExperienceEditScreen(
                                            workExperienceData: {
                                              'id': work[index].id,
                                              'company_name':
                                                  work[index].companyName,
                                              'designation':
                                                  work[index].designation,
                                              'from_date': work[index].fromDate,
                                              'to_date': work[index].toDate,
                                              // Add other fields here
                                            },
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
