import 'package:flutter/material.dart';
import 'package:wHRMS/Components/employees.dart';
import 'package:wHRMS/Components/information_widget.dart';
import 'package:wHRMS/ThemeColor/theme.dart';

class UserListScreen extends StatefulWidget {
  final Employee employee;

  const UserListScreen({
    Key? key,
    required this.employee,
  }) : super(key: key);

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  final double cover = 130.0;
  final double img = 130.0;
  @override
  Widget build(BuildContext context) {
    final double top = cover - img / 2;
    String? profilePictureUrl = widget.employee.userProfilePicture.isNotEmpty
        ? widget.employee.userProfilePicture[0].profilePicture
        : null;

    print('Profile Picture URL: $profilePictureUrl');

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Employee Details',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: ThemeColor.app_bar,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: SingleChildScrollView(
          // padding: const EdgeInsets.all(18.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
                        backgroundImage: NetworkImage('$profilePictureUrl'),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 70),
              const Text(
                'Employee Details',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 20),
              TextWithPadding(
                label: 'Name:',
                value: widget.employee.username,
              ),
              // const SizedBox(height: 15),
              TextWithPadding(
                label: 'Email:',
                value: widget.employee.email,
              ),
              TextWithPadding(
                label: 'Role:',
                value: widget.employee.role.toString(),
              ),
              // const SizedBox(height: 15),
              TextWithPadding(
                label: 'Phone Number:',
                value: widget.employee.phoneNumber,
              ),
              const SizedBox(height: 15),
              TextWithPadding(
                label: 'Date Of Joining:',
                value: widget.employee.dateOfJoining,
              ),
              const SizedBox(height: 20),
              const Text(
                'Work Experience',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 20),
              // Iterate over each work experience and display it
              Column(
                children: widget.employee.workExperience.map((experience) {
                  return Card(
                    // margin:
                    //     const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    // child: Padding(
                    //   padding: const EdgeInsets.all(16),
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextWithPadding(
                          label: 'Company Name:',
                          value: experience.companyName,
                        ),
                        TextWithPadding(
                          label: 'Designation: ',
                          value: experience.designation,
                        ),
                        TextWithPadding(
                            label: 'From Date:  ', value: experience.fromDate),
                        TextWithPadding(
                          label: 'To Date:',
                          value: experience.toDate,
                        ),
                        TextWithPadding(
                          label: 'Description: ',
                          value: experience.description,
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              const Text(
                'Education Information',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 20),
              Column(
                children: widget.employee.education.map((experience) {
                  return Card(
                    // margin:
                    //     const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    // child: Padding(
                    //   padding: const EdgeInsets.all(16),
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextWithPadding(
                          label: 'University Name:',
                          value: experience.universityName,
                        ),
                        TextWithPadding(
                          label: 'Degree: ',
                          value: experience.degree,
                        ),
                        TextWithPadding(
                          label: 'Specialization:',
                          value: experience.specialization,
                        ),
                        TextWithPadding(
                          label: 'CGPA: ',
                          value: experience.cgpa,
                        ),
                        TextWithPadding(
                          label: 'complete Year:',
                          value: experience.completeyear,
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
