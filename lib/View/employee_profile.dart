import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shimmer/shimmer.dart';
import 'package:wHRMS/Components/information_widget.dart';
import 'package:wHRMS/Edit_Page/educationEdit.dart';
import 'package:wHRMS/Edit_Page/familinfoEdit.dart';
import 'package:wHRMS/Edit_Page/identity.dart';
import 'package:wHRMS/Edit_Page/imageUpload.dart';
import 'package:wHRMS/Edit_Page/personalEdit.dart';
import 'package:wHRMS/Edit_Page/workEdit.dart';
import 'package:wHRMS/ThemeColor/theme.dart';
import 'package:wHRMS/View/UserSkills.dart';
import 'package:wHRMS/View/certificates.dart';
import 'package:wHRMS/View/educationScreen.dart';
import 'package:wHRMS/View/familyinfo.dart';
import 'package:wHRMS/View/workScreen.dart';
import 'package:wHRMS/apiHandlar/baseUrl.dart';
import 'package:wHRMS/objects/certificateObject.dart';
import 'package:wHRMS/objects/education.dart';
import 'package:wHRMS/objects/familyObject.dart';
import 'package:wHRMS/objects/personal.dart';
import 'package:wHRMS/objects/profile_field.dart';
import 'package:wHRMS/objects/work_experience.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wHRMS/pages/skills.dart';

class EmployeeProfile extends StatefulWidget {
  const EmployeeProfile({Key? key}) : super(key: key);

  @override
  State<EmployeeProfile> createState() => _EmployeeProfileState();
}

class _EmployeeProfileState extends State<EmployeeProfile> {
  List<WorkExperience> work = [];
  List<EducationDetails> education = [];

  List<FamilyDetails> familyDetails = [];
  List<Certificate> certificate = [];

  EmployeeName? emp;

  String? profile_picture;

  @override
  void initState() {
    super.initState();

    setState(() {
      isLoading = true;
    });
    fetchAllData();
    // WidgetsBinding.instance.addPostFrameCallback((_) async {
    //   setState(() {
    //     this.work = work;
    //     this.familyDetails = familyDetails;
    //     this.education = education;
    //     isLoading = false;
    //   });
    // });

    isLoading = false;
  }

