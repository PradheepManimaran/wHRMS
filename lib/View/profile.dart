import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:wHRMS/ThemeColor/theme.dart';
import 'package:wHRMS/apiHandlar/userProfile.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  //Personal Information Controller's
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController dateOfBirthController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController aboutmeController = TextEditingController();

  //Identity Information Controller's
  TextEditingController uanController = TextEditingController();
  TextEditingController panController = TextEditingController();
  TextEditingController aadharController = TextEditingController();

  //Image Upload Controller's
  TextEditingController aadharCardController = TextEditingController();
  TextEditingController photoController = TextEditingController();

  //Address present Controller's
  TextEditingController presentAddressLine1Controller = TextEditingController();
  TextEditingController presentAddressLine2Controller = TextEditingController();
  TextEditingController presentCityController = TextEditingController();
  TextEditingController presentStateController = TextEditingController();
  TextEditingController presentCountryController = TextEditingController();
  TextEditingController presentPinCodeController = TextEditingController();
  // TextEditingController pincodeController = TextEditingController();

  //permanet address Controller's
  TextEditingController permanentAddressLine1Controller =
      TextEditingController();
  TextEditingController permanentAddressLine2Controller =
      TextEditingController();
  TextEditingController permanentCityController = TextEditingController();
  TextEditingController permanentStateController = TextEditingController();
  TextEditingController permanentCountryController = TextEditingController();
  TextEditingController permanentPinCodeController = TextEditingController();
  //Contact Details Controller's
  TextEditingController workNumberController = TextEditingController();
  TextEditingController personalNumberController = TextEditingController();
  TextEditingController personalEmailController = TextEditingController();
  String? selectedCountry; // Added this line for the selected country
  String? selectedState;
  String? selectedCity;
  String? pinCode;
  //Date Controller's

  TextEditingController fromDateController = TextEditingController();
  TextEditingController toDateController = TextEditingController();
  // TextEditingController completionDateController = TextEditingController();

  //Work Experience Controller's
  TextEditingController companynameController = TextEditingController();
  TextEditingController jobtitleController = TextEditingController();
  TextEditingController jobdecController = TextEditingController();
  TextEditingController desController = TextEditingController();
  TextEditingController personNameController = TextEditingController();
  TextEditingController personalContactController = TextEditingController();
  TextEditingController personPhoneController = TextEditingController();
  TextEditingController personEmailController = TextEditingController();

  //Education Details Controller's
  TextEditingController institutenameController = TextEditingController();
  TextEditingController degreeController = TextEditingController();
  TextEditingController specializationController = TextEditingController();
  TextEditingController dateofcompletionController = TextEditingController();
  TextEditingController cgpaController = TextEditingController();
  File? adharCardImage;
  File? profilePictureImage;
  String? errorMessage;
  //Image Picking
  Future<String?> _pickImage(TextEditingController controller) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png'],
      );

      if (result != null) {
        PlatformFile file = result.files.first;

        // Extract file name from the file path
        String fileName = file.name;

        // Update the text controller with the file name
        controller.text = fileName;

        // Return the file path
        return file.path!;
      } else {
        print("No file picked");
        return null;
      }
    } catch (e) {
      print("Error picking image: $e");
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    _setupPresentAddressListeners();
  }

  void _setupPresentAddressListeners() {
    presentAddressLine1Controller.addListener(() => _copyPresentToPermanent(
        presentAddressLine1Controller, permanentAddressLine1Controller));
    presentAddressLine2Controller.addListener(() => _copyPresentToPermanent(
        presentAddressLine2Controller, permanentAddressLine2Controller));
    presentCityController.addListener(() => _copyPresentToPermanent(
        presentCityController, permanentCityController));
    presentStateController.addListener(() => _copyPresentToPermanent(
        presentStateController, permanentStateController));
    presentCountryController.addListener(() => _copyPresentToPermanent(
        presentCountryController, permanentCountryController));
    presentPinCodeController.addListener(() => _copyPresentToPermanent(
        presentPinCodeController, permanentPinCodeController));
  }

  void _copyPresentToPermanent(TextEditingController presentController,
      TextEditingController permanentController) {
    if (isSameAsPresentAddress) {
      permanentController.text = presentController.text;
    }
  }

  int userId = 1;
  int educationId = 1;
  final int totalFields = 4;
  int filledFields = 0;

  int currentSection = 1;
  bool isLastSection = false;

  bool isSameAsPresentAddress = false;
  bool isFresher = false;

  bool isAdditionalFieldsAdded = false;
  bool isAdditionalFieldsWork = false;

  String? selectedRole;
  String? selectedStatus;
  final List<String> genderOptions = ['Male', 'Female'];
  final List<String> statusOptions = ['Single', 'Married'];

  bool? selectedRelevant;
  List<bool> relevant = [false, true];
  int convertToServerValue(bool? value) {
    return value == true ? 1 : 0;
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void incrementFilledFields() {
    setState(() {
      filledFields++;
    });
  }

  // Calculate the percentage of completion
  double calculateCompletionPercentage() {
    return (filledFields / totalFields) * 100;
  }

  @override
  Widget build(BuildContext context) {
    double completionPercentage = calculateCompletionPercentage();

    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Profile',
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
                  LinearProgressIndicator(
                    value: completionPercentage / 100,
                    backgroundColor: Colors.green[300],
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                  ),
                  const SizedBox(height: 15.0),
                  Text(
                    'Profile Completion: ${completionPercentage.toStringAsFixed(2)}%',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  // const SizedBox(height: 15.0),
                  _buildProfileFields(),
                  const SizedBox(height: 30),
                  // Align(
                  //   alignment: Alignment.bottomCenter,
                  //   child: SizedBox(
                  //     width: 340.0,
                  //     height: 60.0,
                  //     child: ElevatedButton(
                  //       onPressed: () {
                  //         if (_formKey.currentState!.validate()) {
                  //           _nextSection();
                  //         }
                  //       },
                  //       style: ElevatedButton.styleFrom(
                  //         shape: RoundedRectangleBorder(
                  //           borderRadius: BorderRadius.circular(6.0),
                  //         ),
                  //         backgroundColor: ThemeColor.btn_color,
                  //       ),
                  //       child: Text(
                  //         isLastSection ? 'Submit' : 'Next',
                  //         style: const TextStyle(
                  //           color: Colors.white,
                  //           fontWeight: FontWeight.bold,
                  //           fontSize: 20,
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  bottomNavigationButtons(),
                ],
              ),
            ),
          ),
        ));
  }

  void _previousSection() async {
    setState(() {
      if (currentSection > 1) {
        currentSection--;
        isLastSection = false;
      }
    });
  }

  Widget bottomNavigationButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Previous Button
        ElevatedButton(
          onPressed: _previousSection,
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6.0),
            ),
            backgroundColor: Colors.grey,
          ),
          child: const Text(
            'Previous',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),

        // Next/Submit Button
        isLastSection
            ? ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _submitForm();
                  }
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6.0),
                  ),
                  backgroundColor: ThemeColor.btn_color,
                ),
                child: const Text(
                  'Submit',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              )
            : ElevatedButton(
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
                child: const Text(
                  'Next',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
      ],
    );
  }

  void _submitForm() {
    try {
      print('Form submitted!');
      _nextSection();
    } catch (e) {
      print('Error submitting form: $e');
    }
  }

  List<dynamic> getTextFieldsValues() {
    return [
      firstNameController.text,
      lastNameController.text,
      // selectedRole ?? '',
      // selectedStatus ?? '',
      uanController.text,
      panController.text,
      // workNumberController.text,
      // personalNumberController.text,
      // personalEmailController.text,
      presentAddressLine1Controller.text,
      presentAddressLine2Controller.text,
      presentCityController.text,
      presentStateController.text,
      presentCountryController.text,
      presentPinCodeController.text,
      isSameAsPresentAddress
          ? presentAddressLine1Controller.text
          : permanentAddressLine1Controller.text,
      isSameAsPresentAddress
          ? presentAddressLine2Controller.text
          : permanentAddressLine2Controller.text,
      isSameAsPresentAddress
          ? presentCityController.text
          : permanentCityController.text,
      isSameAsPresentAddress
          ? presentStateController.text
          : permanentStateController.text,
      isSameAsPresentAddress
          ? presentCountryController.text
          : permanentCountryController.text,
      isSameAsPresentAddress
          ? presentPinCodeController.text
          : permanentPinCodeController.text,
      workNumberController.text,
      personalNumberController.text,
      personalEmailController.text,
    ];
  }

  void _nextSection() async {
    try {
      if (currentSection < 5) {
        // Move to the next section
        setState(() {
          currentSection++;
          isLastSection = currentSection == 5;
          incrementFilledFields();
        });
      } else {
        print('Profile Details Complete');

        // Prepare the postData map
        List<dynamic> textFieldValues = getTextFieldsValues();

        // Check if any required field is empty
        bool isAnyFieldEmpty =
            textFieldValues.any((value) => value == null || value == '');

        if (isAnyFieldEmpty) {
          // Display an error message and prevent moving to the next section
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Error: Please fill in all required fields.'),
            ),
          );
          return;
        } else {
          // Clear any previous error messages
          setState(() {
            errorMessage = null;
          });
        }

        // Extract date of birth and age
        final dob = dateOfBirthController.text;
        final age = ageController.text;
        final worknum = workNumberController.text;
        final pernum = personalNumberController.text;
        final peremail = personalEmailController.text;
        final uan = uanController.text;
        final pan = panController.text;
        final address = presentAddressLine1Controller.text;
        final address2 = presentAddressLine2Controller.text;
        final city = presentCityController.text;
        final state = presentStateController.text;
        final country = presentCountryController.text;
        final pinCode = presentPinCodeController.text;

        // Check if any of the text fields are empty
        if (dob.isEmpty ||
            age.isEmpty ||
            worknum.isEmpty ||
            pernum.isEmpty ||
            peremail.isEmpty ||
            uan.isEmpty ||
            pan.isEmpty ||
            address.isEmpty) {
          // Display an error message and prevent moving to the next section
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Error: Please fill in all required fields.'),
            ),
          );
          return;
        } else {
          // Clear any previous error messages
          setState(() {
            errorMessage = null;
          });
        }
        // Create postData map
        Map<String, dynamic> postData = {
          'first_name': textFieldValues[0],
          'last_name': textFieldValues[1],
          'gender': selectedRole,
          'age': age,
          'marital_status': textFieldValues[4],
          'uan': uan,
          'pan': pan,
          'working_phone': worknum,
          'personal_phone': pernum,
          'personal_email': peremail,
          'address': '$address,$address2,$city,$state,$country,$pinCode',
          'date_of_birth': dob,
          'about_us': aboutmeController.text,
        };

        // Upload images if available
        if (profilePictureImage != null) {
          await ImageUpload.uploadImages(profilePictureImage!);
        }

        if (adharCardImage != null) {
          await AadharImage.uploadAadharImages(adharCardImage!);
        }

        // Extract work and education data
        List<String> workData = [
          companynameController.text,
          desController.text,
          fromDateController.text,
          toDateController.text,
          jobtitleController.text,
          personNameController.text,
          personalContactController.text,
          personPhoneController.text,
          personEmailController.text,
        ];

        List<String> educationData = [
          institutenameController.text,
          degreeController.text,
          specializationController.text,
          dateofcompletionController.text,
          cgpaController.text,
        ];

        // Call the postData method from ApiHelper
        await ApiHelper.postData(postData, context);

        int serverValue =
            selectedRelevant != null ? (selectedRelevant! ? 1 : 0) : 0;
        print('Relevant Value: $serverValue');

        Map<String, dynamic> workRequestData = {
          'company_name': workData[0],
          'designation': workData[1],
          'from_date': workData[2],
          'to_date': workData[3],
          'description': workData[4],
          'verify_person_name': workData[5],
          'verify_person_contact': workData[6],
          'verify_working_phone': workData[7],
          'verify_personal_email': workData[8],
          'relavent': serverValue,
        };
        // ignore: use_build_context_synchronously
        // await WorkApi.workData(context, workRequestData, userId);
        print('Work user Table: $userId');

        print('Work Experience');
        Map<String, dynamic> educationRequestData = {
          'institute_name': educationData[0],
          'degree_diploma': educationData[1],
          'specialization': educationData[2],
          'date_of_completion': educationData[3],
          'cgpa': educationData[4],
        };
        print('Education Response: $educationData');
        print('Education user Table: $educationId');
        await Future.wait([
          WorkApi.workData(context, workRequestData, userId),
          EducationApi.educationData(
              context, educationRequestData, educationId),
        ]);

        // If all API calls succeed
        // ScaffoldMessenger.of(context).showSnackBar(
        //   const SnackBar(
        //     content: Text('Success: All data submitted successfully.'),
        //   ),
        // );
      }
    } catch (e) {
      // If any error occurs
      print('Error in _nextSection: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error: Some data failed to submit. Please try again.'),
        ),
      );
    }
  }

  Widget _buildProfileFields() {
    switch (currentSection) {
      case 1:
        return _buildPersonalInformationFields();
      case 2:
        return _buildEducationalInformationFields();
      case 3:
        return _buildContactDetailsFields();
      case 4:
        return _buildWorkExperienceFields();
      case 5:
        return _buildEducationFields();

      default:
        return Container();
    }
  }

  //Personal Information's
  Widget _buildPersonalInformationFields() {
    return Column(
      children: [
        const SizedBox(height: 15),
        const Align(
          alignment: Alignment.topLeft,
          child: Text(
            'Personal Information',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
            textAlign: TextAlign.start,
          ),
        ),
        const SizedBox(height: 15),
        _buildTextField(
          hintText: 'First Name',
          prefixIconData: Icons.person,
          controller: firstNameController,
          fieldName: 'First Name',
        ),
        const SizedBox(height: 15),
        _buildTextField(
          hintText: 'Last Name',
          prefixIconData: Icons.person,
          controller: lastNameController,
          fieldName: 'Last Name',
        ),
        const SizedBox(height: 15),
        _buildDropdownFormField(
          items: genderOptions,
          selectedValue: selectedRole,
          hintText: 'Gender',
          onChanged: (String? value) {
            setState(() {
              selectedRole = value;
            });
          },
          fieldName: 'Gender',
          prefixIconData: Icons.person,
        ),
        const SizedBox(height: 15),
        _buildDateField(
          'Date Of Birth',
          dateOfBirthController,
          ageController,
        ),
        const SizedBox(height: 15),
        _buildTextField(
          hintText: 'Age',
          prefixIconData: Icons.person,
          controller: ageController,
          fieldName: 'Age',
        ),
        const SizedBox(height: 15),
        _buildDropdownFormField(
          items: statusOptions,
          selectedValue: selectedStatus,
          hintText: 'Marital Status',
          onChanged: (String? value) {
            setState(() {
              selectedStatus = value;
            });
          },
          fieldName: 'Martial Status',
          prefixIconData: Icons.person,
        ),
        const SizedBox(height: 15),
        _buildLeaveReasonField(),
      ],
    );
  }

  //Identity Information's
  Widget _buildEducationalInformationFields() {
    return Column(
      children: [
        const SizedBox(height: 15),
        const Align(
          alignment: Alignment.topLeft,
          child: Text(
            'Identity Information',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
            textAlign: TextAlign.start,
          ),
        ),
        const SizedBox(height: 15),
        _buildAadharNumber(
          hintText: 'UAN Number',
          prefixIconData: Icons.pin,
          controller: uanController,
          fieldName: 'UAN Number',
        ),
        const SizedBox(height: 15),
        _buildTextField(
          hintText: 'PAN Number',
          prefixIconData: Icons.pin,
          controller: panController,
          fieldName: 'PAN Number',
        ),
        const SizedBox(height: 15),
        _buildAadharNumber(
          hintText: 'Aadhar Number',
          prefixIconData: Icons.pin,
          controller: aadharController,
          fieldName: 'Aadhar Number',
        ),
        const SizedBox(height: 15),
        _buildTextImage(
          hintText: 'Aadhar Card Path',
          prefixIconData: Icons.photo_album_outlined,
          controller: aadharCardController,
          isButton: true,
          onTap: () async {
            String? imagePath = await _pickImage(aadharCardController);
            if (imagePath != null) {
              setState(() {
                adharCardImage = File(
                    imagePath); // Convert file path to File object if necessary
              });
            }
          },
        ),
        const SizedBox(height: 15),
        _buildTextImage(
          hintText: 'Profile Photo Path',
          prefixIconData: Icons.photo,
          controller: photoController,
          isButton: true,
          onTap: () async {
            String? imagePath = await _pickImage(photoController);
            if (imagePath != null) {
              setState(() {
                profilePictureImage = File(
                    imagePath); // Convert file path to File object if necessary
              });
            }
          },
        ),
        const SizedBox(height: 80),
      ],
    );
  }

  //Image Pick Text Field Method
  Widget _buildTextImage({
    required TextEditingController controller,
    required String hintText,
    required IconData prefixIconData,
    bool isButton = false,
    VoidCallback? onTap,
  }) {
    return TextFormField(
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
            color: Colors.grey,
            width: 2.0,
          ),
        ),
        filled: true,
        fillColor: Colors.white,
        // suffixIcon: isButton ? Icon(Icons.camera_alt) : null,
      ),
      readOnly: isButton,
      onTap: onTap,
    );
  }

  Widget _buildTextFields({
    required TextEditingController controller,
    String hintText = 'Enter text here',
    IconData? prefixIconData,
  }) {
    return Center(
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
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
      ),
    );
  }

  //Contact Details
  Widget _buildContactDetailsFields() {
    return Column(
      children: [
        const SizedBox(height: 15),
        const Align(
          alignment: Alignment.topLeft,
          child: Text(
            'Contact Details',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
            textAlign: TextAlign.start,
          ),
        ),
        const SizedBox(height: 15),
        _buildphoneNumber(
          hintText: 'Work Phone Number',
          prefixIconData: Icons.phone_android,
          controller: workNumberController,
          fieldName: 'Work Phone Number',
        ),
        const SizedBox(height: 15),
        _buildphoneNumber(
          hintText: 'Personal Phone Number',
          prefixIconData: Icons.phone_android_sharp,
          controller: personalNumberController,
          fieldName: 'Personal Number',
        ),
        const SizedBox(height: 15),
        _buildTextField(
          hintText: 'Personal Email Address',
          prefixIconData: Icons.email,
          controller: personalEmailController,
          fieldName: 'Personal Email',
        ),
        const SizedBox(height: 15),
        const Row(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                'Present Address',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                textAlign: TextAlign.start,
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        _buildTextField(
          controller: presentAddressLine1Controller,
          hintText: 'Address Line 1',
          prefixIconData: Icons.person,
          fieldName: 'Address',
        ),
        const SizedBox(height: 15),
        _buildTextField(
          controller: presentAddressLine2Controller,
          hintText: 'Address Line 2',
          prefixIconData: Icons.person,
          fieldName: 'Address',
        ),
        const SizedBox(height: 15),
        _buildTextField(
          controller: presentCityController,
          hintText: 'City',
          prefixIconData: Icons.location_city,
          fieldName: 'City',
        ),
        const SizedBox(height: 15),
        _buildTextField(
          controller: presentStateController,
          hintText: 'State',
          prefixIconData: Icons.location_city,
          fieldName: 'State',
        ),
        const SizedBox(height: 15),
        _buildTextField(
          controller: presentCountryController,
          hintText: 'Country',
          prefixIconData: Icons.flag,
          fieldName: 'Country',
        ),
        const SizedBox(height: 15),
        _buildTextField(
          controller: presentPinCodeController,
          hintText: 'Pin Code',
          prefixIconData: Icons.pin,
          fieldName: 'Pin Code',
        ),
        const SizedBox(height: 15),
        Row(
          children: [
            const Align(
              alignment: Alignment.topLeft,
              child: Text(
                'Permanent Address',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
                textAlign: TextAlign.start,
              ),
            ),
            const SizedBox(width: 1),
            Align(
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  Checkbox(
                    value: isSameAsPresentAddress,
                    onChanged: (bool? value) {
                      setState(() {
                        isSameAsPresentAddress = value ?? false;

                        if (isSameAsPresentAddress) {
                          // Copy present address to permanent address
                          _copyPresentToPermanent(presentAddressLine1Controller,
                              permanentAddressLine1Controller);
                          _copyPresentToPermanent(presentAddressLine2Controller,
                              permanentAddressLine2Controller);
                          _copyPresentToPermanent(
                              presentCityController, permanentCityController);
                          _copyPresentToPermanent(
                              presentStateController, permanentStateController);
                          _copyPresentToPermanent(presentCountryController,
                              permanentCountryController);
                          _copyPresentToPermanent(presentPinCodeController,
                              permanentPinCodeController);
                        } else {
                          permanentAddressLine1Controller.clear();
                          permanentAddressLine2Controller.clear();
                          permanentCityController.clear();
                          permanentStateController.clear();
                          permanentCountryController.clear();
                          permanentPinCodeController.clear();
                        }
                      });
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                  ),
                  const Text('Same address'),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        _buildTextField(
          controller: permanentAddressLine1Controller,
          hintText: 'Address Line 1',
          prefixIconData: Icons.person,
          fieldName: 'Address',
        ),
        const SizedBox(height: 15),
        _buildTextField(
          controller: permanentAddressLine2Controller,
          hintText: 'Address Line 2',
          prefixIconData: Icons.person,
          fieldName: 'Address',
        ),
        const SizedBox(height: 15),
        _buildTextField(
          controller: permanentCityController,
          hintText: 'City',
          prefixIconData: Icons.location_city,
          fieldName: 'City',
        ),
        const SizedBox(height: 15),
        _buildTextField(
          controller: permanentStateController,
          hintText: 'State',
          prefixIconData: Icons.location_city,
          fieldName: 'State',
        ),
        const SizedBox(height: 15),
        _buildTextField(
          controller: permanentCountryController,
          hintText: 'Country',
          prefixIconData: Icons.flag,
          fieldName: 'Country',
        ),
        const SizedBox(height: 15),
        _buildTextField(
          controller: permanentPinCodeController,
          hintText: 'Pin Code',
          prefixIconData: Icons.pin,
          fieldName: 'Pin Code',
        ),
      ],
    );
  }

  //Work Experience's
  Widget _buildWorkExperienceFields() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Work Experience',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            // const SizedBox(height: 60),
            Checkbox(
              value: isFresher,
              onChanged: (bool? value) {
                setState(() {
                  isFresher = value ?? false;
                });
              },
              activeColor: Colors.blue,
              checkColor: Colors.white,
            ),
            const Text(
              'Fresher',
              style: TextStyle(
                // fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.blue,
              ),
            ),
            IconButton(
              color: Colors.blue,
              icon: isAdditionalFieldsWork
                  ? const Icon(Icons.remove)
                  : const Icon(Icons.add),
              onPressed: () {
                setState(() {
                  isAdditionalFieldsWork = !isAdditionalFieldsWork;
                });
              },
            ),
            const Text(
              'Add',
              style: TextStyle(
                // fontWeight: FontWeight.bold,
                color: Colors.blue,
                fontSize: 14,
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        Visibility(
          visible: !isFresher, // Hide if the user is a fresher
          child: Column(
            children: [
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
                controller: desController,
                fieldName: 'Job Description',
              ),
              const SizedBox(height: 15),
              _buildTextField(
                hintText: 'Person Name',
                prefixIconData: Icons.description,
                controller: personNameController,
                fieldName: 'Person Name',
              ),
              const SizedBox(height: 15),
              _buildphoneNumber(
                hintText: 'Person Contact',
                prefixIconData: Icons.description,
                controller: personalContactController,
                fieldName: 'Person Contact',
              ),
              const SizedBox(height: 15),
              _buildphoneNumber(
                hintText: 'Person Work Number',
                prefixIconData: Icons.description,
                controller: personPhoneController,
                fieldName: 'Person Work Number',
              ),
              const SizedBox(height: 15),
              _buildTextField(
                hintText: 'Person Email',
                prefixIconData: Icons.description,
                controller: personEmailController,
                fieldName: 'Person Email',
              ),
              const SizedBox(height: 15),
              buildDropdownFormFieldss(
                items: relevant, // Pass the relevant list
                selectedValue: selectedRelevant,
                hintText: 'Select relevant',
                onChanged: (value) {
                  // Ensure the selected value is parsed into an integer before assigning
                  selectedRelevant = value;
                },
                prefixIconData: Icons.check,
              ),
              if (isAdditionalFieldsWork)
                Column(
                  children: [
                    const SizedBox(height: 15),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Additional Fields',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 15),
                    _buildTextField(
                      hintText: 'Company Name',
                      prefixIconData: Icons.business,
                      fieldName: 'Company Name',
                    ),
                    const SizedBox(height: 15),
                    _buildTextField(
                      hintText: 'Job Title',
                      prefixIconData: Icons.work,
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
                      fieldName: 'Job Description',
                    ),
                    const SizedBox(height: 15),
                    buildDropdownFormFieldss(
                      items: relevant, // Pass the relevant list
                      selectedValue: selectedRelevant,
                      hintText: 'Select relevant',
                      onChanged: (value) {
                        selectedRelevant = value;
                      },
                      prefixIconData: Icons.check,
                    ),
                  ],
                ),
            ],
          ),
        ),
      ],
    );
  }

  //Education Details
  Widget _buildEducationFields() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Education Details',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            Row(
              children: [
                IconButton(
                  color: Colors.blue,
                  icon: isAdditionalFieldsAdded
                      ? const Icon(Icons.remove)
                      : const Icon(Icons.add),
                  onPressed: () {
                    setState(() {
                      isAdditionalFieldsAdded = !isAdditionalFieldsAdded;
                    });
                  },
                ),
                const Text(
                  'Add',
                  style: TextStyle(
                    // fontWeight: FontWeight.bold,
                    color: Colors.blue,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 20),
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
        _buildTextField(
          hintText: 'CGPA',
          prefixIconData: Icons.cast_for_education,
          controller: cgpaController,
          fieldName: 'CGPA',
        ),
        const SizedBox(height: 15),
        _buildDateFields('Date Of Completion', dateofcompletionController),
        // Display additional fields based on the flag
        if (isAdditionalFieldsAdded)
          Column(
            children: [
              const SizedBox(height: 15),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Additional Fields',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 15),
              _buildTextField(
                hintText: 'Institute Name 1',
                prefixIconData: Icons.location_city,
                fieldName: 'Institute Name',
              ),
              const SizedBox(height: 15),
              _buildTextField(
                hintText: 'Degree/Diploma 1',
                prefixIconData: Icons.cast_for_education_sharp,
                fieldName: 'Degree/Diploma',
              ),
              const SizedBox(height: 15),
              _buildTextField(
                hintText: 'Specialization 1',
                prefixIconData: Icons.cast_for_education,
                fieldName: 'Specialization',
              ),
              const SizedBox(height: 15),
              _buildDateFields('Date Of Completion 1', TextEditingController()),
            ],
          ),
        const SizedBox(height: 150),
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
        // inputFormatters: [LengthLimitingTextInputFormatter(10)],
        decoration: InputDecoration(
          hintText: hintText,
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

  //Phone Number Method
  Widget _buildphoneNumber({
    TextEditingController? controller,
    String hintText = 'Enter text here',
    IconData? prefixIconData,
    required String fieldName,
    // bool readOnly = false, // Add this line
  }) {
    return Center(
      child: TextFormField(
        controller: controller,
        inputFormatters: [LengthLimitingTextInputFormatter(10)],
        decoration: InputDecoration(
          hintText: hintText,
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

  //Date Field Method in Age Calculation for Date Of Birth
  Widget _buildDateField(String hintText, TextEditingController controller,
      TextEditingController ageController) {
    return SizedBox(
      child: TextField(
        controller: controller,
        readOnly: true,
        decoration: InputDecoration(
          prefixIcon: const Icon(
            Icons.date_range,
          ),
          hintText: hintText,
          labelStyle: const TextStyle(fontSize: 10),
          border: const OutlineInputBorder(),
          filled: true,
          fillColor: ThemeColor.TextFieldColor,
        ),
        onTap: () async {
          DateTime currentDate = DateTime.now();
          DateTime firstAllowedDate = DateTime(1900, 1, 1);

          DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: currentDate,
            firstDate: firstAllowedDate,
            lastDate: currentDate,
          );

          if (pickedDate != null) {
            String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
            controller.text = formattedDate;

            int age = currentDate.year -
                pickedDate.year -
                ((currentDate.month > pickedDate.month ||
                        (currentDate.month == pickedDate.month &&
                            currentDate.day >= pickedDate.day))
                    ? 0
                    : 1);

            ageController.text = age.toString();
          }
        },
      ),
    );
  }

  //About Me method
  Widget _buildLeaveReasonField() {
    return SizedBox(
      width: double.infinity,
      // height: 159,
      child: TextFormField(
        controller: aboutmeController,
        maxLines: null,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter the about me ';
          }
          return null;
        },
        decoration: InputDecoration(
          prefix: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: SizedBox(
              width: 5,
              child: Container(
                color: Colors.black,
              ),
            ),
          ),
          hintText: 'About Me',
          hintStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
          border: const OutlineInputBorder(),
          filled: true,
          fillColor: ThemeColor.TextFieldColor,
        ),
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
          child: Text(value ? 'true' : 'false'),
        );
      }).toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(prefixIconData),
        border: OutlineInputBorder(),
      ),
    );
  }

  // Method to convert boolean value to 0 or 1 for server side

  //DropDown Method
  Widget _buildDropdownFormField({
    required List<String> items,
    required String? selectedValue,
    required String hintText,
    required void Function(String?) onChanged,
    required String fieldName,
    IconData? prefixIconData,
  }) {
    return SizedBox(
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          hintText: hintText,
          filled: true,
          fillColor: ThemeColor.TextFieldColor,
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Colors.grey,
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(5.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Colors.grey,
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(5.0),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(5.0),
          ),
          prefixIcon: Icon(prefixIconData),
        ),
        value: selectedValue,
        items: items.map((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(
              item,
              style: const TextStyle(
                color: Colors.black,
              ),
            ),
          );
        }).toList(),
        dropdownColor: ThemeColor.log_background,
        onChanged: onChanged,
        style: const TextStyle(),
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
          labelStyle: const TextStyle(fontSize: 10),
          border: const OutlineInputBorder(),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
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

  //Aadhar Number Validation
  Widget _buildAadharNumber({
    required TextEditingController controller,
    required String hintText,
    required IconData prefixIconData,
    required String fieldName,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      inputFormatters: [LengthLimitingTextInputFormatter(12)],
      decoration: InputDecoration(
        hintText: hintText,
        labelText: fieldName,
        prefixIcon: Icon(prefixIconData),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(
            color: Colors.grey,
            width: 2.0,
          ),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $fieldName';
        } else if (value.length != 12) {
          return 'Aadhar Number must be 12 digits long';
        } else if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
          return 'Aadhar Number can only contain digits';
        }
        return null;
      },
    );
  }
}
