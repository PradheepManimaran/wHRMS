import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:wHRMS/ThemeColor/theme.dart';
import 'package:wHRMS/apiHandlar/editApi.dart';

import 'package:shared_preferences/shared_preferences.dart';

class EducationEditScreen extends StatefulWidget {
  final Map<String, dynamic> educationData;
  const EducationEditScreen({super.key, required this.educationData});

  @override
  State<EducationEditScreen> createState() => _EducationEditScreen();
}

class _EducationEditScreen extends State<EducationEditScreen> {
  //Education Details Controller's
  TextEditingController institutenameController = TextEditingController();
  TextEditingController degreeController = TextEditingController();
  TextEditingController specializationController = TextEditingController();
  TextEditingController completionDateController = TextEditingController();
  TextEditingController cgpaController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? token;

  final Logger _logger = Logger();

  int currentSection = 1;
  bool isLastSection = false;

  bool isSameAsPresentAddress = false;
  bool isFresher = false;

  bool isAdditionalFieldsAdded = false;

  @override
  void initState() {
    super.initState();
    _initController();
  }

  void _initController() {
    institutenameController.text = widget.educationData['institute_name'] ?? '';
    degreeController.text = widget.educationData['degree_diploma'] ?? '';
    specializationController.text =
        widget.educationData['specialization'] ?? '';
    completionDateController.text =
        widget.educationData['date_of_completion'] ?? '';
    cgpaController.text = widget.educationData['cgpa'] ?? '';
    // selectedRelevant = widget.workExperienceData['relevant'] ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Edit Profile',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          // centerTitle: true,
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
                  _buildProfileFields(),
                  const SizedBox(height: 30),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: SizedBox(
                      width: 340.0,
                      height: 60.0,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _nextSection();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6.0),
                          ),
                          backgroundColor: ThemeColor.btn_color,
                        ),
                        child: Text(
                          isLastSection ? 'Submit' : 'Submit',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  Future<String?> getAuthToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  bool areFieldsRequiredFilled() {
    return !institutenameController.text.isEmpty &&
        !degreeController.text.isEmpty &&
        !specializationController.text.isEmpty &&
        !completionDateController.text.isEmpty &&
        !cgpaController.text.isEmpty;
  }

  void _nextSection() async {
    try {
      print('Profile Details Complete');

      if (!areFieldsRequiredFilled()) {
        // Display an error message using ScaffoldMessenger
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please fill in all the required fields.'),
          ),
        );
        return;
      }

      final instituteName = institutenameController.text;
      final degree = degreeController.text;
      final spec = specializationController.text;
      final completeDate = completionDateController.text;
      final cgpa = cgpaController.text;

      final educationId = widget.educationData['id'].toString();
      _logger.d('Testing ');

      // Call the educationData method from the class UpdateEducationApi
      await UpdateEducationApi.educationData({
        'institute_name': instituteName,
        'degree_diploma': degree,
        'specialization': spec,
        'date_of_completion': completeDate,
        'cgpa': cgpa,
      }, educationId, context);

      // Handle any additional logic or UI updates after the update
    } catch (e) {
      print('Error in _nextSection: $e');
    }
  }

  Widget _buildProfileFields() {
    switch (currentSection) {
      case 1:
        return _buildEducationFields();

      default:
        return Container();
    }
  }

  //Education Details
  Widget _buildEducationFields() {
    return Column(
      children: [
        const SizedBox(height: 15),
        const Text(
          'Education Details',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 15),
        _buildTextField(
          hintText: 'Institute Name',
          prefixIconData: Icons.location_city,
          controller: institutenameController,
          fieldName: 'Institute Name',
        ),
        const SizedBox(height: 15),
        _buildTextField(
          hintText: 'Degree/Diploma',
          prefixIconData: Icons.cast_for_education_sharp,
          controller: degreeController,
          fieldName: 'Degree/Diploma',
        ),
        const SizedBox(height: 15),
        _buildTextField(
          hintText: 'Specialization',
          prefixIconData: Icons.cast_for_education,
          controller: specializationController,
          fieldName: 'Specialization',
        ),
        const SizedBox(height: 15),
        _buildDateFields('Date Of Completion', completionDateController),
        const SizedBox(height: 15),
        _buildTextField(
          hintText: 'CGPA',
          prefixIconData: Icons.cast_for_education,
          controller: cgpaController,
          fieldName: 'CGPA',
        ),
        const SizedBox(height: 130),
      ],
    );
  }

  //Common TextField Method
  Widget _buildTextField({
    TextEditingController? controller,
    String hintText = 'Enter text here',
    IconData? prefixIconData,
    required String fieldName,
    // bool readOnly = false, // Add this line
  }) {
    return Center(
      child: TextFormField(
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
              color: Colors.black,
              width: 2.0,
            ),
          ),
          filled: true,
          fillColor: ThemeColor.TextFieldColor,
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $fieldName';
          }
          return null;
        },
      ),
    );
  }

  //Date method in From Date, To Date
  Widget _buildDateFields(String hintText, TextEditingController controller) {
    return SizedBox(
      // width: 160,
      child: TextField(
        controller: controller,
        readOnly: true, // Make the field read-only
        decoration: InputDecoration(
          prefixIcon: const Icon(
            Icons.date_range,
            // color: Colors.blue,
          ),
          hintText: hintText,
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          labelStyle: const TextStyle(fontSize: 10),
          border: const OutlineInputBorder(),
          filled: true,
          fillColor: ThemeColor.TextFieldColor,
        ),
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(3000),
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
