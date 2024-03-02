import 'package:wHRMS/Components/employees.dart';
import 'package:wHRMS/objects/education.dart';
import 'package:wHRMS/objects/work_experience.dart';

class Employee {
  final int id;
  final String username;
  final String email;
  final String employeeId;
  final String phoneNumber;
  final String role;
  final String department;
  final String designation;
  final String enrollmentType;
  final String enrollmentStatus;
  final String sourceHire;
  final String dateOfJoining;
  final List<UserProfilePicture> userProfilePicture;
  final List<WorkExperience> workExperience;
  final List<EducationDetails> education;

  Employee({
    required this.id,
    required this.username,
    required this.email,
    required this.employeeId,
    required this.phoneNumber,
    required this.role,
    required this.department,
    required this.designation,
    required this.enrollmentType,
    required this.enrollmentStatus,
    required this.sourceHire,
    required this.dateOfJoining,
    required this.userProfilePicture,
    required this.workExperience,
    required this.education,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      employeeId: json['employee_id'],
      phoneNumber: json['phone_number'],
      role: json['role']['name'],
      department: json['department']['name'],
      designation: json['designation']['name'],
      enrollmentType: json['enrollment_type']['name'],
      enrollmentStatus: json['enrollment_status']['name'],
      sourceHire: json['source_hire']['name'],
      dateOfJoining: json['date_of_joining'],
      userProfilePicture: json['user_profile_picture'] != null
          ? List<UserProfilePicture>.from(json['user_profile_picture']
              .map((x) => UserProfilePicture.fromJson(x)))
          : [],
      workExperience: json['work_experience'] != null
          ? List<WorkExperience>.from(
              json['work_experience'].map((x) => WorkExperience.fromJson(x)))
          : [],
      education: json['education'] != null
          ? List<EducationDetails>.from(
              json['education'].map((x) => EducationDetails.fromJson(x)))
          : [],
    );
  }
}