  Future<void> fetchAllData() async {
    try {
      await Future.wait([
        _fetchImage(),
      ]);
    } catch (e) {
      // _handleError(e);
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

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        if (data.isNotEmpty) {
          // Assuming there's only one item in the array
          final Map<String, dynamic> firstItem = data.first;
          setState(() {
            // Assuming profile_picture_url is the key in your API response
            profile_picture = firstItem['profile_picture'] ?? '';
            isLoading = false;
          });
        } else {}
      } else {}
    } catch (e) {}
  }

  String? profilePicture;
  String? userId;

  // Call fetchUserId method from the instance
  void editProfileImage() async {
    try {
      final pickedImage =
          await ImagePicker().pickImage(source: ImageSource.gallery);

      if (pickedImage != null) {
        String? id = await ProfileImageUploader.fetchUserId();
        if (id != null) {
          String filename = pickedImage.path.split('/').last;
          await ProfileImageUploader.uploadProfilePicture(
              File(pickedImage.path), id, filename, context);

          // After uploading the new profile picture, fetch the user ID again
          id = await ProfileImageUploader.fetchUserId();

          if (id != null) {
            // Update the UI with the new user ID
            setState(() {
              userId = id;
            });
          } else {}
        } else {}
      }
    } catch (e) {}
  }

  bool isLoading = true;
  final double cover = 130.0;
  final double img = 130.0;

  @override
  Widget build(BuildContext context) {
    final double top = cover - img / 2;

    return isLoading
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10.0),
              _buildShimmerLoading(),
            ],
          )
        : Column(
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
                    child: GestureDetector(
                      onTap: () {
                        editProfileImage();
                      },
                      child: Stack(
                        children: [
                          Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
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
                            ),
                          ),

                          Positioned.fill(
                            child: profile_picture != null
                                ? ClipOval(
                                    child: Image.network(
                                      '${URLConstants.baseUrl}/$profile_picture',
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : SizedBox(),
                          ),
                          // Camera icon
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              decoration: const BoxDecoration(
                                color: ThemeColor.app_bar,
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                icon: const Icon(
                                  Icons.camera_alt_outlined,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  editProfileImage();
                                },
                              ),
                            ),
                          ),
                        ],
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
                      '${EmployeeModel.employeeData.isNotEmpty ? EmployeeModel.employeeData[0].firstname : ''}',
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(width: 10.0),
                    Text(
                      '${EmployeeModel.employeeData.isNotEmpty ? EmployeeModel.employeeData[0].lastname : ''}',
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 18.0, vertical: 8.0),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Personal Info',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
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
                            size: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.grey.withOpacity(0.4)),
                              borderRadius: BorderRadius.circular(7),
                            ),
                            // child: Card(
                            //   color: Colors.white,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 10),
                                TextWithPadding(
                                  label: 'Employee Id',
                                  value:
                                      '${EmployeeApiProfile.employee.isNotEmpty ? EmployeeApiProfile.employee[0].id : ''}',
                                ),
                                const SizedBox(height: 10),
                                TextWithPadding(
                                    label: 'User Name',
                                    value:
                                        '${EmployeeApiProfile.employee.isNotEmpty ? EmployeeApiProfile.employee[0].username : ''}'),
                                const SizedBox(height: 10),
                                TextWithPadding(
                                  label: 'Age',
                                  value:
                                      '${EmployeeModel.employeeData.isNotEmpty ? EmployeeModel.employeeData[0].age : ''}',
                                ),
                                const SizedBox(height: 10),
                                TextWithPadding(
                                  label: 'Date of Birth',
                                  value:
                                      '${EmployeeModel.employeeData.isNotEmpty ? EmployeeModel.employeeData[0].date : ''}',
                                ),
                                const SizedBox(height: 10),
                                TextWithPadding(
                                    label: 'Email Id',
                                    value:
                                        '${EmployeeApiProfile.employee.isNotEmpty ? EmployeeApiProfile.employee[0].emailid : ''}'),
                                const SizedBox(height: 10),
                              ],
                            ),
                            // ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                // ),
              ),
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 18.0, vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Identy Information',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
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
                            size: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Container(
                      // Card(
                      //   color: Colors.white,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.withOpacity(0.4)),
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),
                          TextWithPadding(
                            label: 'UAN',
                            value:
                                '${EmployeeModel.employeeData.isNotEmpty ? EmployeeModel.employeeData[0].uan : ''}',
                          ),
                          const SizedBox(height: 15),
                          TextWithPadding(
                            label: 'PAN',
                            value:
                                '${EmployeeModel.employeeData.isNotEmpty ? EmployeeModel.employeeData[0].pan : ''}',
                          ),
                          const SizedBox(height: 15),
                          TextWithPadding(
                            label: 'Work Number',
                            value:
                                '${EmployeeModel.employeeData.isNotEmpty ? EmployeeModel.employeeData[0].workNumber : ''}',
                          ),
                          const SizedBox(height: 15),
                          TextWithPadding(
                            label: 'Personal Number',
                            value:
                                '${EmployeeModel.employeeData.isNotEmpty ? EmployeeModel.employeeData[0].personalNumber : ''}',
                          ),
                          const SizedBox(height: 15),
                          TextWithPadding(
                            label: 'Personal Email',
                            value:
                                '${EmployeeModel.employeeData.isNotEmpty ? EmployeeModel.employeeData[0].personalEmail : ''}',
                          ),
                          const SizedBox(height: 15),
                          TextWithPadding(
                            label: 'Address',
                            value:
                                '${EmployeeModel.employeeData.isNotEmpty ? EmployeeModel.employeeData[0].address : ''}',
                          ),
                          const SizedBox(height: 15),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18.0, vertical: 8.0),
                child: Row(
                  children: [
                    const Text(
                      'Education Details',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const EducationScreen(),
                          ),
                        );
                      },
                      child: const Icon(
                        Icons.add,
                        color: Colors.blue,
                        size: 18,
                      ),
                    ),
                  ],
                ),
              ),
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FutureBuilder<List<EducationDetails>>(
                      future: EducationProfile.fetchEducationData(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Container(); // Don't show any loading indicator
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else if (snapshot.hasData &&
                            snapshot.data!.isNotEmpty) {
                          // Iterate over each education item and display them individually
                          return Column(
                            children: snapshot.data!.map((education) {
                              return Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 18.0, vertical: 8.0),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.grey.withOpacity(0.4)),
                                  borderRadius: BorderRadius.circular(7),
                                ),
                                child: Stack(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            const SizedBox(width: 10),
                                            Text(
                                              education.universityName,
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black87,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 5),
                                        Row(
                                          children: [
                                            const SizedBox(width: 10),
                                            Text(
                                              education.degree,
                                              style: const TextStyle(
                                                fontSize: 14,
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            Text(
                                              education.specialization,
                                              style: const TextStyle(
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            const SizedBox(width: 10),
                                            const Text(
                                              'Complete Year',
                                              style: TextStyle(
                                                fontSize: 14,
                                              ),
                                            ),
                                            Text(
                                              education.completeyear,
                                              style: const TextStyle(
                                                fontSize: 14,
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
                                          size: 16,
                                          color: ThemeColor.app_bar,
                                        ),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            PageTransition(
                                              type: PageTransitionType
                                                  .rightToLeft,
                                              duration: const Duration(
                                                  milliseconds: 300),
                                              child: EducationEditScreen(
                                                educationData: {
                                                  'id': education.id,
                                                  'institute_name':
                                                      education.universityName,
                                                  'degree_diploma':
                                                      education.degree,
                                                  'specialization':
                                                      education.specialization,
                                                  'date_of_completion':
                                                      education.completeyear,
                                                  'cgpa': education.cgpa,
                                                },
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          );
                        } else {
                          return Container(
                            height: 100,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 18.0, vertical: 8.0),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.grey.withOpacity(0.4)),
                              borderRadius: BorderRadius.circular(7),
                            ),
                            child: const Center(
                              child: Text(
                                'No data found',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),

              // const SizedBox(height: 15),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18.0, vertical: 8.0),
                child: Row(
                  children: [
                    const Text(
                      'Add Your Skills',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const Spacer(),
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
                        Icons.add,
                        color: Colors.blue,
                        size: 18,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: certificate.isNotEmpty
                    ? certificate.map((certificate) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.grey.withOpacity(0.4)),
                                borderRadius: BorderRadius.circular(7),
                              ),
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 18.0, vertical: 8.0),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Stack(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            const SizedBox(width: 10),
                                            Text(
                                              certificate.sslcCertificate
                                                  .toString(),
                                              style: const TextStyle(
                                                fontSize: 14,
                                                // fontWeight: FontWeight.bold,
                                                // color: Colors.black87,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 5),
                                        Row(
                                          children: [
                                            const SizedBox(width: 10),
                                            Text(
                                              certificate.hscCertificate,
                                              style: const TextStyle(
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(width: 10),
                                        Row(
                                          children: [
                                            const SizedBox(width: 10),
                                            Text(
                                              certificate.ugCertificate,
                                              style: const TextStyle(
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(width: 10),
                                        Row(
                                          children: [
                                            const SizedBox(width: 10),
                                            Text(
                                              certificate.pgCertificate,
                                              style: const TextStyle(
                                                fontSize: 14,
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
                                          size: 16,
                                          color: ThemeColor.app_bar,
                                        ),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            PageTransition(
                                              type: PageTransitionType
                                                  .rightToLeft,
                                              duration: const Duration(
                                                  milliseconds: 300),
                                              child: const SkillsScreen(),
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
                      }).toList()
                    : [
                        Container(
                          height: 100,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 18.0, vertical: 8.0),
                          decoration: BoxDecoration(
                            border:
                                Border.all(color: Colors.grey.withOpacity(0.4)),
                            borderRadius: BorderRadius.circular(7),
                          ),
                          child: const Center(
                            child: Text(
                              'No data found',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18.0, vertical: 8.0),
                child: Row(
                  children: [
                    const Text(
                      'Add Your Certificate',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const Spacer(),
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
                        Icons.add,
                        color: Colors.blue,
                        size: 18,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: certificate.isNotEmpty
                    ? certificate.map((certificate) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.grey.withOpacity(0.4)),
                                borderRadius: BorderRadius.circular(7),
                              ),
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 18.0, vertical: 8.0),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Stack(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            const SizedBox(width: 10),
                                            Text(
                                              certificate.sslcCertificate
                                                  .toString(),
                                              style: const TextStyle(
                                                fontSize: 14,
                                                // fontWeight: FontWeight.bold,
                                                // color: Colors.black87,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 5),
                                        Row(
                                          children: [
                                            const SizedBox(width: 10),
                                            Text(
                                              certificate.hscCertificate,
                                              style: const TextStyle(
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(width: 10),
                                        Row(
                                          children: [
                                            const SizedBox(width: 10),
                                            Text(
                                              certificate.ugCertificate,
                                              style: const TextStyle(
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(width: 10),
                                        Row(
                                          children: [
                                            const SizedBox(width: 10),
                                            Text(
                                              certificate.pgCertificate,
                                              style: const TextStyle(
                                                fontSize: 14,
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
                                          size: 16,
                                          color: ThemeColor.app_bar,
                                        ),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            PageTransition(
                                              type: PageTransitionType
                                                  .rightToLeft,
                                              duration: const Duration(
                                                  milliseconds: 300),
                                              child: const CertificateScreen(),
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
                      }).toList()
                    : [
                        Container(
                          height: 100,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 18.0, vertical: 8.0),
                          decoration: BoxDecoration(
                            border:
                                Border.all(color: Colors.grey.withOpacity(0.4)),
                            borderRadius: BorderRadius.circular(7),
                          ),
                          child: const Center(
                            child: Text(
                              'No data found',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18.0, vertical: 8.0),
                child: Row(
                  children: [
                    const Text(
                      'Add Your Family Info',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const Spacer(),
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
                        Icons.add,
                        color: Colors.blue,
                        size: 18,
                      ),
                    ),
                  ],
                ),
              ),
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FutureBuilder<List<FamilyDetails>>(
                      future: FamilyApiHandler.fetchFamily(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Container(); // Don't show any loading indicator
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else if (snapshot.hasData &&
                            snapshot.data!.isNotEmpty) {
                          // Iterate over each education item and display them individually
                          return Column(
                            children: snapshot.data!.map((familyDetails) {
                              return Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 18.0, vertical: 8.0),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.grey.withOpacity(0.4)),
                                  borderRadius: BorderRadius.circular(7),
                                ),
                                child: Stack(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            const SizedBox(width: 10),
                                            Text(
                                              familyDetails.name,
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black87,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 5),
                                        Row(
                                          children: [
                                            const SizedBox(width: 10),
                                            const Text(
                                              'Relation:',
                                              style: TextStyle(
                                                fontSize: 14,
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            Text(
                                              familyDetails.relation,
                                              style: const TextStyle(
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            const SizedBox(width: 10),
                                            Text(
                                              familyDetails.phoneNumber,
                                              style: const TextStyle(
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            const SizedBox(width: 10),
                                            Text(
                                              familyDetails.address,
                                              style: const TextStyle(
                                                fontSize: 14,
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
                                          size: 16,
                                          color: ThemeColor.app_bar,
                                        ),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            PageTransition(
                                              type: PageTransitionType
                                                  .rightToLeft,
                                              duration: const Duration(
                                                  milliseconds: 300),
                                              child: FamilyEditScreen(
                                                familyData: {
                                                  'name': familyDetails.name,
                                                  'relationship':
                                                      familyDetails.relation,
                                                  'phone_number':
                                                      familyDetails.phoneNumber,
                                                  'address':
                                                      familyDetails.address,
                                                },
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          );
                        } else {
                          return Container(
                            height: 100,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 18.0, vertical: 8.0),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.grey.withOpacity(0.4)),
                            ),
                            child: const Center(
                              child: Text(
                                'No data found',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18.0, vertical: 8.0),
                child: Row(
                  children: [
                    const Text(
                      'Work Experience',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const WorkScreen(),
                          ),
                        );
                      },
                      child: const Icon(
                        Icons.add,
                        color: Colors.blue,
                        size: 18,
                      ),
                    ),
                  ],
                ),
              ),
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FutureBuilder<List<WorkExperience>>(
                      future: workProfile.fetchWorkExperience(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Container(); // Don't show any loading indicator
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else if (snapshot.hasData &&
                            snapshot.data!.isNotEmpty) {
                          // Iterate over each education item and display them individually
                          return Column(
                            children: snapshot.data!.map((work) {
                              return Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 18.0, vertical: 8.0),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.grey.withOpacity(0.4)),
                                  borderRadius: BorderRadius.circular(7),
                                ),
                                child: Stack(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            const SizedBox(width: 10),
                                            Text(
                                              work.designation,
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black87,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 5),
                                        Row(
                                          children: [
                                            const SizedBox(width: 10),
                                            Text(
                                              work.companyName,
                                              style: const TextStyle(
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            const SizedBox(width: 10),
                                            Text(
                                              work.fromDate,
                                              style: const TextStyle(
                                                fontSize: 14,
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            Text(
                                              work.toDate,
                                              style: const TextStyle(
                                                fontSize: 14,
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
                                          size: 16,
                                          color: ThemeColor.app_bar,
                                        ),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            PageTransition(
                                              type: PageTransitionType
                                                  .rightToLeft,
                                              duration: const Duration(
                                                  milliseconds: 300),
                                              child: WorkExperienceEditScreen(
                                                workExperienceData: {
                                                  'id': work.id,
                                                  'company_name':
                                                      work.companyName,
                                                  'designation':
                                                      work.designation,
                                                  'from_date': work.fromDate,
                                                  'to_date': work.toDate,
                                                  'description':
                                                      work.description,
                                                  'relavent': work.relevant,
                                                  'verify_person_name':
                                                      work.personName,
                                                  'verify_person_contact':
                                                      work.personContact,
                                                },
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          );
                        } else {
                          return Container(
                            height: 100,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 18.0, vertical: 8.0),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.grey.withOpacity(0.4)),
                              borderRadius: BorderRadius.circular(7),
                            ),
                            child: const Center(
                              child: Text(
                                'No data found',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
  }

  Widget _buildShimmerLoading() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 10.0),
        _buildCircularShimmerLoading(),
        _buildShimmerLoadingRow(),
        _buildShimmerLoadingRow(),
        _buildShimmerLoadingRow(),
        _buildShimmerLoadingRow(),
        _buildShimmerLoadingRow(),
        _buildShimmerLoadingRow(),
      ],
    );
  }

  Widget _buildCircularShimmerLoading() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      height: 120,
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        period: const Duration(seconds: 1),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: Colors.grey[100]!,
              radius: 60,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerLoadingRow() {
    return SizedBox(
      height: 120,
      child: Card(
        elevation: 1,
        margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
        child: Row(
          children: [
            SizedBox(
              width: 120,
              child: CircleAvatar(
                backgroundColor: Colors.grey[100]!,
                radius: 40,
              ),
            ),
            Expanded(
              child: ListTile(
                title: Container(
                  color: Colors.white,
                  height: 16,
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      color: Colors.white,
                      height: 16,
                    ),
                    Container(
                      color: Colors.white,
                      height: 14,
                    ),
                    Container(
                      color: Colors.white,
                      height: 14,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
