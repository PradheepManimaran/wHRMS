import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:wHRMS/ThemeColor/theme.dart';
import 'package:wHRMS/apiHandlar/editApi.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WorkExperienceEditScreen extends StatefulWidget {
  final Map<String, dynamic> workExperienceData;

  const WorkExperienceEditScreen({super.key, required this.workExperienceData});

  @override
  State<WorkExperienceEditScreen> createState() => _WorkEditScreenState();
}

class _WorkEditScreenState extends State<WorkExperienceEditScreen> {
  TextEditingController fromDateController = TextEditingController();
  TextEditingController toDateController = TextEditingController();

  //Work Experience Controller's
  TextEditingController companynameController = TextEditingController();
  TextEditingController jobtitleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController personNameController = TextEditingController();
  TextEditingController personContactController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // final Logger _logger = Logger();
  String? selectRelevant;
  int currentSection = 1;
  bool isLastSection = false;

  bool isSameAsPresentAddress = false;
  bool isFresher = false;

  bool isAdditionalFieldsWork = false;

  bool? selectedRelevant;
  List<bool> relevant = [false, true];

  @override
  void initState() {
    super.initState();
    _initControllers();
  }

  void _initControllers() {
    companynameController.text =
        widget.workExperienceData['company_name'] ?? '';
    jobtitleController.text = widget.workExperienceData['designation'] ?? '';
    fromDateController.text = widget.workExperienceData['from_date'] ?? '';
    toDateController.text = widget.workExperienceData['to_date'] ?? '';
    descriptionController.text = widget.workExperienceData['description'] ?? '';
    bool selectRelevant = widget.workExperienceData['relavent'] ?? false;
    personNameController.text =
        widget.workExperienceData['verify_person_name'] ?? '';
    personContactController.text =
        widget.workExperienceData['verify_person_contact'] ?? '';

    // print('Company Name: ${companynameController.text}');
    // print('Job Title: ${jobtitleController.text}');
    // print('From Date: ${fromDateController.text}');
    // print('To Date: ${toDateController.text}');
    // print('Description: ${descriptionController.text}');
    print('Select Relevant: $selectRelevant');
    // print('Person Name: ${personContactController.text}');
    // print('Person Contact: ${personContactController.text}');
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
                    width: double.infinity,
                    height: 60.0,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _nextSection();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(1.0),
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
      ),
    );
  }

  Future<String?> getAuthToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  void _nextSection() async {
    if (currentSection < 1) {
      setState(() {
        currentSection++;
        isLastSection = currentSection == 1;
      });
    } else {
      try {
        // print('Profile Details Complete');

        // Retrieve the token from SharedPreferences
        String? token = await getAuthToken();

        // Check if token is not null before making the API call
        if (token == null) {
          // print('Error: Token is null.');
          return;
        }

        // Retrieve the ID of the work experience being edited
        String workExperienceId = widget.workExperienceData['id'].toString();

        // print(
        //     'Work Experience ID: $workExperienceId'); // Print the workExperienceId

        if (!_validateWorkExperienceFields()) {
          // Display an error message using ScaffoldMessenger
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Please fill in all the required fields.'),
            ),
          );
          return;
        }

        final comname = companynameController.text;
        final designation = jobtitleController.text;
        final fromDate = fromDateController.text;
        final toDate = toDateController.text;
        final description = descriptionController.text;
        final relevant = selectedRelevant;
        final personName = personNameController.text;
        final personContact = personContactController.text;
        final tableid = workExperienceId;
        // _logger.d(
        //     'Testing Id: $tableid,COM NAME: $comname,DEG: $designation,FROM Date: $fromDate,TO Date: $toDate,Job: $description,Selecte: $relevant');
        // Call the updateWorkData method from the class UpdateWorkApi
        // ignore: use_build_context_synchronously
        await UpdateWorkApi.updateWorkData({
          'company_name': comname,
          'designation': designation,
          'from_date': fromDate,
          'to_date': toDate,
          'description': description,
          'relavent': relevant,
          'verify_person_name': personName,
          'verify_person_contact': personContact,
          'table_id': tableid
        }, context);

        // Handle any additional logic or UI updates after the update
      } catch (e) {
        // print('Error in _nextSection: $e');
      }
    }
  }

  bool _validateWorkExperienceFields() {
    // Perform validation for work experience fields
    if (isFresher) {
      return true; // No validation needed for fresher
    } else {
      if (companynameController.text.isEmpty ||
          jobtitleController.text.isEmpty ||
          fromDateController.text.isEmpty ||
          toDateController.text.isEmpty ||
          descriptionController.text.isEmpty) {
        return false;
      }
    }
    return true;
  }

  Widget _buildProfileFields() {
    switch (currentSection) {
      case 1:
        return _buildWorkExperienceFields();

      default:
        return Container();
    }
  }

  //Work Experience's
  Widget _buildWorkExperienceFields() {
    return Column(
      children: [
        const SizedBox(height: 15),
        const Text(
          'Work Experience',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 15),
        _buildTextField(
          hintText: 'Company Name',
          prefixIconData: Icons.business,
          controller: companynameController,
          fieldName: 'Company Name',
        ),
        const SizedBox(height: 15),
        _buildTextField(
          hintText: 'Job Title',
          prefixIconData: Icons.work,
          controller: jobtitleController,
          fieldName: 'Job Title',
        ),
        const SizedBox(height: 15),
        _buildDateFields('From Date', fromDateController),
        const SizedBox(height: 15),
        _buildDateFields('To Date', toDateController),
        const SizedBox(height: 15),
        _buildTextField(
          hintText: 'Job Description',
          prefixIconData: Icons.description,
          controller: descriptionController,
          fieldName: 'Job Description',
        ),
        const SizedBox(height: 15),
        buildDropdownFormFieldss(
          items: relevant,
          selectedValue: selectedRelevant,
          hintText: 'Select relevant',
          onChanged: (value) {
            setState(() {
              selectedRelevant = value;
            });
          },
          prefixIconData: Icons.check,
        ),
        const SizedBox(height: 15),
        _buildTextField(
          hintText: 'Person Name',
          prefixIconData: Icons.business,
          controller: personNameController,
          fieldName: 'Person Name',
        ),
        const SizedBox(height: 15),
        _buildTextField(
          hintText: 'Person Contact',
          prefixIconData: Icons.business,
          controller: personContactController,
          fieldName: 'Person Contact',
        ),
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
              width: 1.0,
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

  buildDropdownFormFieldss({
    required List<bool> items,
    required bool? selectedValue,
    required String hintText,
    required Function(bool?) onChanged,
    required IconData prefixIconData,
  }) {
    return DropdownButtonFormField<bool>(
      value: selectedValue,
      items: items.map((bool value) {
        return DropdownMenuItem<bool>(
          value: value,
          child: Text(value ? 'True' : 'False'),
        );
      }).toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hintText,
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
        prefixIcon: Icon(prefixIconData),
        border: OutlineInputBorder(),
      ),
    );
  }

  // Method to convert boolean value to 0 or 1 for server side
  int convertToServerValue(bool? value) {
    return value == true ? 1 : 0;
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
